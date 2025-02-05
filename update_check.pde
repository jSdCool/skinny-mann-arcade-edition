void draw_updae_screen() {//the update screen
  background(#EDEDED);
  fill(0);

  up_title.draw();
  up_info .draw();

  updateOkButton.draw();
  updateGetButton.draw();

  downloadUpdateButton.draw();
  textAlign(LEFT);
}
long [] updateDownloadProgress = {1,0};
boolean exeNameError = false;
UiText exeNameErrorText,exeErrorExplainText;
Button exeErrorCloseButton;

void drawUpdateDownloadingScreen() {
  background(#EDEDED);
  fill(0);
  if(exeNameError){
    if(exeNameErrorText == null){
      exeNameErrorText = new UiText(ui, "Executable Not Found!", 640, 102.857, 50, CENTER, BASELINE);
      exeErrorExplainText = new UiText(ui, "The game Execuable MUST be named 'skiny_mann.app' exactly.\nIf the name differs in any way this will not work!\n(Thank you apple for your genius)",640,130,30,CENTER,BASELINE);
      exeErrorCloseButton = new UiButton(ui, 390, 350, 500, 50, "Close", #FF0004, #FFF300).setStrokeWeight(10);
    }
    exeNameErrorText.draw();
    exeErrorExplainText.draw();
    exeErrorCloseButton.draw();
  }else{
    up_wait.draw();
    fill(0);
    rect(0.1*width,height/2-height*0.05,(float)((width*0.8)*((double)updateDownloadProgress[1]/updateDownloadProgress[0])),height*0.1);
  }
}
ArrayList<String> fileIndex=new ArrayList<>();
void updae_screen_click() {//the buttons on the update screen
  if (updateGetButton.isMouseOver()) {
    link("http://cbi-games.org");//open CBi games in a web browser
  }
  if (updateOkButton.isMouseOver()) {
    Menue="main";//go to the main menue
  }
  if (downloadUpdateButton.isMouseOver()) {
    Menue="downloading update";
    thread("downloadUpdateFunction");
  }
}

void updateDownloadingScreenClick(){
  if(exeNameError&&exeErrorCloseButton.isMouseOver()){
    exit(0);
  }
}

void downloadUpdateFunction() {
  try {
    //get updater info from external file
    String updaterLinks[]=readFileFromGithub("https://raw.githubusercontent.com/jSdCool/CBI-games-version-checker/master/skinny_mann_updater_info").split("\n");
    //make the folder for the updater
    new File(appdata+"/CBi-games/skinny mann updater").mkdirs();
    //download the updater
    DownloadFile.download(updaterLinks[0], appdata+"/CBi-games/skinny mann updater/skinny mann updater.jar",updateDownloadProgress);
    int javaLevel=1;
    //check if java was bundled with the game
    String macJavapath = "";
    if(platform == MACOS){//macos is special so we need to look in a diffrent location
      //if the execuable is not named correctly
      if(!new File(sketchPath()+"/skiny_mann.app").exists()){
        exeNameError=true;
        return;
      }
    
      String contenceFolders[]=new File(sketchPath()+"/skiny_mann.app/Contents/PlugIns").list();
      for (int i=0; i<contenceFolders.length; i++) {
        if (contenceFolders[i].startsWith("jdk"))
          javaLevel=2;
          macJavapath = sketchPath()+"/skiny_mann.app/Contents/PlugIns/"+contenceFolders[i]+"/Contents/Home";
      }
    }else{
      String sketchFolders[]=new File(sketchPath()).list();
      for (int i=0; i<sketchFolders.length; i++) {
        if (sketchFolders[i].equals("java"))
          javaLevel=2;
      }
    }
    //save the info file that tells the updater where the game is located
    saveStrings(appdata+"/CBi-games/skinny mann updater/downloadInfo.txt", new String[]{" ", (javaLevel == 2) ? "JE":"NJE", sketchPath()});
    //                                                                                                                      NOTE: if macos fixes the data folder location bug this may have to change

    //if java was bundled assume that no compatble JVM exists on the system. copy the java instance used by the game so it can be used by the updater
    if (javaLevel==2) {
      if(platform == MACOS){
        //index all the files in the java install
        scanForFiles(macJavapath, "");
        //copy them to the updater location
        for (int i=0; i<fileIndex.size(); i++) {
          javaCopy(0, macJavapath+"/"+fileIndex.get(i), appdata+"/CBi-games/skinny mann updater/java/"+fileIndex.get(i));
        }
      }else{
        //index all the files in the java install
        scanForFiles(sketchPath()+"/java", "");
        //copy them to the updater location
        for (int i=0; i<fileIndex.size(); i++) {
          javaCopy(0, sketchPath()+"/java/"+fileIndex.get(i), appdata+"/CBi-games/skinny mann updater/java/"+fileIndex.get(i));
        }
      }
      //generate the script to run the updater as a seprate process
      if (platform == WINDOWS) {
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.cmd", new String[]{"@echo off", "title skinny mann updater launcher", "echo this window can be closed", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "\""+appdata+"/CBi-games/skinny mann updater/java/bin/javaw.exe\" -jar \"skinny mann updater.jar\"", "exit"});
      } else if (platform == LINUX) {
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.sh", new String[]{"#!/bin/sh","echo skinny mann updater launcher", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "\""+appdata+"/CBi-games/skinny mann updater/java/bin/java\" -jar \"skinny mann updater.jar\"", "echo this window can be closed"});
      } else if(platform == MACOS){
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.sh", new String[]{"#!/bin/zsh","echo skinny mann updater launcher", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "\""+appdata+"/CBi-games/skinny mann updater/java/bin/java\" -jar \"skinny mann updater.jar\"", "echo this window can be closed"});
      }
    } else {
      //generate the script to run the updater as a seprate process
      if (platform == WINDOWS) {
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.cmd", new String[]{"@echo off", "title skinny mann updater launcher", "echo this window can be closed", "cd "+appdata+"/CBi-games/skinny mann updater", "javaw -jar \"skinny mann updater.jar\"", "exit"});
      } else if (platform == LINUX) {
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.sh", new String[]{"#!/bin/sh","echo skinny mann updater launcher", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "java -jar \"skinny mann updater.jar\"", "echo this window can be closed"});
      }else if(platform == MACOS){
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.sh", new String[]{"#!/bin/zsh","echo skinny mann updater launcher", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "java -jar \"skinny mann updater.jar\"", "echo this window can be closed"});
      }
    }
    //wait 500ms to make shure everythingn is good and set
    int a=millis();
    while (a+500<=millis()) {
      random(1);
    }
    //execut the script
    if (platform == WINDOWS) {
      Desktop.getDesktop().open(new File(appdata+"/CBi-games/skinny mann updater/run.cmd"));
    } else if (platform == LINUX) {
      //allow execution because linux is a bitch with file permissions
      //apperently this is how it has to be done
      ProcessBuilder permissionSet = new ProcessBuilder("chmod", "-R", "+x" ,appdata+"/CBi-games/skinny mann updater/");
      permissionSet.directory(new File(appdata+"/CBi-games/skinny mann updater/"));
      permissionSet.start();
      
      //run the script
      ProcessBuilder pb = new ProcessBuilder(appdata+"/CBi-games/skinny mann updater/run.sh");
      pb.directory(new File(appdata+"/CBi-games/skinny mann updater"));
      Process p = pb.start();
    }else if(platform == MACOS){
      //set the executiuon permisson of the files in the updaer folder
      ProcessBuilder permissionSet = new ProcessBuilder("chmod", "-R", "+x" ,appdata+"/CBi-games/skinny mann updater/");
      permissionSet.directory(new File(appdata+"/CBi-games/skinny mann updater/"));
      permissionSet.start();
      
      //run the script
      ProcessBuilder pb = new ProcessBuilder(appdata+"/CBi-games/skinny mann updater/run.sh");
      pb.directory(new File(appdata+"/CBi-games/skinny mann updater"));
      Process p = pb.start();
    }
    //close the game
    exit(2);
  }
  catch(Throwable e) {
    handleError(e);
  }
}

