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
}else{
 & mcs '-target:exe' "-out:$output" "-r:$Assembly" '-r:System.Windows.Forms.dll' '-r:System.IO.Compression.dll' '-r:System.IO.Compression.FileSystem.dll' $source
 if($LASTEXITCODE -ne 0){throw 'Compilation du test de la fenetre interrompue.'}
}
# Preserve the actual assertion in CI annotations, where full logs may require login.
$start=New-Object Diagnostics.ProcessStartInfo
$start.FileName=if($env:OS -eq 'Windows_NT'){$output}else{'mono'}
if($env:OS -ne 'Windows_NT'){$start.Arguments='"'+$output+'"'}
$start.UseShellExecute=$false;$start.CreateNoWindow=$true
$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
$process=[Diagnostics.Process]::Start($start)
$stdout=$process.StandardOutput.ReadToEndAsync();$stderr=$process.StandardError.ReadToEndAsync()
if(-not $process.WaitForExit(150000)){$process.Kill();throw 'Le test de la fenetre a depasse 150 secondes.'}
$process.WaitForExit()
$details=($stdout.Result+' '+$stderr.Result).Trim()
Write-Output $details
if($process.ExitCode -ne 0){
 $summary=($details -replace '[\r\n]+',' | ')
 if($summary.Length -gt 5000){$summary=$summary.Substring($summary.Length-5000)}
 throw ('Le test de la veritable fenetre du lanceur a echoue : '+$summary)
}
