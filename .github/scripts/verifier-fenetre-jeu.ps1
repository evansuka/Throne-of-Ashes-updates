param([Parameter(Mandatory=$true)][string]$Directory,[Parameter(Mandatory=$true)][string]$Tag)
$ErrorActionPreference='Stop'
if($env:OS -ne 'Windows_NT' -or $env:GITHUB_ACTIONS -ne 'true'){throw 'Reserve au runner Windows CI jetable.'}
$version=$Tag.TrimStart('v');$directory=(Resolve-Path $Directory).Path
$fixture=Join-Path $env:RUNNER_TEMP ('toa-window-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $fixture | Out-Null
$reportPath=Join-Path $pwd 'verification/game-window.json'
$result=[ordered]@{version=$version;status='running';checks=@();sourceCommit=$env:GITHUB_SHA}
$process=$null
try{
Add-Type -AssemblyName System.IO.Compression.FileSystem
$launcher=Join-Path $directory 'Throne-of-Ashes.exe'
[Reflection.Assembly]::LoadFile($launcher) | Out-Null
$bridgeSource=Join-Path $fixture 'RealWindowStartup.cs'
$bridgeAssembly=Join-Path $fixture 'RealWindowStartup.dll'
[IO.File]::WriteAllText($bridgeSource,@'
using System.Diagnostics;
using System.Threading.Tasks;
public class RealWindowStartup:LauncherOperations {
 public volatile Process Child;public Task Work;
 public override Process LaunchGameProcess(ProcessStartInfo start){var process=base.LaunchGameProcess(start);Child=Process.GetProcessById(process.Id);return process;}
 public void Begin(string root,string version){Work=Task.Factory.StartNew(()=>StartGame(root,version));}
}
'@)
& 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:library /out:$bridgeAssembly /reference:$launcher $bridgeSource
if($LASTEXITCODE -ne 0){throw 'Compilation du pont de controle graphique refusee.'}
[Reflection.Assembly]::LoadFile($bridgeAssembly) | Out-Null
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class GameWindowProbe {
 [StructLayout(LayoutKind.Sequential)] public struct Rect {public int left,top,right,bottom;}
 [DllImport("user32.dll")]static extern bool GetWindowRect(IntPtr window,out Rect rect);
 [DllImport("user32.dll")]static extern int GetSystemMetrics(int index);
 [DllImport("user32.dll")]static extern bool IsWindowVisible(IntPtr window);
 [DllImport("user32.dll")]static extern bool IsIconic(IntPtr window);
 [DllImport("dwmapi.dll")]static extern int DwmGetWindowAttribute(IntPtr window,int attribute,out int value,int size);
 public static int[] Bounds(IntPtr window){Rect r;GetWindowRect(window,out r);return new[]{r.left,r.top,r.right,r.bottom};}
 public static bool OnScreen(IntPtr window){int cloaked;if(DwmGetWindowAttribute(window,14,out cloaked,4)==0&&cloaked!=0)return false;Rect r;if(window==IntPtr.Zero||!IsWindowVisible(window)||IsIconic(window)||!GetWindowRect(window,out r))return false;int x=GetSystemMetrics(76),y=GetSystemMetrics(77);return r.right>x&&r.bottom>y&&r.left<x+GetSystemMetrics(78)&&r.top<y+GetSystemMetrics(79);}
}
'@
function Check($value,[string]$label){if(-not $value){throw $label};$script:result.checks+=,$label;Write-Output ('GAME_WINDOW_CHECK: '+$label)}
 $gameDirectory=Join-Path $fixture ("versions/"+$version);New-Item -ItemType Directory $gameDirectory -Force | Out-Null
 [IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $directory "Throne-of-Ashes-$version-update.zip"),$gameDirectory)
 $log=Join-Path $fixture 'game.log'
 $ops=New-Object RealWindowStartup;$ops.Begin($fixture,$version)
 $clock=[Diagnostics.Stopwatch]::StartNew();$samples=0
 while(-not $ops.Work.IsCompleted){
  $process=$ops.Child
  if($null -ne $process){
   $process.Refresh();Check (-not $process.HasExited) 'Game survives graphical initialization'
   if([GameWindowProbe]::OnScreen($process.MainWindowHandle)){$result['earlyWindow']=[ordered]@{title=$process.MainWindowTitle;bounds=[GameWindowProbe]::Bounds($process.MainWindowHandle)};Start-Sleep -Milliseconds 50;$process.Refresh();Check (-not [GameWindowProbe]::OnScreen($process.MainWindowHandle)) 'Startup window suppressed within 50 ms';$result['suppressedStartupWindows']=1+[int]$result['suppressedStartupWindows']}
  }
  $samples++
  if($clock.Elapsed.TotalSeconds -gt 95){throw 'Game readiness timed out'}
  Start-Sleep -Milliseconds 100
 }
 $ops.Work.GetAwaiter().GetResult();$process=$ops.Child;$gamePid=$process.Id
 Check ($null -ne $process) 'Real exported game started by actual launcher operations'
 $readyFile=Get-ChildItem -LiteralPath $fixture -Filter 'handoff-*.ready' | Select-Object -First 1
 Check ($null -ne $readyFile) 'Actual launcher handshake file exists'
 $marker=$readyFile.FullName -replace '\.ready$',''
 Check (([IO.File]::ReadAllText($marker+'.ready')).Trim() -eq [string]$gamePid) 'Ready handshake identifies the real game PID'
 for($i=0;$i -lt 180;$i++){$process.Refresh();Check (-not [GameWindowProbe]::OnScreen($process.MainWindowHandle)) 'No on-screen game before explicit launcher release';Start-Sleep -Milliseconds 100}
 $ops.ReleaseGame()
 $visible=$false;$clock.Restart()
 do{$process.Refresh();$visible=[GameWindowProbe]::OnScreen($process.MainWindowHandle);if(-not $visible){Start-Sleep -Milliseconds 100}}while(-not $visible -and $clock.Elapsed.TotalSeconds -lt 20)
 Check $visible 'Same exported game becomes visible on screen after release'
 Start-Sleep -Seconds 3;$process.Refresh()
 Check (-not $process.HasExited -and $process.Id -eq $gamePid) 'One game PID remains alive after handoff'
 $result.gamePid=$gamePid;$result.initializationSamples=$samples;$result.status='passed'
}catch{$result.status='failed';$result.error=$_.Exception.ToString();throw}
finally{
 $result.completedUtc=[DateTime]::UtcNow.ToString('o')
 [IO.File]::WriteAllText($reportPath,($result|ConvertTo-Json -Depth 6),[Text.UTF8Encoding]::new($false))
 if($null -ne $process){try{if(-not $process.HasExited){$process.Kill();$process.WaitForExit(10000)|Out-Null}}catch{};$process.Dispose()}
}
