param([Parameter(Mandatory=$true)][string]$Directory,[Parameter(Mandatory=$true)][string]$Tag)
$ErrorActionPreference='Stop'
if($env:OS -ne 'Windows_NT' -or $env:GITHUB_ACTIONS -ne 'true'){throw 'Reserve au runner Windows CI jetable.'}
$version=$Tag.TrimStart('v');$directory=(Resolve-Path $Directory).Path
$fixture=Join-Path $env:RUNNER_TEMP ('toa-window-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $fixture | Out-Null
$reportPath=Join-Path $pwd 'verification/game-window.json'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$gameDirectory=Join-Path $fixture ("versions/"+$version)
New-Item -ItemType Directory $gameDirectory -Force | Out-Null
[IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $directory "Throne-of-Ashes-$version-update.zip"),$gameDirectory)
$launcher=Join-Path $fixture 'Throne-of-Ashes.exe'
Copy-Item (Join-Path $directory 'Throne-of-Ashes.exe') $launcher
$harness=Join-Path $fixture 'VerifierGameWindow.exe'
$source=Join-Path $PSScriptRoot 'VerifierGameWindow.cs'
& 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$harness /reference:$launcher /reference:System.Web.Extensions.dll $source
if($LASTEXITCODE -ne 0){throw 'Compilation du controle graphique refusee.'}
& $harness $fixture $version $reportPath
if($LASTEXITCODE -ne 0){throw 'Controle de la vraie fenetre du jeu refuse.'}
