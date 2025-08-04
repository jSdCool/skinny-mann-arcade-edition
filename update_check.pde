//start of update_check.pde

/**Draw the update avawable screen
*/
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
//various update screen related vars
long [] updateDownloadProgress = {1,0};
boolean exeNameError = false;
UiText exeNameErrorText,exeErrorExplainText;
Button exeErrorCloseButton;

/**Draw the update downloading screen
*/
void drawUpdateDownloadingScreen() {
  background(#EDEDED);
  fill(0);
  if(exeNameError){//if there is an error with the exe file name on mac, display that error
    if(exeNameErrorText == null){//iniitilize the things if nessarry
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
    //draw the updater download progress bar
    rect(0.1*width,height/2-height*0.05,(float)((width*0.8)*((double)updateDownloadProgress[1]/updateDownloadProgress[0])),height*0.1);
  }
}

ArrayList<String> fileIndex=new ArrayList<>();

/**Process clicks on the update screen
*/
void updae_screen_click() {//the buttons on the update screen
  if (updateGetButton.isMouseOver()) {//get button sends you to the website
    link("http://cbi-games.org");//open CBi games in a web browser
  }
  if (updateOkButton.isMouseOver()) {//ok button sends you to the main menu
    Menue="main";//go to the main menue
  }
  
  if (downloadUpdateButton.isMouseOver()) {//download button, trigger the updater download
    Menue="downloading update";
    thread("downloadUpdateFunction");//spawn a thread to download the updater
  }
}

/**Process clicks on the updater download screen
*/
void updateDownloadingScreenClick(){
  if(exeNameError && exeErrorCloseButton.isMouseOver()){
    exit(0);
  }
}

/**Download and launch the updater. This function runs on its own thread
*/
void downloadUpdateFunction() {
  try {
    //get updater info from external file on github
    String updaterLinks[] = readFileFromGithub("https://raw.githubusercontent.com/jSdCool/CBI-games-version-checker/master/skinny_mann_updater_info").split("\n");
    //note: at this point all but 1 line of this file is leggacy compatibilty stuf for older versions of the game
    //make the folder for the updater
    new File(appdata+"/CBi-games/skinny mann updater").mkdirs();
    //download the updater, the first line of the file contins the download link
    DownloadFile.download(updaterLinks[0], appdata+"/CBi-games/skinny mann updater/skinny mann updater.jar",updateDownloadProgress);
    int javaLevel=1;
    //check if java was bundled with the game, cuz if it was we can not garentee that the user has java >=8 installed and accessable on their computer
    String macJavapath = "";
    if(platform == MACOS){//macos is special so we need to look in a diffrent location
      //if the execuable is not named correctly
      if(!new File(sketchPath()+"/skiny_mann.app").exists()){
        exeNameError=true;
        return;
      }
    
      String contenceFolders[]=new File(sketchPath()+"/skiny_mann.app/Contents/PlugIns").list();
      for (int i=0; i<contenceFolders.length; i++) {
        if (contenceFolders[i].startsWith("jdk")) {
          javaLevel=2;
          macJavapath = sketchPath()+"/skiny_mann.app/Contents/PlugIns/"+contenceFolders[i]+"/Contents/Home";//save the file path to the java install
        }
      }
    }else{
      String sketchFolders[]=new File(sketchPath()).list();
      for (int i=0; i<sketchFolders.length; i++) {
        if (sketchFolders[i].equals("java")) {
          javaLevel=2;//java is included so set the java level to 2
        }
      }
    }
    //save the info file that tells the updater where the game is located
    saveStrings(appdata+"/CBi-games/skinny mann updater/downloadInfo.txt", new String[]{" ", (javaLevel == 2) ? "JE":"NJE", sketchPath()});
    //                                        NOTE: if macos fixes the data folder location bug this may have to change (by default the data folder is located inside the app apcge on mac but sketchPath() currently does not point to that locaktion, if it does in the future then we will have to change this)

    //if java was bundled assume that no compatble JVM exists on the system. so copy the java instance used by the game so it can be used by the updater
    if (javaLevel==2) {
      if(platform == MACOS){//wooo macs being special again
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
      //script synopsis:
      //change the working directory to the updater directpry then run the updater jar
    } else {
      //generate the script to run the updater as a seprate process
      if (platform == WINDOWS) {
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.cmd", new String[]{"@echo off", "title skinny mann updater launcher", "echo this window can be closed", "cd "+appdata+"/CBi-games/skinny mann updater", "javaw -jar \"skinny mann updater.jar\"", "exit"});
      } else if (platform == LINUX) {
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.sh", new String[]{"#!/bin/sh","echo skinny mann updater launcher", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "java -jar \"skinny mann updater.jar\"", "echo this window can be closed"});
      }else if(platform == MACOS){
        saveStrings(appdata+"/CBi-games/skinny mann updater/run.sh", new String[]{"#!/bin/zsh","echo skinny mann updater launcher", "cd \""+appdata+"/CBi-games/skinny mann updater\"", "java -jar \"skinny mann updater.jar\"", "echo this window can be closed"});
      }
      //script synopsis:
      //change the working directory to the updater directpry then run the updater jar
    }
    //wait 500ms to make shure everythingn is good and settled with the file system
    int a=millis();
    while (a+500<=millis()) {
      random(1);//prevent the thread from being auto terminated for inactivity
    }
    //execut the script
    if (platform == WINDOWS) {
      //windows has this nice way of running the script
      Desktop.getDesktop().open(new File(appdata+"/CBi-games/skinny mann updater/run.cmd"));
    } else if (platform == LINUX) {
      //linux is a but more involved
      //allow execution because linux is a bitch with file permissions
      //apperently this is how it has to be done cuz the java code ways of doing it don't appear to do anything
      ProcessBuilder permissionSet = new ProcessBuilder("chmod", "-R", "+x" ,appdata+"/CBi-games/skinny mann updater/");
      permissionSet.directory(new File(appdata+"/CBi-games/skinny mann updater/"));//set the PWD of this process
      permissionSet.start();//run chmod
      
      //run the script
      ProcessBuilder pb = new ProcessBuilder(appdata+"/CBi-games/skinny mann updater/run.sh");
      pb.directory(new File(appdata+"/CBi-games/skinny mann updater"));//set the pwd (wait didnt we do this in the scrip as well?
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
    exit(2);//code 2 for update or somehting
  } catch(Throwable e) {
    handleError(e);
  }
}

/**Get the raw text content of resource on the internet
@param link The url of the resource to read
*/
String readFileFromGithub(String link)throws Throwable {//used to read text files from github, used for getting the latesed verion  of the game and for outher update functions
  //I stole this code from somewhere
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

/**Converts the content of an input stream to a single string
@param Stream The input stream
*/
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
    } finally {
      Stream.close();
    }
    return writer.toString();
  } else {
    return "No Contents";
  }
}

/**Recursively scan folders for files to copy.
  The output is stored in fileIndex
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
    }
  }
}

/**Copy the java install to a new location
@param times Recurcive depth thing, just pass in 0 for this
@param initalPath The source file
@param newPath The destination file
*/
void javaCopy(int times, String initalPath, String newPath) {
  if (times == 10) {//if this file was tried 10 times then just forget it
    return;
  }
  try {
    String[] newDir = (newPath).split("\\\\|/");
    String destDir="";
    for (int i=0; i<newDir.length-1; i++) {//get the path to the current file
      destDir+=newDir[i]+"/";
    }
    new File(destDir).mkdirs();//make the parent folder if it dosen't exist
    File dest = new File(newPath);
    if (dest.exists()) {//if the file already exists in the new location then delete the current version
      dest.delete();
    }
    java.nio.file.Files.copy(new File(initalPath).toPath(), dest.toPath());//copy the file `
  } catch (IOException e) {//if it fails
    e.printStackTrace();//print the stactrace
    javaCopy(times+1, initalPath, newPath);//try again
  }
}
//end of update_check.pde
