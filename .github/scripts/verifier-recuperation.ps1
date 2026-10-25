param([Parameter(Mandatory=$true)][string]$Setup,[Parameter(Mandatory=$true)][string]$Assembly,[string]$Sources=$PSScriptRoot,[string]$ReportPath='')
$ErrorActionPreference='Stop'
$Setup=(Resolve-Path $Setup).Path;$Assembly=(Resolve-Path $Assembly).Path
$fixture=Join-Path ([IO.Path]::GetTempPath()) ('toa-recovery-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $fixture | Out-Null
Copy-Item $Setup,$Assembly $fixture
$probe=Join-Path $fixture 'Probe.exe';$probeSource=Join-Path $fixture 'Probe.cs'
[IO.File]::WriteAllText($probeSource,'public static class Probe { public static int Main(){return 0;} }')
$report=[ordered]@{status='running';launcherSha256=(Get-FileHash $Assembly -Algorithm SHA256).Hash.ToLowerInvariant();setupSha256=(Get-FileHash $Setup -Algorithm SHA256).Hash.ToLowerInvariant()}
try{
 if($env:OS -eq 'Windows_NT'){
  & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$probe $probeSource
 }else{ & mcs '-target:exe' "-out:$probe" $probeSource }
 if($LASTEXITCODE -ne 0){throw 'Compilation probe refusee.'}
 foreach($suite in @('Installer','Launcher')){
  $reference=if($suite -eq 'Installer'){$Setup}else{$Assembly}
  $source=(Resolve-Path (Join-Path $Sources "Recovery$suite.cs")).Path;$exe=Join-Path $fixture "Recovery$suite.exe"
  if($env:OS -eq 'Windows_NT'){
   & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe /out:$exe /reference:$reference /reference:System.Windows.Forms.dll /reference:System.Drawing.dll /reference:System.Web.Extensions.dll /reference:System.IO.Compression.dll /reference:System.IO.Compression.FileSystem.dll $source
  }else{ & mcs '-target:exe' "-out:$exe" "-r:$reference" '-r:System.Windows.Forms.dll' '-r:System.Drawing.dll' '-r:System.Web.Extensions.dll' '-r:System.IO.Compression.dll' '-r:System.IO.Compression.FileSystem.dll' $source }
  if($LASTEXITCODE -ne 0){throw "Compilation recuperation $suite refusee."}
  $arguments=if($suite -eq 'Installer'){@($Setup,$probe,$fixture)}else{@($Assembly,(Join-Path $fixture 'launcher-fixture'))}
  if($env:OS -eq 'Windows_NT'){ $output=@(& $exe @arguments) }else{ $output=@(& mono $exe @arguments) }
  $exitCode=$LASTEXITCODE
  $output | Write-Output
  if($exitCode -ne 0){throw "Recuperation $suite refusee."}
  if($suite -eq 'Installer'){$report['installer']=($output | Where-Object {$_ -match '^\{'} | Select-Object -Last 1 | ConvertFrom-Json)}
  else{$report['launcher']=Get-Content (Join-Path $fixture 'launcher-fixture/launcher-audit.json') -Raw | ConvertFrom-Json}
 }
 $report.status='passed'
 if($ReportPath){[IO.File]::WriteAllText($ReportPath,($report | ConvertTo-Json -Depth 10),[Text.UTF8Encoding]::new($false))}
 Write-Output 'RECOVERY_OK: installer 6 cases; updater 7 cases; isolated faults, cached retry, explicit restore and same-tag conflict rejection.'
}finally{Remove-Item $fixture -Recurse -Force}
