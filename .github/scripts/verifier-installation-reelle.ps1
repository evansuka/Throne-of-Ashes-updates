# Runs only on a disposable Windows CI runner. Exercises the published EXE's
# real entry point, installation, installed bootstrap, launcher and real game.
param([string]$Version='0.14.16',[string]$ExpectedSetupSha='')
$ErrorActionPreference='Stop';$ProgressPreference='SilentlyContinue'
if($env:OS -ne 'Windows_NT' -or $env:GITHUB_ACTIONS -ne 'true'){throw 'Reserve au runner Windows CI jetable.'}
if($Version -notmatch '^\d+\.\d+\.\d+$'){throw 'Version invalide.'}
if(-not $ExpectedSetupSha -and $Version -eq '0.14.16'){$ExpectedSetupSha='743d82f6789ac90e556a02c73fa098a4220395b7013d42a85c24f002d1a7ab28'}
if($ExpectedSetupSha -notmatch '^[a-f0-9]{64}$'){throw 'Empreinte de la version exigee.'}
$pattern=[regex]::Escape($Version)
$repo=Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$reportPath=Join-Path $repo ('verification/installation-'+$Version.Replace('.','')+'-e2e.json')
$screenshot=Join-Path $repo ('verification/installation-'+$Version.Replace('.','')+'-e2e.png')
$app='C:\Games\Throne of Ashes'
$data=Join-Path $env:LOCALAPPDATA 'ThroneOfAshes'
$desktop=[Environment]::GetFolderPath('DesktopDirectory')
$reg='HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ThroneOfAshes'
$start=[DateTime]::UtcNow
$result=[ordered]@{version=$Version;status='running';sourceCommit=$env:GITHUB_SHA;workflowUrl="https://github.com/$env:GITHUB_REPOSITORY/actions/runs/$env:GITHUB_RUN_ID";startedUtc=$start.ToString('o');published=$false;checks=@();observedProcesses=@();platform=[Environment]::OSVersion.VersionString;runnerElevated=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)}
$fixture=Join-Path $env:RUNNER_TEMP ('toa-real-install-'+[Guid]::NewGuid().ToString('N'))
$setup=$null;$owned=$false
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class ToaWindowProbe {
 [StructLayout(LayoutKind.Sequential)]public struct Rect {public int left,top,right,bottom;}
 [DllImport("user32.dll")]static extern bool GetWindowRect(IntPtr window,out Rect rect);
 [DllImport("user32.dll")]static extern int GetSystemMetrics(int index);
 [DllImport("dwmapi.dll")]static extern int DwmGetWindowAttribute(IntPtr window,int attribute,out int value,int size);
 public static bool OnScreen(IntPtr window){int cloaked;if(DwmGetWindowAttribute(window,14,out cloaked,4)==0&&cloaked!=0)return false;Rect r;if(window==IntPtr.Zero||!GetWindowRect(window,out r))return false;int x=GetSystemMetrics(76),y=GetSystemMetrics(77);return r.right>x&&r.bottom>y&&r.left<x+GetSystemMetrics(78)&&r.top<y+GetSystemMetrics(79);}

 [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr handle);
 [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr handle);
}
'@

