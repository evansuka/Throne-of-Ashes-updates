param([Parameter(Mandatory=$true)][string]$Assembly)
$ErrorActionPreference='Stop'
$Assembly=(Resolve-Path -LiteralPath $Assembly).Path
$fixture=Join-Path ([IO.Path]::GetTempPath()) ('toa-startup-test-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixture | Out-Null
Copy-Item -LiteralPath $Assembly -Destination (Join-Path $fixture ([IO.Path]::GetFileName($Assembly)))
$output=Join-Path $fixture 'VerifierLauncherStartup.exe'
$source=Join-Path $PSScriptRoot 'VerifierLauncherStartup.cs'
if($env:OS -eq 'Windows_NT'){
 & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$output /reference:$Assembly /reference:System.Web.Extensions.dll $source
}else{
 & mcs '-target:exe' "-out:$output" "-r:$Assembly" '-r:System.Web.Extensions.dll' $source
}
if($LASTEXITCODE -ne 0){throw 'Compilation du test de demarrage interrompue.'}
$start=New-Object Diagnostics.ProcessStartInfo
$start.FileName=if($env:OS -eq 'Windows_NT'){$output}else{'mono'}
if($env:OS -ne 'Windows_NT'){$start.Arguments='"'+$output+'" mono'}
$start.UseShellExecute=$false;$start.CreateNoWindow=$true
$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
$process=[Diagnostics.Process]::Start($start)
$stdout=$process.StandardOutput.ReadToEndAsync();$stderr=$process.StandardError.ReadToEndAsync()
if(-not $process.WaitForExit(60000)){$process.Kill();throw 'Le test de demarrage a depasse 60 secondes.'}
$process.WaitForExit();$details=($stdout.Result+' '+$stderr.Result).Trim();Write-Output $details
if($process.ExitCode -ne 0){throw ('Le test de demarrage des anciens et nouveaux jeux a echoue : '+$details)}
Remove-Item -LiteralPath $fixture -Recurse -Force
