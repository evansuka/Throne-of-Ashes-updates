param([Parameter(Mandatory=$true)][string]$Setup)
$ErrorActionPreference='Stop'
$Setup=(Resolve-Path $Setup).Path
$fixture=Join-Path ([IO.Path]::GetTempPath()) ('toa-installer-tests-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $fixture | Out-Null
try{
 Copy-Item $Setup (Join-Path $fixture 'Throne-of-Ashes-Setup.exe')
 $probe=Join-Path $fixture 'Probe.exe';$probeSource=Join-Path $fixture 'Probe.cs';[IO.File]::WriteAllText($probeSource,'public static class Probe { public static int Main(){return 0;} }')
 $exe=Join-Path $fixture 'VerifierInstallation.exe';$source=Join-Path $PSScriptRoot 'VerifierInstallation.cs'
 if($env:OS -eq 'Windows_NT'){
  & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$probe $probeSource
  if($LASTEXITCODE -ne 0){throw 'Probe refuse.'}
  & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$exe /reference:$Setup /reference:System.Windows.Forms.dll $source
  if($LASTEXITCODE -ne 0){throw 'Compilation des controles installation refusee.'}
  & $exe $Setup $probe
 }else{
  & mcs '-target:exe' "-out:$probe" $probeSource
  if($LASTEXITCODE -ne 0){throw 'Probe refuse.'}
  & mcs '-target:exe' "-out:$exe" "-r:$Setup" '-r:System.Windows.Forms.dll' $source
  if($LASTEXITCODE -ne 0){throw 'Compilation des controles installation refusee.'}
  & mono $exe $Setup $probe
 }
 if($LASTEXITCODE -ne 0){throw 'Controles installation refuses.'}
}finally{Remove-Item $fixture -Recurse -Force}
