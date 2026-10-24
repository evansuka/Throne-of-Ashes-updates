param([Parameter(Mandatory=$true)][string]$Directory,[Parameter(Mandatory=$true)][string]$Tag)
$ErrorActionPreference='Stop'
if($env:OS -ne 'Windows_NT' -or $env:GITHUB_ACTIONS -ne 'true'){throw 'Reserve au runner Windows CI jetable.'}
$version=$Tag.TrimStart('v');$directory=(Resolve-Path $Directory).Path
$fixture=Join-Path $env:RUNNER_TEMP ('toa-window-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $fixture | Out-Null
$reportPath=Join-Path $pwd 'verification/game-window.json'
$result=[ordered]@{version=$version;status='running';checks=@();sourceCommit=$env:GITHUB_SHA}
$process=$null
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class GameWindowProbe {
 [StructLayout(LayoutKind.Sequential)] public struct Rect {public int left,top,right,bottom;}
 [DllImport("user32.dll")]static extern bool GetWindowRect(IntPtr window,out Rect rect);
 [DllImport("user32.dll")]static extern int GetSystemMetrics(int index);
 [DllImport("user32.dll")]static extern bool IsWindowVisible(IntPtr window);
 [DllImport("user32.dll")]static extern bool IsIconic(IntPtr window);
 public static bool OnScreen(IntPtr window){Rect r;if(window==IntPtr.Zero||!IsWindowVisible(window)||IsIconic(window)||!GetWindowRect(window,out r))return false;int x=GetSystemMetrics(76),y=GetSystemMetrics(77);return r.right>x&&r.bottom>y&&r.left<x+GetSystemMetrics(78)&&r.top<y+GetSystemMetrics(79);}
}
'@
function Check($value,[string]$label){if(-not $value){throw $label};$script:result.checks+=,$label;Write-Output ('GAME_WINDOW_CHECK: '+$label)}
try{
 [IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $directory "Throne-of-Ashes-$version-update.zip"),$fixture)
 $exe=Join-Path $fixture 'Throne-of-Ashes-Game.exe';$marker=Join-Path $fixture 'handoff';$log=Join-Path $fixture 'game.log'
 $start=New-Object Diagnostics.ProcessStartInfo
 $start.FileName=$exe;$start.UseShellExecute=$false;$start.WindowStyle=[Diagnostics.ProcessWindowStyle]::Hidden;$start.WorkingDirectory=$fixture
 $start.Arguments='--position -32000,-32000 --minimized --log-file "'+$log+'" -- --updates-checked --launcher-offscreen "--launcher-handoff='+$marker+'" --launcher-pid='+$PID
 $process=[Diagnostics.Process]::Start($start);$gamePid=$process.Id
 Check ($null -ne $process) 'Real exported game process created'
 $clock=[Diagnostics.Stopwatch]::StartNew();$samples=0
 while(-not (Test-Path -LiteralPath ($marker+'.ready'))){
  $process.Refresh();Check (-not $process.HasExited) 'Game survives graphical initialization'
  if([GameWindowProbe]::OnScreen($process.MainWindowHandle)){throw 'Game appeared on screen before readiness'}
  $samples++
  if($clock.Elapsed.TotalSeconds -gt 90){throw 'Game readiness timed out'}
  Start-Sleep -Milliseconds 100
 }
 Check (([IO.File]::ReadAllText($marker+'.ready')).Trim() -eq [string]$gamePid) 'Ready handshake identifies the real game PID'
 for($i=0;$i -lt 12;$i++){$process.Refresh();Check (-not [GameWindowProbe]::OnScreen($process.MainWindowHandle)) 'No on-screen game before explicit launcher release';Start-Sleep -Milliseconds 100}
 [IO.File]::WriteAllText($marker+'.release','show')
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
