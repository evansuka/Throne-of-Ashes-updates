param([Parameter(Mandatory=$true)][string]$Assembly)
$ErrorActionPreference='Stop'
$Assembly=(Resolve-Path -LiteralPath $Assembly).Path
$fixture=Join-Path ([IO.Path]::GetTempPath()) ('toa-ui-test-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixture | Out-Null
Copy-Item -LiteralPath $Assembly -Destination (Join-Path $fixture 'Throne-of-Ashes.exe')
$output=Join-Path $fixture 'VerifierLauncherUi.exe'
$source=Join-Path $PSScriptRoot 'VerifierLauncherUi.cs'
if($env:OS -eq 'Windows_NT'){
 & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$output /reference:$Assembly /reference:System.Windows.Forms.dll /reference:System.IO.Compression.dll /reference:System.IO.Compression.FileSystem.dll $source
 if($LASTEXITCODE -ne 0){throw 'Compilation du test de la fenetre interrompue.'}
 & $output
}else{
 & mcs '-target:exe' "-out:$output" "-r:$Assembly" '-r:System.Windows.Forms.dll' '-r:System.IO.Compression.dll' '-r:System.IO.Compression.FileSystem.dll' $source
 if($LASTEXITCODE -ne 0){throw 'Compilation du test de la fenetre interrompue.'}
 & mono $output
}
if($LASTEXITCODE -ne 0){throw 'Le test de la veritable fenetre du lanceur a echoue.'}
