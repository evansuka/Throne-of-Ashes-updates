param([Parameter(Mandatory=$true)][string]$Directory,[Parameter(Mandatory=$true)][string]$Tag,[switch]$SkipGameLaunch)
$ErrorActionPreference='Stop'
if($Tag -notmatch '^v\d+\.\d+\.\d+$'){throw 'Tag de version invalide.'}
$version=$Tag.Substring(1)
$short=($version -split '\.')[0..1] -join '.'
$Directory=(Resolve-Path -LiteralPath $Directory).Path
$manifest=Get-Content -LiteralPath (Join-Path $Directory 'update.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$expectedUrl="https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/$Tag/Throne-of-Ashes-$version-update.zip"
if($manifest.version -ne $version -or $manifest.url -ne $expectedUrl){throw 'Le manifeste ne correspond pas au tag.'}
$notes=Get-Content -LiteralPath (Join-Path $Directory 'RELEASE.md') -Raw -Encoding UTF8
if(-not $notes.StartsWith("# Throne of Ashes $version`n") -or $notes -notmatch '(?m)^- \S'){throw 'Notes de version manquantes ou incorrectes.'}
$checksums=Get-Content -LiteralPath (Join-Path $Directory 'checksums.json') -Raw -Encoding UTF8 | ConvertFrom-Json
foreach($entry in $checksums.PSObject.Properties){
 if($entry.Name -notmatch '^[A-Za-z0-9._-]+$'){throw 'Nom de fichier invalide dans les empreintes.'}
 if((Get-FileHash -LiteralPath (Join-Path $Directory $entry.Name) -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.Value){throw "Empreinte invalide : $($entry.Name)"}
}
$update=Join-Path $Directory "Throne-of-Ashes-$version-update.zip"
if((Get-FileHash -LiteralPath $update -Algorithm SHA256).Hash.ToLowerInvariant() -ne $manifest.sha256){throw 'Archive de mise a jour incorrecte.'}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$fixture=Join-Path ([IO.Path]::GetTempPath()) ('toa-publication-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixture | Out-Null
[IO.Compression.ZipFile]::ExtractToDirectory($update,(Join-Path $fixture 'update'))
$bundle=Join-Path $Directory "Throne-of-Ashes-Godot-$short-Windows.zip"
[IO.Compression.ZipFile]::ExtractToDirectory($bundle,(Join-Path $fixture 'bundle'))
$game=Join-Path $fixture 'update/Throne-of-Ashes-Game.exe'
foreach($candidate in @($game,(Join-Path $fixture 'bundle/Throne-of-Ashes-Game.exe'))){
 if((Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash.ToLowerInvariant() -ne $manifest.exeSha256){throw 'EXE du jeu incorrect dans une archive.'}
}
$launcher=Join-Path $Directory 'Throne-of-Ashes.exe'
if((Get-FileHash -LiteralPath $launcher -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath (Join-Path $fixture 'bundle/Throne-of-Ashes.exe') -Algorithm SHA256).Hash){throw 'Lanceurs incoherents.'}
foreach($folder in @('update','bundle')){
 if((Get-Content -LiteralPath (Join-Path $fixture "$folder/RELEASE.md") -Raw -Encoding UTF8) -ne $notes){throw 'Notes absentes ou perimees dans une archive.'}
}
[Reflection.Assembly]::LoadFile($launcher) | Out-Null
if([UpdateLogic]::BundledVersion -ne $version -or [UpdateLogic]::BundledHash -ne $manifest.exeSha256){throw 'Le lanceur ne correspond pas au jeu embarque.'}
$oldGame=Join-Path $fixture 'old.exe';[IO.File]::WriteAllBytes($oldGame,[byte[]]@(77,90,1,2,3,4))
$oldZip=Join-Path $fixture 'old.zip'
$archive=[IO.Compression.ZipFile]::Open($oldZip,[IO.Compression.ZipArchiveMode]::Create)
try{[IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,$oldGame,'Throne-of-Ashes-Game.exe') | Out-Null}finally{$archive.Dispose()}
$old=New-Object UpdateManifest
$old.version='0.0.1';$old.url='https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v0.0.1/game.zip'
$old.sha256=[UpdateLogic]::Hash($oldZip);$old.exeSha256=[UpdateLogic]::Hash($oldGame)
$current=New-Object UpdateManifest
$current.version=$version;$current.url=$manifest.url;$current.sha256=$manifest.sha256;$current.exeSha256=$manifest.exeSha256
foreach($machine in @('pc-a','pc-b')){
 $root=Join-Path $fixture $machine
 [UpdateLogic]::Install($old,$oldZip,$root)
 $save=Join-Path $root 'campagne-v1.json';[IO.File]::WriteAllText($save,'SAVE-MUST-STAY-UNCHANGED');$before=[UpdateLogic]::Hash($save)
 [UpdateLogic]::Install($current,$update,$root)
 if([UpdateLogic]::Installed($root) -ne $version){throw 'Installation de la nouvelle version incorrecte.'}
 if([UpdateLogic]::Hash($save) -ne $before){throw 'Sauvegarde modifiee par installation.'}
 if(-not [IO.File]::Exists([UpdateLogic]::GamePath($root,'0.0.1'))){throw 'Ancienne version non conservee.'}
 $current.sha256='0'*64;$rejected=$false
 try{[UpdateLogic]::Install($current,$update,$root)}catch{$rejected=$true}
 if(-not $rejected -or [UpdateLogic]::Installed($root) -ne $version){throw 'Un telechargement invalide ne preserve pas la version active.'}
 $current.sha256=$manifest.sha256
}
if(-not $SkipGameLaunch){
 $log=Join-Path $fixture 'game.log';$stderr=Join-Path $fixture 'game.err'
 $start=New-Object Diagnostics.ProcessStartInfo
 $start.FileName=$game;$start.WorkingDirectory=Split-Path -Parent $game
 $start.Arguments='--headless --audio-driver Dummy --fixed-fps 60 --quit-after 600 -- --smoke-test'
 $start.UseShellExecute=$false;$start.CreateNoWindow=$true
 $start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
 $process=[Diagnostics.Process]::Start($start)
 $stdoutTask=$process.StandardOutput.ReadToEndAsync();$stderrTask=$process.StandardError.ReadToEndAsync()
 if(-not $process.WaitForExit(90000)){$process.Kill();throw 'Le jeu Windows ne termine pas le test de demarrage.'}
 $process.WaitForExit()
 [IO.File]::WriteAllText($log,$stdoutTask.Result);[IO.File]::WriteAllText($stderr,$stderrTask.Result)
 if($null -eq $process.ExitCode -or $process.ExitCode -ne 0){throw "Le jeu Windows termine en erreur $($process.ExitCode)."}
 $output=(Get-Content -LiteralPath $log -Raw)+(Get-Content -LiteralPath $stderr -Raw)
 Write-Output $output
 if($output -notmatch 'VILLAGE_READY' -or $output -match 'SCRIPT ERROR|ERROR:|Parse Error'){throw 'Le jeu Windows ne demarre pas proprement.'}
}
Write-Output "WINDOWS_PACKAGE_OK: $version; checksums, archives, exact launcher binding, two independent installations, save preservation, corrupt download rejection."
