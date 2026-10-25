using System;
using System.IO;
using System.IO.Compression;
using System.Threading;
using System.Diagnostics;
using System.Windows.Forms;

// Runs the real launcher form and update workflow. Only external services are
// replaced; package verification, activation, cleanup and UI dispatch stay real.
sealed class FixtureOperations:LauncherOperations {
 public string Zip;public UpdateManifest Manifest;public bool Offline,FailStart,Corrupt,FailRelease;public int Starts,UiThread,Releases,Downloads;public Func<bool> IsLauncherVisible;
 public void Worker() {if(Thread.CurrentThread.ManagedThreadId==UiThread)throw new Exception("Blocking work ran on the UI thread.");Thread.Sleep(1500);}
 public override void Prepare(string root) {Worker();Directory.CreateDirectory(root);}
 public override string Installed(string root) {Worker();return base.Installed(root);}
 public override string ImportBundled(string root) {Worker();return "";}
 public override UpdateManifest ReadManifest() {Worker();if(Offline)throw new IOException("Offline fixture");return Manifest;}
 public override void Download(UpdateManifest m,string zip,Action<int> progress) {Downloads++;Worker();File.Copy(Zip,zip);if(Corrupt)File.AppendAllText(zip,"damaged");progress(100);}
 public override void Install(UpdateManifest m,string zip,string root) {Worker();base.Install(m,zip,root);}
 public override void ReleaseGame(){if(IsLauncherVisible())throw new Exception("Game released before launcher hidden");Releases++;if(FailRelease)throw new IOException("Handoff fixture failure");}
 public override void StartGame(string root,string version) {Starts++;Worker();if(FailStart)throw new IOException("Startup fixture failure");if(base.Installed(root)!=version)throw new Exception("Started an unverified version.");}
}
static class VerifierLauncherUi {
 static int checks;
 static void Check(bool ok,string message){checks++;if(!ok)throw new Exception(message);}
 static UpdateManifest Package(string folder,string version,out string zip) {
  var game=Path.Combine(folder,version+".exe");File.WriteAllBytes(game,new byte[]{77,90,1,2,3,4});
  zip=Path.Combine(folder,version+".zip");
  using(var archive=ZipFile.Open(zip,ZipArchiveMode.Create))ZipFileExtensions.CreateEntryFromFile(archive,game,UpdateLogic.Game);
  return new UpdateManifest{version=version,url="https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v"+version+"/game.zip",sha256=UpdateLogic.Hash(zip),exeSha256=UpdateLogic.Hash(game)};
 }
 static void Scenario(string folder,string name,UpdateManifest old,string oldZip,UpdateManifest current,string zip,bool installed,bool offline,bool failStart,bool corrupt,bool failRelease=false) {
  var root=Path.Combine(folder,name);Directory.CreateDirectory(root);
  if(installed)UpdateLogic.Install(old,oldZip,root);
  var save=Path.Combine(root,"campagne-v1.json");File.WriteAllText(save,"SAVE-MUST-STAY-UNCHANGED");var saveHash=UpdateLogic.Hash(save);
  var ops=new FixtureOperations{UiThread=Thread.CurrentThread.ManagedThreadId,Manifest=current,Zip=zip,Offline=offline,FailStart=failStart,Corrupt=corrupt,FailRelease=failRelease};
  bool errorShown=false,timedOut=false;long gap=0,last=0;int ticks=0;
  var clock=Stopwatch.StartNew();
  using(var form=new Launcher(root,ops))using(var timer=new System.Windows.Forms.Timer{Interval=30}) {
   ops.IsLauncherVisible=()=>form.Visible;
   timer.Tick+=(s,e)=>{
    long now=clock.ElapsedMilliseconds;if(last>0)gap=Math.Max(gap,now-last);last=now;ticks++;
    foreach(Control control in form.Controls)if(control is Button&&control.Visible&&control.Text=="Réessayer"){errorShown=true;form.Close();}
    if(now>25000){timedOut=true;form.Close();}
   };
   timer.Start();Application.Run(form);timer.Stop();
  }
  Check(!timedOut,name+": update did not finish");
  Check(ticks>40&&gap<1100,name+": unresponsive UI, gap="+gap+", ticks="+ticks);
  Check(errorShown==failStart,name+": unexpected error/retry state");
  Check(ops.Releases==(failStart?0:1),name+": exactly one release after launcher hidden");
  Check(ops.Starts==1,name+": startup was retried or never attempted");
  Check(UpdateLogic.Installed(root)==((offline||corrupt)?old.version:current.version),name+": wrong active version");
  Check(UpdateLogic.Hash(save)==saveHash,name+": save changed");
  Check(Directory.GetFiles(root,"*.zip",SearchOption.AllDirectories).Length==0,name+": download not cleaned");
  var log=File.ReadAllText(Path.Combine(root,"launcher.log"));
  Check(log.Contains("ERREUR")== (offline||failStart||corrupt),name+": missing diagnostic");
  Console.WriteLine("LAUNCHER_UI_CASE: "+name+"; ticks="+ticks+"; max gap="+gap+" ms; starts="+ops.Starts);
 }
 static void ManualRestore(string folder,UpdateManifest old,string oldZip,UpdateManifest current,string zip){
  var root=Path.Combine(folder,"manual-restore-ui");UpdateLogic.Install(old,oldZip,root);
  var ops=new FixtureOperations{UiThread=Thread.CurrentThread.ManagedThreadId,Manifest=current,Zip=zip,FailStart=true};
  bool clicked=false,timedOut=false;var clock=Stopwatch.StartNew();
  using(var form=new Launcher(root,ops))using(var timer=new System.Windows.Forms.Timer{Interval=30}){
   ops.IsLauncherVisible=()=>form.Visible;
   timer.Tick+=(s,e)=>{
    foreach(Control control in form.Controls)if(!clicked&&control is Button&&control.Visible&&control.Text=="Restaurer la version précédente"){
     Check(ops.Starts==1,"restore: failure never automatically restarts the game");
     clicked=true;ops.FailStart=false;((Button)control).PerformClick();break;
    }
    if(clock.Elapsed.TotalSeconds>40){timedOut=true;form.Close();}
   };
   timer.Start();Application.Run(form);timer.Stop();
  }
  Check(!timedOut&&clicked,"restore: visible recovery control can be clicked");
  Check(ops.Starts==2&&ops.Releases==1,"restore: one extra start only after explicit click");
  Check(ops.Downloads==1,"restore: failed candidate is not downloaded again");
  Check(UpdateLogic.Installed(root)==old.version,"restore: verified previous version selected");
  Console.WriteLine("LAUNCHER_UI_CASE: manual-restore; explicitClick="+clicked+"; starts="+ops.Starts+"; downloads="+ops.Downloads);
 }
 [STAThread] static int Main(string[] args) {
  try {
   Application.EnableVisualStyles();Application.SetCompatibleTextRenderingDefault(false);
   var folder=Path.Combine(Path.GetTempPath(),"toa-launcher-ui-"+Guid.NewGuid().ToString("N"));Directory.CreateDirectory(folder);
   string oldZip,zip;var old=Package(folder,"1.0.0",out oldZip);var current=Package(folder,"1.1.0",out zip);
   Scenario(folder,"fresh-install",old,oldZip,current,zip,false,false,false,false);
   Scenario(folder,"offline-fallback",old,oldZip,current,zip,true,true,false,false);
   Scenario(folder,"startup-failure-no-loop",old,oldZip,current,zip,true,false,true,false);
   Scenario(folder,"corrupt-update-fallback",old,oldZip,current,zip,true,false,false,true);
   Scenario(folder,"handoff-write-failure-no-crash",old,oldZip,current,zip,true,false,false,false,true);
   ManualRestore(folder,old,oldZip,current,zip);
   Console.WriteLine("LAUNCHER_UI_OK: "+checks+" checks; real WinForms loop, responsive slow verification/install/start, offline fallback, startup failure without retry loop, save preservation.");return 0;
  }catch(Exception error){Console.Error.WriteLine(error);return 1;}
 }
}
