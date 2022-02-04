import processing.net.*;//import the stuffs
import processing.sound.*;
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
import java.awt.Desktop;
import javax.swing.*;

void settings(){//first function called
  try{
    settings =loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");//load the settings
    JSONObject vers=settings.getJSONObject(0);
  if(vers.getInt("settings version")!=settingsVersion){
    generateSettings();
  }
  }catch(Throwable e){
    println("an error occored finding the settings file generating new file");
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
   fullScreen(P3D,rez.getInt("full_Screen_diplay"));//if full screen then turn full screen on
   
  }
  PJOGL.setIcon("data/assets/skinny mann face.PNG");
}



void setup(){//seccond function called
 frameRate(60);//limet the frame reate
   background(0);
 if(fs){//get and set some data
   hres=width;
   vres=height;
   Scale=vres/720.0;
   Scale2=hres/1280.0;
 }
 println(height);//debung info

 CBi = loadImage("data/assets/CBi.png");//load the CBi logo
 CBi.resize((int)(500*Scale),(int)(500*Scale));//scale the CBi logo
 
 discordIcon=loadImage("data/assets/discord.png");
 discordIcon.resize((int)(50*Scale),(int)(50*Scale));
 
 coin3D=loadShape("data/modles/coin/tinker.obj");
 coin3D.scale(3);
    
 icon = loadImage("data/assets/skinny mann face.PNG");//load the window icon
 //surface.setIcon(icon);//set the window icon
 
 JSONObject scroll=settings.getJSONObject(1);//load in the settings
 eadgeScroleDist=scroll.getInt("horozontal");
 esdPos=(int)(((eadgeScroleDist-100.0)/530)*440+800);
 eadgeScroleDistV=scroll.getInt("vertical");
 vesdPos=(int)(((eadgeScroleDistV-100.0)/250)*440+800);
 println(esdPos+" "+eadgeScroleDist+" "+vesdPos+" "+eadgeScroleDistV);
 //((esdPos-800.0)/440)*250)+100
 //scroll_left = scroll.getInt("value_left");//set the screen scrolling locations
 //scroll_right = scroll.getInt("value_right");
JSONObject debug=settings.getJSONObject(3);
 displayFPS=debug.getBoolean("fps");
 displayDebugInfo=debug.getBoolean("debug info");
 JSONObject sound=settings.getJSONObject(4);
 musicVolume=sound.getFloat("music volume");
 sfxVolume=sound.getFloat("SFX volume");
 musVolSllid=(int)(musicVolume*440+800);
 sfxVolSllid=(int)(sfxVolume*440+800);
  JSONObject sv3=settings.getJSONObject(5);
 shadow3D=sv3.getBoolean("3D shaows");
 tutorialNarrationMode=sv3.getInt("narrationMode");
 
 musVolSllid=(int)(musicVolume*440+800);
 sfxVolSllid=(int)(sfxVolume*440+800);

 
 
 
 
 try{//load level prgress
 levelProgress=loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/progressions.json");
 levelProgress.getJSONObject(0);
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
  
}
textSize(500);
select_lvl_1=new Button((int)(100*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 1",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_back=new Button((int)(100*Scale),(int)(600*Scale),(int)(200*Scale),(int)(50*Scale),"back",-59135,-1791).setStrokeWeight((int)(10*Scale));
discord=new Button((int)(1190*Scale),(int)(640*Scale),(int)(70*Scale),(int)(70*Scale),-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_2 =new Button((int)(350*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 2",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_3 =new Button((int)(600*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 3",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_4 =new Button((int)(850*Scale),(int)(100*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 4",-59135,-1791).setStrokeWeight((int)(10*Scale));
sdSlider=new Button((int)(800*Scale),(int)(50*Scale),(int)(440*Scale),(int)(30*Scale),255,0).setStrokeWeight((int)(5*Scale));
disableFPS =new Button((int)(1130*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
enableFPS =new Button((int)(1200*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
disableDebug =new Button((int)(1130*Scale),(int)(120*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
enableDebug =new Button((int)(1200*Scale),(int)(120*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight((int)(5*Scale));
select_lvl_5=new Button((int)(100*Scale),(int)(250*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 5",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_6 =new Button((int)(350*Scale),(int)(250*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 6",-59135,-1791).setStrokeWeight((int)(10*Scale));
sttingsGPL = new Button((int)(40*Scale),(int)(550*Scale),(int)(150*Scale),(int)(40*Scale),"game play",-59135,-1791).setStrokeWeight((int)(10*Scale)).setTextFactor(4);
settingsDSP = new Button((int)(240*Scale),(int)(550*Scale),(int)(150*Scale),(int)(40*Scale),"display",-59135,-1791).setStrokeWeight((int)(10*Scale)).setTextFactor(4);
settingsOUT = new Button((int)(440*Scale),(int)(550*Scale),(int)(150*Scale),(int)(40*Scale),"outher",-59135,-1791).setStrokeWeight((int)(10*Scale)).setTextFactor(4);
rez720 = new Button((int)(920*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
rez900 = new Button((int)(990*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
rez1080 = new Button((int)(1060*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
rez1440 = new Button((int)(1130*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
rez4k = new Button((int)(1200*Scale),(int)(50*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
fullScreenOn = new Button((int)(1200*Scale),(int)(120*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
fullScreenOff = new Button((int)(1130*Scale),(int)(120*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
vsdSlider =new Button((int)(800*Scale),(int)(120*Scale),(int)(440*Scale),(int)(30*Scale),255,0).setStrokeWeight((int)(5*Scale));
MusicSlider=new Button((int)(800*Scale),(int)(190*Scale),(int)(440*Scale),(int)(30*Scale),255,0).setStrokeWeight((int)(5*Scale));
SFXSlider=new Button((int)(800*Scale),(int)(260*Scale),(int)(440*Scale),(int)(30*Scale),255,0).setStrokeWeight((int)(5*Scale));
shadowOn = new Button((int)(1200*Scale),(int)(330*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
shadowOff = new Button((int)(1130*Scale),(int)(330*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
narrationMode1 =new Button((int)(1200*Scale),(int)(460*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
narrationMode0 = new Button((int)(1130*Scale),(int)(460*Scale),(int)(40*Scale),(int)(40*Scale),255,0).setStrokeWeight(5*Scale);
select_lvl_UGC=new Button((int)(350*Scale),(int)(600*Scale),(int)(200*Scale),(int)(50*Scale),"UGC",-59135,-1791).setStrokeWeight((int)(10*Scale));
UGC_open_folder=new Button((int)(350*Scale),(int)(600*Scale),(int)(200*Scale),(int)(50*Scale),"open folder",-59135,-1791).setStrokeWeight((int)(10*Scale)).setTextFactor(10);
UGC_lvls_next=new Button((int)(1030*Scale),(int)(335*Scale),(int)(200*Scale),(int)(50*Scale),"next",-59135,-1791).setStrokeWeight((int)(10*Scale));
UGC_lvls_prev=new Button((int)(50*Scale),(int)(335*Scale),(int)(200*Scale),(int)(50*Scale),"prevous",-59135,-1791).setStrokeWeight((int)(10*Scale)).setTextFactor(4);
UGC_lvl_play=new Button((int)(600*Scale),(int)(600*Scale),(int)(200*Scale),(int)(50*Scale),"play",-59135,-1791).setStrokeWeight((int)(10*Scale));
levelcreatorLink=new Button((int)(980*Scale),(int)(600*Scale),(int)(200*Scale),(int)(50*Scale),"create",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_7=new Button((int)(600*Scale),(int)(250*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 7",-59135,-1791).setStrokeWeight((int)(10*Scale));
select_lvl_8 =new Button((int)(850*Scale),(int)(250*Scale),(int)(200*Scale),(int)(100*Scale),"lvl 8",-59135,-1791).setStrokeWeight((int)(10*Scale));

soundHandler =new SoundHandler(musicTracks,sfxTracks,this);
soundHandler.setMusicVolume(0);

tutorialNarration[0][0]=new SoundFile(this,"data/sounds/tutorial/T1a.wav");tutorialNarration[0][1]=new SoundFile(this,"data/sounds/tutorial/T2a.wav");tutorialNarration[0][2]=new SoundFile(this,"data/sounds/tutorial/T3.wav");tutorialNarration[0][3]=new SoundFile(this,"data/sounds/tutorial/T4a.wav");tutorialNarration[0][4]=new SoundFile(this,"data/sounds/tutorial/T5a.wav");tutorialNarration[0][5]=new SoundFile(this,"data/sounds/tutorial/T6a.wav");tutorialNarration[0][6]=new SoundFile(this,"data/sounds/tutorial/T7.wav");tutorialNarration[0][7]=new SoundFile(this,"data/sounds/tutorial/T8a.wav");tutorialNarration[0][8]=new SoundFile(this,"data/sounds/tutorial/T9a.wav");tutorialNarration[0][9]=new SoundFile(this,"data/sounds/tutorial/T10.wav");tutorialNarration[0][10]=new SoundFile(this,"data/sounds/tutorial/T11.wav");tutorialNarration[0][11]=new SoundFile(this,"data/sounds/tutorial/T12.wav");tutorialNarration[0][12]=new SoundFile(this,"data/sounds/tutorial/T13.wav");tutorialNarration[0][13]=new SoundFile(this,"data/sounds/tutorial/T14a.wav");tutorialNarration[0][14]=new SoundFile(this,"data/sounds/tutorial/T15.wav");tutorialNarration[0][15]=new SoundFile(this,"data/sounds/tutorial/T16.wav");tutorialNarration[0][16]=new SoundFile(this,"data/sounds/tutorial/T17.wav");
tutorialNarration[1][0]=new SoundFile(this,"data/sounds/tutorial/T1b.wav");tutorialNarration[1][1]=new SoundFile(this,"data/sounds/tutorial/T2b.wav");tutorialNarration[1][2]=new SoundFile(this,"data/sounds/tutorial/T3.wav");tutorialNarration[1][3]=new SoundFile(this,"data/sounds/tutorial/T4b.wav");tutorialNarration[1][4]=new SoundFile(this,"data/sounds/tutorial/T5b.wav");tutorialNarration[1][5]=new SoundFile(this,"data/sounds/tutorial/T6b.wav");tutorialNarration[1][6]=new SoundFile(this,"data/sounds/tutorial/T7.wav");tutorialNarration[1][7]=new SoundFile(this,"data/sounds/tutorial/T8b.wav");tutorialNarration[1][8]=new SoundFile(this,"data/sounds/tutorial/T9b.wav");tutorialNarration[1][9]=new SoundFile(this,"data/sounds/tutorial/T10.wav");tutorialNarration[1][10]=new SoundFile(this,"data/sounds/tutorial/T11.wav");tutorialNarration[1][11]=new SoundFile(this,"data/sounds/tutorial/T12.wav");tutorialNarration[1][12]=new SoundFile(this,"data/sounds/tutorial/T13.wav");tutorialNarration[1][13]=new SoundFile(this,"data/sounds/tutorial/T14b.wav");tutorialNarration[1][14]=new SoundFile(this,"data/sounds/tutorial/T15.wav");tutorialNarration[1][15]=new SoundFile(this,"data/sounds/tutorial/T16.wav");tutorialNarration[1][16]=new SoundFile(this,"data/sounds/tutorial/T17.wav");

ptsW=100;
  ptsH=100;
initializeSphere(ptsW, ptsH);
thread("thrdCalc2");
}
//define a shit tone of varibles
PImage CBi,icon,discordIcon;
PShape coin3D;
PApplet primaryWindow=this;
Server s;
Client c;
boolean menue =true,inGame=false,player1_moving_right=false,player1_moving_left=false,dev_mode=false,player1_jumping=false,dead=false,level_complete=false,start_host=false,entering_port=false,entering_name=false,entering_ip=false,hosting=false,joined=false,start_join=false,reset_spawn=false,fs,E_pressed=false,loopThread2=true,showSettingsAfterStart=false,displayFPS=true,displayDebugInfo=false,prevousInGame=false,setPlayerPosTo=false,e3DMode=false,checkpointIn3DStage=false,WPressed=false,SPressed=false,levelCompleteSoundPlayed=false,tutorialMode=false,shadow3D=true,UGC_lvl=false,levelCompatible=false,editingBlueprint=false,viewingItemContents=false,selecting=false;
String Menue ="creds"/*,level="n"*/,version="0.5.0_Early_Access",ip="localhost",name="can't_be_botherd_to_chane_it",input,outher_name,file_path,rootPath,stageType="",settingsMenue="game play",author="",displayText="",GAME_version=version;
ArrayList<Boolean> coins;
ArrayList<String> UGCNames;
float Scale =1,Scale2=1,musicVolume=1,sfxVolume=1,gravity=0.001;
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


int camPos=0,camPosY=0,death_cool_down,start_down,port=9367,scroll_left,scroll_right,respawnX=20,respawnY=700,respawnZ=150,spdelay=0,vres,hres,respawnStage,stageIndex,coinCount=0,eadgeScroleDist=100,esdPos=800,setPlayerPosX,setPlayerPosY,setPlayerPosZ,gmillis=0,coinRotation=0,vesdPos=800,eadgeScroleDistV=100,settingsVersion=3,musVolSllid=800,sfxVolSllid=800,currentStageIndex,tutorialDrawLimit=0,displayTextUntill=0,tutorialPos=0,currentTutorialSound,tutorialNarrationMode=0,UGC_lvl_indx,selectedIndex=-1,viewingItemIndex=-1,drawCamPosX=0,drawCamPosY=0;
JSONArray  settings,mainIndex,levelProgress;
Button select_lvl_1,select_lvl_back,discord,select_lvl_2,select_lvl_3,select_lvl_4,select_lvl_5,select_lvl_6,sdSlider,enableFPS,disableFPS,enableDebug,disableDebug,sttingsGPL,settingsDSP,settingsOUT,rez720,rez900,rez1080,rez1440,rez4k,fullScreenOn,fullScreenOff,vsdSlider,MusicSlider,SFXSlider,shadowOn,shadowOff,narrationMode1,narrationMode0,select_lvl_UGC,UGC_open_folder,UGC_lvls_next,UGC_lvls_prev,UGC_lvl_play,levelcreatorLink,select_lvl_7,select_lvl_8;
String[] musicTracks ={"data/music/track1.wav","data/music/track2.wav","data/music/track3.wav"},sfxTracks={"data/sounds/level complete.wav"},compatibleVersions={"0.5.0_Early_Access"};
SoundHandler soundHandler;
Level level;
SoundFile[][] tutorialNarration=new SoundFile[2][17];
float [] tpCords=new float[3];
Stage workingBlueprint;
ArrayList<Boolean> compatibles;
//▄
void draw(){// the function that is called every fraim

try{//catch all fatal errors and display them

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
      soundHandler.setMusicVolume(musicVolume);
      soundHandler.setSoundsVolume(sfxVolume);
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
        text("Early Access",width/2,180*Scale);
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
        text("tutorial",580*Scale,670*Scale);
        fill(255);
        textSize(10*Scale);
        text(version,0*Scale,718*Scale);//proint the version in the lower corner
        discord.draw();
        image(discordIcon,1200*Scale,650*Scale);
     }
     if(Menue.equals("level select")){//if selecting level
     levelCompleteSoundPlayed=false;
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
        if(progress<7){
          select_lvl_7.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_7.setColor(-59135,-1791);
        }
        if(progress<8){
          select_lvl_8.setColor(#B40F00,#B4AF00);
        }else{
          select_lvl_8.setColor(-59135,-1791);
        }
        select_lvl_1.draw();
        select_lvl_2.draw();
        select_lvl_3.draw();
        select_lvl_4.draw();
        select_lvl_5.draw();
        select_lvl_6.draw();
        select_lvl_7.draw();
        select_lvl_8.draw();
        select_lvl_back.draw();
        select_lvl_UGC.draw();
     }
     if(Menue.equals("level select UGC")){
       background(7646207);
       textSize(35*Scale);
       fill(0);
       textAlign(LEFT,BOTTOM);
        text("User Generated Levels",484*Scale,54*Scale);//menue title
        select_lvl_back.draw();
        UGC_open_folder.draw();
        levelcreatorLink.draw();
        fill(0);
        textSize(50*Scale);
        textAlign(CENTER,CENTER);
        if(UGCNames.size()==0){
         text("no levels found",width/2,height/2); 
        }else{
          text(UGCNames.get(UGC_lvl_indx),width/2,height/2);
          if((boolean)compatibles.get(UGC_lvl_indx)){
           text("this level is not compatible with this version of the game",width/2,height/2+height*0.1); 
          }
          if(UGC_lvl_indx<UGCNames.size()-1){
          UGC_lvls_next.draw();
          }
          if(UGC_lvl_indx>0){
          UGC_lvls_prev.draw();
          }
          UGC_lvl_play.draw();
        }
     }
     if(Menue.equals("pause")){//when in the pause emnue cancle all motion
       player1_moving_right=false;
       player1_moving_left=false;
       player1_jumping=false;
     }
     
     
     if(Menue.equals("settings")){//the settings menue
       fill(0);
       textAlign(LEFT,BOTTOM);
       background(7646207); 
       textAlign(CENTER,BOTTOM);
       textSize(100*Scale);
       text("Settings",width/2,height);
       
       textAlign(LEFT,BOTTOM);
       textSize(40*Scale);//explaination text
       
       if(settingsMenue.equals("game play")){
         fill(0);
        text("horozontal screen scrolling location",40*Scale,90*Scale);
        text("vertical  screen scrolling location",40*Scale,160*Scale);
        text((int)(((esdPos-800.0)/440)*530)+100,700*Scale,90*Scale);
        text((int)(((vesdPos-800.0)/440)*250)+100,700*Scale,160*Scale);
        
           sdSlider.draw();
           fill(255);
           rect(esdPos*Scale,42*Scale,10*Scale,45*Scale);//horizontal scrole distance slider bar
           vsdSlider.draw();
           fill(255);
           rect(vesdPos*Scale,112*Scale,10*Scale,45*Scale);//verticle scrole distance slider bar
         
         textSize(50*Scale);
         textAlign(CENTER,TOP);
         fill(0);
         text("game play",width/2,-10*Scale);
       }//end of gameplay settings
       
       if(settingsMenue.equals("display")){
         fill(0);
        text("verticle screen resolution (requires restart)",40*Scale,80*Scale);
        text("full screen (requires restart)",40*Scale,140*Scale);
        textSize(20*Scale);
        text("2160(4K)",1190*Scale,45*Scale);
        text("1440",1120*Scale,45*Scale);
        text("1080",1055*Scale,45*Scale);
        text("900",990*Scale,45*Scale);
        text("720",920*Scale,45*Scale);
        text("yes",1190*Scale,115*Scale);
        text("no",1120*Scale,115*Scale);
        rez720.draw();
        rez900.draw();
        rez1080.draw();
        rez1440.draw();
        rez4k.draw();
        fullScreenOn.draw();
        fullScreenOff.draw();
        
        textSize(50*Scale);
         textAlign(CENTER,TOP);
         fill(0);
         text("display",width/2,-10*Scale);
       }//end of display settings
       
       if(settingsMenue.equals("outher")){
         fill(0);
        text("display fps",40*Scale,70*Scale);
        text("display debug info",40*Scale,140*Scale);
        text("music volume",40*Scale,210*Scale);
        text((int)((int)(musicVolume*100)),700*Scale,215*Scale);
        text("sounds volume",40*Scale,280*Scale);
        text((int)(sfxVolume*100),700*Scale,285*Scale);
        text("3D shaows",40*Scale,350*Scale);
        text("narration mode",40*Scale,460*Scale);
        
        textSize(20*Scale);
        text("yes",1190*Scale,45*Scale);
        text("no",1120*Scale,45*Scale);
        text("better",1190*Scale,460*Scale);
        text("please don't\ndemonetize\nme youtube",1070*Scale,460*Scale);
        
        enableFPS.draw();
        disableFPS.draw();
        enableDebug.draw();
        disableDebug.draw();
        MusicSlider.draw();
        SFXSlider.draw();
        shadowOn.draw();
        shadowOff.draw();
        narrationMode1.draw();
        narrationMode0.draw();
        
        fill(255);
        stroke(0);
        strokeWeight(Scale);
        rect(musVolSllid*Scale,182*Scale,10*Scale,45*Scale);//slider bar
        rect(sfxVolSllid*Scale,252*Scale,10*Scale,45*Scale);//slider bar
        strokeWeight(0);
        
        textSize(50*Scale);
         textAlign(CENTER,TOP);
         fill(0);
         text("outher",width/2,-10*Scale);
       }//end of outher settings
     
      //end of check boers and stuffs

     settings =loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
     
     strokeWeight(5*Scale);
     stroke(255,0,0);
     if(true){
       JSONObject rez=settings.getJSONObject(2);
       int vres = rez.getInt("v-res");
     //  String arat = rez.getString("aspect ratio");
       boolean fus = rez.getBoolean("full_Screen");
       
       
       if(settingsMenue.equals("display")){
       if(vres==720){
         chechMark(rez720.x+rez720.lengthX/2,rez720.y+rez720.lengthY/2);
       }
       if(vres==900){
         chechMark(rez900.x+rez900.lengthX/2,rez900.y+rez900.lengthY/2);
       }
       if(vres==1080){
         chechMark(rez1080.x+rez1080.lengthX/2,rez1080.y+rez1080.lengthY/2);
       }
       if(vres==1440){
         chechMark(rez1440.x+rez1440.lengthX/2,rez1440.y+rez1440.lengthY/2);
       }
       if(vres==2160){
         chechMark(rez4k.x+rez4k.lengthX/2,rez4k.y+rez4k.lengthY/2);
       }
       
       if(!fus){
         chechMark(fullScreenOff.x+fullScreenOff.lengthX/2,fullScreenOff.y+fullScreenOff.lengthY/2);
       }else{
         chechMark(fullScreenOn.x+fullScreenOn.lengthX/2,fullScreenOn.y+fullScreenOn.lengthY/2);
         
       }
       
       }//end of display settings checkmarks
       
       if(settingsMenue.equals("outher")){
       //enableFPS,disableFPS,enableDebug,disableDebug
       if(!displayFPS){
         chechMark(disableFPS.x+disableFPS.lengthX/2,disableFPS.y+disableFPS.lengthY/2);
       }else{
         chechMark(enableFPS.x+enableFPS.lengthX/2,enableFPS.y+enableFPS.lengthY/2);
       }
       if(!displayDebugInfo){
         chechMark(disableDebug.x+disableDebug.lengthX/2,disableDebug.y+disableDebug.lengthY/2);
       }else{
         chechMark(enableDebug.x+enableDebug.lengthX/2,enableDebug.y+enableDebug.lengthY/2);
       }
       
       if(!shadow3D){
         chechMark(shadowOff.x+shadowOff.lengthX/2,shadowOff.y+shadowOff.lengthY/2);
       }else{
         chechMark(shadowOn.x+shadowOn.lengthX/2,shadowOn.y+shadowOn.lengthY/2);
       }
       
       if(tutorialNarrationMode==0){
         chechMark(narrationMode0.x+narrationMode0.lengthX/2,narrationMode0.y+narrationMode0.lengthY/2);
       }else if(tutorialNarrationMode==1){
         chechMark(narrationMode1.x+narrationMode1.lengthX/2,narrationMode1.y+narrationMode1.lengthY/2);
       }
     }
     }//end of outher settings
     
     sttingsGPL.draw();
     settingsDSP.draw();
     settingsOUT.draw();
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
          if(level_complete&&!levelCompleteSoundPlayed){
            soundHandler.addToQueue(0);
            levelCompleteSoundPlayed=true;
          }
     
  }
  
  if(tutorialMode&&!inGame){
    if(Menue.equals("settings")){
      background(0);
   fill(255);
   textSize(50*Scale);
   textAlign(CENTER,CENTER);
   text("this feture is disabled during the tutorial\npres ECS to return",width/2,height/2);
    }else{
   background(0);
   fill(255);
   textSize(50*Scale);
   textAlign(CENTER,CENTER);
   text("ATTENTION\n\nThe folowing contains content language\nthat some may find disterbing.\nIf you don't like foul language,\nmake shure you setting are set accordingly.\n\nAudio in use turn your volume up!",width/2,height/2);
   textSize(25*Scale);
   text("press ESC to close",width/2,height*0.97);
    }
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
     if(death_cool_down>150){// respawn cool down
       dead=false;
       inGame=true;
       //if(respawnX < 400){
       // camPos=0; 
       //}else{
       //camPos=respawnX-400;
       //}
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
  text("player vertical velocity: "+ player1.verticalVelocity,1275*Scale,40*Scale);
  text("player animation Cooldown: "+ player1.animationCooldown,1275*Scale,50*Scale);
  text("player pose: "+ player1.pose,1275*Scale,60*Scale);
  text("camera x: "+camPos,1275*Scale,70*Scale);
  text("camera y: "+camPosY,1275*Scale,80*Scale);
  text("tutorial position: "+tutorialPos,1275*Scale,90*Scale);
}

if(millis()<gmillis){
    glitchEffect();
  }
  if(displayTextUntill>=millis()){
    fill(255);
  textSize(200*Scale);
  textAlign(CENTER, CENTER);
   text(displayText,width/2,height*0.2); 
  }

disEngageHUDPosition();


  }catch(Throwable e){//cath and display all the fatail errors that occor
            e.printStackTrace();
            StackTraceElement[] elements = e.getStackTrace();
            String stack="";
            for(int ele=0;ele<elements.length;ele++){
                stack+=elements[ele].toString()+"\n";
            }
            JOptionPane.showMessageDialog(null,stack,e.toString(),JOptionPane.ERROR_MESSAGE);
            exit();
        }
}




void mouseClicked(){// when you click the mouse

try{
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
         //how to play
           menue=false;
           tutorialMode=true;
           tutorialPos=0;
       }
       if(discord.isMouseOver()){
        link("http://discord.gg/C5SACF2"); 
       }
     }
    if(Menue.equals("level select")&&!start_host){//if that menue is level select
    int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
         if(select_lvl_1.isMouseOver()){
           loadLevel("data/levels/level-1");
           menue=false;
           inGame=true;
         }
         if(select_lvl_2.isMouseOver()&&progress>=2){
           loadLevel("data/levels/level-2");
           menue=false;
           inGame=true;
         }
         if(select_lvl_3.isMouseOver()&&progress>=3){
           loadLevel("data/levels/level-3");
           menue=false;
           inGame=true;
         }
         if(select_lvl_4.isMouseOver()&&progress>=4){
           loadLevel("data/levels/level-4");
           menue=false;
           inGame=true;
         }
         if(select_lvl_5.isMouseOver()&&progress>=5){
           loadLevel("data/levels/level-5");
           menue=false;
           inGame=true;
         }
         if(select_lvl_6.isMouseOver()&&progress>=6){
           loadLevel("data/levels/level-6");
           menue=false;
           inGame=true;
         }
         if(select_lvl_7.isMouseOver()&&progress>=7){
           loadLevel("data/levels/level-7");
           menue=false;
           inGame=true;
         }
         if(select_lvl_8.isMouseOver()&&progress>=8){
           loadLevel("data/levels/level-8");
           menue=false;
           inGame=true;
         }
         
         if(select_lvl_back.isMouseOver()){
           Menue="main";
         }
         if(select_lvl_UGC.isMouseOver()){
           Menue="level select UGC";
           new File(System.getenv("AppData")+"/CBi-games/skinny mann/UGC/levels").mkdirs();
           String[] files=new File(System.getenv("AppData")+"/CBi-games/skinny mann/UGC/levels").list();
           
           compatibles=new ArrayList<>();
           UGCNames=new ArrayList<>();
           try{
           if(files.length==0)
           return;
           }catch(NullPointerException e){
             return;
           }
           for(int i=0;i<files.length;i++){
            if(FileIsLevel(files[i])){
              UGCNames.add(files[i]);
              if(levelCompatible){
                compatibles.add(false);
              }else{
                compatibles.add(true);
              }
              
            }
           }
           UGC_lvl_indx=0;
           return;
         }
         
         
         return;
     }
     if(Menue.equals("level select UGC")){
       if(select_lvl_back.isMouseOver()){
           Menue="level select";
         }
         if(UGC_open_folder.isMouseOver()){
           openUGCFolder();
         }
         
         if(UGCNames.size()==0){
        }else{
          if(UGC_lvl_indx<UGCNames.size()-1){
            if(UGC_lvls_next.isMouseOver()){
              UGC_lvl_indx++;
            }  
          }
          if(UGC_lvl_indx>0){
            if(UGC_lvls_prev.isMouseOver()){
              UGC_lvl_indx--;
            }
          }
          if(UGC_lvl_play.isMouseOver()){
            loadLevel(System.getenv("AppData")+"/CBi-games/skinny mann/UGC/levels/"+UGCNames.get(UGC_lvl_indx));
            if(!levelCompatible){
              Menue="level select";
              return;
            }
            UGC_lvl=true;
            inGame=true;
            menue=false;
          }
          
          
        }
        if(levelcreatorLink.isMouseOver()){
            link("https://cbi-games.glitch.me/level%20creator.html");
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
         tutorialMode=false;
         Menue="level select";
         soundHandler.setMusicVolume(musicVolume);
         coinCount=0;
       }
       
     }
     
     if(Menue.equals("settings")){     //if that menue is settings
    
       if(settingsMenue.equals("game play")){
       
       if(sdSlider.isMouseOver()){
         esdPos=(int)(mouseX/Scale);
         if(esdPos<800){
           esdPos=800;
         }
         if(esdPos>1240){
           esdPos=1240;
         }
         eadgeScroleDist=(int)(((esdPos-800.0)/440)*530)+100;
         JSONObject scroll=settings.getJSONObject(1);
         scroll.setInt("horozontal",(int)(((esdPos-800.0)/440)*530)+100);
         settings.setJSONObject(1,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(vsdSlider.isMouseOver()){
         vesdPos=(int)(mouseX/Scale);
         if(vesdPos<800){
           vesdPos=800;
         }
         if(vesdPos>1240){
           vesdPos=1240;
         }
         eadgeScroleDistV=(int)(((vesdPos-800.0)/440)*250)+100;
         JSONObject scroll=settings.getJSONObject(1);
         scroll.setInt("vertical",(int)(((vesdPos-800.0)/440)*250)+100);
         settings.setJSONObject(1,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       }//end of game play settings
       
       if(settingsMenue.equals("display")){
       JSONObject rez=settings.getJSONObject(2);
       String arat = "16:9";
       if(rez4k.isMouseOver()){//2160 resolution button
           rez.setInt("v-res",2160);
           if(arat.equals("16:9")){
             rez.setInt("h-res",2160*16/9);
           }
          rez.setFloat("scale",2160/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(rez1440.isMouseOver()){// 1440 resolition button
           rez.setInt("v-res",1440);
           if(arat.equals("16:9")){
             rez.setInt("h-res",1440*16/9);
           }
          rez.setFloat("scale",1440/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(rez1080.isMouseOver()){// 1080 resolution button
           rez.setInt("v-res",1080);
           if(arat.equals("16:9")){
             rez.setInt("h-res",1080*16/9);
           }
          rez.setFloat("scale",1080/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(rez900.isMouseOver()){////900 resolution button
           rez.setInt("v-res",900);
           if(arat.equals("16:9")){
             rez.setInt("h-res",900*16/9);
           }
          rez.setFloat("scale",900/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(rez720.isMouseOver()){// 720 resolution button
           rez.setInt("v-res",720);
           if(arat.equals("16:9")){
             rez.setInt("h-res",720*16/9);
           }
          rez.setFloat("scale",720/720.0);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       
       if(fullScreenOn.isMouseOver()){//turn full screen on button
           rez.setBoolean("full_Screen",true);
           
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(fullScreenOff.isMouseOver()){//turn fullscreen off button
           rez.setBoolean("full_Screen",false);
          
          settings.setJSONObject(2,rez);
          saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       }//end of display settings menue
       
       if(settingsMenue.equals("outher")){
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
       
       if(MusicSlider.isMouseOver()){
         musVolSllid=(int)(mouseX/Scale);
         if(musVolSllid<800){
           musVolSllid=800;
         }
         if(musVolSllid>1240){
           musVolSllid=1240;
         }
         musicVolume=(musVolSllid-800.0)/440;
         JSONObject scroll=settings.getJSONObject(4);
         scroll.setFloat("music volume",(musVolSllid-800.0)/440);
         settings.setJSONObject(4,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
         soundHandler.setMusicVolume(musicVolume);
       } 
       if(SFXSlider.isMouseOver()){
         sfxVolSllid=(int)(mouseX/Scale);
         if(sfxVolSllid<800){
           sfxVolSllid=800;
         }
         if(sfxVolSllid>1240){
           sfxVolSllid=1240;
         }
         sfxVolume=(sfxVolSllid-800.0)/440;
         JSONObject scroll=settings.getJSONObject(4);
         scroll.setFloat("SFX volume",(sfxVolSllid-800.0)/440);
         settings.setJSONObject(4,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
         soundHandler.setSoundsVolume(sfxVolume);
       }
       
       if(shadowOn.isMouseOver()){
         JSONObject sv3=settings.getJSONObject(5);
          sv3.setBoolean("3D shaows",true);
           shadow3D=true;
           settings.setJSONObject(5,sv3);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
      if(shadowOff.isMouseOver()){
         JSONObject sv3=settings.getJSONObject(5);
          sv3.setBoolean("3D shaows",false);
           shadow3D=false;
           settings.setJSONObject(5,sv3);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
      if(narrationMode0.isMouseOver()){
         JSONObject sv3=settings.getJSONObject(5);
          sv3.setInt("narrationMode",0);
           tutorialNarrationMode=0;
           settings.setJSONObject(5,sv3);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
      if(narrationMode1.isMouseOver()){
         JSONObject sv3=settings.getJSONObject(5);
          sv3.setInt("narrationMode",1);
           tutorialNarrationMode=1;
           settings.setJSONObject(5,sv3);
           saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
      }
       
       }//end of outher settings menue
       
       if(sttingsGPL.isMouseOver())
       settingsMenue="game play";
     if(settingsDSP.isMouseOver())
     settingsMenue="display";
     if(settingsOUT.isMouseOver())
     settingsMenue="outher";
       
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
           coinCount=0;
           if(!UGC_lvl){
           JSONObject lvlinfo=mainIndex.getJSONObject(0);
             if(lvlinfo.getInt("level_id")>levelProgress.getJSONObject(0).getInt("progress")){
               JSONObject p=new JSONObject();
               p.setInt("progress",levelProgress.getJSONObject(0).getInt("progress")+1);
               levelProgress.setJSONObject(0,p);
               saveJSONArray(levelProgress,System.getenv("AppData")+"/CBi-games/skinny mann/progressions.json");
             }
           }else{
             UGC_lvl=false;
           }
         }
      }
    
  }catch(Throwable e){
            e.printStackTrace();
            StackTraceElement[] elements = e.getStackTrace();
            String stack="";
            for(int ele=0;ele<elements.length;ele++){
                stack+=elements[ele].toString()+"\n";
            }
            JOptionPane.showMessageDialog(null,stack,e.toString(),JOptionPane.ERROR_MESSAGE);
            exit();
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
  if(Menue.equals("level select UGC")){
    if (key == ESC) {
    key = 0;  //clear the key so it doesnt close the program
    Menue="level select";
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
    if(settingsMenue.equals("game play")){
     if(sdSlider.isMouseOver()){
         esdPos=(int)(mouseX/Scale);
         if(esdPos<800){
           esdPos=800;
         }
         if(esdPos>1240){
           esdPos=1240;
         }
         eadgeScroleDist=(int)(((esdPos-800.0)/440)*530)+100;
         JSONObject scroll=settings.getJSONObject(1);
         scroll.setInt("horozontal",(int)(((esdPos-800.0)/440)*530)+100);
         settings.setJSONObject(1,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       }
       
       if(vsdSlider.isMouseOver()){
         vesdPos=(int)(mouseX/Scale);
         if(vesdPos<800){
           vesdPos=800;
         }
         if(vesdPos>1240){
           vesdPos=1240;
         }
         eadgeScroleDistV=(int)(((vesdPos-800.0)/440)*250)+100;
         JSONObject scroll=settings.getJSONObject(1);
         scroll.setInt("vertical",(int)(((vesdPos-800.0)/440)*250)+100);
         settings.setJSONObject(1,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
       } 
    }
    if(settingsMenue.equals("outher")){
      if(MusicSlider.isMouseOver()){
         musVolSllid=(int)(mouseX/Scale);
         if(musVolSllid<800){
           musVolSllid=800;
         }
         if(musVolSllid>1240){
           musVolSllid=1240;
         }
         musicVolume=(musVolSllid-800.0)/440;
         JSONObject scroll=settings.getJSONObject(4);
         scroll.setFloat("music volume",(musVolSllid-800.0)/440);
         settings.setJSONObject(4,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
         soundHandler.setMusicVolume(musicVolume);
       } 
       if(SFXSlider.isMouseOver()){
         sfxVolSllid=(int)(mouseX/Scale);
         if(sfxVolSllid<800){
           sfxVolSllid=800;
         }
         if(sfxVolSllid>1240){
           sfxVolSllid=1240;
         }
         sfxVolume=(sfxVolSllid-800.0)/440;
         JSONObject scroll=settings.getJSONObject(4);
         scroll.setFloat("SFX volume",(sfxVolSllid-800.0)/440);
         settings.setJSONObject(4,scroll);
         saveJSONArray(settings, System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
         soundHandler.setSoundsVolume(sfxVolume);
       } 
    }
  }
}

void loadLevel(String fdp){
 rootPath=fdp;
 mainIndex=loadJSONArray(rootPath+"/index.json");
 level=new Level(mainIndex);
}

int curMills=0,lasMills=0,mspc=0;

void thrdCalc2(){

  while(loopThread2){
 curMills=millis(); 
 mspc=curMills-lasMills;
 if(tutorialMode){
      tutorialLogic();
     }
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
   //soundHandler.setMusicVolume(musicVolume);
   //soundHandler.setSoundsVolume(sfxVolume);
   soundHandler.tick();
  }
}

void generateSettings(){
  showSettingsAfterStart=true;
 settings=new JSONArray(); 
 JSONObject scrolling = new JSONObject(),rez=new JSONObject(),header=new JSONObject(),debug=new JSONObject(),sound=new JSONObject(),sv3=new JSONObject();
    header.setInt("settings version",3);
    settings.setJSONObject(0,header);
 
    scrolling.setString("lable", "scroling location");
    scrolling.setFloat("horozontal", 360);
    scrolling.setFloat("vertical",250);
    settings.setJSONObject(1,scrolling);
          
    rez.setString("lable","resolution stuff");
    rez.setInt("v-res",720);     
    rez.setInt("h-res",720*16/9);
    rez.setFloat("scale",1);
    rez.setBoolean("full_Screen",false);
    rez.setInt("full_Screen_diplay",1);
    settings.setJSONObject(2,rez);
    
    debug.setBoolean("fps",true);
    debug.setString("lable","debig stuffs");
    debug.setBoolean("debug info",false);
    settings.setJSONObject(3,debug);
    
    sound.setFloat("music volume",1);
    sound.setFloat("SFX volume",1);
    sound.setString("lable","music and sound volume");
    settings.setJSONObject(4,sound);
    
    sv3.setBoolean("3D shaows",true);
    sv3.setInt("narrationMode",0);
    settings.setJSONObject(5,sv3);
          
    saveJSONArray(settings,System.getenv("AppData")+"/CBi-games/skinny mann/settings.json");
}

void chechMark(float x,float y){
  line(x-15*Scale,y,x,y+15*Scale);
  line(x+25*Scale,y-15*Scale,x,y+15*Scale);
}

void tutorialLogic(){
  if(tutorialPos==0){
    soundHandler.setMusicVolume(0.01);
    currentTutorialSound=0;
    tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
    tutorialPos++;
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
  }
  if(tutorialPos==1){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      currentTutorialSound=1;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==2){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      loadLevel("/data/levels/tutorial");
      inGame=true;
      tutorialDrawLimit=3;
      currentTutorialSound=2;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==3){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      currentTutorialSound=3;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==4){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      currentTutorialSound=4;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==5){
    player1_moving_left=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      currentTutorialSound=5;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==6){
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      currentTutorialSound=6;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==7){
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
    }
  }
  if(tutorialPos==8){
    player1_jumping=false;
    if(player1.x>=1604){
      currentTutorialSound=7;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
      tutorialDrawLimit=14;
    }
  }
  if(tutorialPos==9){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
    }
  }
  if(tutorialPos==10){
    player1_jumping=false;
    if(dead){
      currentTutorialSound=8;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==11){
    if(player1.x>=1819){
      currentTutorialSound=9;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==12){
    if(player1.x>=3875){
      currentTutorialSound=10;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==13){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
      tutorialDrawLimit=28;
    }
  }
  
  if(tutorialPos==14){
    if(player1.x>=5338){
      currentTutorialSound=11;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==15){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
    }
  }
  
  if(tutorialPos==16){
    if(coinCount>=10){
      currentTutorialSound=12;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
    }
  }
  if(tutorialPos==17){
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      currentTutorialSound=13;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
      tutorialPos++;
      coinCount=0;
    }
  }
  if(tutorialPos==18){
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
      tutorialDrawLimit=51;
    }
  }
  if(tutorialPos==19){
    if(player1.x>=7315){
      tutorialPos++;
      currentTutorialSound=14;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
    }
  }
  if(tutorialPos==20){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
      tutorialDrawLimit=600;
    }
  }
  if(tutorialPos==21){
    if(currentStageIndex==1){
      tutorialPos++;
      currentTutorialSound=15;
      tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
    }
  }
  if(tutorialPos==22){
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      tutorialPos++;
    }
  }
  if(tutorialPos==23){
    if(player1.x>=6739){
      tutorialPos++;
      currentTutorialSound=16;
     tutorialNarration[tutorialNarrationMode][currentTutorialSound].play();
    }
  }
  
  if(tutorialPos==24){
    player1_moving_left=false;
    player1_moving_right=false;
    player1_jumping=false;
    if(!tutorialNarration[tutorialNarrationMode][currentTutorialSound].isPlaying()){
      soundHandler.setMusicVolume(musicVolume);
      tutorialMode=false;
    }
  }
}

void openUGCFolder(){
         Desktop desktop = Desktop.getDesktop();
        File dirToOpen = null;
        try {
            dirToOpen = new File(System.getenv("AppData")+"/CBi-games/skinny mann/UGC/levels");
            desktop.open(dirToOpen);
        } catch (Throwable iae) {
            System.out.println("folder Not Found, creating folder");
            new File(System.getenv("AppData")+"/CBi-games/skinny mann/UGC/levels").mkdirs();
            openUGCFolder();
        }
}

boolean FileIsLevel(String fil){
  try{
    JSONObject job =loadJSONArray(System.getenv("AppData")+"/CBi-games/skinny mann/UGC/levels/"+fil+"/index.json").getJSONObject(0);
    String createdVersion=job.getString("game version");
    if(gameVersionCompatibilityCheck(createdVersion)){
     levelCompatible=true; 
    }else{
     levelCompatible=false; 
    }
  }catch(Throwable e){
    return false;
  }
  return true;
}

boolean gameVersionCompatibilityCheck(String vers){//returns ture if the inputed version id compatible
for(int i=0;i<compatibleVersions.length;i++){
  if(vers.equals(compatibleVersions[i])){
    levelCompatible=true;
   return true; 
  }
}
levelCompatible=false;
 return false; 
}
void drawSoundBox(float x,float y){
}
void engageHUDPosition() {
  //translate(player1.x+DX,player1.y-DY,player1.z-DZ);
  //rotateY(radians(-(xangle-180)));
  //rotateX(radians(yangle));
  //translate(-640,-360,-623);
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
}

void disEngageHUDPosition() {
  //translate(640,360,623);
  //rotateX(radians(-yangle));
  //rotateY(radians((xangle-180)));
  //translate(-1*(player1.x+DX),-1*(player1.y-DY),-1*(player1.z-DZ));
  hint(ENABLE_DEPTH_TEST);
}

void glitchEffect() {
  int n=millis()/100%10;
  //n=9;
  strokeWeight(0);
  if (n==0) {
    fill(0, 255, 0, 120);
    rect(12*Scale, 30*Scale, 200*Scale, 80*Scale);
    rect(800*Scale, 300*Scale, 100*Scale, 300*Scale);
    rect(400*Scale, 240*Scale, 500*Scale, 20*Scale);
    fill(124, 0, 250, 120);
    rect(620*Scale, 530*Scale, 240*Scale, 50*Scale);
    rect(100*Scale, 400*Scale, 300*Scale, 40*Scale);
    rect(50*Scale, 600*Scale, 550*Scale, 20*Scale);
    fill(115, 0, 58, 120);
    rect(720*Scale, 90*Scale, 360*Scale, 112*Scale);
    rect(150*Scale, 619*Scale, 203*Scale, 90*Scale);
    rect(526*Scale, 306*Scale, 266*Scale, 165*Scale);
  }
  if (n==1) {
    fill(0, 255, 0, 120);
    rect(925*Scale, 60*Scale, 89*Scale, 96*Scale);
    rect(305*Scale, 522*Scale, 84*Scale, 140*Scale);
    rect(13*Scale, 332*Scale, 234*Scale, 313*Scale);
    fill(124, 0, 250, 120);
    rect(716*Scale, 527*Scale, 317*Scale, 111*Scale);
    rect(318*Scale, 539*Scale, 233*Scale, 118*Scale);
    rect(902*Scale, 3*Scale, 255*Scale, 42*Scale);
    fill(115, 0, 58, 120);
    rect(163*Scale, 150*Scale, 221*Scale, 127*Scale);
    rect(216*Scale, 142*Scale, 7*Scale, 49*Scale);
    rect(538*Scale, 224*Scale, 41*Scale, 48*Scale);
  }
  if (n==2) {
    fill(0, 255, 0, 120);
    rect(410*Scale, 335*Scale, 94*Scale, 74*Scale);
    rect(45*Scale, 222*Scale, 276*Scale, 90*Scale);
    rect(871*Scale, 287*Scale, 268*Scale, 174*Scale);
    fill(124, 0, 250, 120);
    rect(996*Scale, 535*Scale, 18*Scale, 28*Scale);
    rect(722*Scale, 523*Scale, 82*Scale, 107*Scale);
    rect(263*Scale, 201*Scale, 161*Scale, 88*Scale);
    fill(115, 0, 58, 120);
    rect(697*Scale, 436*Scale, 165*Scale, 44*Scale);
    rect(843*Scale, 486*Scale, 98*Scale, 105*Scale);
    rect(755*Scale, 20*Scale, 151*Scale, 51*Scale);
  }
  if (n==3) {
    fill(0, 255, 0, 120);
    rect(5*Scale, 228*Scale, 226*Scale, 131*Scale);
    rect(813*Scale, 428*Scale, 83*Scale, 60*Scale);
    rect(285*Scale, 452*Scale, 166*Scale, 135*Scale);
    fill(124, 0, 250, 120);
    rect(277*Scale, 514*Scale, 11*Scale, 87*Scale);
    rect(905*Scale, 152*Scale, 8*Scale, 160*Scale);
    rect(369*Scale, 80*Scale, 279*Scale, 153*Scale);
    fill(115, 0, 58, 120);
    rect(179*Scale, 96*Scale, 159*Scale, 65*Scale);
    rect(432*Scale, 296*Scale, 47*Scale, 12*Scale);
    rect(944*Scale, 412*Scale, 22*Scale, 50*Scale);
  }
  if (n==4) {
    fill(0, 255, 0, 120);
    rect(679*Scale, 159*Scale, 76*Scale, 168*Scale);
    rect(144*Scale, 58*Scale, 180*Scale, 61*Scale);
    rect(950*Scale, 89*Scale, 155*Scale, 13*Scale);
    fill(124, 0, 250, 120);
    rect(542*Scale, 463*Scale, 177*Scale, 156*Scale);
    rect(527*Scale, 70*Scale, 115*Scale, 28*Scale);
    rect(211*Scale, 151*Scale, 58*Scale, 164*Scale);
    fill(115, 0, 58, 120);
    rect(88*Scale, 440*Scale, 278*Scale, 23*Scale);
    rect(642*Scale, 440*Scale, 231*Scale, 91*Scale);
    rect(737*Scale, 524*Scale, 69*Scale, 71*Scale);
  }
  if (n==5) {
    fill(0, 255, 0, 120);
    rect(226*Scale, 71*Scale, 291*Scale, 37*Scale);
    rect(91*Scale, 436*Scale, 210*Scale, 8*Scale);
    rect(396*Scale, 72*Scale, 10*Scale, 136*Scale);
    fill(124, 0, 250, 120);
    rect(666*Scale, 274*Scale, 175*Scale, 171*Scale);
    rect(251*Scale, 513*Scale, 280*Scale, 13*Scale);
    rect(663*Scale, 141*Scale, 290*Scale, 33*Scale);
    fill(115, 0, 58, 120);
    rect(900*Scale, 47*Scale, 315*Scale, 125*Scale);
    rect(10*Scale, 156*Scale, 231*Scale, 73*Scale);
    rect(377*Scale, 253*Scale, 175*Scale, 22*Scale);
  }
  if (n==6) {
    fill(0, 255, 0, 120);
    rect(756*Scale, 447*Scale, 205*Scale, 161*Scale);
    rect(304*Scale, 341*Scale, 276*Scale, 144*Scale);
    rect(4*Scale, 141*Scale, 35*Scale, 176*Scale);
    fill(124, 0, 250, 120);
    rect(307*Scale, 98*Scale, 204*Scale, 89*Scale);
    rect(478*Scale, 476*Scale, 44*Scale, 52*Scale);
    rect(620*Scale, 57*Scale, 242*Scale, 144*Scale);
    fill(115, 0, 58, 120);
    rect(495*Scale, 374*Scale, 199*Scale, 62*Scale);
    rect(724*Scale, 71*Scale, 34*Scale, 2*Scale);
    rect(853*Scale, 88*Scale, 199*Scale, 114*Scale);
  }
  if (n==7) {
    fill(0, 255, 0, 120);
    rect(276*Scale, 181*Scale, 220*Scale, 38*Scale);
    rect(955*Scale, 514*Scale, 33*Scale, 51*Scale);
    rect(621*Scale, 135*Scale, 100*Scale, 74*Scale);
    fill(124, 0, 250, 120);
    rect(200*Scale, 333*Scale, 165*Scale, 99*Scale);
    rect(709*Scale, 503*Scale, 84*Scale, 117*Scale);
    rect(212*Scale, 275*Scale, 238*Scale, 27*Scale);
    fill(115, 0, 58, 120);
    rect(787*Scale, 477*Scale, 115*Scale, 9*Scale);
    rect(239*Scale, 443*Scale, 155*Scale, 149*Scale);
    rect(794*Scale, 267*Scale, 185*Scale, 80*Scale);
  }
  if (n==8) {
    fill(0, 255, 0, 120);
    rect(543*Scale, 498*Scale, 22*Scale, 125*Scale);
    rect(749*Scale, 151*Scale, 79*Scale, 174*Scale);
    rect(667*Scale, 380*Scale, 311*Scale, 45*Scale);
    fill(124, 0, 250, 120);
    rect(886*Scale, 193*Scale, 87*Scale, 50*Scale);
    rect(135*Scale, 128*Scale, 151*Scale, 83*Scale);
    rect(651*Scale, 128*Scale, 20*Scale, 85*Scale);
    fill(115, 0, 58, 120);
    rect(862*Scale, 374*Scale, 319*Scale, 136*Scale);
    rect(258*Scale, 149*Scale, 65*Scale, 143*Scale);
    rect(299*Scale, 63*Scale, 297*Scale, 152*Scale);
  }
  if (n==9) {
    fill(0, 255, 0, 120);
    rect(953*Scale, 386*Scale, 11*Scale, 30*Scale);
    rect(453*Scale, 104*Scale, 50*Scale, 95*Scale);
    rect(71*Scale, 157*Scale, 23*Scale, 49*Scale);
    fill(124, 0, 250, 120);
    rect(373*Scale, 447*Scale, 28*Scale, 136*Scale);
    rect(598*Scale, 321*Scale, 227*Scale, 19*Scale);
    rect(500*Scale, 314*Scale, 218*Scale, 113*Scale);
    fill(115, 0, 58, 120);
    rect(423*Scale, 512*Scale, 295*Scale, 30*Scale);
    rect(186*Scale, 489*Scale, 208*Scale, 76*Scale);
    rect(178*Scale, 269*Scale, 117*Scale, 133*Scale);
  }
}
