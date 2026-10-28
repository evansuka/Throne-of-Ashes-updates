function Get-PublicationReportPath([string]$Root,[string]$Version,[string]$RunId,[bool]$Published){
 if($Version -notmatch '^\d+\.\d+\.\d+$' -or $RunId -notmatch '^\d+$'){throw 'Identite du rapport invalide.'}
 $path="verification/publication-$Version.json"
 $existing=Join-Path $Root $path
 if(-not $Published -and (Test-Path -LiteralPath $existing)){
  $previous=Get-Content -LiteralPath $existing -Raw | ConvertFrom-Json
  if($previous.status -eq 'passed' -and $previous.published){return "verification/publication-$Version-attempt-$RunId.json"}
 }
 return $path
}
