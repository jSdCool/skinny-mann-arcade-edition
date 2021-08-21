import processing.net.*;//import the stuffs
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

void settings(){//first function called
  try{
    settings =loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");//load the settings
  }catch(Throwable e){
    generateSettings();
  }
  JSONObject rez=settings.getJSONObject(2);//get the screen resolutipon
  fs=rez.getBoolean("full_Screen");
  if(!fs){//check for fullscreeen
   vres = rez.getInt("v-res");//if no fulll screen then set the resolution
   hres = rez.getInt("h-res");
   Scale=rez.getFloat("scale");
  size(hres,vres,P3D);
  }else{
   fullScreen(P3D);//if full screen then turn full screen on
   
  }
  PJOGL.setIcon("data\\assets\\skinny mann face.PNG");
}



void setup(){//seccond function called
 frameRate(60);//limet the frame reate
 if(fs){//get and set some data
   hres=width;
   vres=height;
   Scale=vres/720.0;
   Scale2=hres/1280.0;
 }
 println(height);//debung info

 CBi = loadImage("data\\assets\\CBi.png");//load the CBi logo
 CBi.resize((int)(500*Scale),(int)(500*Scale));//scale the CBi logo
 
 discordIcon=loadImage("data\\assets\\discord.png");
 discordIcon.resize((int)(50*Scale),(int)(50*Scale));
 
 coin3D=loadShape("data\\modles\\coin\\tinker.obj");
 coin3D.scale(3);
    
 icon = loadImage("data\\assets\\skinny mann face.PNG");//load the window icon
 //surface.setIcon(icon);//set the window icon
 
 JSONObject scroll=settings.getJSONObject(1);
 eadgeScroleDist=scroll.getInt("value");
 esdPos=(int)(((eadgeScroleDist-100.0)/250)*440+800);
 println(esdPos+" "+eadgeScroleDist);
 //((esdPos-800.0)/440)*250)+100
 //scroll_left = scroll.getInt("value_left");//set the screen scrolling locations
 //scroll_right = scroll.getInt("value_right");
JSONObject debug=settings.getJSONObject(3);
 displayFPS=debug.getBoolean("fps");
 displayDebugInfo=debug.getBoolean("debug info");
 try{
 levelProgress=loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/progressions.json");
 }catch(Throwable e){
   levelProgress=new JSONArray();
   JSONObject p=new JSONObject();
   p.setInt("progress",0);
   levelProgress.setJSONObject(0,p);
   saveJSONArray(levelProgress,System.getenv("AppData")+"/CBi-games/skinny mann/progressions.json");
 }

 if(dev_mode){//if devmode is enabled then set the settings you want
  menue=false;
  inGame=true;
  rootPath="/data/levels/test";
  mainIndex=loadJSONArray(rootPath+"/index.json");
  coins=loadJSONArray(rootPath+"/coins.json");
  file_path=rootPath+"/test stage 1.json";
  camPos=00;
  stageIndex=2;
  respawnStage=2;
}
textSize(500);
select_lvl_1=new Button((int)(100*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 1",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_back=new Button((int)(100*Scale),(int)(600*Scale),(int)(200*Scale),(int)(50*Scale),"back",-59135,-1791).setStrokeWeight((int)(10*Scale));
discord=new Button((int)(1190*Scale),(int)(640*Scale),(int)(70*Scale),(int)(70*Scale),-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_2 =new Button((int)(350*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 2",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_3 =new Button((int)(600*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 3",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_4 =new Button((int)(850*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 4",-59135,-1791).setStrokeWeight((int)(10*Scale));
sdSlider=new Button((int)(800*Scale),(int)(50*Scale),(int)(440*Scale),(int)(30*Scale),255,0).setStrokeWeight((int)(5*Scale));
disableFPS =new Button((int)(1130*Scale),(int)(260*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
enableFPS =new Button((int)(1200*Scale),(int)(260*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
disableDebug =new Button((int)(1130*Scale),(int)(330*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
enableDebug =new Button((int)(1200*Scale),(int)(330*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
select_lvl_5=new Button((int)(100*Scale),(int)(250*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 5",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_6 =new Button((int)(350*Scale),(int)(250*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 6",-59135,-1791).setStrokeWeight((int)(10*Scale));
ptsW=100;
  ptsH=100;
initializeSphere(ptsW, ptsH);
thread("thrdCalc2");
}
//define a shit tone of varibles
PImage CBi,icon,discordIcon;
PShape coin3D;
Server s;
Client c;
boolean menue =true,inGame=false,player1_moving_right=false,player1_moving_left=false,dev_mode=false,player1_jumping=false,dead=false,level_complete=false,start_host=false,entering_port=false,entering_name=false,entering_ip=false,hosting=false,joined=false,start_join=false,reset_spawn=false,fs,E_pressed=false,loopThread2=true,showSettingsAfterStart=false,displayFPS=true,displayDebugInfo=false,prevousInGame=false,setPlayerPosTo=false,e3DMode=false,checkpointIn3DStage=false,WPressed=false,SPressed=false;
String Menue ="creds",level="n",version="0.2.2_PRE_SOURSE_RELEASE",ip="localhost",name="can't_be_botherd_to_chane_it",input,outher_name,file_path,rootPath,stageType="";

float Scale =1,Scale2=1;
Player player1 =new Player(20,699,1,"red");
/*player array info
players by index position
0  xpos
1  ypos
2  animation state
3  animation delay count
4  size scale factor
5  jump cool down

*/

//^^^ literaly level 1 ^^^^
int camPos=0,camPosY=0,death_cool_down,start_down,port=9367,scroll_left,scroll_right,respawnX=20,respawnY=700,respawnZ=150,spdelay=0,vres,hres,respawnStage,stageIndex,coinCount=0,eadgeScroleDist=100,esdPos=800,setPlayerPosX,setPlayerPosY,setPlayerPosZ,gmillis=0,coinRotation=0;
JSONArray level_terain, settings,coins,mainIndex,levelProgress;
Button select_lvl_1,select_lvl_back,discord,select_lvl_2,select_lvl_3,select_lvl_4,select_lvl_5,select_lvl_6,sdSlider,enableFPS,disableFPS,enableDebug,disableDebug;

//▄
void draw(){// the function that is called every fraim

  if(menue){//when in a menue
    if(Menue.equals("creds")){//the inital loading screen 
      //image(CBi,390*Scale,0*Scale);// display the CBi logo
      //textAlign(LEFT,BOTTOM);
      //fill(74,250,0);
      //textSize(200*Scale);
      //text("GAMES",300*Scale,700*Scale);
      //start_down++;
      background(0);
        noStroke();
        
        drawlogo();
        
      if(start_wate>=2){// display it for 100  fraims 
        try{
          String inver =get_git_version();//check for updates
          inver =inver.substring(0,inver.length()-1);
          
        if(!inver.equals(version)){//if an update exists 
          Menue="update";//go to update menue
        }else{//if no update exists go to main menue
        if(showSettingsAfterStart){
          Menue="settings";
        }else{
        Menue="main";
        }}
        }catch(Throwable e){//if an error occors or no return then go to main menue
        if(showSettingsAfterStart){
          Menue="settings";
        }else{
          Menue="main";
        }
          println(e);//print to console the cause of the error
        }
      }
    }
    
    if(Menue.equals("update")){//if there is an updat draw the update screen
       draw_updae_screen(); 
    }
    
     if(Menue.equals("main")){//if on main menue
        background(7646207);
        textSize(100*Scale);
        fill(0);
        textAlign(CENTER,CENTER);
        text("skinny mann",width/2,80*Scale);//the title
        fill(255,255,0);
        text("ALFA",width/2,180*Scale);
        textSize(35*Scale);
        fill(-16732415);
        stroke(-16732415);
        rect(0*Scale,360*Scale,1280*Scale,360*Scale);//green rectangle
        draw_mann(200*Scale,360*Scale,1,4*Scale,"red");
        draw_mann(1080*Scale,360*Scale,1,4*Scale,"green");
        
        textAlign(LEFT,BOTTOM);
        fill(255,25,0);
        stroke(255,249,0);
        strokeWeight(10*Scale);
        rect(540*Scale,310*Scale,200*Scale,50*Scale);//play button
        fill(0);
        text("play",600*Scale,350*Scale);
        fill(255,25,0);
        rect(540*Scale,390*Scale,200*Scale,50*Scale);//the rest of the buttons on the screen
        rect(540*Scale,470*Scale,200*Scale,50*Scale);
        rect(540*Scale,550*Scale,200*Scale,50*Scale);
        rect(540*Scale,630*Scale,200*Scale,50*Scale);
        fill(0);
        text("exit",600*Scale,510*Scale);//exit button
        text("settings",580*Scale,590*Scale);
        text("how to play",543*Scale,670*Scale);
        fill(255);
        textSize(10*Scale);
        text(version,0*Scale,718*Scale);//proint the version in the lower corner
        discord.draw();
        image(discordIcon,1200*Scale,650*Scale);
     }
     if(Menue.equals("level select")){//if selecting level
     textAlign(LEFT,BOTTOM);
       strokeWeight(10*Scale);
        background(7646207);
        textSize(35*Scale);
        fill(-16732415);
        stroke(-16732415);
        strokeWeight(0);
        rect(0*Scale,360*Scale,1280*Scale,360*Scale);//green rectangle
        textSize(50*Scale);
        fill(0);
        text("Level Select",484*Scale,54*Scale);//menue title
        int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
        if(progress<2){
          select_lvl_2.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_2.setColor(-59135,-1791);
        }
        if(progress<3){
          select_lvl_3.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_3.setColor(-59135,-1791);
        }
        if(progress<4){
          select_lvl_4.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_4.setColor(-59135,-1791);
        }
        if(progress<5){
          select_lvl_5.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_5.setColor(-59135,-1791);
        }
        if(progress<6){
          select_lvl_6.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_6.setColor(-59135,-1791);
        }
        select_lvl_1.draw();
        select_lvl_2.draw();
        select_lvl_3.draw();
        select_lvl_4.draw();
        select_lvl_5.draw();
        select_lvl_6.draw();
        select_lvl_back.draw();
     }
     if(Menue.equals("pause")){//when in the pause emnue cancle all motion
       player1_moving_right=false;
       player1_moving_left=false;
       player1_jumping=false;
     }
     
     
     if(Menue.equals("settings")){//the settings menue
     textAlign(LEFT,BOTTOM);
      background(7646207); 
      fill(255);
      stroke(0);
      strokeWeight(5*Scale);
      //the checkboxes
      rect(1200*Scale,120*Scale,40*Scale,40*Scale);
      rect(1130*Scale,120*Scale,40*Scale,40*Scale);
      rect(1060*Scale,120*Scale,40*Scale,40*Scale);
      rect(920*Scale,120*Scale,40*Scale,40*Scale);
      rect(990*Scale,120*Scale,40*Scale,40*Scale);
      rect(1200*Scale,190*Scale,40*Scale,40*Scale);
      rect(1130*Scale,190*Scale,40*Scale,40*Scale);
      //rect(1060*Scale,190*Scale,40*Scale,40*Scale);
      enableFPS.draw();
      disableFPS.draw();
      enableDebug.draw();
      disableDebug.draw();
      fill(0);
      textAlign(LEFT,BOTTOM);
      textSize(40*Scale);//explaination text
      text("screen scrolling location",40*Scale,90*Scale);
      text("verticle screen resolution (requires restart)",40*Scale,150*Scale);
      text("full screen (requires restart)",40*Scale,210*Scale);
      text((int)(((esdPos-800.0)/440)*250)+100,530*Scale,90*Scale);
      text("display fps",40*Scale,280*Scale);
      text("display debug info",40*Scale,350*Scale);
      textSize(20*Scale);
      text("2160(4K)",1190*Scale,115*Scale);
      text("1440",1120*Scale,115*Scale);
      text("1080",1055*Scale,115*Scale);
      text("900",990*Scale,115*Scale);
      text("720",920*Scale,115*Scale);
      /*
      text("32:9",1190*Scale,185*Scale);
      text("16:9",1120*Scale,185*Scale);
      text("16:10",1055*Scale,185*Scale);
      */
      text("yes",1190*Scale,185*Scale);
      text("no",1120*Scale,185*Scale);

     settings =loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
     if(true){
       sdSlider.draw();
       fill(255);
       rect(esdPos*Scale,42*Scale,10*Scale,45*Scale);
     } 
     strokeWeight(5*Scale);
     stroke(255,0,0);
     if(true){
       JSONObject rez=settings.getJSONObject(2);
       int vres = rez.getInt("v-res");
     //  String arat = rez.getString("aspect ratio");
       boolean fus = rez.getBoolean("full_Screen");
       
       if(vres==720){
         line(925*Scale,140*Scale,940*Scale,155*Scale);
         line(965*Scale,125*Scale,940*Scale,155*Scale  );
       }
       if(vres==900){
         line(995*Scale,140*Scale,1010*Scale,155*Scale);
         line(1035*Scale,125*Scale,1010*Scale,155*Scale);
       }
       if(vres==1080){
         line(1065*Scale,140*Scale,1080*Scale,155*Scale);
         line(1105*Scale,125*Scale,1080*Scale,155*Scale);
       }
       if(vres==1440){
         line(1135*Scale,140*Scale,1150*Scale,155*Scale);
         line(1175*Scale,125*Scale,1150*Scale,155*Scale);
       }
       if(vres==2160){
         line(1205*Scale,140*Scale,1220*Scale,155*Scale);
         line(1245*Scale,125*Scale,1220*Scale,155*Scale);
       }
       if(!fus){
         line(1135*Scale,210*Scale,1150*Scale,225*Scale);
         line(1175*Scale,195*Scale,1150*Scale,225*Scale);
       }else{
         line(1205*Scale,210*Scale,1220*Scale,225*Scale);
         line(1245*Scale,195*Scale,1220*Scale,225*Scale);
       }
       
       if(!displayFPS){
         line(1135*Scale,280*Scale,1150*Scale,295*Scale);
         line(1175*Scale,265*Scale,1150*Scale,295*Scale);
       }else{
         line(1205*Scale,280*Scale,1220*Scale,295*Scale);
         line(1245*Scale,265*Scale,1220*Scale,295*Scale);
       }
       if(!displayDebugInfo){
         line(1135*Scale,350*Scale,1150*Scale,365*Scale);
         line(1175*Scale,335*Scale,1150*Scale,365*Scale);
       }else{
         line(1205*Scale,350*Scale,1220*Scale,365*Scale);
         line(1245*Scale,335*Scale,1220*Scale,365*Scale);
       }
     }
         textAlign(LEFT,BOTTOM);
         fill(255,25,0);
        stroke(255,249,0);
        strokeWeight(10*Scale);
        rect(40*Scale,610*Scale,200*Scale,50*Scale);//the back button
        fill(0);
        textSize(50*Scale);
        text("back",60*Scale,655*Scale);
   }
   
   
   if(Menue.equals("how to play")){//how to play menue
     background(#4FCEAF);
     fill(0);
     textAlign(LEFT,TOP);
     textSize(60*Scale);
     text("press 'A' or 'D' to move left or right \npress SPACE to jump\npress 'ESC' to pause the game\ngoal: get the the finishline at the \nend of the level",100*Scale,100*Scale);//the explaination
     fill(255,25,0);
      stroke(255,249,0);
     strokeWeight(10*Scale);
     rect(40*Scale,610*Scale,200*Scale,50*Scale);// the back button
     fill(0);
     textAlign(LEFT,BOTTOM);
     textSize(50*Scale);
     text("back",60*Scale,655*Scale);
   }
   
  }
  //end of menue draw
  
  
  if(inGame){
        //================================================================================================
        background(7646207);
          stageLevelDraw();
          //playerPhysics();
     
  }
  engageHUDPosition();//anything hud
  
  if(inGame){
       fill(255);
       textSize(50*Scale);
       textAlign(LEFT,TOP);
       text("coins: "+coinCount,0,0);
     
     
     
  }
  
  if(menue){
    if(Menue.equals("pause")){//when paused
    textAlign(LEFT,BOTTOM);
      fill(50,200);
      rect(0,0,width,height);
      fill(0);
      textSize(100*Scale);
      text("GAME PAUSED",300*Scale,100*Scale);
      fill(255,25,0);
       stroke(255,249,0);
       strokeWeight(10*Scale);
       rect(500*Scale,200*Scale,300*Scale,60*Scale);//buttons
       rect(500*Scale,300*Scale,300*Scale,60*Scale);
       rect(500*Scale,400*Scale,300*Scale,60*Scale);
       fill(0);
       textSize(50*Scale);
       text("resume",550*Scale,250*Scale);
       text("options",550*Scale,350*Scale);
       text("quit",600*Scale,450*Scale);
       
    }
  }
  
  
  if(dead){// when  dead
    fill(255,0,0);
    textSize(50*Scale);
    text("you died",500*Scale,360*Scale);
     death_cool_down++;
     if(death_cool_down>200){// respawn cool down
       dead=false;
       inGame=true;
       if(respawnX < 400){
        camPos=0; 
       }else{
       camPos=respawnX-400;
       }
       player1_moving_right=false;
       player1_moving_left=false;
       player1_jumping=false;
     }
  }
  
  
if(displayFPS){
  fill(255);
  textSize(10*Scale);//fraim rate counter
  textAlign(LEFT,BOTTOM);
  text("fps: "+ frameRate,1200*Scale,10*Scale);
}
if(displayDebugInfo){
  fill(255);
  textSize(10*Scale);//fraim rate counter
  textAlign(RIGHT,TOP);
  text("mspc: "+ mspc,1275*Scale,10*Scale);
  text("player X: "+ player1.x,1275*Scale,20*Scale);
  text("player Y: "+ player1.y,1275*Scale,30*Scale);
  text("player time in air: "+ player1.timeInAir,1275*Scale,40*Scale);
  text("player jump distance: "+ player1.jumpDist,1275*Scale,50*Scale);
  text("player animation Cooldown: "+ player1.animationCooldown,1275*Scale,60*Scale);
  text("player pose: "+ player1.pose,1275*Scale,70*Scale);
  text("camera x: "+camPos,1275*Scale,80*Scale);
  text("camera y: "+camPosY,1275*Scale,90*Scale);
}

if(millis()<gmillis){
    glitchEffect();
  }

disEngageHUDPosition();
}

void mouseClicked(){// when you click the mouse
  if(menue){//if your in a menue
     if(Menue.equals("main")){//if that menue is the main menue
       if(mouseX >= 540*Scale && mouseX <= 740*Scale && mouseY >= 310*Scale && mouseY <= 360*Scale){//level select button
         Menue = "level select";
         return;
       }
       if(mouseX >= 540*Scale && mouseX <= 740*Scale && mouseY >= 470*Scale && mouseY <= 510*Scale){//exit button
         exit();
       }
       if((mouseX >= 540*Scale && mouseX <= 740*Scale && mouseY >= 390*Scale && mouseY <= 440*Scale)&&!hosting&&!joined){//join game button
          link("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
       }
       if((mouseX >= 540*Scale && mouseX <= 740*Scale && mouseY >= 550*Scale && mouseY <= 600*Scale)&&!hosting&&!joined){//settings button
         Menue="settings";
         return;
       }
       if((mouseX >= 540*Scale && mouseX <= 740*Scale && mouseY >= 630*Scale && mouseY <= 680*Scale)&&!hosting&&!joined){//how to play button
         Menue="how to play";
       }
       if(discord.isMouseOver()){
        link("http://discord.gg/C5SACF2"); 
       }
     }
    if(Menue.equals("level select")&&!start_host){//if that menue is level select
    int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
         if(select_lvl_1.isMouseOver()){
           loadLevel("/data/levels/level-1");
           menue=false;
           inGame=true;
         }
         if(select_lvl_2.isMouseOver()&&progress>=2){
           loadLevel("/data/levels/level-2");
           menue=false;
           inGame=true;
         }
         if(select_lvl_3.isMouseOver()&&progress>=3){
           loadLevel("/data/levels/level-3");
           menue=false;
           inGame=true;
         }
         if(select_lvl_4.isMouseOver()&&progress>=4){
           loadLevel("/data/levels/level-4");
           menue=false;
           inGame=true;
         }
         if(select_lvl_5.isMouseOver()&&progress>=3){
           loadLevel("/data/levels/level-5");
           menue=false;
           inGame=true;
         }
         if(select_lvl_6.isMouseOver()&&progress>=4){
           loadLevel("/data/levels/level-6");
           menue=false;
           inGame=true;
         }
         
         if(select_lvl_back.isMouseOver()){
           Menue="main";
         }
     }
     
     if(Menue.equals("pause")&&!start_host){//if that menue is pause
       if(mouseX >= 500*Scale && mouseX <= 800*Scale && mouseY >= 200*Scale && mouseY <= 260*Scale){//resume game button
         menue=false;
       }
       if(mouseX >= 500*Scale && mouseX <= 800*Scale && mouseY >= 300*Scale && mouseY <= 360*Scale){//resume game button
         Menue="settings";
         prevousInGame=true;
         inGame=false;
       }
       if(mouseX >= 500*Scale && mouseX <= 800*Scale && mouseY >= 400*Scale && mouseY <= 460*Scale){//quit button
         menue=true;
         inGame=false;
         Menue="level select";
       }
       
     }
     
     if(Menue.equals("settings")){     //if that menue is settings
    
       // if((mouseX >= 1200*Scale && mouseX <= 1240*Scale && mouseY >= 50*Scale && mouseY <= 90*Scale)&&!hosting&&!joined){//normal screen scrolling
       //    JSONObject scrolling = new JSONObject();
       //   scrolling.setString("lable", "normal");
       //   scrolling.setFloat("value_right", 1100);
       //   scrolling.setFloat("value_left", 100);
       //   settings.setJSONObject(0,scrolling);
       //   saveJSONArray(settings, "data/settings.json");
       //}
       
       //if((mouseX >= 1130*Scale && mouseX <= 1170*Scale && mouseY >= 50*Scale && mouseY <= 90*Scale)&&!hosting&&!joined){//noob screen scrolling
       //    JSONObject scrolling = new JSONObject();
       //   scrolling.setString("lable", "noob");
       //   scrolling.setFloat("value_right", 650);
       //   scrolling.setFloat("value_left", 630);
       //   settings.setJSONObject(0,scrolling);
       //   saveJSONArray(settings, "data/settings.json");
       //}
       
       if(sdSlider.isMouseOver()){
         esdPos=(int)(mouseX/Scale);
         if(esdPos<800){
           esdPos=800;
         }
         if(esdPos>1240){
           esdPos=1240;
         }
         eadgeScroleDist=(int)(((esdPos-800.0)/440)*250)+100;
         JSONObject scroll=settings.getJSONObject(1);
         scroll.setInt("value",(int)(((esdPos-800.0)/440)*250)+100);
         settings.setJSONObject(1,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       JSONObject rez=settings.getJSONObject(2);
      // int vres = rez.getInt("v-res");
       String arat = "16:9";
       if((mouseX >= 1200*Scale && mouseX <= 1240*Scale && mouseY >= 120*Scale && mouseY <= 160*Scale)&&!hosting&&!joined){//2160 resolution button
           rez.setInt("v-res",2160);
           if(arat.equals("16:9")){
             rez.setInt("h-res",2160*16/9);
           }
           if(arat.equals("16:10")){
             rez.setInt("h-res",2160*16/10);
           }
           if(arat.equals("32:9")){
             rez.setInt("h-res",2160*32/9);
           }
          rez.setFloat("scale",2160/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if((mouseX >= 1130*Scale && mouseX <= 1170*Scale && mouseY >= 120*Scale && mouseY <= 160*Scale)&&!hosting&&!joined){// 1440 resolition button
           rez.setInt("v-res",1440);
           if(arat.equals("16:9")){
             rez.setInt("h-res",1440*16/9);
           }
           if(arat.equals("16:10")){
             rez.setInt("h-res",1440*16/10);
           }
           if(arat.equals("32:9")){
             rez.setInt("h-res",1440*32/9);
           }
          rez.setFloat("scale",1440/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if((mouseX >= 1060*Scale && mouseX <= 1100*Scale && mouseY >= 120*Scale && mouseY <= 160*Scale)&&!hosting&&!joined){// 1080 resolution button
           rez.setInt("v-res",1080);
           if(arat.equals("16:9")){
             rez.setInt("h-res",1080*16/9);
           }
           if(arat.equals("16:10")){
             rez.setInt("h-res",1080*16/10);
           }
           if(arat.equals("32:9")){
             rez.setInt("h-res",1080*32/9);
           }
          rez.setFloat("scale",1080/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if((mouseX >= 990*Scale && mouseX <= 1030*Scale && mouseY >= 120*Scale && mouseY <= 160*Scale)&&!hosting&&!joined){////900 resolution button
           rez.setInt("v-res",900);
           if(arat.equals("16:9")){
             rez.setInt("h-res",900*16/9);
           }
           if(arat.equals("16:10")){
             rez.setInt("h-res",900*16/10);
           }
           if(arat.equals("32:9")){
             rez.setInt("h-res",900*32/9);
           }
          rez.setFloat("scale",900/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if((mouseX >= 920*Scale && mouseX <= 960*Scale && mouseY >= 120*Scale && mouseY <= 160*Scale)&&!hosting&&!joined){// 720 resolution button
           rez.setInt("v-res",720);
           if(arat.equals("16:9")){
             rez.setInt("h-res",720*16/9);
           }
           if(arat.equals("16:10")){
             rez.setInt("h-res",720*16/10);
           }
           if(arat.equals("32:9")){
             rez.setInt("h-res",720*32/9);
           }
          rez.setFloat("scale",720/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       
       if((mouseX >= 1200*Scale && mouseX <= 1240*Scale && mouseY >= 190*Scale && mouseY <= 230*Scale)&&!hosting&&!joined){//turn full screen on button
           rez.setBoolean("full_Screen",true);
           
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if((mouseX >= 1130*Scale && mouseX <= 1170*Scale && mouseY >= 190*Scale && mouseY <= 230*Scale)&&!hosting&&!joined){//turn fullscreen off button
           rez.setBoolean("full_Screen",false);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       JSONObject debug=settings.getJSONObject(3);
       if(enableFPS.isMouseOver()){
           debug.setBoolean("fps",true);
           displayFPS=true;
           settings.setJSONObject(3,debug);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
      if(disableFPS.isMouseOver()){
        debug.setBoolean("fps",false);
           displayFPS=false;
           settings.setJSONObject(3,debug);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
      if(enableDebug.isMouseOver()){
        debug.setBoolean("debug info",true);
           displayDebugInfo=true;
           settings.setJSONObject(3,debug);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
      if(disableDebug.isMouseOver()){
        debug.setBoolean("debug info",false);
           displayDebugInfo=false;
           settings.setJSONObject(3,debug);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
       
       
       
       if(mouseX >= 40*Scale && mouseX <= 240*Scale && mouseY >= 610*Scale && mouseY <= 660*Scale){//back button
       if(prevousInGame){
         Menue="pause";
         inGame=true;
         prevousInGame=false;
       }else{
           Menue ="main";
       }
         }
     }
     
     
     if(Menue.equals("how to play")){//if that menue is how to play
      if(mouseX >= 40*Scale && mouseX <= 240*Scale && mouseY >= 610*Scale && mouseY <= 660*Scale){//back button
           Menue ="main";
         } 
     }
     
     if(Menue.equals("update")){//if that menue is update
       updae_screen_click(); //check the update clicks 
    }
  }
  if(level_complete){//if you completed a level and have not joined
    if(mouseX >= 550*Scale && mouseX <= 750*Scale && mouseY >= 450*Scale && mouseY <= 490*Scale){//continue button
           menue=true;
           inGame=false;
           Menue="level select";
           level_complete=false;
           JSONObject lvlinfo=mainIndex.getJSONObject(0);
           if(lvlinfo.getInt("level_id")>levelProgress.getJSONObject(0).getInt("progress")){
             JSONObject p=new JSONObject();
             p.setInt("progress",levelProgress.getJSONObject(0).getInt("progress")+1);
             levelProgress.setJSONObject(0,p);
             saveJSONArray(levelProgress,System.getenv("AppData")+"/CBi-games/skinny mann/progressions.json");
           }
         }
  }
    

  
  }


void keyPressed(){// when a key is pressed
  if(inGame){//if in game
  if (key == ESC) {
    key = 0;  //clear the key so it doesnt close the program
    menue=true;
    Menue="pause";
  }
  if(keyCode==65){//if A is pressed
    player1_moving_left=true;
  }
  if(keyCode==68){//if D is pressed
    player1_moving_right=true;
  }
  if(keyCode==32){//if space is pressed
    player1_jumping=true;
  }
  if(dev_mode){//if in dev mode
   if(keyCode==81){//if q is pressed print the player position
    System.out.println(player1.getX()+" "+player1.getY());
  }}
  if(key=='e'||key=='E'){
   E_pressed=true; 
  }
  if(e3DMode){
  if(keyCode==87){//w
    WPressed=true;
  }
  if(keyCode==83){//s
    SPressed=true;
  }
  
  }//end of 3d mode
}
if(menue){
  if(Menue.equals("level select")){
    if (key == ESC) {
    key = 0;  //clear the key so it doesnt close the program
    Menue="main";
  }
  }
  if(Menue.equals("settings")){
    if (key == ESC) {
    key = 0;  //clear the key so it doesnt close the program
    if(prevousInGame){
         Menue="pause";
         inGame=true;
         prevousInGame=false;
       }else{
           Menue ="main";
       }
    
  }
  }
  if(Menue.equals("how to play")){
    if (key == ESC) {
    key = 0;  //clear the key so it doesnt close the program
    Menue="main";
  }
  }
}
  
//System.out.println(keyCode);
}

void keyReleased(){//when you release a key
  if(inGame){//whehn in game
    if(keyCode==65){//if A is released
      player1_moving_left=false;
    }
    if(keyCode==68){//if D is released
      player1_moving_right=false;
    }
    if(keyCode==32){//if SPACE is released
    player1_jumping=false;
  }
  if(key=='e'||key=='E'){
   E_pressed=false; 
  }
  if(e3DMode){
  if(keyCode==87){//w
    WPressed=false;
  }
  if(keyCode==83){//s
    SPressed=false;
  }
  }//end of 3d mode
  }
}

void mouseDragged(){
  if(Menue.equals("settings")){
 if(sdSlider.isMouseOver()){
         esdPos=(int)(mouseX/Scale);
         if(esdPos<800){
           esdPos=800;
         }
         if(esdPos>1240){
           esdPos=1240;
         }
         eadgeScroleDist=(int)(((esdPos-800.0)/440)*250)+100;
         JSONObject scroll=settings.getJSONObject(1);
         scroll.setInt("value",(int)(((esdPos-800.0)/440)*250)+100);
         settings.setJSONObject(1,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       } 
  }
}

void loadLevel(String fdp){
 rootPath=fdp;
 mainIndex=loadJSONArray(rootPath+"/index.json");
 JSONObject lvlinfo=mainIndex.getJSONObject(0);
 coins=loadJSONArray(rootPath+mainIndex.getJSONObject(lvlinfo.getInt("coins")).getString("location"));
 stageIndex=lvlinfo.getInt("mainStage");
 respawnStage=stageIndex;
 file_path=rootPath+mainIndex.getJSONObject(stageIndex).getString("location");
 player1.setX(lvlinfo.getInt("spawnX"));
 player1.setY(lvlinfo.getInt("spawnY"));
 respawnX=lvlinfo.getInt("spawn pointX");
 respawnY=lvlinfo.getInt("spawn pointY");
 level_terain=loadJSONArray(file_path);
 coinCount=0;
}

int curMills=0,lasMills=0,mspc=0;

void thrdCalc2(){

  while(loopThread2){
 curMills=millis(); 
 mspc=curMills-lasMills;
 if(inGame){
   try{
   playerPhysics();
   }catch(Throwable e){
     
   }
 }else{
random(10);//some how make it so it doesent stop the thread
 }
   lasMills=curMills;
   //println(mspc);
  }
}

void generateSettings(){
  showSettingsAfterStart=true;
 settings=new JSONArray(); 
 JSONObject scrolling = new JSONObject(),rez=new JSONObject(),header=new JSONObject(),debug=new JSONObject();
    header.setInt("settings version",1);
    settings.setJSONObject(0,header);
 
    scrolling.setString("lable", "scroling location");
    scrolling.setFloat("value", 100);
    settings.setJSONObject(1,scrolling);
          
    rez.setString("lable","resolution stuff");
    rez.setInt("v-res",720);     
    rez.setInt("h-res",720*16/9);
    rez.setFloat("scale",1);
    rez.setBoolean("full_Screen",false);
    settings.setJSONObject(2,rez);
    
    debug.setBoolean("fps",true);
    debug.setString("lable","debig stuffs");
    debug.setBoolean("debug info",false);
    settings.setJSONObject(3,debug);
          
    saveJSONArray(settings,System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
}
