param([Parameter(Mandatory=$true)][string]$Directory)
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath($Directory)
$planPath=Join-Path $root 'transfer-parts.json'
if(-not (Test-Path -LiteralPath $planPath)){Write-Output 'Transfert classique : aucun assemblage.';return}
$plan=Get-Content -LiteralPath $planPath -Raw | ConvertFrom-Json
$checks=Get-Content -LiteralPath (Join-Path $root 'checksums.json') -Raw | ConvertFrom-Json
if($plan.version -ne 1 -or @($plan.files).Count -lt 1 -or @($plan.files).Count -gt 4){throw 'Plan de transfert invalide.'}
foreach($file in $plan.files){
 if($file.name -notmatch '^Throne-of-Ashes-[A-Za-z0-9.-]+(?:-update|-Windows)\.zip$' -or $file.sha256 -notmatch '^[0-9a-f]{64}$'){throw 'Nom ou empreinte de transfert invalide.'}
 if($checks.PSObject.Properties[$file.name].Value -ne $file.sha256 -or $file.bytes -le 0 -or $file.bytes -gt 2GB){throw 'Transfert incompatible avec les empreintes.'}
 if(@($file.parts).Count -lt 2 -or @($file.parts).Count -gt 32){throw 'Nombre de morceaux invalide.'}
 $destination=Join-Path $root $file.name
 if(Test-Path -LiteralPath $destination){throw 'La destination existe deja.'}
 $temporary=$destination+'.assembling'
 if(Test-Path -LiteralPath $temporary){throw 'Assemblage temporaire deja present.'}
 $stream=$null;$total=[long]0
 try{
  $stream=[IO.File]::Open($temporary,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
  for($i=0;$i -lt @($file.parts).Count;$i++){
   $part=$file.parts[$i];$expected=$file.name+'.part'+$i.ToString('D3')
   if($part.name -cne $expected -or $part.bytes -le 0 -or $part.bytes -gt 48MB -or $part.sha256 -notmatch '^[0-9a-f]{64}$'){throw 'Morceau invalide.'}
   $path=Join-Path $root $expected
   if((Get-Item -LiteralPath $path).Length -ne $part.bytes -or (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() -ne $part.sha256){throw 'Morceau incomplet ou corrompu.'}
   $inputFile=[IO.File]::OpenRead($path)
   try{$inputFile.CopyTo($stream)}finally{$inputFile.Dispose()}
   $total+=$part.bytes
  }
  $stream.Dispose();$stream=$null
  if($total -ne $file.bytes -or (Get-FileHash -LiteralPath $temporary -Algorithm SHA256).Hash.ToLowerInvariant() -ne $file.sha256){throw 'Archive assemblee non conforme.'}
  Move-Item -LiteralPath $temporary -Destination $destination
 }finally{
  if($null -ne $stream){$stream.Dispose()}
  if(Test-Path -LiteralPath $temporary){Remove-Item -LiteralPath $temporary}
 }
 foreach($part in $file.parts){Remove-Item -LiteralPath (Join-Path $root $part.name)}
 Write-Output ('TRANSFERT_ASSEMBLE_OK : '+$file.name+' ; '+$total+' octets')
}
Remove-Item -LiteralPath $planPath
