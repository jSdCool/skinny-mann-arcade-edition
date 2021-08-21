  void draw_updae_screen(){//the update screen
    background(#EDEDED);
    fill(0);
    textSize(50*Scale);
    textAlign(CENTER);
    text("UPDATE!!!",width/2,height/7);
    textSize(20*Scale);
    text("A new version of this game has been released!!!",width/2,height/6);
    fill(#FF0004);
    stroke(#FFF300);
    strokeWeight(10*Scale);
    rect(400*Scale2,150*Scale,500*Scale2,50*Scale);
    rect(400*Scale2,250*Scale,500*Scale2,50*Scale);
    fill(0);
    textSize(40*Scale);
    text("get it",650*Scale2,190*Scale);
    text("OK",650*Scale2,290*Scale);

    textAlign(LEFT);
  }
  
  void updae_screen_click(){//the buttons on the update screen
    if(mouseX>=400*Scale2&&mouseX<=400*Scale2+500*Scale2 && mouseY>=150*Scale&&mouseY<=150*Scale+50*Scale){
      link("http://cbi-games.glitch.me");//open CBi games in a web browser
    }
    if(mouseX>=400*Scale2&&mouseX<=400*Scale2+500*Scale2 && mouseY>=250*Scale&&mouseY<=250*Scale+50*Scale){
      Menue="main";//go to the main menue
    }
  }

String get_git_version()throws Throwable{//getting the version from git hub
  String link = "https://raw.githubusercontent.com/jSdCool/CBI-games-version-checker/master/skinny_mann.txt";//the link to the raw repository
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
      } finally {
        Stream.close();
      }
      return writer.toString();
    } else {
      return "No Contents";
    }

  }
