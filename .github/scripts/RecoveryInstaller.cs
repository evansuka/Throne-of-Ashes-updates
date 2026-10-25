using System;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Reflection;
using System.ComponentModel;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public static class AuditInstaller {
 static readonly List<Dictionary<string,object>> Cases=new List<Dictionary<string,object>>();
 static void Record(string id,bool reproduced,Dictionary<string,object> facts){facts["id"]=id;facts["passed"]=reproduced;Cases.Add(facts);}
 static string Make(string root,string name){string path=Path.Combine(root,name);Directory.CreateDirectory(path);return path;}
 static void Initial(string root,string seed,string hash){LocalInstall.Activate(root,seed,"0.0.1",hash);LocalInstall.Activate(root,seed,LocalInstall.SeedVersion,hash);}
 static void InstallFixture(string app,string setup,string seed,string desktop){
  try{LocalInstall.Install(app,setup,seed,desktop);}
  catch(NotImplementedException){if(Environment.OSVersion.Platform==PlatformID.Win32NT)throw;}
  catch(PlatformNotSupportedException){if(Environment.OSVersion.Platform==PlatformID.Win32NT)throw;}
 }
 [STAThread] public static int Main(string[] args){
  Console.OutputEncoding=new UTF8Encoding(false);
  var report=new Dictionary<string,object>{{"suite","installer-recovery-audit"},{"cases",Cases},{"platform",Environment.OSVersion.ToString()},{"windowsShortcutExercised",Environment.OSVersion.Platform==PlatformID.Win32NT}};
  string fixture=null;bool owned=false;int exit=2;
  try{
   if(args.Length!=3)throw new ArgumentException("Usage: AuditInstaller.exe Setup.exe Probe.exe TempParent");
   string setup=Path.GetFullPath(args[0]),probe=Path.GetFullPath(args[1]);
   if(LocalInstall.Hash(setup)!=LocalInstall.Hash(typeof(LocalInstall).Assembly.Location))throw new InvalidDataException("Setup argument differs from referenced Setup assembly.");
   fixture=Path.Combine(Path.GetFullPath(args[2]),"toa-installer-audit-"+Guid.NewGuid().ToString("N"));Directory.CreateDirectory(fixture);owned=true;
   string seed=Path.Combine(fixture,"seed.exe");using(var input=Assembly.LoadFile(setup).GetManifestResourceStream("LauncherSeed"))using(var output=File.Create(seed))input.CopyTo(output);
   string hash=LocalInstall.Hash(seed);if(hash!=LocalInstall.SeedHash)throw new InvalidDataException("Embedded launcher hash mismatch.");
   report["setupVersion"]=LocalInstall.SeedVersion;report["setupSha256"]=LocalInstall.Hash(setup);
   string root=Make(fixture,"corrupt-primary");Initial(root,seed,hash);File.AppendAllText(LocalInstall.LauncherPath(root,LocalInstall.SeedVersion),"audit-corrupt-tail");
   string current=LocalInstall.Current(root);Exception failure=null;
   try{LocalInstall.Activate(root,seed,LocalInstall.SeedVersion,hash);}catch(Exception error){failure=error;}
   Record("seed-repair-succeeds",current=="0.0.1"&&failure==null&&LocalInstall.Current(root)==LocalInstall.SeedVersion,new Dictionary<string,object>{{"verifiedFallback",current},{"repairError",failure==null?null:failure.GetType().Name+": "+failure.Message},{"trigger","Same-version active launcher changed; bootstrap seeds its embedded version before Refresh or StartVerified."}});
   root=Make(fixture,"secondary-denial");string probeHash=LocalInstall.Hash(probe);Initial(root,probe,probeHash);int attempts=0;
   try{LocalInstall.StartVerified(root,LocalInstall.SeedVersion,info=>{attempts++;throw new Win32Exception(5,"audit access denied");});}catch(Win32Exception){}
   bool primaryRejected=LocalInstall.Rejected(root,LocalInstall.SeedVersion,probeHash),fallbackRejected=LocalInstall.Rejected(root,"0.0.1",probeHash);current=LocalInstall.Current(root);
   Record("all-denials-recorded",attempts==2&&primaryRejected&&fallbackRejected&&current=="",new Dictionary<string,object>{{"attempts",attempts},{"primaryRejected",primaryRejected},{"fallbackRejected",fallbackRejected},{"selectedAfterFailure",current},{"impact","Both denied hashes excluded from subsequent selection."}});
   root=Make(fixture,"missing-primary");Initial(root,probe,probeHash);string selected=LocalInstall.Current(root);File.Delete(LocalInstall.LauncherPath(root,selected));attempts=0;failure=null;
   try{using(var child=LocalInstall.StartVerified(root,selected,info=>{attempts++;return Process.Start(info);}))child.WaitForExit();}catch(Exception error){failure=error;}
   current=LocalInstall.Current(root);
   Record("missing-primary-uses-verified-fallback",failure==null&&attempts==1&&current=="0.0.1",new Dictionary<string,object>{{"error",failure==null?null:failure.GetType().Name},{"launchAttempts",attempts},{"verifiedFallback",current},{"trigger","Primary disappears after selection and before its final hash check."}});
   string app=Path.Combine(fixture,"app"),desktop=Path.Combine(fixture,"desktop");InstallFixture(app,setup,seed,desktop);string host=Path.Combine(app,LocalInstall.HostName);
   File.AppendAllText(host,"audit-corrupt-tail");string nativeVersion=FileVersionInfo.GetVersionInfo(host).FileVersion;
   if(nativeVersion!=LocalInstall.SeedVersion+".0")throw new InvalidDataException("Corruption fixture lost its native version resource.");
   InstallFixture(app,setup,seed,desktop);bool restored=LocalInstall.Hash(host)==LocalInstall.Hash(setup);
   Record("same-version-host-repaired",restored,new Dictionary<string,object>{{"nativeVersionAfterCorruption",nativeVersion},{"restoredHash",restored},{"trigger","Re-run the same Setup on a modified host retaining its native file version."}});
   root=Make(fixture,"transient-lock");Initial(root,probe,probeHash);
   attempts=0;
   using(var child=LocalInstall.StartVerified(root,LocalInstall.SeedVersion,info=>{attempts++;if(attempts==1)throw new Win32Exception(32,"temporary lock");return Process.Start(info);}))child.WaitForExit();
   bool rejected=LocalInstall.Rejected(root,LocalInstall.SeedVersion,probeHash);int downloads=0;
   var feed=new LauncherFeed{launcherVersion=LocalInstall.SeedVersion,launcherSha256=probeHash,launcherUrl="https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v"+LocalInstall.SeedVersion+"/Throne-of-Ashes.exe"};
   string cached=LocalInstall.Refresh(root,feed,(url,path)=>{downloads++;throw new Exception("Unexpected network");});
   Record("transient-lock-cached-retry",!rejected&&downloads==0&&cached==LocalInstall.SeedVersion,new Dictionary<string,object>{{"downloads",downloads},{"rejected",rejected}});
   root=Make(fixture,"modified-before-start");Initial(root,probe,probeHash);File.AppendAllText(LocalInstall.LauncherPath(root,LocalInstall.SeedVersion),"changed");attempts=0;
   using(var child=LocalInstall.StartVerified(root,LocalInstall.SeedVersion,info=>{attempts++;return Process.Start(info);}))child.WaitForExit();
   Record("modified-primary-uses-fallback",attempts==1&&LocalInstall.Current(root)=="0.0.1",new Dictionary<string,object>{{"startAttempts",attempts}});
   bool all=true;foreach(var item in Cases)if(!(bool)item["passed"])all=false;
   report["status"]=all?"all-recovery-checks-passed":"recovery-check-failed";exit=all?0:1;
  }catch(Exception error){report["status"]="harness-error";report["error"]=error.ToString();}
  finally{
   if(owned)try{Directory.Delete(fixture,true);}catch(Exception error){report["cleanupError"]=error.Message;}
   report["completedUtc"]=DateTime.UtcNow.ToString("o");Console.WriteLine(new JavaScriptSerializer().Serialize(report));
  }
  return exit;
 }
}
