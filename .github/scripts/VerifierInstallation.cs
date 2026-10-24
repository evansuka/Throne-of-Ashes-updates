using System;
using System.IO;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
public static class VerifierInstallation {
 [DllImport("kernel32.dll",CharSet=CharSet.Unicode)]static extern IntPtr LoadLibraryEx(string path,IntPtr file,uint flags);
 [DllImport("kernel32.dll")]static extern IntPtr FindResource(IntPtr module,IntPtr name,IntPtr type);
 [DllImport("kernel32.dll")]static extern IntPtr LoadResource(IntPtr module,IntPtr resource);
 [DllImport("kernel32.dll")]static extern IntPtr LockResource(IntPtr resource);
 [DllImport("kernel32.dll")]static extern uint SizeofResource(IntPtr module,IntPtr resource);
 [DllImport("kernel32.dll")]static extern bool FreeLibrary(IntPtr module);
 static string Manifest(string path){
  var module=LoadLibraryEx(path,IntPtr.Zero,2);if(module==IntPtr.Zero)throw new Exception("Cannot read PE resources");
  try{var resource=FindResource(module,new IntPtr(1),new IntPtr(24));if(resource==IntPtr.Zero)throw new Exception("Missing execution manifest");var bytes=new byte[(int)SizeofResource(module,resource)];Marshal.Copy(LockResource(LoadResource(module,resource)),bytes,0,bytes.Length);return Encoding.UTF8.GetString(bytes);}finally{FreeLibrary(module);}
 }
 static int count;
 static void Check(bool result,string label){count++;if(!result)throw new Exception(label);}
 static void Reject(Action action,string label){bool rejected=false;try{action();}catch{rejected=true;}Check(rejected,label);}
 [STAThread] public static int Main(string[] args){
  if(args.Length==1&&args[0]=="--probe")return 0;
  var fixture=Path.Combine(Path.GetTempPath(),"toa-install-test-"+Guid.NewGuid().ToString("N"));Directory.CreateDirectory(fixture);
  try{
   var detail=LocalInstall.ErrorText("UAC test",new TargetInvocationException(new System.ComponentModel.Win32Exception(5,"Accès refusé")));
   Check(detail.Contains("UAC test")&&detail.Contains("Code Windows : 5")&&detail.Contains("Win32Exception"),"Full phase and nested Windows error preserved without a log file");
   var blockedRoot=Path.Combine(fixture,"not-a-directory");File.WriteAllText(blockedRoot,"fixture");
   var fallback=LocalInstall.Log(blockedRoot,"diagnostic fallback");
   Check(fallback!=null&&File.ReadAllText(fallback).Contains("diagnostic fallback"),"Logging falls back when the normal log cannot be created");
   File.Delete(fallback);
   if(Environment.OSVersion.Platform==PlatformID.Win32NT){
    bool seen=false;Exception uiError=null;
    using(var timer=new System.Windows.Forms.Timer{Interval=150}){
     timer.Tick+=(sender,eventArgs)=>{
      foreach(System.Windows.Forms.Form form in System.Windows.Forms.Application.OpenForms){
       if(!form.Text.StartsWith("Diagnostic"))continue;
       seen=true;timer.Stop();
       try{
        bool report=false,copy=false;
        foreach(System.Windows.Forms.Control control in form.Controls){
         var box=control as System.Windows.Forms.TextBox;if(box!=null)report=box.ReadOnly&&box.Text.Contains("UAC test")&&box.Text.Contains("Code Windows : 5");
         var button=control as System.Windows.Forms.Button;if(button!=null)copy=button.Enabled&&button.Text=="Copier le diagnostic";
        }
        Check(report,"Real error dialog exposes full diagnostic when normal log is unavailable");Check(copy,"Error dialog provides copy action");
       }catch(Exception e){uiError=e;}finally{form.Close();}break;
      }
     };
     timer.Start();LocalInstall.ShowError(null,blockedRoot,"UAC test",new System.ComponentModel.Win32Exception(5,"Accès refusé"));
    }
    if(uiError!=null)throw uiError;Check(seen,"Real diagnostic dialog opened and closed");
    var uiLog=LocalInstall.Log(blockedRoot,"UI diagnostic test completed");if(uiLog!=null)File.Delete(uiLog);
   }
   var setup=Path.GetFullPath(args[0]);var probe=Path.GetFullPath(args[1]);var seed=Path.Combine(fixture,"seed.exe");
   using(var input=Assembly.LoadFile(setup).GetManifestResourceStream("LauncherSeed"))using(var output=File.Create(seed))input.CopyTo(output);
   Check(LocalInstall.Hash(seed)==LocalInstall.SeedHash,"Embedded launcher exact hash");
   Check((string)Assembly.LoadFile(seed).GetType("UpdateLogic").GetField("BundledVersion").GetRawConstantValue()==LocalInstall.SeedVersion,"Embedded launcher version matches installer");
   var helper=Path.Combine(fixture,"Uninstaller.exe");
   using(var input=Assembly.LoadFile(setup).GetManifestResourceStream("UninstallerSeed"))using(var output=File.Create(helper))input.CopyTo(output);
   try{
    Check(File.Exists(helper),"Normal uninstaller embedded and extractable");
    using(var input=File.OpenRead(helper))Check(input.ReadByte()==77&&input.ReadByte()==90,"Uninstaller is a Windows PE");
    if(Environment.OSVersion.Platform==PlatformID.Win32NT){
     Check(FileVersionInfo.GetVersionInfo(setup).FileVersion==LocalInstall.SeedVersion+".0","Setup native file version present and correct");
     Check(FileVersionInfo.GetVersionInfo(helper).FileVersion==LocalInstall.SeedVersion+".0","Uninstaller native file version present and correct");
     Check(Manifest(helper).Contains("level=\"asInvoker\""),"Uninstaller PE manifest requires no elevation");
     Check(Manifest(setup).Contains("level=\"asInvoker\""),"Normal launcher PE manifest does not elevate the game");
    }
   }finally{File.Delete(helper);}
   Check(LocalInstall.ProgramRoot==@"C:\Games\Throne of Ashes","Requested C Games installation target");
   foreach(var bad in new[]{"../escape","1.2","1.2.3/escape","v1.2.3","1.2.3.4"})Reject(()=>LocalInstall.LauncherPath(fixture,bad),"Unsafe version path");
   var manifest=new LauncherFeed{launcherVersion="99.0.0",launcherUrl="https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v99.0.0/Throne-of-Ashes.exe",launcherSha256=LocalInstall.Hash(probe)};
   LocalInstall.Validate(manifest);count++;
   var url=manifest.launcherUrl;
   foreach(var bad in new[]{"http://github.com/a","https://evil.example/game.exe",url+"?other=1",url.Replace("v99.0.0","v98.0.0")}){manifest.launcherUrl=bad;Reject(()=>LocalInstall.Validate(manifest),"Invalid launcher URL rejected");}manifest.launcherUrl=url;
   foreach(var machine in new[]{"PC A é","PC B"}){
    var root=Path.Combine(fixture,machine);Directory.CreateDirectory(root);var save=Path.Combine(root,"campagne-v1.json");File.WriteAllText(save,"SAVE MUST STAY");
    LocalInstall.Activate(root,seed,LocalInstall.SeedVersion,LocalInstall.SeedHash);Check(LocalInstall.Current(root)==LocalInstall.SeedVersion,"Initial seed activated");
    var downloads=0;
    LocalInstall.Refresh(root,manifest,(u,p)=>{downloads++;File.Copy(probe,p);});
    Check(LocalInstall.Current(root)=="99.0.0"&&downloads==1,"New launcher downloaded and activated");
    using(var child=Process.Start(new ProcessStartInfo(LocalInstall.LauncherPath(root,"99.0.0"),"--probe"){UseShellExecute=false})){Check(child.WaitForExit(10000)&&child.ExitCode==0,"Real updated child process executes");}
    LocalInstall.Refresh(root,manifest,(u,p)=>{throw new Exception("Must not download same version");});Check(LocalInstall.Current(root)=="99.0.0","Current launcher not replaced");
    manifest.launcherVersion="98.0.0";manifest.launcherUrl=url.Replace("99.0.0","98.0.0");LocalInstall.Refresh(root,manifest,(u,p)=>{throw new Exception("Must not downgrade");});Check(LocalInstall.Current(root)=="99.0.0","No downgrade");
    manifest.launcherVersion="100.0.0";manifest.launcherUrl=url.Replace("99.0.0","100.0.0");
    Reject(()=>LocalInstall.Refresh(root,manifest,(u,p)=>File.WriteAllText(p,"corrupt")),"Corrupt update rejected");Check(LocalInstall.Current(root)=="99.0.0","Active launcher preserved on corrupt update");
    Reject(()=>LocalInstall.Refresh(root,manifest,(u,p)=>{throw new IOException("offline");}),"Offline update surfaces failure");Check(LocalInstall.Current(root)=="99.0.0","Offline keeps installed launcher");
    Check(File.ReadAllText(save)=="SAVE MUST STAY","Save preservation");Check(Directory.GetFiles(root,"*.download").Length==0,"Download cleanup");
    File.WriteAllText(LocalInstall.LauncherPath(root,"99.0.0"),"corrupt");Check(LocalInstall.Current(root)==LocalInstall.SeedVersion,"Hash failure falls back to previous launcher");
    if(Environment.OSVersion.Platform==PlatformID.Win32NT){
     var app=Path.Combine(root,"Games","Throne of Ashes");var desktop=Path.Combine(root,"Bureau");LocalInstall.Install(app,setup,seed,desktop);
     Check(LocalInstall.Hash(Path.Combine(app,LocalInstall.HostName))==LocalInstall.Hash(setup),"Exact local host installation");Check(LocalInstall.Hash(Path.Combine(app,"Throne-of-Ashes.exe"))==LocalInstall.SeedHash,"Base launcher installed");
     var type=Type.GetTypeFromProgID("WScript.Shell",true);object shell=Activator.CreateInstance(type),link=null;
     try{link=type.InvokeMember("CreateShortcut",BindingFlags.InvokeMethod,null,shell,new object[]{Path.Combine(desktop,"Throne of Ashes.lnk")});var target=(string)link.GetType().InvokeMember("TargetPath",BindingFlags.GetProperty,null,link,null);Check(String.Equals(target,Path.Combine(app,LocalInstall.HostName),StringComparison.OrdinalIgnoreCase),"Desktop shortcut targets installed host");}
     finally{if(link!=null)System.Runtime.InteropServices.Marshal.FinalReleaseComObject(link);System.Runtime.InteropServices.Marshal.FinalReleaseComObject(shell);}
     LocalInstall.Install(app,setup,seed,desktop);Check(File.Exists(Path.Combine(desktop,"Throne of Ashes.lnk")),"Reinstallation repairs shortcut");
     Check(File.Exists(Path.Combine(app,LocalInstall.UninstallerName)),"Per-user uninstaller installed next to host");
     var keyPath=@"Software\ThroneOfAshes-QA-"+Guid.NewGuid().ToString("N");
     try{using(var key=Microsoft.Win32.Registry.CurrentUser.CreateSubKey(keyPath)){
      LocalInstall.WriteRegistration(key,app);
      Check((string)key.GetValue("InstallLocation")==app,"Registration uses the user application location");
      Check((string)key.GetValue("UninstallString")=="\""+Path.Combine(app,LocalInstall.UninstallerName)+"\"","Registration points to normal installed uninstaller");
     }}finally{Microsoft.Win32.Registry.CurrentUser.DeleteSubKeyTree(keyPath,false);}
     var beforeHost=LocalInstall.Hash(Path.Combine(app,LocalInstall.HostName));
     var personal=Path.Combine(app,"personal-save.keep");File.WriteAllText(personal,"PRESERVE");
     using(var cleanup=UserUninstaller.DeferredSelfRemoval(app))Check(cleanup.WaitForExit(15000),"Deferred normal-user cleanup terminates");
     Check(!File.Exists(Path.Combine(app,LocalInstall.UninstallerName)),"Deferred cleanup removes only its own uninstaller");
     Check(File.ReadAllText(personal)=="PRESERVE"&&LocalInstall.Hash(Path.Combine(app,LocalInstall.HostName))==beforeHost,"Cleanup never recursively deletes other app or personal files");
     Reject(()=>UserUninstaller.DeferredSelfRemoval(app+"&unsafe"),"Shell metacharacter paths rejected");
    }
    manifest.launcherVersion="99.0.0";manifest.launcherUrl=url;
   }
   var rejectedRoot=Path.Combine(fixture,"rejected-start");Directory.CreateDirectory(rejectedRoot);var probeHash=LocalInstall.Hash(probe);
   LocalInstall.Activate(rejectedRoot,probe,"98.0.0",probeHash);LocalInstall.Activate(rejectedRoot,probe,"99.0.0",probeHash);
   int starts=0;
   using(var child=LocalInstall.StartVerified(rejectedRoot,"99.0.0",info=>{starts++;if(starts==1)throw new System.ComponentModel.Win32Exception(5,"Access denied fixture");return Process.Start(info);})){
    Check(child.WaitForExit(10000)&&child.ExitCode==0&&starts==2,"Rejected update falls back once to a real verified previous process");
   }
   Check(LocalInstall.Current(rejectedRoot)=="98.0.0"&&LocalInstall.Rejected(rejectedRoot,"99.0.0",probeHash),"Rejected version excluded from activation pointer");
   var repeated=new LauncherFeed{launcherVersion="99.0.0",launcherUrl=url,launcherSha256=probeHash};int repeatedDownloads=0;
   Check(LocalInstall.Refresh(rejectedRoot,repeated,(u,p)=>{repeatedDownloads++;File.Copy(probe,p);})=="98.0.0"&&repeatedDownloads==0,"Rejected identical version is never downloaded again");
   repeated.launcherVersion="100.0.0";repeated.launcherUrl=url.Replace("99.0.0","100.0.0");
   Check(LocalInstall.Refresh(rejectedRoot,repeated,(u,p)=>{repeatedDownloads++;File.Copy(probe,p);})=="100.0.0"&&repeatedDownloads==1,"A genuinely new version can still update after a rejected version");
   Console.WriteLine("LOCAL_INSTALLATION_OK: "+count+" checks; isolated installs, launcher update/hash/rollback/offline/no downgrade, real child process and saves; Windows shortcuts="+(Environment.OSVersion.Platform==PlatformID.Win32NT));return 0;
  }catch(Exception e){Console.Error.WriteLine(e);return 1;}finally{try{Directory.Delete(fixture,true);}catch{}}
 }
}
