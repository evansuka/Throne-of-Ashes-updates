using System;
using System.IO;
using System.IO.Compression;
using System.Collections.Generic;
using System.Reflection;
using System.Windows.Forms;
using System.Web.Script.Serialization;

// Audit harness only: real package/hash/pointer/Work code, isolated fixtures,
// fake network and StartGame so no game or external process is executed.
sealed class AuditLauncherOperations:LauncherOperations {
 public UpdateManifest Manifest;public string Zip;public int Reads,Downloads;public bool FailStartup,CopyLegacyCache;
 public readonly List<string> Starts=new List<string>();
 public override void Prepare(string root){if(CopyLegacyCache)base.Prepare(root);else Directory.CreateDirectory(root);}
 public override string ImportBundled(string root){return "";}
 public override UpdateManifest ReadManifest(){Reads++;return Manifest;}
 public override void Download(UpdateManifest manifest,string target,Action<int> progress){Downloads++;File.Copy(Zip,target);}
 public override void StartGame(string root,string version){Starts.Add(version);if(FailStartup)throw new IOException("Audit: startup failed before readiness");}
}
static class AuditLauncher {
 static readonly List<Dictionary<string,object>> cases=new List<Dictionary<string,object>>();
 static UpdateManifest Package(string folder,string version,byte tag,out string zip){
  string exe=Path.Combine(folder,version+".exe");File.WriteAllBytes(exe,new byte[]{77,90,tag});zip=Path.Combine(folder,version+".zip");
  using(var archive=ZipFile.Open(zip,ZipArchiveMode.Create))ZipFileExtensions.CreateEntryFromFile(archive,exe,UpdateLogic.Game);
  return new UpdateManifest{version=version,url="https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v"+version+"/game.zip",sha256=UpdateLogic.Hash(zip),exeSha256=UpdateLogic.Hash(exe)};
 }
 static bool Work(string root,AuditLauncherOperations services){using(var form=new Launcher(root,services))return (bool)typeof(Launcher).GetMethod("Work",BindingFlags.Instance|BindingFlags.NonPublic).Invoke(form,null);}
 static void Record(string name,bool reproduced,Dictionary<string,object> evidence){evidence["case"]=name;evidence["passed"]=reproduced;cases.Add(evidence);Console.WriteLine("AUDIT_CASE: "+name+"; passed="+reproduced);}
 [STAThread]static int Main(string[] args){
  if(args.Length!=2){Console.Error.WriteLine("Usage: AuditLauncher.exe <candidate-launcher.exe> <empty-fixture-directory>");return 1;}
  string fixture=Path.GetFullPath(args[1]);if(Directory.Exists(fixture)&&Directory.GetFileSystemEntries(fixture).Length!=0){Console.Error.WriteLine("Fixture must be empty; existing data is never touched.");return 1;}
  Directory.CreateDirectory(fixture);
  var report=new Dictionary<string,object>{{"scope","Isolated updater business logic; no real game/network; runtime startup failure is injected"},{"platform",Environment.OSVersion.VersionString},{"cases",cases},{"realPlayerDataAccessed",false},{"productionFilesModified",false}};
  int exit=1;
  try{
   string loaded=typeof(UpdateLogic).Assembly.Location;string expected=UpdateLogic.Hash(args[0]);
   if(UpdateLogic.Hash(loaded)!=expected)throw new Exception("Loaded launcher differs from candidate");
   report["launcherSha256"]=expected;report["loadedLauncher"]=loaded;
   string z1,z2,z3;var v1=Package(fixture,"1.0.0",1,out z1);var v2=Package(fixture,"1.1.0",2,out z2);var v3=Package(fixture,"1.2.0",3,out z3);
   string root=Path.Combine(fixture,"corrupt-version");UpdateLogic.Install(v1,z1,root);UpdateLogic.Install(v2,z2,root);File.WriteAllText(UpdateLogic.GamePath(root,v2.version),"CORRUPTED");
   int downloads=0;var starts=new List<string>();for(int i=0;i<2;i++){var ops=new AuditLauncherOperations{Manifest=v2,Zip=z2};Work(root,ops);downloads+=ops.Downloads;starts.AddRange(ops.Starts);}
   bool corruption=downloads==1&&UpdateLogic.Installed(root)==v2.version&&starts.Count==2&&starts[0]==v2.version&&starts[1]==v2.version;
   Record("corrupt-existing-version-repaired",corruption,new Dictionary<string,object>{{"manualLaunches",2},{"downloads",downloads},{"startedVersions",starts},{"activeVersion",UpdateLogic.Installed(root)}});
   File.WriteAllText(UpdateLogic.GamePath(root,v2.version),"CORRUPTED AGAIN");UpdateLogic.Install(v3,z3,root);File.WriteAllText(UpdateLogic.GamePath(root,v3.version),"CORRUPTED");
   bool oldValid=UpdateLogic.Hash(UpdateLogic.GamePath(root,v1.version))==v1.exeSha256;string previous=File.ReadAllText(Path.Combine(root,"previous.txt"));string active=UpdateLogic.Installed(root);
   Record("last-valid-backup-preserved",oldValid&&previous==v1.version&&active==v1.version,new Dictionary<string,object>{{"previousPointer",previous},{"activeVersion",active},{"oldestVersionStillValid",oldValid},{"trigger","Current 1.1.0 is corrupt while previous 1.0.0 is valid; install 1.2.0; damage 1.2.0"}});
   root=Path.Combine(fixture,"startup-failure");UpdateLogic.Install(v1,z1,root);starts=new List<string>();bool first=true,second=true;
   for(int i=0;i<2;i++){var ops=new AuditLauncherOperations{Manifest=v2,Zip=z2,FailStartup=true};bool result=Work(root,ops);if(i==0)first=result;else second=result;starts.AddRange(ops.Starts);}
   active=UpdateLogic.Installed(root);previous=File.ReadAllText(Path.Combine(root,"previous.txt"));
   Record("next-manual-launch-offers-recovery",!first&&!second&&active==v2.version&&previous==v1.version&&starts.Count==1&&starts[0]==v2.version,new Dictionary<string,object>{{"manualLaunches",2},{"startedVersions",starts},{"activeVersion",active},{"previousPointer",previous},{"note","No automatic restart is requested; audit checks recovery on the next explicit manual launch"}});
   root=Path.Combine(fixture,"read-only-legacy-cache");UpdateLogic.Install(v1,z1,root);string cache=Path.Combine(root,"Throne-of-Ashes.exe");File.WriteAllText(cache,"LEGACY CACHE");File.SetAttributes(cache,FileAttributes.ReadOnly);
   try{
    var ops=new AuditLauncherOperations{Manifest=v2,Zip=z2,CopyLegacyCache=true};bool result=Work(root,ops);
    Record("legacy-cache-does-not-block-update",result&&ops.Reads==1&&ops.Downloads==1&&ops.Starts.Count==1&&ops.Starts[0]==v2.version,new Dictionary<string,object>{{"manifestReads",ops.Reads},{"downloads",ops.Downloads},{"startedVersions",ops.Starts},{"launcherReportsSuccess",result}});
   }finally{File.SetAttributes(cache,FileAttributes.Normal);}
   // Explicit recovery on a later manual attempt; no same-tag download.
   root=Path.Combine(fixture,"startup-failure");UpdateLogic.Activate(root,v1.version);
   var restored=new AuditLauncherOperations{Manifest=v2,Zip=z2};bool recovered=Work(root,restored);
   Record("manual-restore-skips-failed-update",recovered&&restored.Downloads==0&&restored.Starts.Count==1&&restored.Starts[0]==v1.version,new Dictionary<string,object>{{"downloads",restored.Downloads}});
   // Changing a tag's content must still be rejected after atomic repair was added.
   root=Path.Combine(fixture,"tag-conflict");UpdateLogic.Install(v1,z1,root);var conflict=Package(fixture,"1.0.1",9,out z3);conflict.version=v1.version;bool refused=false;
   try{UpdateLogic.Install(conflict,z3,root);}catch(InvalidDataException){refused=true;}
   Record("same-tag-content-conflict-rejected",refused&&UpdateLogic.Verified(root,v1.version),new Dictionary<string,object>{{"refused",refused}});
   root=Path.Combine(fixture,"failed-candidate-newer-update");UpdateLogic.Install(v1,z1,root);
   var failing=new AuditLauncherOperations{Manifest=v2,Zip=z2,FailStartup=true};Work(root,failing);
   var newer=new AuditLauncherOperations{Manifest=v3,Zip=Path.Combine(fixture,"1.2.0.zip")};bool newerOk=Work(root,newer);
   Record("newer-version-after-startup-failure",newerOk&&newer.Downloads==1&&newer.Starts.Count==1&&newer.Starts[0]==v3.version,new Dictionary<string,object>{{"activeVersion",UpdateLogic.Installed(root)}});
   bool all=true;foreach(var result in cases)all&=(bool)result["passed"];report["status"]=all?"all-recovery-checks-passed":"recovery-check-failed";exit=all?0:2;
  }catch(Exception error){report["status"]="audit-harness-failed";report["error"]=error.ToString();Console.Error.WriteLine(error);}
  finally{report["completedUtc"]=DateTime.UtcNow.ToString("o");File.WriteAllText(Path.Combine(fixture,"launcher-audit.json"),new JavaScriptSerializer().Serialize(report));}
  return exit;
 }
}