String readFileFromGithub(String link)throws Throwable {//used to read text files from github, used for getting the latesed verion  of the game and for outher update functions
  URL url =new URL(link);//get as URL
  HttpURLConnection Http = (HttpURLConnection) url.openConnection();//open the url
  Map<String, List<String>> Header = Http.getHeaderFields();//redirection shit I dont understand
  for (String header : Header.get(null)) {
    if (header.contains(" 302 ") || header.contains(" 301 ")) {
      link = Header.get("Location").get(0);
      url = new URL(link);
      Http = (HttpURLConnection) url.openConnection();
      Header = Http.getHeaderFields();
    }
  }

  InputStream I_Stream = Http.getInputStream();//get the incomeing stream of html data
  String Response = GetStringFromStream(I_Stream);//get a raw string from the data

  System.out.println(Response);
  return Response;
}

String GetStringFromStream(InputStream Stream) throws IOException {//turns the raw html data into a string java can understand
  if (Stream != null) {
    Writer writer = new StringWriter();
    char[] Buffer = new char[2048];
    try {
      Reader reader = new BufferedReader(new InputStreamReader(Stream, "UTF-8"));
      int counter;
      while ((counter = reader.read(Buffer)) != -1) {
        writer.write(Buffer, 0, counter);
      }
    }
    finally {
      Stream.close();
    }
    return writer.toString();
  } else {
    return "No Contents";
  }
}

/**Recursively scan folders for files to copy
 *
 * @param parentPath the root path of the folder that is being copied
 * @param subPath the path of the current sub folder that is being looked through
 */
public void scanForFiles(String parentPath, String subPath) {
  String[] files=new File(parentPath+"/"+subPath).list();//get a list of all things in the current folder
  for (int i=0; i<files.length; i++) {//loop through all the things in the current folder

    if (new File(parentPath+"/"+subPath+"/"+files[i]).list()!=null) {//check weather the current thing is a folder or a file
      scanForFiles(parentPath, subPath+"/"+files[i]);//if it is a folder then scan through that folder for more files
    } else {//if it is a file
      if (subPath.equals("")) {
        fileIndex.add(files[i]);
      } else {
        fileIndex.add(subPath+"/"+files[i]);
      }
      //System.out.println(fileIndex.get(fileIndex.size()-1));
    }
  }
}

void javaCopy(int times, String initalPath, String newPath) {
  if (times==10)
    return;
  try {
    String[] newDir=(newPath).split("\\\\|/");
    String destDir="";
    for (int i=0; i<newDir.length-1; i++) {//get the path to the current file
      destDir+=newDir[i]+"/";
    }
    new File(destDir).mkdirs();//make the parent folder if it dosen't exist
    File dest=new File(newPath);
    if (dest.exists()) {//if the file already exists in the new location then delete the current version
      dest.delete();
    }
    java.nio.file.Files.copy(new File(initalPath).toPath(), dest.toPath());//copy the file `
  }
  catch (IOException e) {//if it fails
    e.printStackTrace();//print the stactrace
    javaCopy(times+1, initalPath, newPath);//try again
  }
}
