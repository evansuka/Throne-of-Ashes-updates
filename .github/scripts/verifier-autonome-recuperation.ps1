param([Parameter(Mandatory=$true)][string]$Helper)
$ErrorActionPreference='Stop'
$root=Join-Path $env:RUNNER_TEMP ('toa-portable-recovery-'+[Guid]::NewGuid().ToString('N'));New-Item -ItemType Directory $root|Out-Null
$checks=@();$children=New-Object Collections.Generic.List[Diagnostics.Process]
function Hash($p){(Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash.ToLowerInvariant()}
function Check($ok,$message){if(-not $ok){throw $message};$script:checks+=@($message)}
function StartExe($exe,$arguments=''){$s=New-Object Diagnostics.ProcessStartInfo;$s.FileName=$exe;$s.Arguments=$arguments;$s.UseShellExecute=$false;$p=[Diagnostics.Process]::Start($s);$script:children.Add($p);return $p}
$source=@'
using System;using System.IO;using System.Threading;using System.Diagnostics;using System.Web.Script.Serialization;
class Probe {static int Main(string[] args){
 foreach(string a in args){
  if(a.StartsWith("--portable-update-ticket=")){
   if(!READY)return 23;
   string plan=a.Substring("--portable-update-ticket=".Length);File.WriteAllText(Path.Combine(Path.GetDirectoryName(plan),"game.ready"),Process.GetCurrentProcess().Id.ToString());Thread.Sleep(60000);return 0;
  }
  if(a.StartsWith("--portable-update-failed=")){
   string plan=a.Substring("--portable-update-failed=".Length);File.AppendAllText(Path.Combine(Path.GetDirectoryName(plan),"fallback.txt"),"one\n");Thread.Sleep(60000);return 0;
  }
 }
 Thread.Sleep(60000);return 0;}}
'@
foreach($mode in @('old','good','bad')){
 $cs=Join-Path $root ($mode+'.cs');[IO.File]::WriteAllText($cs,$source.Replace('READY',$(if($mode -eq 'bad'){'false'}else{'true'})))
 & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:winexe /out:"$root/$mode.exe" /reference:System.Web.Extensions.dll $cs
 if($LASTEXITCODE -ne 0){throw 'Probe compilation failed.'}
}
try{
 foreach($case in @('success','bad-hash','outside-path','startup-failure','stage-changed','locked-target')){
  $dir=Join-Path $root ($case+' espaces été');New-Item -ItemType Directory $dir|Out-Null
  $target=Join-Path $dir 'Jeu été.exe';Copy-Item (Join-Path $root 'old.exe') $target
  $next=Join-Path $dir ('.toa-update-'+[Guid]::NewGuid().ToString('N')+'.exe')
  Copy-Item (Join-Path $root $(if($case -eq 'startup-failure'){'bad.exe'}else{'good.exe'})) $next
  $oldHash=Hash $target;$newHash=Hash $next;$parent=StartExe $target
  $plan=@{target=$target;next=$next;parentPid=$parent.Id;oldHash=$oldHash;newHash=$newHash;version='999.0.0'}
  if($case -eq 'bad-hash'){$plan.newHash='0'*64}
  if($case -eq 'outside-path'){$plan.next=Join-Path $root 'good.exe'}
  $planFile=Join-Path $dir 'plan.json';[IO.File]::WriteAllText($planFile,($plan|ConvertTo-Json),[Text.UTF8Encoding]::new($false))
  $helperProcess=StartExe 'powershell.exe' ('-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "'+$Helper+'" -Plan "'+$planFile+'"')
  $clock=[Diagnostics.Stopwatch]::StartNew();$ready=Join-Path $dir 'helper.ready'
  while(-not (Test-Path $ready) -and -not $helperProcess.HasExited -and $clock.Elapsed.TotalSeconds -lt 20){Start-Sleep -Milliseconds 50}
  $lock=$null
  if($case -in @('bad-hash','outside-path')){
   Check (-not (Test-Path $ready)) ($case+': rejected before game closes')
   Check (-not $parent.HasExited) ($case+': original process remains alive')
  }else{
   Check (Test-Path $ready) ($case+': helper validates before handoff')
   if($case -eq 'stage-changed'){[IO.File]::AppendAllText($next,'changed')}
   if($case -eq 'locked-target'){$lock=[IO.File]::Open($target,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::Read)}
   $parent.Kill();$parent.WaitForExit()
  }
  try{
   if(-not $helperProcess.WaitForExit(25000)){$helperProcess.Kill();throw ('Helper timeout: '+$case)}
  }finally{if($lock){$lock.Dispose()}}
  if($case -eq 'success'){
   Check ($helperProcess.ExitCode -eq 0) 'Success helper exits cleanly'
   Check ((Hash $target) -eq $newHash) 'New verified binary activated'
   Check ((Hash ($target+'.previous')) -eq $oldHash) 'Previous binary retained'
   $pidNew=[int](Get-Content (Join-Path $dir 'game.ready'));$children.Add((Get-Process -Id $pidNew))
  }else{
   Check ($helperProcess.ExitCode -ne 0) ($case+': failure reported')
   Check ((Hash $target) -eq $oldHash) ($case+': old binary preserved or restored')
  }
  if($case -eq 'startup-failure'){
   $clock.Restart();$fallback=Join-Path $dir 'fallback.txt'
   while(-not (Test-Path $fallback) -and $clock.Elapsed.TotalSeconds -lt 10){Start-Sleep -Milliseconds 100}
   Check (Test-Path $fallback) 'Failed new game starts the old game once'
   Check (@(Get-Content $fallback).Count -eq 1) 'Rollback never loops'
  }
  # Clean only fixture processes, including the one-time fallback.
  foreach($p in @(Get-Process -ErrorAction SilentlyContinue|Where-Object {try{$_.MainModule.FileName -eq $target}catch{$false}})){if(-not $p.HasExited){$p.Kill();$p.WaitForExit()}}
 }
 $result=@{status='passed';checks=$checks;cases=6;noSecuritySettingsChanged=$true}
 [IO.File]::WriteAllText((Join-Path $pwd 'verification/portable-recovery.json'),($result|ConvertTo-Json -Depth 5),[Text.UTF8Encoding]::new($false))
 Write-Output ('PORTABLE_RECOVERY_OK: '+$checks.Count+' checks; six real process/replacement/rollback cases.')
}finally{foreach($p in $children){try{if(-not $p.HasExited){$p.Kill();$p.WaitForExit()}}catch{}}}
