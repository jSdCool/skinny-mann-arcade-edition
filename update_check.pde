void draw_updae_screen() {//the update screen
  background(#EDEDED);
  fill(0);
  textSize(50*Scale);
  textAlign(CENTER);
  text("UPDATE!!!", width/2, height/7);
  textSize(20*Scale);
  text("A new version of this game has been released!!!", width/2, height/6);
  updateOkButton.draw();
  updateGetButton.draw();
  if (platform==WINDOWS)
    downloadUpdateButton.draw();

  textAlign(LEFT);
}

void drawUpdateDownloadingScreen() {
  background(#EDEDED);
  textSize(50*Scale);
  textAlign(CENTER);
  fill(0);
  text("please wait", width/2, height/7);
}
ArrayList<String> fileIndex=new ArrayList<>();
void updae_screen_click() {//the buttons on the update screen
  if (updateGetButton.isMouseOver()) {
    link("http://cbi-games.glitch.me");//open CBi games in a web browser
  }
  if (updateOkButton.isMouseOver()) {
    Menue="main";//go to the main menue
  }
  if (platform==WINDOWS&&downloadUpdateButton.isMouseOver()) {
    Menue="downloading update";
    thread("downloadUpdateFunction");
  }
}

void downloadUpdateFunction() {
  try {
    String updaterLinks[]=readFileFromGithub("https://raw.githubusercontent.com/jSdCool/CBI-games-version-checker/master/skinny_mann_updater_info").split("\n");
    new File(System.getenv("AppData")+"/CBi-games/skinny mann updater").mkdirs();
    DownloadFile.download(updaterLinks[0], System.getenv("AppData")+"/CBi-games/skinny mann updater/skinny mann updater.jar");
    int javaLevel=1;
    String sketchFolders[]=new File(sketchPath()).list();
    for (int i=0; i<sketchFolders.length; i++) {
      if (sketchFolders[i].equals("java"))
        javaLevel=2;
    }
    saveStrings(System.getenv("AppData")+"/CBi-games/skinny mann updater/downloadInfo.txt", new String[]{updaterLinks[javaLevel], internetVersion, sketchPath()});
    if (javaLevel==2) {
      scanForFiles(sketchPath()+"/java", "");
      for (int i=0; i<fileIndex.size(); i++) {
        javaCopy(0, sketchPath()+"/java/"+fileIndex.get(i), System.getenv("AppData")+"/CBi-games/skinny mann updater/java/"+fileIndex.get(i));
      }
      saveStrings(System.getenv("AppData")+"/CBi-games/skinny mann updater/run.cmd", new String[]{"@echo off", "title skinny mann updater launcher", "echo this window can be closed", "cd "+System.getenv("AppData")+"/CBi-games/skinny mann updater", "\""+System.getenv("AppData")+"/CBi-games/skinny mann updater/java/bin/javaw.exe\" -jar \"skinny mann updater.jar\"", "exit"});
    } else {
      saveStrings(System.getenv("AppData")+"/CBi-games/skinny mann updater/run.cmd", new String[]{"@echo off", "title skinny mann updater launcher", "echo this window can be closed", "cd "+System.getenv("AppData")+"/CBi-games/skinny mann updater", "javaw -jar \"skinny mann updater.jar\"", "exit"});
    }
    int a=millis();
    while (a+500<=millis()) {
      random(1);
    }
    Desktop.getDesktop().open(new File(System.getenv("AppData")+"/CBi-games/skinny mann updater/run.cmd"));
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
