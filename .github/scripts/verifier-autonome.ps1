param([Parameter(Mandatory=$true)][string]$Directory,[Parameter(Mandatory=$true)][string]$Tag)
$ErrorActionPreference='Stop'
$version=$Tag.TrimStart('v');$directory=(Resolve-Path $Directory).Path
$report=[ordered]@{status='running';version=$version;noInstaller=$true;checks=@()}
function Check([bool]$ok,[string]$message){if(-not $ok){throw $message};$script:report.checks+=@($message)}
function RunGame([string]$exe,[string]$arguments,[int]$seconds=180){
 $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName=$exe;$start.WorkingDirectory=Split-Path -Parent $exe;$start.Arguments=$arguments;$start.UseShellExecute=$false;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
 $process=[Diagnostics.Process]::Start($start);$out=$process.StandardOutput.ReadToEndAsync();$err=$process.StandardError.ReadToEndAsync()
 if(-not $process.WaitForExit($seconds*1000)){$process.Kill();throw 'Game verification timed out.'}
 $process.WaitForExit();$text=$out.Result+"`n"+$err.Result;Write-Host $text
 Check ($process.ExitCode -eq 0 -and $text -notmatch 'SCRIPT ERROR|ERROR:|Parse Error') 'Exported game verification terminates cleanly'
 return $text
}
try{
 Check ($version -match '^\d+\.\d+\.\d+$') 'Strict release version'
 $manifest=Get-Content (Join-Path $directory 'update.json') -Raw -Encoding UTF8|ConvertFrom-Json
 Check ($manifest.version -eq $version -and $manifest.distribution -eq 'standalone') 'Standalone manifest matches tag'
 Check ($manifest.url -eq "https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/$Tag/Throne-of-Ashes-$version-update.zip") 'Immutable update URL'
 Check (-not (Test-Path (Join-Path $directory 'Throne-of-Ashes-Setup.exe'))) 'No installer in distribution'
 $hashes=Get-Content (Join-Path $directory 'checksums.json') -Raw -Encoding UTF8|ConvertFrom-Json
 foreach($entry in $hashes.PSObject.Properties){
  Check ($entry.Name -match '^[A-Za-z0-9._-]+$') 'Safe distribution filename'
  Check ((Get-FileHash (Join-Path $directory $entry.Name) -Algorithm SHA256).Hash.ToLowerInvariant() -eq $entry.Value) ('Checksum '+$entry.Name)
 }
 $zip=Join-Path $directory "Throne-of-Ashes-$version-update.zip"
 Check ((Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant() -eq $manifest.sha256) 'Archive matches manifest'
 Add-Type -AssemblyName System.IO.Compression.FileSystem
 $fixture=Join-Path $env:RUNNER_TEMP ('Throne essais autonomes-'+[Guid]::NewGuid().ToString('N'));New-Item -ItemType Directory $fixture|Out-Null
 [IO.Compression.ZipFile]::ExtractToDirectory($zip,$fixture)
 $game=Join-Path $fixture 'Throne-of-Ashes-Game.exe'
 Check ((Get-FileHash $game -Algorithm SHA256).Hash.ToLowerInvariant() -eq $manifest.exeSha256) 'Executable matches manifest'
 Check ([Diagnostics.FileVersionInfo]::GetVersionInfo($game).FileVersion -eq ($version+'.0')) 'Native executable version matches release'
 Check ((Get-Content (Join-Path $directory 'RELEASE.md') -Raw).StartsWith("# Throne of Ashes $version")) 'Version-specific release notes'
 $text=RunGame $game '--audio-driver Dummy -- --verify-dungeon-biomes'
 Check ($text -match 'EXPORTED_BIOMES_OK' -and $text -match 'EXPORTED_CHRONICLES_OK') 'Six rendered floors, five guardians and ending rewards'
 $audio=RunGame $game '--headless -- --verify-audio-bridge' 45
 Check ($audio -match 'WINDOWS_AUDIO_BRIDGE_CHECKS') 'Embedded Windows audio bridge remains available'
 # The real game requests a self-replacement from its home-screen button.
 $trial=Join-Path $fixture 'essai';New-Item -ItemType Directory $trial|Out-Null
 Copy-Item $zip (Join-Path $trial 'update.zip')
 $info=@{version='999.0.0';url='https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v999.0.0/Throne-of-Ashes-999.0.0-update.zip';sha256=$manifest.sha256;exeSha256=$manifest.exeSha256}
 [IO.File]::WriteAllText((Join-Path $trial 'input.json'),($info|ConvertTo-Json),[Text.UTF8Encoding]::new($false))
 $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName=$game;$start.WorkingDirectory=$fixture;$start.UseShellExecute=$false;$start.Arguments='--audio-driver Dummy -- --verify-portable-update="'+$trial+'"'
 $old=[Diagnostics.Process]::Start($start);$clock=[Diagnostics.Stopwatch]::StartNew()
 while(-not (Test-Path (Join-Path $trial 'trial.json')) -and -not $old.HasExited -and $clock.Elapsed.TotalSeconds -lt 90){Start-Sleep -Milliseconds 200}
 Check (Test-Path (Join-Path $trial 'trial.json')) 'Actual game prepared a self-update'
 $trialInfo=Get-Content (Join-Path $trial 'trial.json') -Raw -Encoding UTF8|ConvertFrom-Json
 Check (-not $trialInfo.realPlayerSaveAccessed) 'Self-update trial uses no player saves'
 $report.trial=$trialInfo
 Check ($trialInfo.versionLabel -eq ('VERSION '+$version)) 'Home screen displays the installed game version'
 Check ($trialInfo.button -eq 'Mettre à jour et redémarrer') 'Home screen offers the direct update action'
 $result=Join-Path $trialInfo.work 'result.json';$clock.Restart()
 while(-not (Test-Path $result) -and $clock.Elapsed.TotalSeconds -lt 180){Start-Sleep -Milliseconds 200}
 Check (Test-Path $result) 'Replacement helper reports its outcome'
 $outcome=Get-Content $result -Raw -Encoding UTF8|ConvertFrom-Json
 Check ($outcome.state -eq 'success') ('Self-update completed: '+$outcome.message)
 Check $old.HasExited 'Old game exits for the explicit update'
 $newPid=[int](Get-Content (Join-Path $trialInfo.work 'game.ready') -Raw)
 $new=Get-Process -Id $newPid -ErrorAction Stop
 Start-Sleep -Seconds 10
 Check (-not $new.HasExited) 'Replacement game stays open without a restart loop'
 Check ((Get-FileHash ($game+'.previous') -Algorithm SHA256).Hash.ToLowerInvariant() -eq $manifest.exeSha256) 'Previous game retained as rollback backup'
 Copy-Item (Join-Path $trial 'home.png') 'verification/portable-home.png'
 $report.selfUpdate=@{oldPid=$old.Id;newPid=$newPid;status=$outcome.state;installedVersion=$trialInfo.versionLabel;keptAliveSeconds=10}
 $new.Kill();$new.WaitForExit()
 # Exercise the exact helper extracted by the real exported game, with isolated
 # processes and immutable source hashes. No security setting is changed.
 & (Join-Path $PSScriptRoot 'verifier-autonome-recuperation.ps1') -Helper (Join-Path $trialInfo.work 'apply.ps1')
 if($LASTEXITCODE -ne 0){throw 'Portable recovery checks failed.'}
 # Publish the game itself, not a launcher disguised by the same filename.
 Copy-Item $game (Join-Path $directory 'Throne-of-Ashes.exe')
 Check ((Get-FileHash (Join-Path $directory 'Throne-of-Ashes.exe') -Algorithm SHA256).Hash.ToLowerInvariant() -eq $manifest.exeSha256) 'Direct download is the Godot game itself'
 $report.status='passed'
 Write-Output 'PORTABLE_WINDOWS_OK: direct game, home version, real self-replacement and rollback tests; no installer.'
}catch{$report.status='failed';$report.error=$_.Exception.ToString();throw}
finally{
 [IO.File]::WriteAllText((Join-Path $pwd 'verification/portable-validation.json'),($report|ConvertTo-Json -Depth 8),[Text.UTF8Encoding]::new($false))
 if($new -and -not $new.HasExited){$new.Kill()}
 if($old -and -not $old.HasExited){$old.Kill()}
}