function Check($value,[string]$label){if(-not $value){throw $label};$script:result.checks+=,$label;Write-Output ('INSTALL_E2E_CHECK: '+$label)}
function Read-SharedText([string]$path){
 $stream=[IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete))
 $reader=New-Object IO.StreamReader $stream
 try{return $reader.ReadToEnd()}finally{$reader.Dispose()}
}
function Save-Report{
 [IO.File]::WriteAllText($script:reportPath,($script:result|ConvertTo-Json -Depth 7),[Text.UTF8Encoding]::new($false))
}
function Capture-Desktop{
 Add-Type -AssemblyName System.Windows.Forms
 Add-Type -AssemblyName System.Drawing
 $bounds=[Windows.Forms.SystemInformation]::VirtualScreen
 $bitmap=New-Object Drawing.Bitmap $bounds.Width,$bounds.Height
 $graphics=[Drawing.Graphics]::FromImage($bitmap)
 try{$graphics.CopyFromScreen($bounds.Left,$bounds.Top,0,0,$bitmap.Size);$bitmap.Save($screenshot,[Drawing.Imaging.ImageFormat]::Png)}finally{$graphics.Dispose();$bitmap.Dispose()}
}
try{
 # Refuse to touch an existing installation even on CI.
 Check (-not (Test-Path -LiteralPath $app)) 'Fresh app directory'
 Check (-not (Test-Path -LiteralPath $data)) 'Fresh user data directory'
 Check (-not (Test-Path -LiteralPath (Join-Path $desktop 'Throne of Ashes.lnk'))) 'Fresh desktop shortcut'
 Check (-not (Test-Path -LiteralPath $reg)) 'Fresh per-user registration'
 $owned=$true
 New-Item -ItemType Directory -Path $fixture -Force | Out-Null
 $source=Join-Path $fixture 'Throne-of-Ashes-Setup.exe'
 Invoke-WebRequest ("https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v$Version/Throne-of-Ashes-Setup.exe") -OutFile $source -UseBasicParsing
 Check ((Get-FileHash $source -Algorithm SHA256).Hash.ToLowerInvariant() -eq $ExpectedSetupSha) 'Exact published Setup SHA256'
 $info=New-Object Diagnostics.ProcessStartInfo
 $info.FileName=$source;$info.WorkingDirectory=$fixture;$info.UseShellExecute=$true
 $setup=[Diagnostics.Process]::Start($info)
 Check ($null -ne $setup) 'Published Setup process created through the shell'
 $deadline=[DateTime]::UtcNow.AddMinutes(4)
 $ready=$false;$seen=@{}
 do{
  foreach($name in @('Throne-of-Ashes-Setup','Throne-of-Ashes-Start','Throne-of-Ashes','Throne-of-Ashes-Game')){
   foreach($process in Get-Process -Name $name -ErrorAction SilentlyContinue){
    try{if($process.StartTime.ToUniversalTime() -ge $start -and -not $seen.ContainsKey($process.Id)){
     $seen[$process.Id]=$true;$script:result.observedProcesses+=,[ordered]@{pid=$process.Id;name=$process.ProcessName;path=$process.MainModule.FileName}
    }}catch{}
   }
  }
  $log=Join-Path $data 'game.log'
  $launcherPath=Join-Path $data 'launcher.log'
  $launcherText=if(Test-Path -LiteralPath $launcherPath){Read-SharedText $launcherPath}else{''}
  $games=@(Get-Process -Name 'Throne-of-Ashes-Game' -ErrorAction SilentlyContinue)
  if($games.Count -eq 1){
   $games[0].Refresh();$handle=$games[0].MainWindowHandle
   $ready=$launcherText -match ('Jeu lanc. : '+$pattern) -and $handle -ne [IntPtr]::Zero -and [ToaWindowProbe]::IsWindowVisible($handle) -and -not [ToaWindowProbe]::IsIconic($handle) -and [ToaWindowProbe]::OnScreen($handle)
   $visible=$handle -ne [IntPtr]::Zero -and [ToaWindowProbe]::IsWindowVisible($handle) -and -not [ToaWindowProbe]::IsIconic($handle) -and [ToaWindowProbe]::OnScreen($handle)
   $initializing=$visible -and [string]::IsNullOrWhiteSpace($games[0].MainWindowTitle) -and $launcherText -notmatch ('Jeu lanc. : '+$pattern)
   if($initializing){$result['initializationWindowObserved']=$true}
   if($visible -and -not $initializing){
    foreach($launcher in Get-Process -Name 'Throne-of-Ashes','Throne-of-Ashes-Start','Throne-of-Ashes-Setup' -ErrorAction SilentlyContinue){
     $launcher.Refresh();$window=$launcher.MainWindowHandle
     Check (-not ($window -ne [IntPtr]::Zero -and [ToaWindowProbe]::IsWindowVisible($window) -and -not [ToaWindowProbe]::IsIconic($window) -and [ToaWindowProbe]::OnScreen($window))) 'Ready game never overlaps a visible installer or launcher window'
    }
   }
   if($ready){$result.gameWindow=[ordered]@{pid=$games[0].Id;title=$games[0].MainWindowTitle;visible=$true;minimized=$false}}
  }
  if(-not $ready){Start-Sleep -Milliseconds 500}
 }while(-not $ready -and [DateTime]::UtcNow -lt $deadline)
 Capture-Desktop
 $installed=Join-Path $app 'Throne-of-Ashes-Start.exe'
 Check (Test-Path -LiteralPath $installed) 'Installed bootstrap exists'
 Check ((Get-FileHash $installed -Algorithm SHA256).Hash -eq (Get-FileHash $source -Algorithm SHA256).Hash) 'Installed bootstrap exact source bytes'
 Check ($setup.WaitForExit(10000) -and $setup.ExitCode -eq 0) 'Original Setup exits successfully'
 Check ((Get-ItemProperty $reg).InstallLocation -eq $app) 'Actual current-user app registration'
 $shell=New-Object -ComObject WScript.Shell
 $shortcut=$shell.CreateShortcut((Join-Path $desktop 'Throne of Ashes.lnk'))
 Check ($shortcut.TargetPath -eq $installed) 'Actual desktop shortcut targets local bootstrap'
 Check $ready 'Real public game is visible after launcher startup'
 Check (@($result.observedProcesses | Where-Object {$_.name -eq 'Throne-of-Ashes-Game'}).Count -eq 1) 'Only one game PID observed throughout startup'
 $games=@(Get-Process -Name 'Throne-of-Ashes-Game' -ErrorAction SilentlyContinue)
 Check ($games.Count -eq 1) 'Exactly one real game process'
 Check ($games[0].MainModule.FileName -eq (Join-Path $data ("versions/$Version/Throne-of-Ashes-Game.exe"))) ("Visible game is the actual installed $Version executable")
 Start-Sleep -Seconds 30
 Check (-not $games[0].HasExited) 'Real game remains open thirty seconds after launcher startup'
 Check (@(Get-Process -Name 'Throne-of-Ashes','Throne-of-Ashes-Start','Throne-of-Ashes-Setup' -ErrorAction SilentlyContinue).Count -eq 0) 'Setup, bootstrap and launcher have all exited while game stays open'
 Capture-Desktop
 $launcherLog=Read-SharedText (Join-Path $data 'launcher.log')
 Check ($launcherLog -match ('Lanceur '+$pattern) -and $launcherLog -match ('Jeu lanc. : '+$pattern)) 'Published launcher completes startup'
 $text=Read-SharedText (Join-Path $data 'game.log')
 Check ($text -notmatch 'SCRIPT ERROR|Parse Error') 'No script or parse error'
 $lines=$text -split '\r?\n';$unexpected=@();$expectedAudio=@()
 for($i=0;$i -lt $lines.Count;$i++){
  if($lines[$i] -notmatch '^ERROR:'){continue}
  $context=($lines[$i..([Math]::Min($i+3,$lines.Count-1))] -join "`n")
  if($i+1 -lt $lines.Count -and $lines[$i+1] -match '^\s*at: .+ \(drivers/wasapi/audio_driver_wasapi\.cpp:\d+\)\s*$' -and ($lines[$i] -match '^ERROR: WASAPI: init_output_device error\.$' -or $lines[$i] -eq 'ERROR: Condition "hr != ((HRESULT)0x00000000)" is true. Returning: ERR_CANT_OPEN')){$expectedAudio+=,$context}else{$unexpected+=,$context}
 }
 $result.expectedCiAudioErrors=$expectedAudio;$result.unexpectedRuntimeErrors=$unexpected
 Check ($unexpected.Count -eq 0) 'No unexpected engine runtime error (known WASAPI initialization failure on audio-less CI recorded separately)'

 $result.status='passed'
}catch{
 $result.status='failed';$result.error=$_.Exception.ToString();Save-Report;Write-Output $result.error
 try{Capture-Desktop}catch{$result.captureError=$_.Exception.Message}
 throw
}finally{
 $logs=[ordered]@{}
 $result.completedUtc=[DateTime]::UtcNow.ToString('o');Save-Report
 if($owned){
  foreach($name in @('installation.log','launcher.log','game.log')){
   $path=Join-Path $data $name
   try{$logs[$name]=if(Test-Path -LiteralPath $path){@((Read-SharedText $path) -split '\r?\n' | Select-Object -Last 100)}else{@('MISSING')}}catch{$logs[$name]=@('READ ERROR: '+$_.Exception.Message)}
  }
  $result.logs=$logs;Save-Report
  $events=@()
  foreach($channel in @('Application','Microsoft-Windows-CodeIntegrity/Operational','Microsoft-Windows-AppLocker/EXE and DLL')){
   try{$events+=@(Get-WinEvent -FilterHashtable @{LogName=$channel;StartTime=$start.ToLocalTime()} -ErrorAction SilentlyContinue | Where-Object {$_.Message -match 'Throne.of.Ashes'} | Select-Object -First 8 | ForEach-Object {[ordered]@{channel=$channel;id=$_.Id;time=$_.TimeCreated.ToUniversalTime().ToString('o');message=$_.Message}})}catch{$events+=,[ordered]@{channel=$channel;readError=$_.Exception.Message}}
  }
  $result.events=$events;Save-Report
  foreach($name in @('Throne-of-Ashes-Game','Throne-of-Ashes-Setup','Throne-of-Ashes-Start','Throne-of-Ashes')){
   Get-Process -Name $name -ErrorAction SilentlyContinue | ForEach-Object {try{if($_.StartTime.ToUniversalTime() -ge $start){Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue}}catch{}}
  }
 }
 $result.logs=$logs;$result.completedUtc=[DateTime]::UtcNow.ToString('o');Save-Report
 Write-Output ('INSTALL_E2E_REPORT: '+$reportPath)
}
