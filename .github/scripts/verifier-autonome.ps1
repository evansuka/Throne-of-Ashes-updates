param([Parameter(Mandatory=$true)][string]$Directory,[Parameter(Mandatory=$true)][string]$Tag)
$ErrorActionPreference='Stop'
$version=$Tag.TrimStart('v');$directory=(Resolve-Path $Directory).Path
$report=[ordered]@{status='running';version=$version;noInstaller=$true;checks=@()}
function Check([bool]$ok,[string]$message){if(-not $ok){throw $message};$script:report.checks+=@($message)}
function RunGame([string]$exe,[string]$arguments,[int]$seconds=180){
 $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName=$exe;$start.WorkingDirectory=Split-Path -Parent $exe;$start.Arguments=$arguments;$start.UseShellExecute=$false;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
 $process=[Diagnostics.Process]::Start($start);$out=$process.StandardOutput.ReadToEndAsync();$err=$process.StandardError.ReadToEndAsync()
 if(-not $process.WaitForExit($seconds*1000)){$process.Kill();$process.WaitForExit();$text=$out.Result+"`n"+$err.Result;Write-Host $text;$script:report.timeoutDiagnostics=@{arguments=$arguments;output=$text};throw 'Game verification timed out.'}
 $process.WaitForExit();$text=$out.Result+"`n"+$err.Result;Write-Host $text
 if($process.ExitCode -ne 0 -or $text -match 'SCRIPT ERROR|ERROR:|Parse Error'){
  $script:report['processDiagnostics']=@{arguments=$arguments;exitCode=$process.ExitCode;output=$text}
  $toaFailedArmor=Join-Path $fixture 'armor.json'
  if(Test-Path $toaFailedArmor){$script:report['armor']=Get-Content $toaFailedArmor -Raw -Encoding UTF8 | ConvertFrom-Json}
  $toaFailedFit=Join-Path $fixture 'equipment-fit.json'
  if(Test-Path $toaFailedFit){$script:report['equipmentFit']=Get-Content $toaFailedFit -Raw -Encoding UTF8 | ConvertFrom-Json}
  $toaFailedPresentation=Join-Path $fixture 'presentation.json'
  if(Test-Path $toaFailedPresentation){$script:report['presentation']=Get-Content $toaFailedPresentation -Raw -Encoding UTF8 | ConvertFrom-Json}
  $toaFailedWardrobe=Join-Path $fixture 'wardrobe.json'
  if(Test-Path $toaFailedWardrobe){$script:report['wardrobe']=Get-Content $toaFailedWardrobe -Raw -Encoding UTF8 | ConvertFrom-Json}
 }
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
 if([Version]$version -ge [Version]'0.14.33'){
  foreach($audit in @(@{mode='graphics';file='hero-graphics.json';marker='HERO_GRAPHICS_AUDIT';key='heroGraphics'},@{mode='coordination';file='hero-coordination.json';marker='HERO_COORDINATION_CHECKS';key='heroCoordination'})){
   $auditPath=Join-Path $fixture $audit.file
   $auditText=RunGame $game ('--headless --audio-driver Dummy -- --verify-hero-'+$audit.mode+'="'+$auditPath+'"') 180
   Check ($auditText -match $audit.marker -and (Test-Path $auditPath)) ('Embedded '+$audit.key+' audit completes')
   $auditInfo=Get-Content $auditPath -Raw -Encoding UTF8 | ConvertFrom-Json
   Check ($auditInfo.failures.Count -eq 0 -or $auditInfo.failures -eq 0) ('Exported '+$audit.key+' has no failures')
   if($audit.key -eq 'heroGraphics'){Check ($auditInfo.classes.Count -eq 4 -and $auditInfo.directions -eq 8 -and $auditInfo.metrics.poses -ge 24192) 'Four classes, eight directions and complete exported pose matrix'}
   else{Check ($auditInfo.checks -ge 14 -and -not $auditInfo.playerSavesAccessed) 'Real delayed bow release, pause, interruption and travel cancellation'}
   $report[$audit.key]=$auditInfo
  }
 }
 if([Version]$version -ge [Version]'0.14.34'){
  $garmentPath=Join-Path $fixture 'hero-garments.json'
  $garmentText=RunGame $game ('--audio-driver Dummy -- --verify-hero-garments="'+$garmentPath+'"') 180
  Check ($garmentText -match 'HERO_GARMENT_PIXELS' -and (Test-Path $garmentPath)) 'Actual rendered garment pixel audit completes'
  $garmentInfo=Get-Content $garmentPath -Raw -Encoding UTF8 | ConvertFrom-Json
  Check ($garmentInfo.failures.Count -eq 0 -and $garmentInfo.checks -ge 120 -and $garmentInfo.actualGpuPixels) 'Four class outfits retain native front/back motifs in five combat poses'
  $report['heroGarments']=$garmentInfo
 }
 if([Version]$version -ge [Version]'0.14.35'){
  $itemPath=Join-Path $fixture 'itemization.json'
  $itemText=RunGame $game ('--audio-driver Dummy -- --verify-itemization="'+$itemPath+'"') 180
  Check ($itemText -match 'ITEMIZATION_CHECKS' -and (Test-Path $itemPath)) 'Exported itemization, commerce and repair audit completes'
  $itemInfo=Get-Content $itemPath -Raw -Encoding UTF8 | ConvertFrom-Json
  Check ($itemInfo.failures.Count -eq 0 -and $itemInfo.generatedItems -ge 3072 -and $itemInfo.attackTrials -ge 10000) 'Rarity powers, physical ranges, attack speed and critical rolls verified'
  Check ($itemInfo.commerceOnlyGoldBottomLeft -and $itemInfo.jewelryDoesNotWear -and -not $itemInfo.playerSavesAccessed) 'Commerce-only bottom-left prices, repairs and jewelry preservation verified'
  $report['itemization']=$itemInfo
 }
 if([Version]$version -ge [Version]'0.14.36'){
  $villagePath=Join-Path $fixture 'village.json'
  $villageText=RunGame $game ('--audio-driver Dummy -- --verify-village="'+$villagePath+'"') 180
  Check ($villageText -match 'VILLAGE_AUDIT' -and (Test-Path $villagePath)) 'Exported village, service access and NPC audit completes'
  $villageInfo=Get-Content $villagePath -Raw -Encoding UTF8 | ConvertFrom-Json
  Check ($villageInfo.failures.Count -eq 0 -and $villageInfo.routes.Count -eq 6 -and $villageInfo.captures.Count -ge 5 -and $villageInfo.dynamicNpcClearance -gt 0.56) 'Six NPC services, full body selection, dynamic detours and five rendered village views verified'
  Check ($villageInfo.detailMeshes -le 8 -and $villageInfo.detailTriangles -lt 15000 -and -not $villageInfo.playerSavesAccessed) 'Village detail budget and isolated save policy verified'
  $report['village']=$villageInfo
 }
 if([Version]$version -ge [Version]'0.14.37'){
  Check ($villageInfo.roadSurface -eq 'dirt' -and $villageInfo.roadMeshes -eq 1 -and $villageInfo.roadBorderStones -eq 0 -and $villageInfo.roadTriangles -lt 12000) 'Continuous dirt-only trails without paving or stone borders verified'
  $armorPath=Join-Path $fixture 'armor.json'
  $armorText=RunGame $game ('--audio-driver Dummy -- --verify-armor="'+$armorPath+'"') 180
  Check ($armorText -match 'ARMOR_AUDIT' -and (Test-Path $armorPath)) 'Actual rendered armor opening audit completes'
  $armorInfo=Get-Content $armorPath -Raw -Encoding UTF8 | ConvertFrom-Json
  Check ($armorInfo.failures.Count -eq 0 -and $armorInfo.checks -ge 469 -and $armorInfo.armorModels -eq 5 -and $armorInfo.classes -eq 4 -and $armorInfo.directions -eq 8) 'Original native neck and arm pixels remain visible through all five armor model openings'
  Check ($armorInfo.changedVikingCollars -eq 5 -and $armorInfo.actualGpuPixels -and $armorInfo.viewportCoordinatesScaled -and $armorInfo.fixtureInterpolationDisabled -and -not $armorInfo.playerSavesAccessed) 'All five Viking collars corrected without accessing player saves'
  $report['armor']=$armorInfo
 }
 if([Version]$version -ge [Version]'0.14.38'){
  $fitPath=Join-Path $fixture 'equipment-fit.json'
  $fitText=RunGame $game ('--audio-driver Dummy -- --verify-equipment-fit="'+$fitPath+'"') 240
  Check ($fitText -match 'EQUIPMENT_FIT_AUDIT' -and (Test-Path $fitPath)) 'Actual worn equipment fitting audit completes'
  $fitInfo=Get-Content $fitPath -Raw -Encoding UTF8 | ConvertFrom-Json
  Check ($fitInfo.failures.Count -eq 0 -and $fitInfo.checks -ge 21802 -and $fitInfo.classes -eq 4 -and $fitInfo.directions -eq 8 -and $fitInfo.kits -eq 7) 'Four heroes retain fitted equipment across complete, mixed and unique kits'
  Check ($fitInfo.actualGpuPixels -and $fitInfo.nativeSubViewport -and $fitInfo.fixedRenderSize[0] -eq 2560 -and $fitInfo.fixedRenderSize[1] -eq 1440 -and $fitInfo.facePatchSize -eq 3 -and $fitInfo.faceBackgroundExcluded -and $fitInfo.minFaceVisibleFraction -ge 0.60 -and $fitInfo.facePixelProbes -ge 192 -and $fitInfo.opaqueShellPixelProbes -ge 336 -and -not $fitInfo.playerSavesAccessed) 'Open faces, opaque body coverage, native sleeves and rear accessories verified'
  $report['equipmentFit']=$fitInfo
 }
 if([Version]$version -ge [Version]'0.14.39'){
  $presentationPath=Join-Path $fixture 'presentation.json'
  $presentationText=RunGame $game ('--audio-driver Dummy -- --verify-presentation="'+$presentationPath+'"') 180
  Check ($presentationText -match 'PRESENTATION_AUDIT' -and (Test-Path $presentationPath)) 'Native terrain, biome and animation audit completes'
  $presentationInfo=Get-Content $presentationPath -Raw -Encoding UTF8 | ConvertFrom-Json
  $report['presentation']=$presentationInfo
  Check ($presentationInfo.failures.Count -eq 0 -and $presentationInfo.checks -ge 287 -and $presentationInfo.levels.Count -eq 6) 'Five cave regions and final room retain navigation, static details and light budgets'
  Check ($presentationInfo.actualNativeRendering -and $presentationInfo.captures.Count -eq 7 -and $presentationInfo.foliageMaterials -eq 4 -and $presentationInfo.foliageChunks -gt 4 -and $presentationInfo.foliageChunks -le 512 -and $presentationInfo.roadTriangles -lt 12000) 'Village and six dungeon views render with shared foliage materials and bounded geometry'
  Check ($presentationInfo.maxGuardReturnError -lt 0.002 -and -not $presentationInfo.playerSavesAccessed -and -not $presentationInfo.testerFpsClaimed) 'Attack recovery, hit reaction and distant AI preserve gameplay and player saves'
 }
 if([Version]$version -ge [Version]'0.14.40'){
  $wardrobePath=Join-Path $fixture 'wardrobe.json'
  $wardrobeText=RunGame $game ('--audio-driver Dummy -- --verify-wardrobe="'+$wardrobePath+'"') 240
  Check ($wardrobeText -match 'WARDROBE_AUDIT' -and (Test-Path $wardrobePath)) 'Native base-outfit replacement audit completes'
  $wardrobeInfo=Get-Content $wardrobePath -Raw -Encoding UTF8 | ConvertFrom-Json
  $report['wardrobe']=$wardrobeInfo
  Check ($wardrobeInfo.failures.Count -eq 0 -and $wardrobeInfo.checks -ge 16256 -and $wardrobeInfo.poses -eq 1280 -and $wardrobeInfo.classes -eq 4 -and $wardrobeInfo.directions -eq 8 -and $wardrobeInfo.kits -eq 10) 'Default and worn clothing remain exclusive across four heroes and mixed kits'
  Check ($wardrobeInfo.exactPixelRestorations -eq 4 -and $wardrobeInfo.nativeSubViewport -and $wardrobeInfo.fixedRenderSize[0] -eq 2560 -and $wardrobeInfo.fixedRenderSize[1] -eq 1440) 'All four native default pose images restore exactly after removing dyed and unique gear'
  Check ($wardrobeInfo.actualInventoryTransactions -and $wardrobeInfo.defaultInventoryItems -eq 0 -and $wardrobeInfo.baseStatBonus -eq 0 -and -not $wardrobeInfo.playerSavesAccessed) 'Real equip/remove creates no default inventory item or hidden stat bonus'
 }
 if([Version]$version -ge [Version]'0.14.53'){
  $gripPath=Join-Path $fixture 'hand-grips.json'
  $gripText=RunGame $game ('--audio-driver Dummy -- --verify-hand-grips="'+$gripPath+'"') 240
  Check ($gripText -match 'WRAPPED_HANDS_01453' -and (Test-Path $gripPath)) 'Exported gripping-hand shader audit completes'
  $gripInfo=Get-Content $gripPath -Raw -Encoding UTF8 | ConvertFrom-Json
  $report['handGrips']=$gripInfo
  Check ($gripInfo.nativeVersion -eq ($version+'-conversion') -and $gripText -notmatch 'SESSION_START:|GAME_UPDATE:') 'Native verification flag runs before normal game startup'
  Check ($gripInfo.failures.Count -eq 0 -and $gripInfo.poses -eq 896 -and $gripInfo.actualGpuProbes -eq $(if([Version]$version -ge [Version]'0.14.55'){96}else{48})) 'Four heroes, eight directions, visible fingers and actual shaft openings verified'
  Check ($gripInfo.maxHandleError -lt 0.00001 -and $gripInfo.originalAtlasUnmodified -and -not $gripInfo.playerSavesAccessed) 'Painted rest axes track actual hand sockets without changing the original atlas or saves'
 }
 if([Version]$version -ge [Version]'0.14.55'){
  $restPath=Join-Path $fixture 'rest-equipment.json'
  $restText=RunGame $game ('--audio-driver Dummy -- --verify-rest-equipment="'+$restPath+'"') 180
  Check ($restText -match 'REST_EQUIPMENT_01455' -and (Test-Path $restPath)) 'Native village carrying and actual zone transitions audit completes'
  $restInfo=Get-Content $restPath -Raw -Encoding UTF8 | ConvertFrom-Json
  $report['restEquipment']=$restInfo
  Check ($restInfo.nativeVersion -eq ($version+'-conversion') -and $restInfo.failures.Count -eq 0 -and $restInfo.villagePoses -eq 448) 'Four heroes retain their actual gear while stowed, including mixed kits and uniques'
  Check ($restInfo.actualStartAndTravel -and $restInfo.actualGpuFaceProbes -eq 16 -and $restInfo.coveredHairPixels -gt 20 -and -not $restInfo.playerSavesAccessed) 'Real village/dungeon transitions draw and stow weapons without accessing player saves'
 }
 $audio=RunGame $game '--headless -- --verify-audio-bridge' 45
 Check ($audio -match 'WINDOWS_AUDIO_BRIDGE_CHECKS') 'Embedded Windows audio bridge remains available'
 # The real game requests a self-replacement from its home-screen button.
 $trial=Join-Path $fixture 'essai';New-Item -ItemType Directory $trial|Out-Null
 Copy-Item $zip (Join-Path $trial 'update.zip')
 $info=@{version='999.0.0';url='https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v999.0.0/Throne-of-Ashes-999.0.0-update.zip';sha256=$manifest.sha256;exeSha256=$manifest.exeSha256}
 [IO.File]::WriteAllText((Join-Path $trial 'input.json'),($info|ConvertTo-Json),[Text.UTF8Encoding]::new($false))
 $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName=$game;$start.WorkingDirectory=$fixture;$start.UseShellExecute=$false;$start.Arguments='--audio-driver Dummy -- --verify-portable-update="'+$trial+'"'
 $start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
 $old=[Diagnostics.Process]::Start($start);$trialStdout=$old.StandardOutput.ReadToEndAsync();$trialStderr=$old.StandardError.ReadToEndAsync();$clock=[Diagnostics.Stopwatch]::StartNew()
 while(-not (Test-Path (Join-Path $trial 'trial.json')) -and -not $old.HasExited -and $clock.Elapsed.TotalSeconds -lt 90){Start-Sleep -Milliseconds 200}
 Check (Test-Path (Join-Path $trial 'trial.json')) 'Actual game prepared a self-update'
 $trialInfo=Get-Content (Join-Path $trial 'trial.json') -Raw -Encoding UTF8|ConvertFrom-Json
 Check (-not $trialInfo.realPlayerSaveAccessed) 'Self-update trial uses no player saves'
 $report.trial=$trialInfo
 Check ($trialInfo.versionLabel -eq ('VERSION '+$version)) 'Home screen displays the installed game version'
 Check ($trialInfo.button -eq 'Mettre à jour et redémarrer') 'Home screen offers the direct update action'
 $result=Join-Path $trialInfo.work 'result.json';$clock.Restart()
 while(-not (Test-Path $result) -and $clock.Elapsed.TotalSeconds -lt 300){Start-Sleep -Milliseconds 200}
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
 if($old -and -not $old.HasExited){$old.Kill();$old.WaitForExit()}
 if($trialStdout -and $trialStdout.Wait(2000)){$report.trialOutput=$trialStdout.Result}
 if($trialStderr -and $trialStderr.Wait(2000)){$report.trialErrors=$trialStderr.Result}
 if($trialInfo){$report.helperDiagnostics=@{};foreach($name in @('update.log','result.json','helper.ready')){$f=Join-Path $trialInfo.work $name;if(Test-Path $f){$report.helperDiagnostics[$name]=[IO.File]::ReadAllText($f)}}}
 [IO.File]::WriteAllText((Join-Path $pwd 'verification/portable-validation.json'),($report|ConvertTo-Json -Depth 8),[Text.UTF8Encoding]::new($false))
 if($new -and -not $new.HasExited){$new.Kill()}
 if($old -and -not $old.HasExited){$old.Kill()}
}
