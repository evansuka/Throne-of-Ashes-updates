using System;
using System.IO;
using System.Diagnostics;
using System.Threading;
using System.Web.Script.Serialization;
using System.Collections.Generic;

sealed class StartupProbe:LauncherOperations {
 public string Capture,Self,Runtime;public int Starts,Pid;public bool Crash;public Process Completion;
 public override Process LaunchGameProcess(ProcessStartInfo game){
  Starts++;
  string arguments="--fake-game \""+Capture+"\" "+(Crash?"--fail-boot ":"")+game.Arguments;
  var start=new ProcessStartInfo(Runtime==null?Self:Runtime,(Runtime==null?"":"\""+Self+"\" ")+arguments){UseShellExecute=false,CreateNoWindow=true};
  var process=Process.Start(start);Pid=process.Id;
  if(!Crash){
   // The launcher disposes its own Process. Retain a separate OS handle while
   // this child is alive: Framework cannot recover its exit code by PID later.
   Completion=Process.GetProcessById(Pid);
   if(Completion.Handle==IntPtr.Zero)throw new IOException("Cannot retain the child completion handle.");
  }
  return process;
 }
}
static class VerifierLauncherStartup {
 static int checks;
 static void Check(bool ok,string message){checks++;if(!ok)throw new Exception(message);}
 static Dictionary<string,object> Read(string path){return new JavaScriptSerializer().Deserialize<Dictionary<string,object>>(File.ReadAllText(path));}
 static int Fake(string[] args){
  string capture=args[1],marker=null;bool minimized=false,crash=false;
  foreach(string arg in args){if(arg.StartsWith("--launcher-handoff="))marker=arg.Substring("--launcher-handoff=".Length);if(arg=="--minimized")minimized=true;if(arg=="--fail-boot")crash=true;}
  File.WriteAllText(capture,new JavaScriptSerializer().Serialize(new {pid=Process.GetCurrentProcess().Id,minimized=minimized,marker=marker}));
  if(crash)return 7;
  if(marker==null){Thread.Sleep(3800);return 0;}
  File.WriteAllText(marker+".ready.tmp",Process.GetCurrentProcess().Id.ToString());File.Move(marker+".ready.tmp",marker+".ready");
  var clock=Stopwatch.StartNew();while(!File.Exists(marker+".release")&&clock.ElapsedMilliseconds<6000)Thread.Sleep(20);
  return File.Exists(marker+".release")?0:9;
 }
 static void Complete(Process process){using(process){Check(process.WaitForExit(10000),"Child did not finish");Check(process.ExitCode==0,"Child failed: "+process.ExitCode);}}
 static int Main(string[] args){
  if(args.Length>1&&args[0]=="--fake-game")return Fake(args);
  try{
   string root=Path.Combine(Path.GetTempPath(),"toa-startup-é test-"+Guid.NewGuid().ToString("N"));Directory.CreateDirectory(root);
   string self=System.Reflection.Assembly.GetExecutingAssembly().Location;
   string runtime=Environment.OSVersion.Platform==PlatformID.Win32NT?null:(args.Length>0?args[0]:"mono");
   foreach(string version in new[]{"0.14.8","0.14.9"}){
    var probe=new StartupProbe{Self=self,Runtime=runtime,Capture=Path.Combine(root,version+".json")};var clock=Stopwatch.StartNew();
    probe.StartGame(root,version);var captured=Read(probe.Capture);bool modern=version=="0.14.9";
    Check(Convert.ToBoolean(captured["minimized"])==modern,"Wrong visibility mode for "+version);
    Check((captured["marker"]!=null)==modern,"Wrong handoff protocol for "+version);
    Check(probe.Starts==1,"More than one child started");
    Check(clock.ElapsedMilliseconds<5000,"Startup waited for an unsupported handoff");
    Check(!probe.Completion.HasExited,"Closing the launcher process handle terminated the game");
    if(modern){string marker=Convert.ToString(captured["marker"]);Check(!File.Exists(marker+".release"),"Game was released before explicit handoff");probe.ReleaseGame();Check(File.Exists(marker+".release"),"Explicit handoff did not release the existing child");}
    else probe.ReleaseGame();
    Complete(probe.Completion);
   }
   foreach(string version in new[]{"0.14.8","0.14.9"}){
    var probe=new StartupProbe{Self=self,Runtime=runtime,Capture=Path.Combine(root,version+"-failed.json"),Crash=true};bool rejected=false;
    try{probe.StartGame(root,version);}catch(IOException error){rejected=error.Message.Contains("7");}
    Check(rejected,"Early process failure was not reported for "+version);Check(probe.Starts==1,"Failed launch was retried");
   }
   Directory.Delete(root,true);Console.WriteLine("LAUNCHER_STARTUP_OK: "+checks+" checks; real legacy/new child processes, PID handshake, old-version visibility, early failure and no restart.");return 0;
  }catch(Exception error){Console.Error.WriteLine(error);return 1;}
 }
}
