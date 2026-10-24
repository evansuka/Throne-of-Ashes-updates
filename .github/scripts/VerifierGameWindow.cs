using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

public sealed class WindowStartupOperations:LauncherOperations {
 public volatile Process Child;
 public override Process LaunchGameProcess(ProcessStartInfo start){var p=base.LaunchGameProcess(start);Child=Process.GetProcessById(p.Id);return p;}
}
public static class VerifierGameWindow {
 [StructLayout(LayoutKind.Sequential)]struct Rect {public int left,top,right,bottom;}
 [DllImport("user32.dll")]static extern bool GetWindowRect(IntPtr window,out Rect rect);
 [DllImport("user32.dll")]static extern int GetSystemMetrics(int index);
 [DllImport("user32.dll")]static extern bool IsWindowVisible(IntPtr window);
 [DllImport("user32.dll")]static extern bool IsIconic(IntPtr window);
 [DllImport("dwmapi.dll")]static extern int DwmGetWindowAttribute(IntPtr window,int attribute,out int value,int size);
 static bool OnScreen(Process process){
  process.Refresh();var window=process.MainWindowHandle;int cloaked;Rect r;
  if(window==IntPtr.Zero||!IsWindowVisible(window)||IsIconic(window))return false;
  if(DwmGetWindowAttribute(window,14,out cloaked,4)==0&&cloaked!=0)return false;
  if(!GetWindowRect(window,out r))return false;
  int x=GetSystemMetrics(76),y=GetSystemMetrics(77);
  return r.right>x&&r.bottom>y&&r.left<x+GetSystemMetrics(78)&&r.top<y+GetSystemMetrics(79);
 }
 static readonly List<string> checks=new List<string>();
 static void Check(bool value,string message){if(!value)throw new Exception(message);checks.Add(message);Console.WriteLine("GAME_WINDOW_CHECK: "+message);}
 static string ReadShared(string path){using(var stream=new FileStream(path,FileMode.Open,FileAccess.Read,FileShare.ReadWrite|FileShare.Delete))using(var reader=new StreamReader(stream))return reader.ReadToEnd();}
 [STAThread]public static int Main(string[] args){
  string root=args[0],version=args[1],reportPath=args[2];
  var result=new Dictionary<string,object>{{"version",version},{"status","running"},{"sourceCommit",Environment.GetEnvironmentVariable("GITHUB_SHA")},{"checks",checks}};
  var ops=new WindowStartupOperations();var logLock=new object();
  ops.Report=message=>{lock(logLock)File.AppendAllText(Path.Combine(root,"startup-guard.log"),DateTime.UtcNow.ToString("o")+" "+message+Environment.NewLine);};
  int exit=1;
  try{
   var work=Task.Factory.StartNew(()=>ops.StartGame(root,version));var clock=Stopwatch.StartNew();int samples=0;
   while(!work.IsCompleted){
    var child=ops.Child;
    if(child!=null){
     if(child.HasExited)throw new Exception("Game stopped during graphical initialization");
     if(OnScreen(child)){
      var window=child.MainWindowHandle;Rect bounds;GetWindowRect(window,out bounds);
      result["earlyWindow"]=new Dictionary<string,object>{{"title",child.MainWindowTitle},{"bounds",new[]{bounds.left,bounds.top,bounds.right,bounds.bottom}}};
      Thread.Sleep(50);Check(!OnScreen(child),"Startup window suppressed within 50 ms");
     }
    }
    if(clock.Elapsed.TotalSeconds>95)throw new Exception("Game readiness timed out");
    samples++;Thread.Sleep(100);
   }
   work.GetAwaiter().GetResult();var process=ops.Child;int pid=process.Id;
   Check(!process.HasExited,"Real exported game started by actual launcher operations");
   var ready=Directory.GetFiles(root,"handoff-*.ready");Check(ready.Length==1,"Actual launcher handshake file exists");
   Check(File.ReadAllText(ready[0]).Trim()==pid.ToString(),"Ready handshake identifies the real game PID");
   for(int i=0;i<180;i++){if(OnScreen(process))throw new Exception("Game appeared before explicit launcher release");Thread.Sleep(100);}
   Check(true,"No on-screen game during 18 seconds before explicit release");
   ops.ReleaseGame();clock.Restart();bool visible=false;
   do{visible=OnScreen(process);if(!visible)Thread.Sleep(100);}while(!visible&&clock.Elapsed.TotalSeconds<20);
   Check(visible,"Same exported game becomes visible on screen after release");
   Thread.Sleep(3000);Check(!process.HasExited&&process.Id==pid,"One game PID remains alive after handoff");
   result["gamePid"]=pid;result["initializationSamples"]=samples;result["status"]="passed";exit=0;
  }catch(Exception error){result["status"]="failed";result["error"]=error.ToString();Console.Error.WriteLine(error);}
  finally{
   try{ops.ReleaseGame();}catch(Exception error){result["cleanupReleaseError"]=error.Message;}
   var child=ops.Child;if(child!=null)try{if(!child.HasExited){child.Kill();child.WaitForExit(10000);}child.Dispose();}catch(Exception error){result["cleanupError"]=error.Message;}
   foreach(string name in new[]{"startup-guard.log","game.log"})try{string path=Path.Combine(root,name);if(File.Exists(path))result[name=="game.log"?"gameLogTail":"startupLog"]=ReadShared(path);}catch(Exception error){result[name+"ReadError"]=error.Message;}
   result["completedUtc"]=DateTime.UtcNow.ToString("o");File.WriteAllText(reportPath,new JavaScriptSerializer().Serialize(result));
  }
  return exit;
 }
}
