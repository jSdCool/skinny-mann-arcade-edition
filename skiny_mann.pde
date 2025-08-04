import processing.sound.*;//import the stuffs
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.Socket;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.awt.Desktop;
import javax.swing.*;
import java.util.function.Function;
import net.java.games.input.*;
import net.java.games.util.plugins.*;
import net.java.games.util.*;


/**First method called during initilization.<br>
Used to initilize the most basic of things before the window is created.
*/
void settings() {//first function called
  //setup the univertal error handler
  UniversalErrorManager.init(this);
  //if on winodws
  if (platform==WINDOWS) {
    appdata=System.getenv("AppData");//set the appadata path to the users appdata directory
  } else {
    appdata=System.getenv("HOME");//set the appdata path to the current users home directory
  }
  try {
    println("attempting to load settings");
    //load settings
    settings = new Settings(appdata+"/CBi-games/skinny mann/settings.json");
    
    if (!settings.getFullScreen()) {//check for fullscreeen
      //set the window size to what is congfigured in settings
      size(settings.getResolutionHorozontal(), settings.getResolutionVertical(), P3D);
    } else {
      //create a fullscreen window on the requested display, note the displays start at index 1, index 0 will streach across all displays
      fullScreen(P3D, settings.getFullScreenScreen());
    }
    println("loading window icon");
    //smet the window icon / task bar icon, why does this not wotk on lunix?
    PJOGL.setIcon("data/assets/skinny mann face.PNG");
    //give a fair ammount of classes a static refence to this class, note: WE NEED TO REMOVE THIS!
    sourceInitilize();
  }catch(Throwable e) {
    println("an error orrored in the settings function");
    handleError(e);
  }
}//after this setup will be called after more initilization happens like creating the window surface 


/**Second function called during initialization.<br>
Used as the primary place to load and initilize things and spawn threads to load / initilize things, after the window has been created.
*/
void setup() {//seccond function called
  try {
    frameRate(60);//set the FPS limit, note set this to a lerger number to get higher frame rates
    background(0);
    if (settings.getFullScreen()) {
      Scale=height/720.0;//if in fullscreen calculate the scale
    }else{
      Scale = settings.getScale();//if not in fullscreen then load the scale from settings
    }
    //cretae the Ui frame
    ui=new UiFrame(this, 1280, 720);
    
    println(height+" "+Scale);//debung info
    println("loading texture for start screen");
    CBi = loadImage("data/assets/CBi.png");//load the CBi logo

    //load the font at a size of 500 so that normal sized fronts dont look like 3 pixles
    textSize(100*Scale);//500
    println("initilizing buttons");
    //initilize all buttons and text
    initButtons();
    initText();

    //initilize variables re;ated to the 3D sphere in the startup logo
    ptsW=100;
    ptsH=100;
    println("initilizing CBi sphere");
    //genrate the verticies coordintaes for the 3D sphere
    initializeSphere(ptsW, ptsH);
    //generate the PSahoe for the sphere and apply the texture to it
    textureSphere(200, 200, 200, CBi);

    //start the load thread
    thread("programLoad");
	
	//load the leaderboards
    leaderBoards = new ArcadeLeaderBoard(arcadeLeaderBoardFilePath,this);
    println("leaderBoards:\n"+leaderBoards);

  }
  catch(Throwable e) {
    println("an error occored in the setup function");
    handleError(e);
  }

}//after this normal program execution begins with draw being called for every frame
//define a shit tone of varibles

PApplet primaryWindow=this;

Player players[] =new Player[10];
ArrayList<Client> clients= new ArrayList<>();


//int

//button





















//▄

//definitiion of the default camera function
//camera() = camera(defCameraX, defCameraY, defCameraZ,    defCameraX, defCameraY, 0,    0, 1, 0);
//defCameraX = width/2;
//defCameraY = height/2;
//defCameraFOV = 60 * DEG_TO_RAD;
//defCameraZ = defCameraY / ((float) Math.tan(defCameraFOV / 2.0f));
/**The primary render Loop,<br>
This function is automatically called once every frame to record data to the render command buffer. Aything visual happend in this funtion.
*/
void draw() {// the function that is called every frame
  //cursor blinking things, perhas this should be changed 
  if (frameCount%20==0) {
    cursor="|";
    coursorr="|";
    coursor=true;
  }
  if (frameCount%40==0) {
    cursor="";
    coursorr="";
    coursor=false;
  }
  
  //if  the depth buffer bas been requested to be initilized (usually from the load thread)
  if(requestDepthBufferInit){
    requestDepthBufferInit=false;//set the varaible back to false
    initDepthBuffer();//initilize the depth buffer (this is what causes the game to freez on startup, it must be done on a thread with an opengl context)
    skipFrameInumeration = true;//for startup logo animarion purpuses dont advance the animation for a frame becaus if extream lag
  }
  

  try {//catch all fatal errors and display them

    if (saveColors) {//if saved colors should be saved
      saveJSONArray(colors, appdata+"/CBi-games/skinny mann level creator/colors.json");//save the saved colors
      saveColors=false;
    }

    if (!levelCreator) {//if not in the level creator
      if (transitioningMenu) {//if a menu transition is currently in progress
        menuTransition();//process the menu transistion 
      }

      if (menue) {//when in a menue
        if (Menue.equals("creds")) {//the inital loading screen
          background(0);
          noStroke();

          drawlogo(true, true);//draw the 3D sphere 

          if (start_wate>=2&&loaded) {// wait for the animation to complete and loading to finish before continuing to the game 
            soundHandler.startSounds();//start the sound engine
            if (dev_mode) {//if dev mode is on
              Menue="dev";//set the menu to the dev menu 
              println("dev mode activated");
              return;//dont conitnue to process anything else in this frame 
            }

            try {
              String inver = readFileFromGithub("https://raw.githubusercontent.com/jSdCool/CBI-games-version-checker/master/skinny_mann.txt");//check for updates  inver = internet version

              inver =inver.substring(0, inver.length()-1);//remove the last char from the string (its a new line)
              internetVersion=inver;//not sure why this is here
              if (false) {//if an update exists, in the arcade edition we do not care about this so just ignoore it
                Menue="update";//go to update menu
              } else {//if no update exists go to main menu
                if (settings.getSettingsAfterStart()) {//if no settings file exsisted or was the wrong version,
                  //start the treansition to the settings menu
                  menue=false;
                  Menue="settings";
                  initMenuTransition(Transitions.LOGO_TO_SETTINGS);
                  return;
                } else {
                  //start the transition to the main menu
                  menue=false;
                  Menue="main";
                  initMenuTransition(Transitions.LOGO_TO_MAIN);
                  return;
                }
              }
            }
            catch(Throwable e) {//if an error occors or no return then go to main menue
              println(e);//print to console the cause of the error
              if (settings.getSettingsAfterStart()) {//if no settings file exsisted or was the wrong version,
                //start the treansition to the settings menu
                menue=false;
                Menue="settings";
                initMenuTransition(Transitions.LOGO_TO_SETTINGS);
                return;
              } else {
                //start the transition to the main menu
                menue=false;
                Menue="main";
                initMenuTransition(Transitions.LOGO_TO_MAIN);
                return;
              }
            }
          }
        }

        if (Menue.equals("update")) {//if there is an update draw the update screen
          draw_updae_screen();
        }
        if (Menue.equals("downloading update")) {//if on the dwnloading update the draw the downloading update screen
          drawUpdateDownloadingScreen();
        }

        if (Menue.equals("main")) {//if on main menue
          hint(DISABLE_KEY_REPEAT);
          drawMainMenu(true);//draw the main menu
        }
        if (Menue.equals("level select")) {//if selecting level
          drawLevelSelect(true,0);//draw the level select screen
        }
        if (Menue.equals("level select UGC")) {//if on the UGC menu
          drawLevelSelectUGC();//draw the UGC menu
        }
        if(Menue.equals("level select 2")){//if on the second level selct menu
         drawLevelSelect2(true); //draw the second level selcet menu
        }
        if (Menue.equals("pause")) {//when in the pause menu cancel all motion
          player1_moving_right=false;
          player1_moving_left=false;
          player1_jumping=false;
          playerMovementManager.reset();
        }


        if (Menue.equals("settings")) {//the settings menue
          hint(ENABLE_KEY_REPEAT);//allow key repeat for the text box
          drawSettings();
        }

        //very old and not used but still exsist here anyway
        if (Menue.equals("how to play")) {//how to play menue
          background(#4FCEAF);
          fill(0);
          textAlign(LEFT, TOP);
          textSize(60*Scale);
          text("press 'A' or 'D' to move left or right \npress SPACE to jump\npress 'ESC' to pause the game\ngoal: get the the finishline at the \nend of the level", 100*Scale, 100*Scale);//the explaination
          fill(255, 25, 0);
          stroke(255, 249, 0);
          strokeWeight(10*Scale);
          rect(40*Scale, 610*Scale, 200*Scale, 50*Scale);// the back button
          fill(0);
          textAlign(LEFT, BOTTOM);
          textSize(50*Scale);
          text("back", 60*Scale, 655*Scale);
        }

        if (Menue.equals("multiplayer strart")) {//if on the multyplayer starting menu
          background(#FF8000);
          hint(ENABLE_KEY_REPEAT);//allow key repeat for the textb boxes
          fill(0);
          initMultyplayerScreenTitle.draw();//draw the page title

          //draw the join, host, and exit button
          multyplayerJoin.draw();
          multyplayerHost.draw();
          multyplayerExit.draw();
        }

        if (Menue.equals("start host")) {//if on the seting up hosting menu
          background(#FF8000);
          fill(0);
          //draw the text on the menu
          mp_hostSeccion.draw();
          mp_host_Name.draw();
          mp_host_port.draw();
          
          //draw the text boxes on the menu
          multyPlayerNameTextBox.draw();
          multyPlayerPortTextBox.draw();
          //draw the exit an go buttons
          multyplayerExit.draw();
          multyplayerGo.draw();
        }
        
        if (Menue.equals("start join")) {//if on the setup joining menu
          background(#FF8000);
          fill(0);
          //draw the text on the menu
          mp_joinSession.draw();
          mp_join_name.draw();
          mp_join_port.draw();
          mp_join_ip.draw();
          //draw the text boxes on the menu
          multyPlayerNameTextBox.draw();
          multyPlayerPortTextBox.draw();
          multyPlayerIpTextBox.draw();
          //draw the exit and go buttons
          multyplayerExit.draw();
          multyplayerGo.draw();
        }
        
        if (Menue.equals("disconnected")) {//if on the multyplauer disconnection screen 

          background(200);
          fill(0);
          //draw the menu title
          mp_disconnected.draw();
          //set then draw the disconnect reason(error)
          mp_dc_reason.setText(disconnectReason);
          mp_dc_reason.draw();
          //draw the exit button
          multyplayerExit.draw();
        }
        //TODO: update text in multyplayer selection menu to UiText
        if (Menue.equals("multiplayer selection")) {//the main multyplayer screen
          background(-9131009);
          fill(0);
          
          //oh god what the fuck did I do here
          rect(width*0.171875, 0, 2*Scale, height);//verticle line on the left of the screen
          textAlign(CENTER, CENTER);
          textSize(20*Scale);
          text("players", width*0.086, height*0.015);
          rect(0, height*0.04, width*0.171875, height*(2.0/720));//horozontal line ath the top of the left colum
          //why have I not modernized any of this yet?
          
          //horozontal lines that seperate the names of the players
          for (int i=0; i<10; i++) {
            rect(0, height*0.04+((height*0.91666-height*0.04)/10)*i, width*0.171875, height*(1.0/720));
          }

          rect(width*0.8, 0, width*0.0015625, height);//verticle line on the right of the screen

          //multyplayerSelectedLevel
          calcTextSize("selected level", width*0.15);
          text("Selected Level", width*0.9, height*0.1);
          rect(width*0.8, height*0.2, width*0.2, height*(2.0/720));
          textSize(10*Scale);
          textAlign(LEFT, CENTER);
          if (multyplayerSelectedLevel.exsists) {//if something is selcted then display its information
            text("Name: "+multyplayerSelectedLevel.name, width*0.81, height*0.22);
            text("Author: "+multyplayerSelectedLevel.author, width*0.81, height*0.24);
            text("Game Version: "+multyplayerSelectedLevel.gameVersion, width*0.81, height*0.26);
            text("Multyplayer Mode: "+((multyplayerSelectedLevel.multyplayerMode==1) ? "Speed Run" : "Co - Op"), width*0.81, height*0.28);
            if (multyplayerSelectedLevel.multyplayerMode==2) {
              text("Max players: "+multyplayerSelectedLevel.maxPlayers, width*0.81, height*0.3);
              text("Min players: "+multyplayerSelectedLevel.minPlayers, width*0.81, height*0.32);
            }
            if (multyplayerSelectedLevel.multyplayerMode==1) {
              textAlign(CENTER, CENTER);
              calcTextSize("time to complete", width*0.96609375-width*0.8463194444);
              text("time to complete", width*0.901, height*0.68);
              String time = formatMillis(sessionTime);
              calcTextSize(time, width*0.96609375-width*0.8463194444);
              text(time, width*0.901, height*0.72);
            }
            if (multyplayerSelectedLevel.gameVersion!=null&&!gameVersionCompatibilityCheck(multyplayerSelectedLevel.gameVersion)) {//check if the currenly selected level is compatiable with this version of the game
              textSize(10*Scale);
              textAlign(LEFT, CENTER);
              text("Level is incompatible with current version of game", width*0.81, height*0.34);
            } else {
              if (isHost) {
                if (!waitingForReady) {
                  if (multyplayerSelectedLevel.multyplayerMode==1) {
                    increaseTime.draw();
                    decreaseTime.draw();
                    multyplayerPlay.draw();
                  }
                  if (multyplayerSelectedLevel.multyplayerMode==2) {
                    if (clients.size()+1 >= multyplayerSelectedLevel.minPlayers && clients.size()+1 <= multyplayerSelectedLevel.maxPlayers) {
                      multyplayerPlay.draw();
                    } else {
                      textSize(20*Scale);
                      text((clients.size()+1 < multyplayerSelectedLevel.minPlayers)? "not enough players" : "too many players", width*0.81, height*0.72);
                    }
                  }
                } else {//when waiting for clients to be readdy
                  calcTextSize("waiting for clients", multyplayerPlay.lengthX);
                  textAlign(CENTER, CENTER);
                  fill(0);
                  text("waiting for clients", multyplayerPlay.x+multyplayerPlay.lengthX/2, multyplayerPlay.y+multyplayerPlay.lengthY/2);
                }
              }
            }
          }

          textAlign(CENTER, CENTER);
          if (isHost) {//if you are the host of the session
            calcTextSize("select level", width*0.15);
            text("select level", width/2, height*0.05);

            //display your name at the top of the list
            calcTextSize(name, width*0.16875, (int)(25*Scale));
            text(name+"\n(you)", width*0.086, height*0.04+((height*0.91666-height*0.04)/10/2));

            //display the names of all the outher players
            for (int i=0; i<clients.size(); i++) {
              calcTextSize(clients.get(i).name, width*0.16875, (int)(25*Scale));
              text(clients.get(i).name, width*0.086, height*0.04+((height*0.91666-height*0.04)/10/2)+((height*0.91666-height*0.04)/10)*(i+1));
            }
            //horozontal line under selecte level
            rect(width*0.171875, height*0.09, width*0.8-width*0.171875, height*(2.0/720));

            //draw the buttons for level type
            multyplayerSpeedrun.draw();
            multyplayerCoop.draw();
            multyplayerUGC.draw();

            //darw lines seperating levels
            fill(0);
            for (int i=0; i<16; i++) {
              rect(width*0.171875, height*0.09+((height*0.9027777777-height*0.09)/16)*i, width*0.8-width*0.171875, height*(1.0/720));
            }

            if (multyplayerSelectionLevels.equals("speed")) {
              multyplayerSpeedrun.setColor(-59135, -35185);
              multyplayerCoop.setColor(-59135, -1791);
              multyplayerUGC.setColor(-59135, -1791);
              int numOfBuiltInLevels=14;
              calcTextSize("level 30", width*0.1);
              textAlign(CENTER, CENTER);
              for (int i=0; i<numOfBuiltInLevels; i++) {
                text("Level "+(i+1), width/2, height*0.09+(height*0.7/32)+((height*0.9027777777-height*0.09)/16)*i);
              }
            }
            if (multyplayerSelectionLevels.equals("coop")) {
              multyplayerSpeedrun.setColor(-59135, -1791);
              multyplayerCoop.setColor(-59135, -35185);
              multyplayerUGC.setColor(-59135, -1791);
              calcTextSize("level 30", width*0.1);
              textAlign(CENTER, CENTER);
              for (int i=0; i<2; i++) {
                text("Co-Op "+(i+1), width/2, height*0.09+(height*0.7/32)+((height*0.9027777777-height*0.09)/16)*i);
              }
            }
            if (multyplayerSelectionLevels.equals("UGC")) {
              multyplayerSpeedrun.setColor(-59135, -1791);//color of the buttons at the bottom of the screen
              multyplayerCoop.setColor(-59135, -1791);
              multyplayerUGC.setColor(-59135, -35185);

              calcTextSize("level 30", width*0.1);//display the levels to selct from
              textAlign(CENTER, CENTER);
              for (int i=0; i<UGCNames.size(); i++) {
                String levelName = loadJSONArray(appdata+"/CBi-games/skinny mann/UGC/levels/"+UGCNames.get(i)+"/index.json").getJSONObject(0).getString("name");
                text(levelName, width/2, height*0.09+(height*0.7/32)+((height*0.9027777777-height*0.09)/16)*i);
              }
            }
          } else {
            textAlign(CENTER, CENTER);
            for (int i=0; i<playerNames.size(); i++) {
              calcTextSize(playerNames.get(i), width*0.16875, (int)(25*Scale));
              text(playerNames.get(i), width*0.086, height*0.04+((height*0.91666-height*0.04)/10/2)+((height*0.91666-height*0.04)/10)*(i));
            }

            if (clients.size()>0) {
              if (clients.get(0).downloadingLevel) {
                calcTextSize("downloading... ", width*0.25, (int)(25*Scale));
                text("downloading... ", width/2, height*0.05);
                int totalBlocks=0;
                if (clients.get(0).ldi!=null) {
                  for (int i=0; i<clients.get(0).ldi.fileSizes.length; i++) {
                    totalBlocks+=clients.get(0).ldi.fileSizes[i];
                  }
                  int downloadedBlocks=0;
                  for (int i=0; i<clients.get(0).currentDownloadIndex; i++) {
                    downloadedBlocks+=clients.get(0).ldi.fileSizes[i];
                  }
                  downloadedBlocks+=clients.get(0).currentDownloadblock;
                  rect(width*0.3, height*0.1, width*0.4, height*0.08);
                  fill(-9131009);
                  rect(width*0.305, height*0.11, width*0.39, height*0.06);
                  fill(0);
                  rect(width*0.305, height*0.11, width*0.39*(1.0*downloadedBlocks/totalBlocks), height*0.06);
                }
              }
              if (clients.get(0).readdy) {
                calcTextSize("waiting for server", width*0.35, (int)(25*Scale));
                text("waiting for server", width/2, height*0.05);
              }
            }
          }
          multyplayerLeave.draw();
          
          //if you are wondering what that was, it was an attempt at amking a scalable UI but clearly it did not work very well. no I am just not able to be botherd to fix it
        }//end of multyplayer selection

        if (Menue.equals("dev")) {//if on the dev menu
          drawDevMenue();//draw the dev menu
        }

        if(Menue.equals("level complete")){
          background(-9131009);
          fill(255);
          levelCompleteTitle.draw();
          levelCompleteLevelName.draw();
          levelCompleteLeaderBoardLeftColumn.draw();
          levelCompleteLeaderBoardCenterColumn.draw();
          levelCompleteLeaderBoardRightColumn.draw();
          yourScore.draw();

          levelCompleteScreenContinue.draw();
        }

        if(Menue.equals("high score")){
          background(-9131009);
          fill(255);
          enterNameText.draw();
          for(int i=0;i<onScreenKeyboardButtons.length;i++){
            for(int j=0;j<onScreenKeyboardButtons[i].length;j++){
              if(onScreenKeyboardButtons[i][j]!=null){
                onScreenKeyboardButtons[i][j].draw();
              }
            }
          }
          fill(255);
          highScoreName.draw();
        }

      }
      //end of menue draw


      if (inGame) {//if in game
        hint(DISABLE_KEY_REPEAT);//diable the key repeat because it causes issues with input handling 
        //================================================================================================ dont remember what this was for anymore
        background(7646207);//wait, this should not be here anymore
        stageLevelDraw();//render the level
        
        if (level_complete&&!levelCompleteSoundPlayed) {//if the level has been completed and the sound has not been played yet
          if (multiplayer) {//if in multyplayer
            if (level.multyplayerMode==1) {//if this level is in speedrun mode
              players[currentPlayer].setX(-100);//move the player to -100,-100
              players[currentPlayer].setY(-100);
              level.psudoLoad();//run a fake load on the level
              level_complete=false;//set the level to not be complete
              int completeTime=millis()-startTime;//calculate the time it took to complete
              println("completed in: "+completeTime+" "+formatMillis(completeTime));
              if (completeTime<bestTime||bestTime==0) {//if this was better then your best time, or your best time was 0
                bestTime=completeTime;//set this to be your best time
              }
              startTime=millis();//reset stage start time
            }
          } else {//if not in multyplayer
            soundHandler.addToQueue(0);//queue the level complete sound to playe (sound 0)
            levelCompleteSoundPlayed=true;//set the sound to played
          }
        }
      }
      perspective();//reset the perspecive / fov for 3D mode

      if (tutorialMode&&!inGame) {//if in the tutorial and not currenly in a level
        if (Menue.equals("settings")) {//if the menu is settings
          background(0);
          fill(255);
          tut_notToday.draw();//display the rejection message
        } else {//otherwize 
          background(0);
          fill(255);//dsiplay the disclaimer text 
          tut_disclaimer.draw();
          tut_toClose.draw();
        }
      }
      engageHUDPosition();//prepair for rendering HUD elements

      if (inGame) {//if in the game
        fill(255);//render the coin count
        coinCountText.setText("coins: "+coinCount);
        coinCountText.draw();
      }

      if (menue) {
        if (Menue.equals("pause")) {//when paused
        //render the pause menu
          fill(50, 200);
          rect(0, 0, width, height);//darken the background
          fill(0);
          pa_title.draw();

          pauseResumeButton.draw();
          pauseOptionsButton.draw();
          pauseQuitButton.draw();

          if (multiplayer) {//if in multyplayer then display the reset time button
            if (level.multyplayerMode==1) {
              pauseRestart.draw();
            }
          }
        }
      }
      //end of not in level creator
    } else {
      //if in the level creator
      if (startup) {//if on the startup screen
        hint(ENABLE_KEY_REPEAT);//allow key repeat for the author field
        background(#48EDD8);
        translate(width/2, 150*Scale, 0);
        rotateX(PI);
        ambientLight(128, 128, 128);
        directionalLight(255, 255, 255, -0.4, -0.3, 0.1);
        shape(LevelCreatorLogo);//logo
        noLights();
        rotateX(-PI);
        translate(-width/2, -150*Scale, 0);

        newLevelButton.draw();
        loadLevelButton.draw();
        textAlign(LEFT, BOTTOM);
        fill(0);
        textSize(15*Scale);
        lc_start_version.draw();
        lc_start_author.setText("author: "+author+coursorr);
        lc_start_author.draw();
        strokeWeight(0);
        rect(60*Scale, 31*Scale, textWidth(author), 1*Scale);//draw the line under the author name
        newBlueprint.draw();
        loadBlueprint.draw();
        lc_backButton.draw();
        if (settings.getFullScreen()) {//if in full screen mode then display this warning
          fill(0);
          lc_fullScreenWarning.draw();
        }
      }//end of startup screen

      if (loading) {//if loading a level
        background(#48EDD8);
        fill(0);
        lc_load_new_describe.draw();

        lcEnterLevelTextBox.draw();
        if (levelNotFound) {
          fill(200, 0, 0);
          lc_load_notFound.draw();
        }
        stroke(#4857ED);
        fill(#BB48ED);
        lcLoadLevelButton.draw();//draw load button
        lc_backButton.draw();
        lc_openLevelsFolder.draw();
      }//end of loading level

      if (newLevel) {//if creating a new level
        hint(ENABLE_KEY_REPEAT);
        background(#48EDD8);
        fill(0);
        lc_load_new_describe.draw();
        lcEnterLevelTextBox.draw();
        lcNewLevelButton.draw();//start button
        lc_backButton.draw();
        lc_openLevelsFolder.draw();
      }//end of make new level

      if (editingStage) {//if edditing the stage
        hint(DISABLE_KEY_REPEAT);//again disable the key repeat for input reasons
        if (!simulating) {//if not simulating allow the camera to be moved by the arrow keys
          if (cam_left&&camPos>0) {
            camPos-=4;
          }
          if (cam_right) {
            camPos+=4;
          }
          if (cam_down&&camPosY>0) {
            camPosY-=4;
          }
          if (cam_up) {
            camPosY+=4;
          }
        }

        stageLevelDraw();//render the level
        
        //if placing a blueprint in 3D, render the blueprint that is being palced
        if (e3DMode && selectingBlueprint && blueprints.length!=0){
          generateDisplayBlueprint3D();
          renderBlueprint3D();
          //calculate the width, height, and depth of the blueprint
          float cdx = blueprintMax[0]-blueprintMin[0];
          float cdy = blueprintMax[1]-blueprintMin[1];
          float cdz = blueprintMax[2]-blueprintMin[2];
          renderTranslationArrows(blueprintMin[0],blueprintMin[1],blueprintMin[2],cdx,cdy,cdz);
        }
        
        stageEditGUI();//draw the editing gui/placemnt logic 

        if (selectingBlueprint&&blueprints.length!=0) {//if selecting blueprint
          if(!e3DMode){//if not in 3D mode 
            generateDisplayBlueprint();//prepair to visualize the blueprint that is selected
            renderBlueprint();//render blueprint
          }
        }
        perspective();//reset the perspecive / fov
        engageHUDPosition();//setup for rendering HUD elements
      }

      if (levelOverview) {//if on the level overview
        hint(DISABLE_KEY_REPEAT);
        background(#0092FF);
        fill(#7CC7FF);
        stroke(#7CC7FF);
        strokeWeight(0);
        if (overviewSelection!=-1) {//if something is selected
          rect(0, ((overviewSelection- filesScrole)*60+80)*Scale, 1280*Scale, 60*Scale);//draw the highlight
          if (overviewSelection<level.stages.size()) {//if the selection is in rage of the stages
            if (level.stages.get(overviewSelection).type.equals("stage")) {//if the selected thing is a 2D stage
              edditStage.draw();//draw edit button
              fill(255, 255, 0);
              strokeWeight(1*Scale);
              quad(1155*Scale, 37*Scale, 1129*Scale, 54*Scale, 1114*Scale, 39*Scale, 1140*Scale, 22*Scale);//draw the pencil
              fill(#E5B178);
              triangle(1129*Scale, 54*Scale, 1114*Scale, 39*Scale, 1109*Scale, 53*Scale);//more pencil thing
              setMainStage.draw();//draw set main stage button
              fill(255, 0, 0);
              quad(1030*Scale, 16*Scale, 1010*Scale, 40*Scale, 1030*Scale, 66*Scale, 1050*Scale, 40*Scale);//draw the main stage diamond
              setMainStage.drawHoverText();
            }
            if (level.stages.get(overviewSelection).type.equals("3Dstage")) {//if the selected thing is a 3D stage
              edditStage.draw();//draw edit stage button
              fill(255, 255, 0);
              strokeWeight(1*Scale);
              quad(1155*Scale, 37*Scale, 1129*Scale, 54*Scale, 1114*Scale, 39*Scale, 1140*Scale, 22*Scale);//draw the pencil
              fill(#E5B178);
              triangle(1129*Scale, 54*Scale, 1114*Scale, 39*Scale, 1109*Scale, 53*Scale);
            }
          }//end of thing slected is in stage range
          if (overviewSelection>=level.stages.size()+level.sounds.size()) {//if the selection is in the logic board range
            edditStage.draw();//draw edit button
            fill(255, 255, 0);
            strokeWeight(1*Scale);
            quad(1155*Scale, 37*Scale, 1129*Scale, 54*Scale, 1114*Scale, 39*Scale, 1140*Scale, 22*Scale);//draw the pencil
            fill(#E5B178);
            triangle(1129*Scale, 54*Scale, 1114*Scale, 39*Scale, 1109*Scale, 53*Scale);//more pencil thing
          }
        }//end of if something is selected
        textAlign(LEFT, BOTTOM);
        stroke(0);
        strokeWeight(2*Scale);
        line(0*Scale, 80*Scale, 1280*Scale, 80*Scale);
        fill(0);
        textSize(30*Scale);
        //TODO: update the text here. outher stuff def needs to be changed to scale well with it
        //load the names of the sounds
        String[] keys=new String[0];//create a string array that can be used to place the sound keys in
        keys=level.sounds.keySet().toArray(keys);//place the sound keys into the array
        for (int i=0; i < 11 && i + filesScrole < level.stages.size()+level.sounds.size()+level.logicBoards.size(); i++) {//loop through all the stages, sounds, and logic boards to display 11 of them on screen
          if (i+ filesScrole<level.stages.size()) {//if the current thing attemping to diaply is in the range of stages
            fill(0);
            String displayName=level.stages.get(i+ filesScrole).name, type=level.stages.get(i+ filesScrole).type;//get the name and type of the stages
            text(displayName, 80*Scale, (130+60*(i))*Scale);//display the name
            if (type.equals("stage")) {//if it is a stage then display the stage icon
              drawWorldSymbol(20*Scale, (90+60*(i))*Scale,g);
            }
            if (type.equals("3Dstage")) {
              draw3DStageIcon(43*Scale, (100+60*i)*Scale, 0.7*Scale,g);
            }
          } else if (i+ filesScrole<level.stages.size()+level.sounds.size()) {//if the thing is in the range of sounds
            fill(0);
            String displayName=level.sounds.get(keys[i+ filesScrole-level.stages.size()]).name, type=level.sounds.get(keys[i+ filesScrole-level.stages.size()]).type;//get the name and type of a sound in the level
            text(displayName, 80*Scale, (130+60*(i))*Scale);//display the name
            if (type.equals("sound")) {//if the thing is a sound then display the sound icon
              drawSpeakericon(40*Scale, (110+60*(i))*Scale, 0.5*Scale,g);
            }
          } else {//at this point in the the only other type of thing is a logic board
            fill(0);
            String displayName=level.logicBoards.get(i+ filesScrole-(level.stages.size()+level.sounds.size())).name;//get the name of the logic board
            text(displayName, 80*Scale, (130+60*(i))*Scale);//display the name
            logicIcon(40*Scale, (100+60*i)*Scale, 1*Scale,g);//draw the logic board icon
          }
        }


        textAlign(CENTER, CENTER);
        newStage.draw();//draw the new file button
        textAlign(LEFT, BOTTOM);
        //why is this happening every frame on the overview?
        respawnX=(int)level.SpawnX;//set the respawn info to that of the current level
        respawnY=(int)level.SpawnY;
        respawnStage=level.mainStage;

        overview_saveLevel.draw();//draw save button
        saveIcon(overview_saveLevel.x+overview_saveLevel.lengthX/2,overview_saveLevel.y+overview_saveLevel.lengthY/2,settings.getScale(),g);
        help.draw();//draw help button
        if (filesScrole>0)//draw scroll buttons if nessarry
          overviewUp.draw();
        if (filesScrole+11<level.stages.size()+level.sounds.size()+level.logicBoards.size())
          overviewDown.draw();
        lcOverviewExitButton.draw();
      }//end of level overview

      if (newFile) {//if on the new file screen
        hint(ENABLE_KEY_REPEAT);//allow key repeat for text boxes
        background(#0092FF);
        stroke(0);
        strokeWeight(2*Scale);
        line(100*Scale, 450*Scale, 1200*Scale, 450*Scale);//text input line
        //highlight the option that is currently set
        if (newFileType.equals("2D")) {
          new2DStage.setColor(#BB48ED, #51DFFA);
          new3DStage.setColor(#BB48ED, #4857ED);
          addSound.setColor(#BB48ED, #4857ED);
        } else if (newFileType.equals("3D")) {
          new3DStage.setColor(#BB48ED, #51DFFA);
          new2DStage.setColor(#BB48ED, #4857ED);
          addSound.setColor(#BB48ED, #4857ED);
        } else if (newFileType.equals("sound")) {
          new3DStage.setColor(#BB48ED, #4857ED);
          new2DStage.setColor(#BB48ED, #4857ED);
          addSound.setColor(#BB48ED, #51DFFA);
        }

        new2DStage.draw();//draw the selection buttons
        new3DStage.draw();
        addSound.draw();
        newFileCreate.draw();
        newFileBack.draw();
        drawSpeakericon(addSound.x+addSound.lengthX/2, addSound.y+addSound.lengthY/2, 1*Scale,g);
        fill(0);

        if (newFileType.equals("sound")) {//if the selected type is sound
          String pathSegments[]=fileToCoppyPath.split("/|\\\\");
          lc_newf_fileName.setText(pathSegments[pathSegments.length-1]);//display the name of the selected file
          lc_newf_fileName.draw();
          chooseFileButton.draw();
          if(newSoundAsNarration){//change the hilight for the sound vs narration options
            lc_newSoundAsSoundButton.setColor(#BB48ED, #4857ED);
            lc_newSoundAsNarrationButton.setColor(#BB48ED, #51DFFA);
          }else{
            lc_newSoundAsSoundButton.setColor(#BB48ED, #51DFFA);
            lc_newSoundAsNarrationButton.setColor(#BB48ED, #4857ED);
          }
          lc_newSoundAsSoundButton.draw();
          lc_newSoundAsNarrationButton.draw();
        }
        lcNewFileTextBox.draw();
      }//end of new file

      if (drawingPortal2) {//if drawing portal part 2 aka outher overview selection screen
        //cant be bottherd to do more comments in this part becasue it is bascially the same as the ovreview
        background(#0092FF);
        fill(#7CC7FF);
        stroke(#7CC7FF);
        strokeWeight(0);
        if (overviewSelection!=-1) {//if sonethign is selected
          rect(0, ((overviewSelection- filesScrole)*60+80)*Scale, 1280*Scale, 60*Scale);//highlight
          if (overviewSelection<level.stages.size())
            if (level.stages.get(overviewSelection).type.equals("stage")||level.stages.get(overviewSelection).type.equals("3Dstage")) {//if the selected thing is a posible destination stage
              selectStage.draw();//draw the select stage button
              stroke(0, 255, 0);
              strokeWeight(7*Scale);
              line(1212*Scale, 44*Scale, 1224*Scale, 55*Scale);//checkmark
              line(1224*Scale, 55*Scale, 1253*Scale, 29*Scale);
            }
        }
        textAlign(LEFT, BOTTOM);
        stroke(0);
        strokeWeight(2*Scale);
        line(0*Scale, 80*Scale, 1280*Scale, 80*Scale);
        fill(0);
        textSize(30*Scale);
        //TODO: fix text here just like overview
        String[] keys=new String[0];//create a string array that can be used to place the sound keys in
        keys=level.sounds.keySet().toArray(keys);//place the sound keys into the array
        for (int i=0; i < 11 && i + filesScrole < level.stages.size()+level.sounds.size()+level.logicBoards.size(); i++) {//loop through all the stages and sounds and display 11 of them on screen
          if (i+ filesScrole<level.stages.size()) {//if the current thing attemping to diaply is in the range of stages
            fill(0);
            String displayName=level.stages.get(i+ filesScrole).name, type=level.stages.get(i+ filesScrole).type;//get the name and type of the stages
            text(displayName, 80*Scale, (130+60*(i))*Scale);//display the name
            if (type.equals("stage")) {//if it is a stage then display the stage icon
              drawWorldSymbol(20*Scale, (90+60*(i))*Scale,g);
            }
            if (type.equals("3Dstage")) {
              draw3DStageIcon(43*Scale, (100+60*i)*Scale, 0.7*Scale,g);
            }
          } else if (i+ filesScrole<level.stages.size()+level.sounds.size()) {//if the thing is not a stage type
            fill(0);
            String displayName=level.sounds.get(keys[i+ filesScrole-level.stages.size()]).name, type=level.sounds.get(keys[i+ filesScrole-level.stages.size()]).type;//get the name and type of a sound in the level
            text(displayName, 80*Scale, (130+60*(i))*Scale);//display the name
            if (type.equals("sound")) {//if the thing is a sound then display the sound icon
              drawSpeakericon(40*Scale, (110+60*(i))*Scale, 0.5*Scale,g);
            }
          } else {
            fill(0);
            String displayName=level.logicBoards.get(i+ filesScrole-(level.stages.size()+level.sounds.size())).name;//get the name of the logic board
            text(displayName, 80*Scale, (130+60*(i))*Scale);//display the name
            logicIcon(40*Scale, (100+60*i)*Scale, 1*Scale,g);
          }
        }
        fill(0);
        lc_dp2_info.draw();
        if (filesScrole>0)//scroll buttons
          overviewUp.draw();
        if (filesScrole+11<level.stages.size()+level.sounds.size())
          overviewDown.draw();
      }//end of drawing portal2

      if (creatingNewBlueprint) {//if creating a new bueprint screen
        background(#48EDD8);
        fill(0);
        lc_newbp_describe.draw();
        lcEnterLevelTextBox.draw();

        createBlueprintGo.draw();//create button
        lc_backButton.draw();
        if(newBlueprintIs3D){//hilght for 2D or 3D bluepint buttons
          new2DStage.setColor(#BB48ED, #4857ED);
          new3DStage.setColor(#BB48ED, #51DFFA);
        }else{
          new2DStage.setColor(#BB48ED, #51DFFA);
          new3DStage.setColor(#BB48ED, #4857ED);
        }
        new2DStage.draw();
        new3DStage.draw();
      }//end of creating new blueprint

      if (loadingBlueprint) {//if loading blueprint
        background(#48EDD8);
        fill(0);
        lc_newbp_describe.draw();
        lcEnterLevelTextBox.draw();
        createBlueprintGo.setText("load");//load button
        createBlueprintGo.draw();
        lc_backButton.draw();
      }//end of loading blueprint

      if (editingBlueprint) {//if edditing blueprint
        hint(DISABLE_KEY_REPEAT);
        background(7646207);
        if(!e3DMode){//if not in 3D mode
          fill(0);
          strokeWeight(0);
          rect(width/2-0.5, 0, 1, height);//draw lines in the center of the screen that indicate wherer (0,0) is
          rect(0, height/2-0.5, width, 1);
        }
        blueprintEditDraw();//draw the accual blueprint
        stageEditGUI();//overlays when placing things
        engageHUDPosition();
      }//end of edit blueprint

      if (editinglogicBoard) {//if editing a logic board
        background(#FFECA0);
        for (int i=0; i<level.logicBoards.get(logicBoardIndex).components.size(); i++) {//draw the components
          if (selectedIndex==i) {//if the current component is selected
            strokeWeight(0);
            fill(255, 0, 0);//draw the hilight arrounf the comonnent
            rect((level.logicBoards.get(logicBoardIndex).components.get(i).x-5-camPos)*Scale, (level.logicBoards.get(logicBoardIndex).components.get(i).y-5-camPosY)*Scale, (level.logicBoards.get(logicBoardIndex).components.get(i).button.lengthX+10*Scale), (level.logicBoards.get(logicBoardIndex).components.get(i).button.lengthY+10*Scale));
          }
          level.logicBoards.get(logicBoardIndex).components.get(i).draw();//draw the component
        }
        for (int i=0; i<level.logicBoards.get(logicBoardIndex).components.size(); i++) {//draw the connections
          level.logicBoards.get(logicBoardIndex).components.get(i).drawConnections();
        }

        if (connectingLogic&&connecting) {//draw the connnecting line to the mouse
          float[] nodePos = level.logicBoards.get(logicBoardIndex).components.get(connectingFromIndex).getTerminalPos(2);
          stroke(0);
          strokeWeight(5*Scale);
          line(nodePos[0]*Scale, nodePos[1]*Scale, mouseX, mouseY);
        }

        if (movingLogicComponent&&moveLogicComponents) {//if moving logic components
          level.logicBoards.get(logicBoardIndex).components.get(movingLogicIndex).setPos(mouseX/Scale+camPos, mouseY/Scale+camPosY);
        }
        if (cam_left&&camPos>0) {//camera movement
          camPos-=4;
        }
        if (cam_right) {
          camPos+=4;
        }
        if (cam_up&&camPosY>0) {
          camPosY-=4;
        }
        if (cam_down) {
          camPosY+=4;
        }
      }

      if (exitLevelCreator) {//if on the exiting level creator screen
        background(#0092FF);
        fill(0);
        lc_exit_question.draw();
        lc_exit_disclaimer.draw();

        lc_exitConfirm.draw();
        lc_exitCancle.draw();
      }
    }//end of level creator


    if (dead) {// when  dead
      fill(255, 0, 0);
      deadText.draw();//draw the dead text
      death_cool_down++;
      if (death_cool_down>75) {// respawn cool down
        dead=false;
        inGame=true;
        player1_moving_right=false;//reset movemnt 
        player1_moving_left=false;
        player1_jumping=false;
        SPressed=false;
        WPressed=false;
        playerMovementManager.reset();
      }
      if(!inGame){//if not in game then turn dead off
        dead=false;
      }
    }
    
    if (settingPlayerSpawn && levelCreator) {//if setting the player spawn point 
      draw_mann(mouseX, mouseY, 1, Scale, 0,g);//draw the example player
      fill(0);
      settingPlayerSpawnText.draw();//draw the explain text
    }


    if (settings.getDebugFPS()) {//if displaying FPS
      fill(255);
      fpsText.setText("FPS: "+ frameRate);//redner the FPS
      fpsText.draw();
    }
    if (settings.getDebugInfo()) {//if displaying debug info
      fill(255);//render the debig info as long as the current player exsists
      if (players[currentPlayer]!=null) {
        dbg_mspc.setText("mspc: "+ mspc);
        dbg_playerX.setText("player X: "+ players[currentPlayer].x);
        dbg_playerY.setText("player Y: "+ players[currentPlayer].y);
        dbg_vertvel.setText("player vertical velocity: "+ players[currentPlayer].verticalVelocity);
        dbg_animationCD.setText("player animation Cooldown: "+ players[currentPlayer].animationCooldown);
        dbg_pose.setText("player pose: "+ players[currentPlayer].pose);
        dbg_camX.setText("camera x: "+camPos);
        dbg_camY.setText("camera y: "+camPosY);
        dbg_tutorialPos.setText("tutorial position: "+tutorialPos);
      }
      if(multiplayer){//if in multyplayer
        if(clients.size()==0){//if there are no conections
          dbg_ping.setText("Ping: N/A");//report the ping as N/A
        }else if(clients.size()==1){//if there is exactly 1 connection
          long pingl = clients.get(0).ping;//displaly the ping of that connection
          float pingDisp = (int)(pingl/10000)/100.0;
          dbg_ping.setText("Ping: "+pingDisp);
        }else{//if there is more then 1 connection
          //display the average ping
          long totalPing = clients.stream().map( c -> c.ping).reduce(0l, Long::sum);
          long avgPingl = totalPing / clients.size();
          float pingDisp = (int)(avgPingl/10000)/100.0;
          dbg_ping.setText("avgPing: "+pingDisp);
        }
      }else{//if not in multyplayer
        dbg_ping.setText("Ping: N/A");//display the ping as N/A
      }
      dbg_mspc.draw();
      dbg_playerX.draw();
      dbg_playerY.draw();
      dbg_vertvel.draw();
      dbg_animationCD.draw();
      dbg_pose.draw();
      dbg_camX.draw();
      dbg_camY.draw();
      dbg_tutorialPos.draw();
      dbg_ping.draw();
    }

    if (millis()<gmillis) {//if the glish effect should be shown 
      glitchEffect();//draw the glitch effect
    }
    
    if(showDepthBuffer&&dev_mode&&shadowMap!=null){//if the depth buffer should be renderd
      image(shadowMap,0,height/2,width/2,height/2);//redner the depth buffer
    }

    if (displayTextUntill>=millis()) {//if text is being displayed on screen
      fill(255);
      game_displayText.setText(displayText);//render the display text
      game_displayText.draw();
    }

    if(inGame&&!tutorialMode&&level.levelID!=-1){
      fill(255);
      String curtime_=formatMillis(millis()-startTime);
      elapsedTimeDisplay.setText(curtime_);
      elapsedTimeDisplay.draw();
    }
    
    if(soundHandler!=null && settings.getSoundNarrationVolume()< 0.2 && soundHandler.anyNarrationPlaying()){//if a narration is playing and the volume is low,
      fill(255);
      narrationCaptionText.draw();//display the cation notice
    }
    //TODO: text stuff for multyplayer in game
    if (multiplayer&&inGame) {
      if (level.multyplayerMode==1) {
        fill(255);
        String curtime=formatMillis(millis()-startTime);
        calcTextSize(curtime, width*0.06);
        textAlign(CENTER, CENTER);
        text(curtime, width/2, height*0.015);//redner the current level time
        //if host calculate the order of the score board
        if (isHost) {
          BestScore[] scores=new BestScore[10];
          for (int i=0; i<10; i++) {
            scores[i]=new BestScore("", 0);
          }
          scores[0]=new BestScore(name, bestTime);
          int j=1;
          for (int i=0; i<clients.size(); i++) {
            scores[j]=clients.get(i).bestScore;
            j++;
          }
          for (int i=0; i<9; i++) {//lazyest bubble sort ever
            for (j=0; j<9; j++) {
              if ((scores[j].score==0||scores[j].score>scores[j+1].score)&&scores[j+1].score!=0) {
                BestScore tmp =scores[j+1];
                scores[j+1]=scores[j];
                scores[j]=tmp;
              }
            }
          }
          String []times={"", "", "", "", "", "", "", "", "", ""};
          for (int i=0; i<10; i++) {
            if (!scores[i].name.equals("")) {
              times[i]=scores[i].name+": "+formatMillis(scores[i].score);
            }
          }
          leaderBoard=new LeaderBoard(times);
        }
        calcTextSize("12345678910", width*0.06);
        textAlign(LEFT, TOP);
        //redner the leaderboard
        String lb ="Leader Board\n";
        for (int i=0; i<leaderBoard.leaderboard.length; i++) {
          lb+=leaderBoard.leaderboard[i]+"\n";
        }
        text(lb, width*0.01, height*0.15);
        String timeLeft=formatMillis(timerEndTime-millis());
        calcTextSize(timeLeft, width*0.05);
        text(timeLeft, width*0.01, height*0.12);
        calcTextSize("Time Left", width*0.05);
        //redner ho much time is left in this level
        text("Time Left", width*0.01, height*0.1);
        if (isHost) {//if your the host and time is up,
          if (timerEndTime-millis()<=0) {
            Menue="multiplayer selection";
            returnToSlection();//return to the seldction screen
            menue=true;
            inGame=false;
          }
        }
      }
      if (level.multyplayerMode==2) {//if in co-op mode and all players are on a finish line
        if (isHost) {
          boolean allDone=true;
          for (int i=0; i<clients.size(); i++) {
            //println(clients.get(i).reachedEnd+" "+i);
            allDone=allDone && clients.get(i).reachedEnd;
          }
          allDone = allDone && reachedEnd;
          if (allDone) {
            level_complete=true;//complete the level
          }
        }
      }
    }


    disEngageHUDPosition();//turn the HUD things off
  }
  catch(Throwable e) {//cath and display all the fatail errors that occor
    handleError(e);
  }

  //when waiting for clients to be readdy
  if (waitingForReady) {
    try {
      boolean rtg=true;
      for (int i=0; i<clients.size(); i++) {
        //print(clients.get(i).readdy+" ");
        if (!clients.get(i).readdy) {
          rtg=false;
          break;
        }
      }
      //println();
      if (rtg) {
        waitingForReady=false;
        menue=false;
        inGame=true;
        for (int i=0; i<clients.size(); i++) {
          clients.get(i).dataToSend.add(new CloseMenuRequest());
        }
        startTime=millis();
        timerEndTime=sessionTime+millis();
      }
    }
    catch(Exception e) {
    }
  }

}



/**Automaticaly called when a mouse click is detected in the window.
Executes on the render thread
*/
void mouseClicked() {// when you click the mouse

  try {
    if (!levelCreator) {

      if (menue) {//if your in a menu
        if (Menue.equals("main")) {//if that menu is the main menu
          if (playButton.isMouseOver()) {//level select button
            Menue = "level select";
            menue=false;
            initMenuTransition(Transitions.MAIN_TO_LEVEL_SELECT);
            return;
          }
          if (exitButton.isMouseOver()) {//exit button
            exit(1);
          }
          if (joinButton.isMouseOver()) {//join game button
            Menue="multiplayer strart";
          }
          if (settingsButton.isMouseOver()) {//settings button
            Menue="settings";
            menue=false;
            initMenuTransition(Transitions.MAIN_TO_SETTINGS);
            return;
          }
          if (howToPlayButton.isMouseOver()) {//tutorial button
            //how to play
            menue=false;
            tutorialMode=true;
            tutorialPos=0;
          }
        }
        if (Menue.equals("level select")) {//if that menu is level select
          //get the current level progress
          int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
          // if the mouse clicks on a level and the progress has unlocked that level then load that level
          if (select_lvl_1.isMouseOver()) {
            loadLevel("data/levels/level-1");
            menue=false;
            inGame=true;
          }
          if (select_lvl_2.isMouseOver()&&progress>=2) {
            loadLevel("data/levels/level-2");
            menue=false;
            inGame=true;
          }
          if (select_lvl_3.isMouseOver()&&progress>=3) {
            loadLevel("data/levels/level-3");
            menue=false;
            inGame=true;
          }
          if (select_lvl_4.isMouseOver()&&progress>=4) {
            loadLevel("data/levels/level-4");
            menue=false;
            inGame=true;
          }
          if (select_lvl_5.isMouseOver()&&progress>=5) {
            loadLevel("data/levels/level-5");
            menue=false;
            inGame=true;
          }
          if (select_lvl_6.isMouseOver()&&progress>=6) {
            loadLevel("data/levels/level-6");
            menue=false;
            inGame=true;
          }
          if (select_lvl_7.isMouseOver()&&progress>=7) {
            loadLevel("data/levels/level-7");
            menue=false;
            inGame=true;
          }
          if (select_lvl_8.isMouseOver()&&progress>=8) {
            loadLevel("data/levels/level-8");
            menue=false;
            inGame=true;
          }
          if (select_lvl_9.isMouseOver()&&progress>=9) {
            loadLevel("data/levels/level-9");
            menue=false;
            inGame=true;
          }
          if (select_lvl_10.isMouseOver()&&progress>=10) {
            loadLevel("data/levels/level-10");
            menue=false;
            inGame=true;
          }
          
          if(select_lvl_11.isMouseOver()&&progress>=11){
            loadLevel("data/levels/level-11");
            menue=false;
            inGame=true;
          }
          
          if(select_lvl_12.isMouseOver()&&progress>=12){
            loadLevel("data/levels/level-12");
            menue=false;
            inGame=true;
          }
          
          

          if (select_lvl_back.isMouseOver()) {//back button
            Menue="main";
            menue=false;
            initMenuTransition(Transitions.LEVEL_SELECT_TO_MAIN);
          }
          if (select_lvl_next.isMouseOver()) {//next page button
            Menue="level select 2";
            menue=false;
            initMenuTransition(Transitions.LEVEL_SELECT_TO_LEVEL_SELECT_2);
          }
          if (select_lvl_UGC.isMouseOver()) {//UGC level select button
            Menue="level select UGC";
            menue=false;
            loadUGCList();
            UGC_lvl_indx=0;
            initMenuTransition(Transitions.LEVEL_SELECT_TO_UGC);
            return;
          }


          return;//do no conitune attempting to process this mouse click incase the screen changed
        }
        if (Menue.equals("level select 2")) {//if that menu is level select2
          //get the current level progress
          int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
          // if the mouse clicks on a level and the progress has unlocked that level then load that level
          if (select_lvl_13.isMouseOver()&&progress>=13) {
            loadLevel("data/levels/level-13");
            menue=false;
            inGame=true;
          }
          if (select_lvl_14.isMouseOver()&&progress>=14) {
            loadLevel("data/levels/level-14");
            menue=false;
            inGame=true;
          }
          if (select_lvl_15.isMouseOver()&&progress>=15) {
            loadLevel("data/levels/level-15");
            menue=false;
            inGame=true;
          }
          if (select_lvl_16.isMouseOver()&&progress>=16) {
            loadLevel("data/levels/level-16");
            menue=false;
            inGame=true;
          }
          
          if (select_lvl_back.isMouseOver()) {// back button
            Menue="level select";
            menue=false;
            initMenuTransition(Transitions.LEVEL_SELECT_2_TO_LEVEL_SELECT);
          }
        }

        if (Menue.equals("level select UGC")) {//if that menu is the UGC level select screne
          if (select_lvl_back.isMouseOver()) {//back button
            Menue="level select";
            menue=false;
            initMenuTransition(Transitions.UGC_TO_LEVEL_SELECT);
          }
          if (UGC_open_folder.isMouseOver()) {//open folder button
            openUGCFolder();
          }

          if (UGCNames.size()==0) {//if there are no UGC levels do nothing
          } else {//if there are UGC levels then
            if (UGC_lvl_indx<UGCNames.size()-1) {//if there is another level
              if (UGC_lvls_next.isMouseOver()) {//next button
                UGC_lvl_indx++;
              }
            }
            if (UGC_lvl_indx>0) {//if not on the first level
              if (UGC_lvls_prev.isMouseOver()) {//prevous level button
                UGC_lvl_indx--;
              }
            }
            if (UGC_lvl_play.isMouseOver()) {//play level button
              loadLevel(appdata+"/CBi-games/skinny mann/UGC/levels/"+UGCNames.get(UGC_lvl_indx));
              if (!levelCompatible) {//if the level version is not compatable with this version of the game
                Menue="level select";
                return;
              }
              UGC_lvl=true;
              inGame=true;
              menue=false;
            }
          }
          if (levelcreatorLink.isMouseOver()) {//this now opens the level creator
            //link("https://cbi-games.glitch.me/level%20creator.html");//old level creator webpage
            if (scr2==null){//create the 2nd screen if it does not exsist
              scr2 =new ToolBox(millis());
            }
            startup=true;//set the level creator screen variables
            loading=false;
            newLevel=false;
            editingStage=false;
            levelOverview=false;
            newFile=false;
            levelCreator=true;
            filesScrole=0;
            author = settings.getDefaultAuthor();//set the author to the default
            return;
          }
        }//end of UGC menu

        if (Menue.equals("pause")) {//if that menu is pause
          if (pauseResumeButton.isMouseOver()) {//resume game button
            menue=false;
          }
          if (pauseOptionsButton.isMouseOver()) {//options button
            Menue="settings";
            prevousInGame=true;
            inGame=false;
          }
          if (pauseQuitButton.isMouseOver()) {//quit button
            menue=true;
            inGame=false;
            tutorialMode=false;
            if (multiplayer) {//hanlde multyplayer quitting
              if (isHost) {//if host then just go back to the level selcetion screen
                Menue="multiplayer selection";
                returnToSlection();
              } else {//if a client then leave multyplayer
                Menue="main";
                println("quitting multyplayer joined");
                clientQuitting=true;
                clients.get(0).disconnect();
                println("returning to main menu");
                multiplayer=false;
                return;
              }
            } else {
              Menue="level select";
              stats.incrementGamesQuit();
              stats.save();
            }
            soundHandler.setMusicVolume(settings.getSoundMusicVolume());//reset the music volume, incase you are quitting the tutorial
            coinCount=0;
          }
          if (multiplayer) {//mulyplayer restart level button
            if (level.multyplayerMode==1) {
              if (pauseRestart.isMouseOver()) {
                level.psudoLoad();
                startTime=millis();
                menue=false;
              }
            }
          }
        }

        if (Menue.equals("settings")) {//if that menu is settings
          //oh boy here we go..
          
          if (settingsMenue.equals("game play")) {//if on the gamplay tab
            //process clicks for the sliders
            verticleEdgeScrollSlider.mouseClicked();
            horozontalEdgeScrollSlider.mouseClicked();
            fovSlider.mouseClicked();
            //update the settings if any of the sliders have been clicked on
            if (horozontalEdgeScrollSlider.button.isMouseOver()) {
              settings.setScrollHorozontal((int)horozontalEdgeScrollSlider.getValue(),true);
              settings.save();
            }

            if (verticleEdgeScrollSlider.button.isMouseOver()) {
              settings.setScrollVertical((int)verticleEdgeScrollSlider.getValue(),true);
              settings.save();
            }
            if(fovSlider.button.isMouseOver()){
              settings.setFOV(fovSlider.getValue(),true);
              settings.save();
            }
            
            
          }//end of game play settings

          if (settingsMenue.equals("display")) {//if on the display tab
            String arat = "16:9";//default aspect ratio
            //when clicking on buttons update the approprate settings
            if (rez4k.isMouseOver()) {//2160 (4K) resolution button
              settings.setResolution((int)(2160*16.0/9),2160);
              settings.save();
            }

            if (rez1440.isMouseOver()) {// 1440 resolition button
              settings.setResolution((int)(1440*16.0/9),1440);
              settings.save();
            }

            if (rez1080.isMouseOver()) {// 1080 resolution button
              settings.setResolution((int)(1080*16.0/9),1080);
              settings.save();
            }

            if (rez900.isMouseOver()) {////900 resolution button
              settings.setResolution((int)(900*16.0/9),900);
              settings.save();
            }

            if (rez720.isMouseOver()) {// 720 resolution button
              settings.setResolution((int)(720*16.0/9),720);
              settings.save();
            }


            if (fullScreenOn.isMouseOver()) {//turn full screen on button
              settings.setFullScreen(true);
              settings.save();
            }

            if (fullScreenOff.isMouseOver()) {//turn fullscreen off button
              settings.setFullScreen(false);
              settings.save();
            }
          }//end of display settings menue

          if (settingsMenue.equals("sound")) {//if on the sound tab
            
            //process clicks for the sliders
            musicVolumeSlider.mouseClicked();
            SFXVolumeSlider.mouseClicked();
            narrationVolumeSlider.mouseClicked();
            //if the sliders have been clicked on then update settings
            if (musicVolumeSlider.button.isMouseOver()) {
              settings.setSoundMusicVolume(musicVolumeSlider.getValue()/100.0,true);
              soundHandler.setMusicVolume(settings.getSoundMusicVolume());
              settings.save();
            }
            if (SFXVolumeSlider.button.isMouseOver()) {
              settings.setSoundSoundVolume(SFXVolumeSlider.getValue()/100.0,true);
              soundHandler.setSoundsVolume(settings.getSoundSoundVolume());
              settings.save();
              
            }
            if (narrationVolumeSlider.button.isMouseOver()) {
              settings.setSoundNarrationVolume(narrationVolumeSlider.getValue()/100.0,true);
              soundHandler.setNarrationVolume(settings.getSoundNarrationVolume());
              settings.save();

            }
            //narration mode buttons
            if (narrationMode0.isMouseOver()) {
              settings.setSoundNarrationMode(0);
              settings.save();
            }
            if (narrationMode1.isMouseOver()) {
              settings.setSoundNarrationMode(1);
              settings.save();
            }
            
          }//end of sound settings
          
          if (settingsMenue.equals("outher")) {//if on the other tab
            //when clicking on buttons update the approprate settings
            if (enableFPS.isMouseOver()) {
              settings.setDebugFPS(true);
              settings.save();
            }
            if (disableFPS.isMouseOver()) {
              settings.setDebugFPS(false);
              settings.save();
            }
            if (enableDebug.isMouseOver()) {
              settings.setDebugInfo(true);
              settings.save();
            }
            if (disableDebug.isMouseOver()) {
              settings.setDebugInfo(false);
              settings.save();
            }
            if (shadows4.isMouseOver()) {
              settings.setShadows(4);
              settings.save();
              requestDepthBufferInit = true;
            }
            if (shadows3.isMouseOver()) {
              settings.setShadows(3);
              settings.save();
              requestDepthBufferInit = true;
            }
            if (shadows2.isMouseOver()) {
              settings.setShadows(2);
              settings.save();
              requestDepthBufferInit = true;
            }
            if (shadows1.isMouseOver()) {
              settings.setShadows(1);
              settings.save();
            }
            if (shadows0.isMouseOver()) {
              settings.setShadows(0);
              settings.save();
            }
            
            if(enableMenuTransitionButton.isMouseOver()){
              settings.setDisableMenuTransitions(false);
              settings.save();
            }
            
            if(disableMenuTransistionsButton.isMouseOver()){
              settings.setDisableMenuTransitions(true);
              settings.save();
            }

            //process clicks on the default author text box
            defaultAuthorNameTextBox.mouseClicked();
            
          }//end of outher settings menue

          if (sttingsGPL.isMouseOver()){//gameplay button
            settingsMenue="game play";
            defaultAuthorNameTextBox.resetState();
          }
          if (settingsDSP.isMouseOver()){//dsiplay button
            settingsMenue="display";
            defaultAuthorNameTextBox.resetState();
          }
          if (settingsSND.isMouseOver()){//sound button
            settingsMenue="sound";
            defaultAuthorNameTextBox.resetState();
          }
          if (settingsOUT.isMouseOver()){//other button
            settingsMenue="outher";
          }

          if (settingsBackButton.isMouseOver()) {//back button
            defaultAuthorNameTextBox.resetState();
            if (prevousInGame) {//hanlde going back to the game if opened from inside a level
              Menue="pause";
              inGame=true;
              prevousInGame=false;
            } else {
              Menue ="main";
              menue=false;
              initMenuTransition(Transitions.SETTINGS_TO_MAIN);
            }
            stats.save();//save statistics
          }
        }

        //back button for the old how to play menu NOT REMOVING THIS!
        if (Menue.equals("how to play")) {//if that menu is how to play
          if (mouseX >= 40*Scale && mouseX <= 240*Scale && mouseY >= 610*Scale && mouseY <= 660*Scale) {//back button
            Menue ="main";
          }
        }

        if (Menue.equals("update")) {//if that menu is update
          updae_screen_click(); //check the update clicks
        }

        if (Menue.equals("downloading update")) {
          updateDownloadingScreenClick();
        }


        if (Menue.equals("multiplayer strart")) {//if the menu is multyplayer start
          if (multyplayerExit.isMouseOver()) {//exit button
            Menue="main";
          }
          if (multyplayerJoin.isMouseOver()) {//join button
            Menue="start join";
          }
          if (multyplayerHost.isMouseOver()) {//host button
            Menue="start host";
          }
        }
        
        if (Menue.equals("start host")) {//if the menu is setting up hosting
          if (multyplayerExit.isMouseOver()) {//bakc button
            Menue="main";
            multyPlayerNameTextBox.resetState();
            multyPlayerPortTextBox.resetState();
          }
          //hanlde text box mouse clicks
          multyPlayerNameTextBox.mouseClicked();
          multyPlayerPortTextBox.mouseClicked();
          
          if (multyplayerGo.isMouseOver()) {//go button
            name = multyPlayerNameTextBox.getContence();
            port = Integer.parseInt(multyPlayerPortTextBox.getContence());
            multyPlayerNameTextBox.resetState();//make sure the text boxes are not slected
            multyPlayerPortTextBox.resetState();
            
            isHost=true;
            Menue = "multiplayer selection";
            multiplayer = true;
            server = new Server(port);//start the multyplayer session
            players[0].name = name;
          }
          return;
        }//end f setting up hosting
        
        if (Menue.equals("start join")) {//if setting up joining
          if (multyplayerExit.isMouseOver()) {//back button
            Menue="main";
            multyPlayerNameTextBox.resetState();
            multyPlayerPortTextBox.resetState();
            multyPlayerIpTextBox.resetState();
          }
          
          //handle text box clicks
          multyPlayerNameTextBox.mouseClicked();
          multyPlayerPortTextBox.mouseClicked();
          multyPlayerIpTextBox.mouseClicked();
          
          if (multyplayerGo.isMouseOver()) {//go button
            name = multyPlayerNameTextBox.getContence();
            port = Integer.parseInt(multyPlayerPortTextBox.getContence());
            ip = multyPlayerIpTextBox.getContence();
            multyPlayerNameTextBox.resetState();//make sure the text boxes are not still active
            multyPlayerPortTextBox.resetState();
            multyPlayerIpTextBox.resetState();
            isHost=false;
            Menue="multiplayer selection";
            multiplayer=true;
            try {
              clients.add(new Client(new Socket(ip, port)));//try to connect to the server
            } catch(Exception c) {//if the connection failed 
              c.printStackTrace();//go to the disconnedeted screen
              multiplayer=false;
              Menue="disconnected";
              disconnectReason="failed to connect to server\n"+c.toString();
            }
            return;
          }
        }//end of setting up joining
        
        
        if (Menue.equals("disconnected")) {//if that menu is the disconnedted menu
          if (multyplayerExit.isMouseOver()) {//back button
            Menue="start join";
            multiplayer=false;
            currentPlayer=0;
          }
        }

        if (Menue.equals("dev")) {//if that menu is dev
          clickDevMenue();//handle clicks for the dev menu
          return;
        }
        
        if (Menue.equals("multiplayer selection")) {//if that menu is multyplayer selection  
          if (isHost) {//if you are the host
            if (multyplayerLeave.isMouseOver()) {//leave button
              println("quitting multyplayer host");
              server.end();//stop the server
              println("returning to main menu");
              Menue="main";
              multiplayer=false;
              waitingForReady=false;
              currentPlayer=0;
              return;
            }
            //this is the mouse side of the old terrible attempt at a resizable UI
            if (mouseX>=width*0.171875 && mouseX<= width*0.8 && mouseY >=height*0.09 && mouseY <=height*0.91666) {//if the mouse is in the area to select a level
              int slotSelected=(int)( (mouseY - height*0.09)/(height*0.8127777777/16));//calculate the slot selceted
              if (multyplayerSelectionLevels.equals("speed")) {//if on the speedrun tab
                if (slotSelected<=13) {//set speed run max levels here for selection
                  multyplayerSelectedLevelPath="data/levels/level-"+(slotSelected+1);
                  genSelectedInfo(multyplayerSelectedLevelPath, false);
                }
              }
              if (multyplayerSelectionLevels.equals("coop")) {//if on the co op tab
                if (slotSelected<=1) {// set co op max levels here for selection
                  multyplayerSelectedLevelPath="data/levels/co-op_"+(slotSelected+1);
                  genSelectedInfo(multyplayerSelectedLevelPath, false);
                }
              }
              if (multyplayerSelectionLevels.equals("UGC")) {//if on the UGC tab
                if (slotSelected<=UGCNames.size()-1) {// set co op max levels here for selection
                  multyplayerSelectedLevelPath=appdata+"/CBi-games/skinny mann/UGC/levels/"+UGCNames.get(slotSelected);
                  genSelectedInfo(multyplayerSelectedLevelPath, true);
                }
              }
              return;
            }//end of mouse clicked in the levels area
            
            if (multyplayerSelectedLevel.gameVersion!=null && gameVersionCompatibilityCheck(multyplayerSelectedLevel.gameVersion)) {//if the selected level is compatbale with this version of the game
              if (multyplayerPlay.isMouseOver()) {//if the play button is clicked
                if (!multyplayerSelectedLevel.isUGC) {//if the level is not UGC
                  if (multyplayerSelectedLevel.multyplayerMode==1) {//if in speedrun mode
                    LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevelPath);//make a level load request
                    for (int i=0; i<clients.size(); i++) {//send it to all the clients
                      clients.get(i).dataToSend.add(req);
                    }
                    loadLevel(multyplayerSelectedLevelPath);//load the level
                    waitingForReady=true;//be waiting for all clients to be readdy
                    bestTime=0;
                  }//end of speed run mode

                  if (multyplayerSelectedLevel.multyplayerMode==2) {//if in co-op mode
                    if (clients.size()+1 >= multyplayerSelectedLevel.minPlayers && clients.size()+1 <= multyplayerSelectedLevel.maxPlayers) {//if the number of players is within the allowed number
                      LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevelPath);//create a level load request
                      for (int i=0; i<clients.size(); i++) {//send it to all the clients
                        clients.get(i).dataToSend.add(req);
                      }
                      loadLevel(multyplayerSelectedLevelPath);//load the level
                      waitingForReady=true;//be waiting for all the clients to be readdy
                    }//end of good number of players
                  }//end of co - op mode
                } else {//if the level is UGC
                  if (multyplayerSelectedLevel.multyplayerMode==1) {//if in speedrun mode

                    loadLevel(multyplayerSelectedLevelPath);//load the level
                    LoadLevelRequest req = new LoadLevelRequest(multyplayerSelectedLevel.id, getLevelHash(multyplayerSelectedLevelPath));//create a level load request and calculate the level hash to send as well
                    for (int i=0; i<clients.size(); i++) {//send the request to all clients
                      clients.get(i).dataToSend.add(req);
                    }

                    waitingForReady=true;//be waiting for all the clients to be readdy
                    bestTime=0;
                  }//end of speed run mode

                  if (multyplayerSelectedLevel.multyplayerMode==2) {//if co-op mode
                    if (clients.size()+1 >= multyplayerSelectedLevel.minPlayers && clients.size()+1 <= multyplayerSelectedLevel.maxPlayers) {//if the number of players is within the allowed number
                      loadLevel(multyplayerSelectedLevelPath);//load the level
                      LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevel.id, getLevelHash(multyplayerSelectedLevelPath));//create a level load request and calculate the level hash to send as well
                      for (int i=0; i<clients.size(); i++) {//send the request to all clients
                        clients.get(i).dataToSend.add(req);
                      }

                      waitingForReady=true;//be waiting for all the clients to be readdy
                    }//end of good number of players
                  }//end of co - op mode
                }//end of UGC
              }//end of multyplayer play button
            }//end of level compable with this version
            
            if (multyplayerSelectedLevel.multyplayerMode==1) {//if the selected level is speed run
              if (increaseTime.isMouseOver()) {//increase time button
                sessionTime+=30000;
              }
              if (decreaseTime.isMouseOver()) {//decrease time button
                if (sessionTime>30000)
                  sessionTime-=30000;
              }
            }
            
            if (multyplayerCoop.isMouseOver()) {//coop button
              multyplayerSelectionLevels="coop";
            }
            if (multyplayerSpeedrun.isMouseOver()) {//speed run button
              multyplayerSelectionLevels="speed";
            }
            if (multyplayerUGC.isMouseOver()) {//UGC button
              multyplayerSelectionLevels="UGC";
              //load a list of all the UGC levels
              loadUGCList();
            }
          } else {//if joined
            if (multyplayerLeave.isMouseOver()) {//leave button
              println("quitting multyplayer joined");
              clientQuitting=true;
              clients.get(0).disconnect();
              println("returning to main menu");
              Menue="main";
              multiplayer=false;
              currentPlayer=0;
              return;
            }
			//as you can see there is not much if the player has joined
          }//end of joined
        }//end of multyplayer menu 

        if(Menue.equals("level complete")){
          if(levelCompleteScreenContinue.isMouseOver()){
            menue=true;
            inGame=false;
            Menue="level select";
            level_complete=false;
            coinCount=0;
            if (!UGC_lvl) {
              if (level.levelID>levelProgress.getJSONObject(0).getInt("progress")) {
                JSONObject p=new JSONObject();
                p.setInt("progress", levelProgress.getJSONObject(0).getInt("progress")+1);
                levelProgress.setJSONObject(0, p);
                saveJSONArray(levelProgress, appdata+"/CBi-games/skinny mann/progressions.json");
              }
            } else {
              UGC_lvl=false;
            }
          }
        }

        if(Menue.equals("high score")){
          highScoreMouseClicked();
        }
      }//end of in menu

      if (level_complete&&(level.multyplayerMode!=2||isHost)) {//if you completed a level and have not joined
        if (endOfLevelButton.isMouseOver()) {//continue button
          if (multiplayer) {//multyplayer version of the button
            menue=true;
            inGame=false;
            level_complete=false;
            Menue="multiplayer selection";
            returnToSlection();
          } else {//single player version of the button
            menue=true;
            inGame=false;
            Menue="level select";
            level_complete=false;
            coinCount=0;
            if (!UGC_lvl) {//if the level was not UGC
              if (level.levelID>levelProgress.getJSONObject(0).getInt("progress")) {//if the level ID was greater then your level progress
                JSONObject p=new JSONObject();//increease your level progress by 1
                p.setInt("progress", levelProgress.getJSONObject(0).getInt("progress")+1);
                levelProgress.setJSONObject(0, p);
                saveJSONArray(levelProgress, appdata+"/CBi-games/skinny mann/progressions.json");
              }
            } else {//if it was UGC
              UGC_lvl=false;//set UGC level to false
            }
            stats.incrementLevelsCompleted();//adjust stats
            stats.save();
          }
        }
      }//end of level complete
      
    } else {//if in level creator
      if (mouseButton==LEFT) {//if the button pressed was the left button
        //System.out.println(mouseX+" "+mouseY);//print the location the mouse clicked to the console
        if (startup) {//if on the startup screen
          if (newLevelButton.isMouseOver()) {//new level button
            startup=false;
            newLevel=true;
            rootPath="";
            lcEnterLevelTextBox.setContence("");
            lcEnterLevelTextBox.activate();
            return;
          }
          if (loadLevelButton.isMouseOver()) {//load level button
            startup=false;
            loading=true;
            rootPath="";
            lcEnterLevelTextBox.setContence("");
            lcEnterLevelTextBox.activate();
            return;
          }
          if (newBlueprint.isMouseOver()) {//new blurprint button
            startup=false;
            creatingNewBlueprint=true;
            new_name="my blueprint";
            lcEnterLevelTextBox.setContence("my blueprint");
            lcEnterLevelTextBox.activate();
            return;
          }
          if (loadBlueprint.isMouseOver()) {//load blueprint button
            startup=false;
            loadingBlueprint=true;
            new_name="";
            lcEnterLevelTextBox.setContence("");
            lcEnterLevelTextBox.activate();
            return;
          }
          if (lc_backButton.isMouseOver()) {//exit level creator button
            levelCreator=false;
          }
        }
        if (loading) {//if loading level
          lcEnterLevelTextBox.mouseClicked();
          if (lcLoadLevelButton.isMouseOver()) {//load button
          JSONArray mainIndex = null;
          rootPath = lcEnterLevelTextBox.getContence();
            try {//attempt to load the level
              String tmp=rootPath;
              rootPath=appdata+"/CBi-games/skinny mann level creator/levels/"+rootPath;
              boolean exsists=new File(rootPath+"/index.json").exists();//check if the level even exsists
              if (!exsists) {
                levelNotFound=true;
                rootPath=tmp;
                return;
              }
              mainIndex=loadJSONArray(rootPath+"/index.json");
              lcEnterLevelTextBox.resetState();
              loading=false;
              levelOverview=true;
              levelNotFound=false;
            } catch(Throwable e) {//do nothings if loading fails
              e.printStackTrace();
            }
            
            level=new Level(mainIndex);//load the level
            level.logicBoards.get(level.loadBoard).superTick();//run the level load board
            if (level.multyplayerMode==2) {//set the number of players if in co-op mode
              currentNumberOfPlayers=level.maxPLayers;
            }
            return;
          }
          
          if (lc_backButton.isMouseOver()) {//back button
            startup=true;
            loading=false;
            lcEnterLevelTextBox.resetState();
          }
          
          if (lc_openLevelsFolder.isMouseOver()) {//open folder button
            openLevelCreatorLevelsFolder();
          }
        }
        
        if (newLevel) {//if creating a new level
          lcEnterLevelTextBox.mouseClicked();
          if (lcNewLevelButton.isMouseOver()) {//create button
            new_name = lcEnterLevelTextBox.getContence();
            newLevel=false;
            rootPath=appdata+"/CBi-games/skinny mann level creator/levels/"+new_name;
            JSONArray mainIndex=new JSONArray();//set up a new level
            JSONObject terain = new JSONObject();//create all the basic into nessarry for a new level
            terain.setInt("level_id", (int)(Math.random()*1000000000%999999999));
            terain.setString("name", new_name);
            terain.setString("game version", GAME_version);
            terain.setFloat("spawnX", 20);
            terain.setFloat("spawnY", 700);
            terain.setFloat("spawn pointX", 20);
            terain.setFloat("spawn pointY", 700);
            terain.setInt("mainStage", -1);
            terain.setInt("coins", 0);
            terain.setString("author", author);
            mainIndex.setJSONObject(0, terain);//put that info into a JOSN Array
            levelOverview=true;
            level=new Level(mainIndex);//load that new level
            level.save(true);//save the level to disc
            lcEnterLevelTextBox.resetState();
            return;
          }
          
          if (lc_backButton.isMouseOver()) {//back button
            startup=true;
            newLevel=false;
            lcEnterLevelTextBox.resetState();
          }
          
          if (lc_openLevelsFolder.isMouseOver()) {//open folder button
            openLevelCreatorLevelsFolder();
          }
        }
        
        if (!e3DMode){
          GUImouseClicked();//level editor gui clicking code
        } else {
          mouseClicked3D();//3D level editor GUI clicking code
        }



        if (levelOverview) {//if on level overview
          if (newStage.isMouseOver()) {//if the new file button is clicked
            levelOverview=false;
            newFile=true;
            lcNewFileTextBox.setContence("");
            lcNewFileTextBox.activate();
            return;
          }
          if (mouseY>80*Scale) {//if the mouse is in the files section of the screen
            overviewSelection=(int)(mouseY/Scale-80)/60+ filesScrole;//figure out witch thing to select
            if (overviewSelection>=level.stages.size()+level.sounds.size()+level.logicBoards.size()) {//de seclect if there was nothing under where the click happend
              overviewSelection=-1;
            }
          }

          if (overview_saveLevel.isMouseOver()) {//save button in the level overview
            System.out.println("saving level");
            level.save(true);
            gmillis=millis()+400;//glitch effect
            System.out.println("save complete");
          }
          
          if (help.isMouseOver()) {//help button in the level overview
            link("https://youtu.be/Ufn94mrjz8s");//tutorial video
          }
          
          if (overviewSelection!=-1) {//if something is selected
            if (overviewSelection<level.stages.size()) {//if the selection is in rage of the stages
              if (level.stages.get(overviewSelection).type.equals("stage")) {//if the selected thing is a stage
                if (edditStage.isMouseOver()) {//eddit stage button
                  editingStage=true;
                  levelOverview=false;
                  currentStageIndex=overviewSelection;
                  respawnStage=currentStageIndex;
                }

                if (setMainStage.isMouseOver()) {//set main stage button
                  level.mainStage=overviewSelection;
                  background(0);
                  settingPlayerSpawn=true;
                  levelOverview=false;
                  editingStage=true;
                  currentStageIndex=overviewSelection;
                  respawnStage=currentStageIndex;
                  return;
                }
              }
              
              if (level.stages.get(overviewSelection).type.equals("3Dstage")) {//if the selected thing is a 3D stage
                if (edditStage.isMouseOver()) {//eddit button
                  editingStage=true;
                  levelOverview=false;
                  currentStageIndex=overviewSelection;
                  respawnStage=currentStageIndex;
                }
              }
            }//end if if selection is in range of the stages
            
            if (overviewSelection>=level.stages.size()+level.sounds.size()) {//if the selecion is in the logic board range
              if (edditStage.isMouseOver()) {//eddit button
                levelOverview=false;
                editinglogicBoard=true;
                logicBoardIndex=overviewSelection-(level.stages.size()+level.sounds.size());
                camPos=0;
                camPosY=0;
              }
            }
          }//end of if something is selected

          if (filesScrole>0&&overviewUp.isMouseOver()){//scroll up button
            filesScrole--;
          }
          if (filesScrole+11<level.stages.size()+level.sounds.size()+level.logicBoards.size()&&overviewDown.isMouseOver()){//scroll down button
            filesScrole++;
          }

          if (lcOverviewExitButton.isMouseOver()) {//exit level creator button
            levelOverview=false;
            exitLevelCreator=true;
          }
        }//end of level overview

        if (newFile) {//if on the new file page
          lcNewFileTextBox.mouseClicked();//process clicks on the text box
          if (newFileBack.isMouseOver()) {//back button
            levelOverview=true;
            newFile=false;
            lcNewFileTextBox.resetState();
          }

          if (newFileCreate.isMouseOver()) {//create button
            if (lcNewFileTextBox.getContence().isEmpty()) {//if no name has been entered
              return;
            }
            if (newFileType.equals("sound")) {//if the type that is selected is sound
              if (fileToCoppyPath.equals("")) {//if no file is selected
                return;
              }
              String pathSegments[]=fileToCoppyPath.split("/|\\\\");//split the file path at directory seperator
              try {//attempt to coppy the file
                System.out.println("attempting to coppy file");
                java.nio.file.Files.copy(new File(fileToCoppyPath).toPath(), new File(rootPath+"/"+pathSegments[pathSegments.length-1]).toPath());
              } catch(IOException i) {
                i.printStackTrace();
                return;
              }
              System.out.println("adding sound to level");
              String newFileName = lcNewFileTextBox.getContence();
              level.sounds.put(newFileName, new StageSound(newFileName, "/"+pathSegments[pathSegments.length-1],newSoundAsNarration));//add the sound to the level
              System.out.println("saving level");
              level.save(true);//save the level
              gmillis=millis()+400;///glitch effect
              System.out.println("save complete"+gmillis);
              newFile=false;//return back to the obverview
              fileToCoppyPath="";
              levelOverview=true;
              lcNewFileTextBox.resetState();
              return;
            }
            currentStageIndex=level.stages.size();//set the current stage to the new stage
            respawnStage=currentStageIndex;
            if (newFileType.equals("2D")) {//create the approriate type of stage based on what is selectd
              level.stages.add(new Stage(lcNewFileTextBox.getContence(), "stage"));
            }
            if (newFileType.equals("3D")) {//create the approriate type of stage based on what is selectd
              level.stages.add(new Stage(lcNewFileTextBox.getContence(), "3Dstage"));
            }

            editingStage=true;
            newFile=false;
            lcNewFileTextBox.resetState();
          }
          
          if (newFileType.equals("sound")) {
            if (chooseFileButton.isMouseOver()) {//choose file button for when the type is sound
              selectInput("select audio file: .WAV .AIF .MP3:", "fileSelected");//open file selection diaglog
            }
            if(lc_newSoundAsSoundButton.isMouseOver()){//sound button
              newSoundAsNarration=false;
            }
            if(lc_newSoundAsNarrationButton.isMouseOver()){//narration button
              newSoundAsNarration=true;
            }
          }

          if (new3DStage.isMouseOver()) {//3D stage button
            newFileType="3D";
          }
          if (new2DStage.isMouseOver()) {//2D stage Button
            newFileType="2D";
          }
          if (addSound.isMouseOver()) {//sound type buttpn
            newFileType="sound";
          }
        }
        if (drawingPortal2) {//if placing portal part 2 (part that has the overview)

          if (mouseY>80*Scale) {//select the file that was clicked on in the overview
            overviewSelection=(int)(mouseY/Scale-80)/60+ filesScrole;
            if (overviewSelection>=level.stages.size()+level.sounds.size()) {
              overviewSelection=-1;
            }
          }

          if (overviewSelection!=-1) {//if something is selected
            if (overviewSelection<level.stages.size()) {//if the selection is in rage of the stages
              if (level.stages.get(overviewSelection).type.equals("stage")||level.stages.get(overviewSelection).type.equals("3Dstage")) {//if the selected thing is a valid destination stage
                if (selectStage.isMouseOver()) {//if the select stagge button is clicked
                  editingStage=true;//go to that stage
                  levelOverview=false;
                  drawingPortal2=false;
                  drawingPortal3=true;
                  camPos=0;
                  currentStageIndex=overviewSelection;
                }
              }
            }//end of if in stage range
          }
          if (filesScrole>0&&overviewUp.isMouseOver())//scroll up button
            filesScrole--;
          if (filesScrole+11<level.stages.size()+level.sounds.size()&&overviewDown.isMouseOver())//scroll down button
            filesScrole++;
        }//end of drawing portal 2

        if (creatingNewBlueprint) {//if creating a new blueprint
          lcEnterLevelTextBox.mouseClicked();//handle text box clicks
          if (createBlueprintGo.isMouseOver()) {//create button
            new_name = lcEnterLevelTextBox.getContence();
            if (new_name!=null&&!new_name.equals("")) {//if something was entered
              if(newBlueprintIs3D){
                workingBlueprint=new Stage(new_name, "3D blueprint");//creat and load the new blueprint
              }else{
                workingBlueprint=new Stage(new_name, "blueprint");//creat and load the new blueprint
              }
              lcEnterLevelTextBox.resetState();
              creatingNewBlueprint=false;
              editingBlueprint=true;
              camPos=-640;
              camPosY=360;
              rootPath=System.getenv("appdata")+"/CBi-games/skinny mann level creator/blueprints";
              
            }//end of name was enterd
          }//end of create button
          if (lc_backButton.isMouseOver()) {
            startup=true;
            creatingNewBlueprint=false;
            lcEnterLevelTextBox.resetState();
          }
          if (new3DStage.isMouseOver()) {//buttons to set type
            newBlueprintIs3D=true;
          }
          if (new2DStage.isMouseOver()) {
            newBlueprintIs3D=false;
          }
        }//end of creating new bluepint

        if (loadingBlueprint) {//if loading blueprint
        lcEnterLevelTextBox.mouseClicked();
          if (createBlueprintGo.isMouseOver()) {//load button
          new_name = lcEnterLevelTextBox.getContence();
            if (new_name!=null&&!new_name.equals("")) {//if something was entered
              rootPath = appdata + "/CBi-games/skinny mann level creator/blueprints";
              workingBlueprint = new Stage(loadJSONArray(rootPath+"/"+new_name+".json"));//load the blueprint
              lcEnterLevelTextBox.resetState();
              loadingBlueprint = false;
              editingBlueprint = true;
              camPos = -640;
              camPosY = 360;
            }//end of thing were entered
          }//end of load button
          if (lc_backButton.isMouseOver()) {//back button
            startup=true;
            loadingBlueprint=false;
            lcEnterLevelTextBox.resetState();
          }
        }//end of loading blueprint
        
        if (editinglogicBoard) {
          //add new logic component to the current logic board
          if(currentlyPlaceing != null){
            LogicCompoentnPlacementContext placementContext = new LogicCompoentnPlacementContext(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex));//create the placement info
            Function<LogicCompoentnPlacementContext,LogicComponent> constructor = LogicComponentRegistry.getPlacementConstructor(currentlyPlaceing);//get the object constructor
            if(constructor != null){
              level.logicBoards.get(logicBoardIndex).components.add(constructor.apply(placementContext));//create the new compoentn and add it to the logic board
            }
          }
          
          if (deleteing) {//if deleteing componetns
            for (int i=0; i< level.logicBoards.get(logicBoardIndex).components.size(); i++) {//loop through all the components on this board
              if (level.logicBoards.get(logicBoardIndex).components.get(i).button.isMouseOver()) {//if the mouse was over this one
                level.logicBoards.get(logicBoardIndex).remove(i);//delete it
                return;
              }
            }
          }
          
          if (selecting) {//if selecting componentss
            for (int i=0; i< level.logicBoards.get(logicBoardIndex).components.size(); i++) {//loop through all the components on this board
              if (level.logicBoards.get(logicBoardIndex).components.get(i).button.isMouseOver()) {//if the mouse was over this one
                selectedIndex=i;//set this one as selected
              }
            }
          }
        }//end of edditing logic board

        if (settingPlayerSpawn) {//if a request to set the player spawn as been made
          level.SpawnX=mouseX/Scale+camPos;//set the spawn to where the mouse is
          level.SpawnY=mouseY/Scale-camPosY;
          level.RewspawnX=mouseX/Scale+camPos;
          level.RespawnY=mouseY/Scale-camPosY;
          settingPlayerSpawn=false;
        }
        
        if (exitLevelCreator) {//if on the exiting level creator 
          if (lc_exitConfirm.isMouseOver()) {//exit button
            exitLevelCreator=false;
            levelCreator=false;
            inGame=false;
            menue=true;
          }

          if (lc_exitCancle.isMouseOver()) {//cancle exit button
            exitLevelCreator=false;
            levelOverview=true;
          }
        }
      }//end of left mouse button clicked
    }//end of level creator
  }
  catch(Throwable e) {//if any errors occor
    handleError(e);//display the error and close the game
  }
}


/**Automatically called when a key is pressed down and this window is active.<br>
Executes on the render thread.
*/
void keyPressed() {// when a key is pressed
  try {
    if (!menue && tutorialMode && key == ESC && tutorialPos<3) {//if escape is pressed and in the start of the turial
      exit(1);//close the game
    }

    if (inGame || (levelCreator && editingStage && simulating)) {//if in game or in the level creator editing a stage and not paused
      if (key == ESC && !levelCreator) {//if escape and not in the level creator
        key = 0;  //clear the key so it doesnt close the program
        menue=true;//open the pause menu
        Menue="pause";
      }
      if (keyCode==65) {//if A is pressed
        playerMovementManager.setLeft(true);
      }
      if (keyCode==68) {//if D is pressed
        playerMovementManager.setRight(true);
      }
      if (keyCode==32) {//if space is pressed
        playerMovementManager.setJump(true);
      }
      if (dev_mode) {//if in dev mode
        if (keyCode==81) {//if q is pressed print the player position
          System.out.println(players[currentPlayer].getX()+" "+players[currentPlayer].getY());
        }
      }
      if (key=='e'||key=='E') {//if E is pressed
        E_pressed=true;
      }
      if (keyCode==87) {//if W is pressed
        playerMovementManager.setIn(true);
      }
      if (keyCode==83) {//if S is pressed
        playerMovementManager.setOut(true);
      }
      if (e3DMode) {//if in 3D mode
        //level creator camera controlls
        if (keyCode==65) {//if 'A' is pressed
          a3D=true;
        }
        if (keyCode==68) {//if 'D' is pressed
          d3D=true;
        }
        if (keyCode==32) {//if SPACE is pressed
          space3D=true;
        }
        if (keyCode==16) {//if 'SHIFT' is pressed
          shift3D=true;
        }
        if (keyCode==87) {//if 'W' is pressed
          w3D=true;
          key = 0;//clear key so CTRL + W doesent close the program
        }
        if (keyCode==83) {//if 'S' is pressed
          s3D=true;
        }
        if (keyCode==37) {//if LEFT ARROW is pressed
          cam_left=true;
        }
        if (keyCode==39) {//if RIGHT ARROW is pressed
          cam_right=true;
        }
        if (keyCode==38) {//if UP ARROW is pressed
          cam_up=true;
        }
        if (keyCode==40) {//if DOWN ARROW is pressed
          cam_down=true;
        }
      }
    }
    
    if (menue && !levelCreator) {//if in a menu and not in the level creator
      if (Menue.equals("level select")) {//if on the level select screen
        if (key == ESC) {//if escape
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
      }
      
      if (Menue.equals("level select UGC")) {//if on the UGC screen
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="level select";
        }
      }
      
      if (Menue.equals("settings")) {//if on the seettings screen
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          defaultAuthorNameTextBox.resetState();
          if (prevousInGame) {
            Menue="pause";
            inGame=true;
            prevousInGame=false;
          } else {
            Menue ="main";
          }
        }
        
        if (settingsMenue.equals("outher")) {//if the setting tab is other
          defaultAuthorNameTextBox.keyPressed();//process the text box
          if(!defaultAuthorNameTextBox.getContence().equals(defaultAuthor)){//change the default author if it has changed
            String newName =  defaultAuthorNameTextBox.getContence();
            
            if(!newName.isEmpty()){
              defaultAuthor = newName;
            }else{
              defaultAuthor = "can't be botherd to change it";
            }
            settings.setDefaultAuthor(defaultAuthor);
            settings.save();
          }
        }
      }
      
      if (Menue.equals("how to play")) {//if on the old how to play menu
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
      }
      
      if (Menue.equals("main")) {//if on the main menu
        if (key == ESC){
          exit(0);//close the program
        }
      }
      
      if (Menue.equals("start host")) {//if on the setting up hosting menu
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
        //handle typing in the text boxes
        multyPlayerNameTextBox.keyPressed();
        multyPlayerPortTextBox.keyPressed();
      }
      
      if (Menue.equals("start join")) {//if on the setting up joining menu
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
        //hanlde typing in the text boxes
        multyPlayerNameTextBox.keyPressed();
        multyPlayerPortTextBox.keyPressed();
        multyPlayerIpTextBox.keyPressed();
      }
    }
    
    if (levelCreator) {//if in the level creator
      if (key == ESC){//blanket eat the escape key
        key=0;
        return;  
      }
      
      if (editingStage||editingBlueprint) {//if edditng a stage
        if (key=='r'||key=='R') {//if 'R' is pressed
          triangleMode++;//increase the current rotation
          if (triangleMode==4)//reset if rotation os over max
            triangleMode=0;
        }
      }
      
      if(loading || newLevel || creatingNewBlueprint || loadingBlueprint){//if on any of the loading / new setup screens
        lcEnterLevelTextBox.keyPressed();//handle typing in that text box
      }

      
      if (newFile) {//if new file
        lcNewFileTextBox.keyPressed();//hanle typing in that text box
      }

      if (startup) {//if on the main menue
        author = getInput(author, 0);//typing for the author name
      }
      
      //this shit is redundent
      if (!simulating||editinglogicBoard||e3DMode) {//if the simulation is paused
        if (keyCode==37) {//if LEFT ARROW is pressed
          cam_left=true;
        }
        if (keyCode==39) {//if RIGHT ARROW is pressed
          cam_right=true;
        }
        if (keyCode==38) {//if UP ARROW is pressed
          cam_up=true;
        }
        if (keyCode==40) {//if DOWN ARROW is pressed
          cam_down=true;
        }
      }//end of if sumilating
      if (!simulating&&e3DMode) {
        if (keyCode==65) {//if 'A' is pressed
          a3D=true;
        }
        if (keyCode==68) {//if 'D' is pressed
          d3D=true;
        }
        if (keyCode==32) {//if SPACE is pressed
          space3D=true;
        }
        if (keyCode==16) {//if 'SHIFT' is pressed
          shift3D=true;
        }
        if (keyCode==87) {//if 'W' is pressed
          w3D=true;
          key = 0;//clear key so CTRL + W doesent close the program
        }
        if (keyCode==83) {//if 'S' is pressed
          s3D=true;
        }
      }//end of not simulating and in 3D
    }//end of level creator

    if(keyCode == 108 && dev_mode){//F12 and dev mode
      showDepthBuffer = !showDepthBuffer;//toggle viewing the depth buffer
    }
    if(keyCode == 107 && dev_mode){//F11 and dev mode
      shadowShaderOutputSampledDepthInfo = !shadowShaderOutputSampledDepthInfo;//toggle rednering depth buffer value on level instread of correct colors
    }
    if(keyCode == 106 && dev_mode){//F10 and dev mode
      shadowShader = loadShader("data/shaders/shadowMapFrag.glsl","data/shaders/shadowMapVert.glsl");//reload shadow shader
      println("Relaoded Shaders");
    }
    
    //System.out.println(keyCode);
    if (key=='b'||key=='B') {
      println("p");
    }
  }catch(Throwable e) {//if an error occors
    handleError(e);//display the error and close the program
  }
}

/**Automatically called when a key is released and this window is active.<br>
Executes on the render thread.
*/
void keyReleased() {//when you release a key
  try {
    if (inGame || (levelCreator && editingStage)) {//when in a level or when in the level creator and editng a stage
      //update movement manager inputs
      if (keyCode==65) {//if A is released
        playerMovementManager.setLeft(false);
      }
      if (keyCode==68) {//if D is released
        playerMovementManager.setRight(false);
      }
      if (keyCode==32) {//if SPACE is released
        playerMovementManager.setJump(false);
      }
      if (key=='e'||key=='E') {
        E_pressed=false;
      }
      if (keyCode==87) {//w
        playerMovementManager.setIn(false);
      }
      if (keyCode==83) {//s
        playerMovementManager.setOut(false);
      }
      
      if (e3DMode) {//if in 3D mode
        if (keyCode==65) {//if 'A' is pressed
          a3D=false;
        }
        if (keyCode==68) {//if 'D' is pressed
          d3D=false;
        }
        if (keyCode==32) {//if SPACE is pressed
          space3D=false;
        }
        if (keyCode==16) {//if 'SHIFT' is pressed
          shift3D=false;
        }
        if (keyCode==87) {//if 'W' is pressed
          w3D=false;
          key = 0;//clear key so CTRL + W doesent close the program
        }
        if (keyCode==83) {//if 'S' is pressed
          s3D=false;
        }
        if (keyCode==37) {//if LEFT ARROW released
          cam_left=false;
        }
        if (keyCode==39) {//if RIGHT ARROW released
          cam_right=false;
        }
        if (keyCode==38) {//if UP ARROW released
          cam_up=false;
        }
        if (keyCode==40) {//if DOWN ARROW released
          cam_down=false;
        }
      }
    }

    if (levelCreator) {//when in the level creator
      if(loading || newLevel || creatingNewBlueprint || loadingBlueprint){//when on one of the new / loading screens
        lcEnterLevelTextBox.keyReleased();//process key releases for that text box
      }
      
      if(newFile){//if adding something new to the stage
        lcNewFileTextBox.keyReleased();//process key release for that text box
      }
      if (!simulating || editinglogicBoard || e3DMode) {//this seems to be for the logic boards as the pervous section hanldes all insatces of being in the stage editor
        if (keyCode==37) {//if LEFT ARROW released
          cam_left=false;
        }
        if (keyCode==39) {//if RIGHT ARROW released
          cam_right=false;
        }
        if (keyCode==38) {//if UP ARROW released
          cam_up=false;
        }
        if (keyCode==40) {//if DOWN ARROW released
          cam_down=false;
        }
      }//end of simulation pasued
      if (!simulating&&e3DMode) { // this again seems to be redundent
        if (keyCode==65) {//if 'A' is pressed
          a3D=false;
        }
        if (keyCode==68) {//if 'D' is pressed
          d3D=false;
        }
        if (keyCode==32) {//if SPACE is pressed
          space3D=false;
        }
        if (keyCode==16) {//if 'SHIFT' is pressed
          shift3D=false;
        }
        if (keyCode==87) {//if 'W' is pressed
          w3D=false;
          key = 0;//clear key so CTRL + W doesent close the program
        }
        if (keyCode==83) {//if 'S' is pressed
          s3D=false;
        }
      }
    }
    
    if(menue){//if in a menu
      if (Menue.equals("settings")) {//if that menu is settings
        if (settingsMenue.equals("outher")) {//if the setting tab is other
          defaultAuthorNameTextBox.keyReleased();//process key releases for the default author text box
        }
      }
      //process key releases on the text boxes for the start multyplayer screeness
      if (Menue.equals("start host")) {
        multyPlayerNameTextBox.keyReleased();
        multyPlayerPortTextBox.keyReleased();
      }
      
      if (Menue.equals("start join")) {
        multyPlayerNameTextBox.keyReleased();
        multyPlayerPortTextBox.keyReleased();
        multyPlayerIpTextBox.keyReleased();
      }
    }
  } catch(Throwable e) {//if an error occors
    handleError(e);//display the error and close the program
  }
}

/**Automatically called when a key is pressed down, this window is active, and the charater is a regular typeable charaters(ie not shift, ctrl, alt ect...)<br>
Executes on the render thread.
*/
void keyTyped(){
  if(menue){//if in a menu
    if (Menue.equals("settings")) {//if that menu is settings
      if (settingsMenue.equals("outher")) {//if the setting tab is other
        defaultAuthorNameTextBox.keyTyped();//process key typing for the default euthor text box
        if(!defaultAuthorNameTextBox.getContence().equals(defaultAuthor)){//save the new name if a change was made
          String newName =  defaultAuthorNameTextBox.getContence();
          
          if(!newName.isEmpty()){
            defaultAuthor = newName;
          }else{
            defaultAuthor = "can't be botherd to change it";
          }
          settings.setDefaultAuthor(defaultAuthor);
          settings.save();
        }
      }
    }
    //process typing on the text boxes for the start multyplayer screens
    if (Menue.equals("start host")) {
      multyPlayerNameTextBox.keyTyped();
      multyPlayerPortTextBox.keyTyped();
    }
    if (Menue.equals("start join")) {
      multyPlayerNameTextBox.keyTyped();
      multyPlayerPortTextBox.keyTyped();
      multyPlayerIpTextBox.keyTyped();
    }
  }
  
  if(levelCreator){//if in the level creator
    if(loading || newLevel || creatingNewBlueprint || loadingBlueprint){//if on the new / load screens
      lcEnterLevelTextBox.keyTyped();//hanld typing for that text box
    }
    
    if(newFile){//if adding a new file to a level
      lcNewFileTextBox.keyTyped();//hanle typing for that text box
    }
  }
}

/**Automaticaly called when the mouse is being clicked and dragged withing the window. This triggers oftain while this is happening.<br>
Executes on the render thread.
*/
void mouseDragged() {
  try {
    if (!levelCreator) {//when not in the level creator
      if (Menue.equals("settings")) {     //if that menue is settings
        //hanle dragging arround all the sliders in the settings menu
        if (settingsMenue.equals("game play")) {
          verticleEdgeScrollSlider.mouseDragged();
          horozontalEdgeScrollSlider.mouseDragged();
          fovSlider.mouseDragged();
          if (horozontalEdgeScrollSlider.button.isMouseOver()) {
            settings.setScrollHorozontal((int)horozontalEdgeScrollSlider.getValue(),false);
            settings.save();
          }

          if (verticleEdgeScrollSlider.button.isMouseOver()) {
              settings.setScrollVertical((int)verticleEdgeScrollSlider.getValue(),false);
              settings.save();
          }
          if(fovSlider.button.isMouseOver()){
            settings.setFOV(fovSlider.getValue(),false);
            settings.save();
          }
        }
        
        if (settingsMenue.equals("sound")) {
            
          musicVolumeSlider.mouseDragged();
          SFXVolumeSlider.mouseDragged();
          narrationVolumeSlider.mouseDragged();
          
          if (musicVolumeSlider.button.isMouseOver()) {
            settings.setSoundMusicVolume(musicVolumeSlider.getValue()/100.0,false);
            soundHandler.setMusicVolume(settings.getSoundMusicVolume());
            settings.save();
          }
          if (SFXVolumeSlider.button.isMouseOver()) {
            settings.setSoundSoundVolume(SFXVolumeSlider.getValue()/100.0,false);
            soundHandler.setSoundsVolume(settings.getSoundSoundVolume());
            settings.save();
          }
          if (narrationVolumeSlider.button.isMouseOver()) {
            settings.setSoundNarrationVolume(narrationVolumeSlider.getValue()/100.0,false);
            soundHandler.setNarrationVolume(settings.getSoundNarrationVolume());
            settings.save();
          }
        }
      }
    }
  }catch(Throwable e) {//if an error occors
    handleError(e);//display the error and close the program
  }
}

void updateSettingsFromSliderValues(){
  settings.setScrollHorozontal((int)horozontalEdgeScrollSlider.getValue(),false);
  settings.setScrollVertical((int)verticleEdgeScrollSlider.getValue(),false);


  

  settings.setSoundMusicVolume(musicVolumeSlider.getValue()/100.0,false);
  soundHandler.setMusicVolume(settings.getSoundMusicVolume());

  
  settings.setSoundSoundVolume(SFXVolumeSlider.getValue()/100.0,false);
  soundHandler.setSoundsVolume(settings.getSoundSoundVolume());

  settings.setSoundNarrationVolume(narrationVolumeSlider.getValue()/100.0,false);
  soundHandler.setNarrationVolume(settings.getSoundNarrationVolume());
  
  settings.setFOV(fovSlider.getValue(),false);

}


/**Automaticaly called when the window gets resized.<br>
Executes on the render thread.
*/
void windowResized() {
  ui.reScale();//have the Ui frame recaluate its scale and position
  Scale = height/720.0;//recalcualte the 2D level scale
}

/**Load a given level
@param path The file path of the level folder
*/
void loadLevel(String path) {
  soundHandler.dumpLS();//unload any sounds from the prevous level and let them be garbage collected
  try {
    reachedEnd=false;
    rootPath=path;//load the level
    JSONArray mainIndex=loadJSONArray(rootPath+"/index.json");
    level=new Level(mainIndex);
    level.logicBoards.get(level.loadBoard).superTick();//run the load logic board
    startTime = millis();
  } catch(Throwable e) {
    handleError(e);
  }
}

/**Physics thread
*/
void thrdCalc2() {

  //while the thread should be active
  while (loopThread2) {
    //calculate how long has passed since the last time the loop started
    curMills=millis();
    mspc=curMills-lasMills;
	//process controlller inputs
    ReadController.read(gamepad);
    handleControllerState();

    //run tutorial logic if in the tutorial
    if (tutorialMode) {
      tutorialLogic();
    }
    //if in game or in the levelcreator while editing a stage
    if (inGame||(levelCreator&&editingStage)) {
      //calcualte a frame of player physics
      try {
        playerPhysics();
      } catch(Throwable e) {//if an error occors, just print it to the console and move on
        e.printStackTrace();
      }
    } else {
      if (logicTickingThread.isAlive()) {//if the ticking thread is running when we dont want it to be
        logicTickingThread.shouldRun=false;//then stop it
      }
      random(10);//some how make it so processing doesent stop the thread(also increase CPU useage :D )
    }
    lasMills = curMills;
    //println(mspc);
  }
}

/**Automaticaly called every time a mouse button is pressed down while this window is activated.<br>
Execuated on the render thread.
*/
void mousePressed() {
  if (levelCreator) {//if in the level creator
    if (mouseButton==LEFT) {//if the button is the left button
      if (editingStage||editingBlueprint) {//if edditing a stage or blueprint
        GUImousePressed();
      }
      if (editinglogicBoard) {//if editing a logic board
        if (connectingLogic) {//if connecting logic terminals
          LogicBoard board=level.logicBoards.get(logicBoardIndex);//get the current logic board
          for (int i=0; i<board.components.size(); i++) {//check all the terminals to see if the mouse if over any of them
            float[] nodePos=board.components.get(i).getTerminalPos(2);
            if (Math.sqrt(Math.pow(nodePos[0]-mouseX/Scale, 2)+Math.pow(nodePos[1]-mouseY/Scale, 2))<=10) {
              connecting=true;//if the mouse is over any of them, then set this as the one to start connecting from
              connectingFromIndex=i;
              return;
            }
          }
        }
        
        if (moveLogicComponents) {//if moving logic components
          LogicBoard board=level.logicBoards.get(logicBoardIndex);//get the logic board
          for (int i=0; i<board.components.size(); i++) {//check if the mouse of over a component
            if (board.components.get(i).button.isMouseOver()) {
              movingLogicIndex=i;//if so then set this one as the one that is being moved
              movingLogicComponent=true;
              return;
            }
          }
        }
      }//end of editng logic board
      
      StageComponent ct = null;
      if (e3DMode && selectedIndex != -1) {//if in 3D mode and selecting something
        //get that thing
        if (editingStage) {
          ct = level.stages.get(currentStageIndex).parts.get(selectedIndex);
        }
        if (editingBlueprint) {
          ct = workingBlueprint.parts.get(selectedIndex);
        }
        
        for (int i=0; i<5000; i++) {//ray cast from the camera
          Point3D testPoint=genMousePoint(i);
          if(!(current3DTransformMode == 3 && ct instanceof Rotatable)){//if not rotate mmode
            PVector center = ct.getCenter();//get the center position
            //if the mouse was over one of the z-axis poles
            if (testPoint.x >= center.x-5 && testPoint.x <= center.x+5 && testPoint.y >= center.y-5 && testPoint.y <= center.y+5 && testPoint.z >= center.z+ct.getDepth()/2 && testPoint.z <= center.z+ct.getDepth()/2+60) {
              translateZaxis=true;
              transformComponentNumber=1;
              break;
            }
            //if the mouse was over one of the z-axis poles
            if (testPoint.x >= center.x-5 && testPoint.x <= center.x+5 && testPoint.y >= center.y-5 && testPoint.y <= center.y+5 && testPoint.z >= center.z-ct.getDepth()/2-60 && testPoint.z <= center.z-ct.getDepth()/2) {
              translateZaxis=true;
              transformComponentNumber=2;
              break;
            }
            //if the mouse was over one of the x-axis poles
            if (testPoint.x >= center.x-ct.getWidth()/2-60 && testPoint.x <= center.x-ct.getWidth()/2 && testPoint.y >= center.y-5 && testPoint.y <= center.y+5 && testPoint.z >= center.z-5 && testPoint.z <= center.z+5) {
              translateXaxis=true;
              transformComponentNumber=2;
              break;
            }
            //if the mouse was over one of the x-axis poles
            if (testPoint.x >= center.x+ct.getWidth()/2 && testPoint.x <= center.x+ct.getWidth()/2+60 && testPoint.y >= center.y-5 && testPoint.y <= center.y+5 && testPoint.z >= center.z-5 && testPoint.z <= center.z+5) {
              translateXaxis=true;
              transformComponentNumber=1;
              break;
            }
            //if the mouse was over one of the y-axis poles
            if (testPoint.x >= center.x-5 && testPoint.x <= center.x+5 && testPoint.y >= center.y-ct.getHeight()/2-60 && testPoint.y <= center.y-ct.getHeight()/2 && testPoint.z >= center.z-5 && testPoint.z <= center.z+5) {
              translateYaxis=true;
              transformComponentNumber=2;
              break;
            }
            //if the mouse was over one of the y-axis poles
            if (testPoint.x >= center.x-5 && testPoint.x <= center.x+5 && testPoint.y >= center.y+ct.getHeight()/2 && testPoint.y <= center.y+ct.getHeight()/2+60 && testPoint.z >= center.z-5 && testPoint.z <= center.z+5) {
              translateYaxis=true;
              transformComponentNumber=1;
              break;
            }
          }
        }
        
        if(current3DTransformMode==3 && ct instanceof Rotatable){//if in rotate mode
            PVector center = ct.getCenter();//get the center of the object
            float sze = sqrt(pow(ct.getWidth()/2,2)+pow(ct.getHeight()/2,2)+pow(ct.getDepth()/2,2))/28;//calculate the aproximage size value
            sze*=31;//scale factor to make the cyleners the right size
            Rotatable rota = (Rotatable)ct;//cast to a rotatable type
            PVector cameraVec = new PVector(cam3Dx+DX,cam3Dy-DY,cam3Dz-DZ), mousePointVec = new PVector(mousePoint.x,mousePoint.y,mousePoint.z);
            //calculate the position on the rotation plane that intersects with the mouse
            PVector inPlaneX = Util.intersectPlaneAndLine(cameraVec,mousePointVec,center,rota.getXRotationAxis());
            PVector inPlaneY = Util.intersectPlaneAndLine(cameraVec,mousePointVec,center,rota.getYRotationAxis());
            PVector inPlaneZ = Util.intersectPlaneAndLine(cameraVec,mousePointVec,center,rota.getZRotationAxis());
            
            PVector distToCenterX = new PVector(),distToCenterY = new PVector(),distToCenterZ = new PVector();
            PVector distToCamX = new PVector(),distToCamY = new PVector(),distToCamZ = new PVector();
            
            //calculate the distance from to center of the object to the point
            PVector.sub(inPlaneX,center,distToCenterX);
            PVector.sub(inPlaneY,center,distToCenterY);
            PVector.sub(inPlaneZ,center,distToCenterZ);
            
            //calculate the distance fron the point to the camera
            PVector.sub(inPlaneX,cameraVec,distToCamX);
            PVector.sub(inPlaneY,cameraVec,distToCamY);
            PVector.sub(inPlaneZ,cameraVec,distToCamZ);
            
            
            //find out what circles the mouse could be over
            if(distToCenterX.mag() <= sze){
              translateXaxis=true;
            }
            if(distToCenterY.mag() <= sze){
              translateYaxis=true;
            }
            if(distToCenterZ.mag() <= sze){
              translateZaxis=true;
            }
            
            
            //if multiple are selcted then only select the one that is closested to the camera
            if(translateXaxis && translateYaxis){
              if(distToCamX.mag() < distToCamY.mag()){
                translateYaxis = false;
              }else{
                translateXaxis = false;
              }
            }
            if(translateXaxis && translateZaxis){
              if(distToCamX.mag() < distToCamZ.mag()){
                translateZaxis = false;
              }else{
                translateXaxis = false;
              }
            }
            if(translateYaxis && translateZaxis){
              if(distToCamY.mag() < distToCamZ.mag()){
                translateZaxis = false;
              }else{
                translateYaxis = false;
              }
            }
            //save the current rotation
            currentComponentRotation.x = rota.getRotateX();
            currentComponentRotation.y = rota.getRotateY();
            currentComponentRotation.z = rota.getRotateZ();
            //save the correct plane point for the slected axis
            if(translateXaxis){
              initalMousePoint=new Point3D(inPlaneX);
            }else if(translateYaxis){
              initalMousePoint=new Point3D(inPlaneY);
            }else if(translateZaxis){
              initalMousePoint=new Point3D(inPlaneZ);
            }
            
          }else{
            initalMousePoint=mousePoint;
          }
        //save the initial position and size of the object
        initalObjectPos=new Point3D(ct.getX(), ct.getY(), ct.getZ());
        initialObjectDim=new Point3D(ct.getWidth(), ct.getHeight(), ct.getDepth());
      }else if (selectedIndex!=-1) {//if somthing is selcetd and not in 3D
        //get that thing
        if (editingStage) {
          ct=level.stages.get(currentStageIndex).parts.get(selectedIndex);
        }
        if (editingBlueprint) {
          ct = workingBlueprint.parts.get(selectedIndex);
        }
        //2D Rotation
        if(current3DTransformMode==3 && ct instanceof Rotatable){//if rotating
          //prepair the visual center pos
          PVector center = ct.getCenter();
          center.z=0;
          center.mult(Scale);
          center.x -= drawCamPosX*Scale;
          center.y += drawCamPosY*Scale;
          float sze = sqrt(pow(ct.getWidth()/2,2)+pow(ct.getHeight()/2,2))*2.5;
          Rotatable rota = (Rotatable)ct;

          if(dist(mouseX,mouseY,center.x,center.y) <= sze/2*Scale){//if close enough to the center
            translateZaxis=true;
            currentComponentRotation.z = rota.getRotateZ();
            initalMousePoint=new Point3D(mouseX,mouseY,0);
          }
          
        }
        
      }
      
      //placing a blueprint in 3D movement
      if (e3DMode && selectingBlueprint && blueprints.length!=0){
        //get the center posisiton
        float cdx = blueprintMax[0]-blueprintMin[0];
        float cdy = blueprintMax[1]-blueprintMin[1];
        float cdz = blueprintMax[2]-blueprintMin[2];
        //ray cast
        for (int i=0; i<5000; i++) {
          Point3D testPoint=genMousePoint(i);
          //see if clicking on movement arrows
          if (testPoint.x >= (blueprintMin[0]+cdx/2)-5 && testPoint.x <= (blueprintMin[0]+cdx/2)+5 && testPoint.y >= (blueprintMin[1]+cdy/2)-5 && testPoint.y <= (blueprintMin[1]+cdy/2)+5 && testPoint.z >= blueprintMin[2]+cdz && testPoint.z <= blueprintMin[2]+cdz+60) {
            translateZaxis=true;
            transformComponentNumber=1;
            break;
          }

          if (testPoint.x >= (blueprintMin[0]+cdx/2)-5 && testPoint.x <= (blueprintMin[0]+cdx/2)+5 && testPoint.y >= (blueprintMin[1]+cdy/2)-5 && testPoint.y <= (blueprintMin[1]+cdy/2)+5 && testPoint.z >= blueprintMin[2]-60 && testPoint.z <= blueprintMin[2]) {
            translateZaxis=true;
            transformComponentNumber=2;
            break;
          }

          if (testPoint.x >= blueprintMin[0]-60 && testPoint.x <= blueprintMin[0] && testPoint.y >= (blueprintMin[1]+cdy/2)-5 && testPoint.y <= (blueprintMin[1]+cdy/2)+5 && testPoint.z >= (blueprintMin[2]+cdz/2)-5 && testPoint.z <= (blueprintMin[2]+cdz/2)+5) {
            translateXaxis=true;
            transformComponentNumber=2;
            break;
          }

          if (testPoint.x >= blueprintMin[0]+cdx && testPoint.x <= blueprintMin[0]+cdx+60 && testPoint.y >= (blueprintMin[1]+cdy/2)-5 && testPoint.y <= (blueprintMin[1]+cdy/2)+5 && testPoint.z >= (blueprintMin[2]+cdz/2)-5 && testPoint.z <= (blueprintMin[2]+cdz/2)+5) {
            translateXaxis=true;
            transformComponentNumber=1;
            break;
          }

          if (testPoint.x >= (blueprintMin[0]+cdx/2)-5 && testPoint.x <= (blueprintMin[0]+cdx/2)+5 && testPoint.y >= blueprintMin[1]-60 && testPoint.y <= blueprintMin[1] && testPoint.z >= (blueprintMin[2]+cdz/2)-5 && testPoint.z <= (blueprintMin[2]+cdz/2)+5) {
            translateYaxis=true;
            transformComponentNumber=2;
            break;
          }

          if (testPoint.x >= (blueprintMin[0]+cdx/2)-5 && testPoint.x <= (blueprintMin[0]+cdx/2)+5 && testPoint.y >= blueprintMin[1]+cdy && testPoint.y <= blueprintMin[1]+cdy+60 && testPoint.z >= (blueprintMin[2]+cdz/2)-5 && testPoint.z <= (blueprintMin[2]+cdz/2)+5) {
            translateYaxis=true;
            transformComponentNumber=1;
            break;
          }
        }
        //store the inital mouse pos
        initalMousePoint=mousePoint;
        initalObjectPos=new Point3D(blueprintPlacemntX, blueprintPlacemntY, blueprintPlacemntZ);
      }
    }
  }
}
/**Automaticaly called every time a mouse button is released while this window is activated.<br>
Execuated on the render thread.
*/
void mouseReleased() {
  if (levelCreator) {//if in the level creator
    if (mouseButton==LEFT) {//if the button released was left
      if (editingStage||editingBlueprint) {//if edditing a stage or blueprint
        GUImouseReleased();
      }
      if (editinglogicBoard) {//if editing a logic board
        if (connectingLogic&&connecting) {//if attempting to connect terminals
          connecting=false;//stop more connecting
          LogicBoard board=level.logicBoards.get(logicBoardIndex);//get the current board
          for (int i=0; i<board.components.size(); i++) {//srech through all components in the current board
            float[] nodePos1=board.components.get(i).getTerminalPos(0), nodePos2=board.components.get(i).getTerminalPos(1);//gets the positions of the terminals of the component
            if (Math.sqrt(Math.pow(nodePos1[0]-mouseX/Scale, 2)+Math.pow(nodePos1[1]-mouseY/Scale, 2))<=10) {//if the mmouse is over terminal 0
              for (int j=0; j<board.components.get(connectingFromIndex).connections.size(); j++) {//checkif the connection allready exsists
                if (board.components.get(connectingFromIndex).connections.get(j)[0]==i&&board.components.get(connectingFromIndex).connections.get(j)[1]==0) {//if so then remove the connection
                  board.components.get(connectingFromIndex).connections.remove(j);
                  return;
                }
              }
              for (int j=0; j<board.components.size(); j++) {//check if any outher components are connecting to this terminal allready
                for (int k=0; k<board.components.get(j).connections.size(); k++) {
                  if ( board.components.get(j).connections.get(k)[0]==i&&board.components.get(j).connections.get(k)[1]==0) {//if so then do nothing
                    return;
                  }
                }
              }
              board.components.get(connectingFromIndex).connect(i, 0);//make the connection
              return;
            }
            if (Math.sqrt(Math.pow(nodePos2[0]-mouseX/Scale, 2)+Math.pow(nodePos2[1]-mouseY/Scale, 2))<=10) {//if the mouse is over terminal 1
              for (int j=0; j<board.components.get(connectingFromIndex).connections.size(); j++) {//checkif the connection allready exsists
                if (board.components.get(connectingFromIndex).connections.get(j)[0]==i&&board.components.get(connectingFromIndex).connections.get(j)[1]==1) {//if so then remove the connection
                  board.components.get(connectingFromIndex).connections.remove(j);
                  return;
                }
              }

              for (int j=0; j<board.components.size(); j++) {//check if any outher components are connecting to this terminal allready
                for (int k=0; k<board.components.get(j).connections.size(); k++) {
                  if ( board.components.get(j).connections.get(k)[0]==i&&board.components.get(j).connections.get(k)[1]==1) {//if so then do nothing
                    return;
                  }
                }
              }
              board.components.get(connectingFromIndex).connect(i, 1);
              return;
            }
          }
        }
        if (moveLogicComponents) {//if moving logic omcponents
          if (movingLogicComponent) {
            movingLogicComponent=false;//stop moving
            level.logicBoards.get(logicBoardIndex).components.get(movingLogicIndex).setPos(mouseX/Scale+camPos, mouseY/Scale+camPosY);//set the position
          }
        }
      }//end of editing logic board
      
      if (selectedIndex !=- 1) {//if something was selected then stop any movemnt
        translateZaxis=false;
        translateXaxis=false;
        translateYaxis=false;
      }
      if (e3DMode && selectingBlueprint){ //if placeing a blueprint then stop any movement
        translateZaxis=false;
        translateXaxis=false;
        translateYaxis=false;
      }
    }
  }
}

/**Draws the main menu
@param background wether or not to draw the backround
*/
void drawMainMenu(boolean background) {
  if (background){
    background(7646207);
  }
  fill(0);
  //the title
  mm_title.draw();

  fill(255, 255, 0);
  mm_EarlyAccess.draw();
  textSize(35*Scale);
  fill(-16732415);
  stroke(-16732415);
  rect(0, height/2, width, height/2);//green rectangle
  draw_mann(ui.topX()+200*ui.scale(), ui.topY()+360*ui.scale(), 1, 4*ui.scale(), 0,g);
  draw_mann(ui.topX()+1080*ui.scale(), ui.topY()+360*ui.scale(), 1, 4*ui.scale(), 1,g);

  playButton.draw();
  exitButton.draw();
  //joinButton.draw();
  settingsButton.draw();
  howToPlayButton.draw();

  fill(255);
  mm_version.draw();

  fill(0,30,255);
  mainMenuWebsite.draw();
}

/**Draws the settings page
*/
void drawSettings() {
  fill(0);
  background(7646207);
  st_title.draw();

  if (settingsMenue.equals("game play")) {//if on the gameplay tab
    fill(0);
    st_Hssr.draw();
    st_Vssr.draw();
    st_hsrp.setText((int)horozontalEdgeScrollSlider.getValue()+"");
    st_vsrp.setText((int)verticleEdgeScrollSlider.getValue()+"");
    st_hsrp.draw();
    st_vsrp.draw();
    st_gmp_fovdisp.setText(fovSlider.getValue()+"");
    st_gmp_fovdisp.draw();
    st_gmp_fovdesc.draw();

    verticleEdgeScrollSlider.draw();
    horozontalEdgeScrollSlider.draw();
    fovSlider.draw();
    fill(0);
    st_gameplay.draw();
  }//end of gameplay settings

  if (settingsMenue.equals("display")) {//if on the display tab
    fill(0);
    st_dsp_vsr.draw();
    st_dsp_fs.draw();
    st_dsp_4k.draw();
    st_dsp_1440.draw();
    st_dsp_1080.draw();
    st_dsp_900.draw();
    st_dsp_720.draw();
    st_dsp_fsYes.draw();
    st_dsp_fsNo.draw();
    rez720.draw();
    rez900.draw();
    rez1080.draw();
    rez1440.draw();
    rez4k.draw();
    fullScreenOn.draw();
    fullScreenOff.draw();

    fill(0);
    st_display.draw();
  }//end of display settings
  
  if(settingsMenue.equals("sound")){//if on the sound tab
    fill(0);
    st_sound.draw();
    st_snd_musicVol.draw();
    st_snd_SFXvol.draw();
    st_snd_currentMusicVolume.setText((int)(settings.getSoundMusicVolume()*100)+"");
    st_snd_currentSoundsVolume.setText((int)(settings.getSoundSoundVolume()*100)+"");
    st_snd_currentNarrationVolume.setText((int)(settings.getSoundNarrationVolume()*100)+"");
    st_snd_currentMusicVolume.draw();
    st_snd_currentSoundsVolume.draw();
    st_snd_better.draw();
    st_snd_demonitized.draw();
    st_snd_narration.draw();
    st_snd_narrationVol.draw();
    st_snd_currentNarrationVolume.draw();
    
    musicVolumeSlider.draw();
    SFXVolumeSlider.draw();
    narrationVolumeSlider.draw();
    
    narrationMode1.draw();
    narrationMode0.draw();
  }
  if (settingsMenue.equals("outher")) {//if on the other tab
    fill(0);
    st_o_displayFPS.draw();
    st_o_debugINFO.draw();
    st_o_3DShadow.draw();
    st_o_yes.draw();
    st_o_no.draw();
    st_o_diableTransitions.draw();
    //st_o_defaultAuthor.draw();
    st_o_shadowsOff.draw();
    st_o_shadowsOld.draw();
    st_o_shadowsLow.draw();
    st_o_shadowsMedium.draw();
    st_o_shadowsHigh.draw();
    
    

    enableFPS.draw();
    disableFPS.draw();
    enableDebug.draw();
    disableDebug.draw();
    shadows0.draw();
    shadows1.draw();
    shadows2.draw();
    shadows3.draw();
    shadows4.draw();
    
    disableMenuTransistionsButton.draw();
    enableMenuTransitionButton.draw();
    //defaultAuthorNameTextBox.draw();


    textSize(50*Scale);
    textAlign(CENTER, TOP);
    fill(0);
    st_other.draw();
  }//end of outher settings

  //end of check boxes and stuffs

  strokeWeight(5*Scale);
  stroke(255, 0, 0);
  if (true) {//render the checkmarks on the options
    if (settingsMenue.equals("display")) {
      if (settings.getResolutionVertical()==720) {
        chechMark(rez720.x+rez720.lengthX/2, rez720.y+rez720.lengthY/2);
      }
      if (settings.getResolutionVertical()==900) {
        chechMark(rez900.x+rez900.lengthX/2, rez900.y+rez900.lengthY/2);
      }
      if (settings.getResolutionVertical()==1080) {
        chechMark(rez1080.x+rez1080.lengthX/2, rez1080.y+rez1080.lengthY/2);
      }
      if (settings.getResolutionVertical()==1440) {
        chechMark(rez1440.x+rez1440.lengthX/2, rez1440.y+rez1440.lengthY/2);
      }
      if (settings.getResolutionVertical()==2160) {
        chechMark(rez4k.x+rez4k.lengthX/2, rez4k.y+rez4k.lengthY/2);
      }

      if (!settings.getFullScreen()) {
        chechMark(fullScreenOff.x+fullScreenOff.lengthX/2, fullScreenOff.y+fullScreenOff.lengthY/2);
      } else {
        chechMark(fullScreenOn.x+fullScreenOn.lengthX/2, fullScreenOn.y+fullScreenOn.lengthY/2);
      }
    }//end of display settings checkmarks
    
    if (settingsMenue.equals("sound")) {
      if (settings.getSoundNarrationMode()==0) {
        chechMark(narrationMode0.x+narrationMode0.lengthX/2, narrationMode0.y+narrationMode0.lengthY/2);
      } else if (settings.getSoundNarrationMode()==1) {
        chechMark(narrationMode1.x+narrationMode1.lengthX/2, narrationMode1.y+narrationMode1.lengthY/2);
      }
    }
    if (settingsMenue.equals("outher")) {
      
      if (!settings.getDebugFPS()) {
        chechMark(disableFPS.x+disableFPS.lengthX/2, disableFPS.y+disableFPS.lengthY/2);
      } else {
        chechMark(enableFPS.x+enableFPS.lengthX/2, enableFPS.y+enableFPS.lengthY/2);
      }
      if (!settings.getDebugInfo()) {
        chechMark(disableDebug.x+disableDebug.lengthX/2, disableDebug.y+disableDebug.lengthY/2);
      } else {
        chechMark(enableDebug.x+enableDebug.lengthX/2, enableDebug.y+enableDebug.lengthY/2);
      }

      
      switch(settings.getShadows()){
        case 4:
          chechMark(shadows4.x+shadows4.lengthX/2, shadows4.y+shadows4.lengthY/2);
        break;
        case 3:
          chechMark(shadows3.x+shadows3.lengthX/2, shadows3.y+shadows3.lengthY/2);
        break;
        case 2:
          chechMark(shadows2.x+shadows2.lengthX/2, shadows2.y+shadows2.lengthY/2);
        break;
        case 1:
          chechMark(shadows1.x+shadows1.lengthX/2, shadows1.y+shadows1.lengthY/2);
        break;
        case 0:
          chechMark(shadows0.x+shadows0.lengthX/2, shadows0.y+shadows0.lengthY/2);
        break;
      }
      
      if(!settings.getDisableMenuTransitions()){
        chechMark(enableMenuTransitionButton.x+enableMenuTransitionButton.lengthX/2, enableMenuTransitionButton.y+enableMenuTransitionButton.lengthY/2);
      } else {
        chechMark(disableMenuTransistionsButton.x+disableMenuTransistionsButton.lengthX/2, disableMenuTransistionsButton.y+disableMenuTransistionsButton.lengthY/2);
      }

      
    }
  }//end of outher settings
  //draw the common buttons
  sttingsGPL.draw();
  settingsDSP.draw();
  settingsSND.draw();
  settingsOUT.draw();

  settingsBackButton.draw();
}//end of draw settings

/**Draw the first level select screen
@param bcakground wether or not to draw the deafult
@param gc the background color to draw if not the default
*/
void drawLevelSelect(boolean bcakground,int gc) {
  levelCompleteSoundPlayed=false;
  if (bcakground)
    background(7646207);
  if(bcakground){
    fill(-16732415);
    stroke(-16732415);
  }else{
    fill(gc);
  }
  strokeWeight(0);
  rect(0, height/2, width, height);//green rectangle
  fill(0);
  ls_levelSelect.draw();
  int progress=levelProgress.getJSONObject(0).getInt("progress")+1;//load level progress
  //make the buttons dark if they are not avawable
  if (progress<2) {
    select_lvl_2.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_2.setColor(-59135, -1791);
  }
  if (progress<3) {
    select_lvl_3.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_3.setColor(-59135, -1791);
  }
  if (progress<4) {
    select_lvl_4.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_4.setColor(-59135, -1791);
  }
  if (progress<5) {
    select_lvl_5.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_5.setColor(-59135, -1791);
  }
  if (progress<6) {
    select_lvl_6.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_6.setColor(-59135, -1791);
  }
  if (progress<7) {
    select_lvl_7.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_7.setColor(-59135, -1791);
  }
  if (progress<8) {
    select_lvl_8.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_8.setColor(-59135, -1791);
  }
  if (progress<9) {
    select_lvl_9.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_9.setColor(-59135, -1791);
  }
  if (progress<10) {
    select_lvl_10.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_10.setColor(-59135, -1791);
  }
  if (progress < 11){
    select_lvl_11.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_11.setColor(-59135, -1791);
  }
  if (progress < 12){
    select_lvl_12.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_12.setColor(-59135, -1791);
  }
  select_lvl_1.draw();
  select_lvl_2.draw();
  select_lvl_3.draw();
  select_lvl_4.draw();
  select_lvl_5.draw();
  select_lvl_6.draw();
  select_lvl_7.draw();
  select_lvl_8.draw();
  select_lvl_9.draw();
  select_lvl_10.draw();
  select_lvl_11.draw();
  select_lvl_12.draw();
  select_lvl_back.draw();
  select_lvl_UGC.draw();
  select_lvl_next.draw();
}

/**Draw the second level select screen
@param bcakground wether or not to draw the backround
*/
void drawLevelSelect2(boolean bcakground){
  levelCompleteSoundPlayed=false;
  if (bcakground)
    background(#66696F);
  fill(0);
  ls_levelSelect.draw();
  int progress=levelProgress.getJSONObject(0).getInt("progress")+1;//get the current level progress
  //make buttons dark if they are not unlocked yet
  if (progress<13) {
    select_lvl_13.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_13.setColor(-59135, -1791);
  }
  if (progress<14) {
    select_lvl_14.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_14.setColor(-59135, -1791);
  }
  if (progress<15) {
    select_lvl_15.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_15.setColor(-59135, -1791);
  }
  if (progress<16) {
    select_lvl_16.setColor(#B40F00, #B4AF00);
  } else {
    select_lvl_16.setColor(-59135, -1791);
  }

  select_lvl_13.draw();
  select_lvl_14.draw();
  select_lvl_15.draw();
  select_lvl_16.draw();
  select_lvl_back.draw();
}

/** Draw the UGC level selecting screen
*/
void drawLevelSelectUGC() {
  background(7646207);
  fill(0);
  lsUGC_title.draw();//menue title

  select_lvl_back.draw();
  //UGC_open_folder.draw();
  //levelcreatorLink.draw();
  fill(0);
  //if there are no UGC levels
  if (UGCNames.size()==0) {
    lsUGC_noLevelFound.draw();
  } else {//if there are levels
    lsUGC_levelName.setText(UGCNames.get(UGC_lvl_indx));//render the name of the current slecetd level
    lsUGC_levelName.draw();
    if ((boolean)compatibles.get(UGC_lvl_indx)) {//if this one is not compatable
      lsUGC_levelNotCompatible.draw();//show it is not compatable
    }
    //next and back buttons
    if (UGC_lvl_indx<UGCNames.size()-1) {
      UGC_lvls_next.draw();
    }
    if (UGC_lvl_indx>0) {
      UGC_lvls_prev.draw();
    }
    UGC_lvl_play.draw();//play button
  }
}

/**Draws a properly scaled check mark at the screen coordinats provided.<br>
Note: this uses stroke and does not automaticaly include the color.
@param x the on screen x position of the check mark
@param y the on screen y position of the check mark
*/
void chechMark(float x, float y) {
  line(x-15*Scale, y, x, y+15*Scale);
  line(x+25*Scale, y-15*Scale, x, y+15*Scale);
}

/**The logic for handling the narraion and stage effects in the tutorial
*/
void tutorialLogic() {
  
  //this should be simple enough
  //I am not explaining this
  if (tutorialPos==0) {
    soundHandler.setMusicVolume(0.01*settings.getSoundMusicVolume());
    currentTutorialSound=0;
    soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
    tutorialPos++;
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
  }
  if (tutorialPos==1) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      currentTutorialSound=1;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==2) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      loadLevel("data/levels/tutorial");
      inGame=true;
      tutorialDrawLimit=3;
      currentTutorialSound=2;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==3) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      currentTutorialSound=3;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==4) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      currentTutorialSound=4;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==5) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      currentTutorialSound=5;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==6) {
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      currentTutorialSound=6;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==7) {
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
    }
  }
  if (tutorialPos==8) {
    playerMovementManager.setJump(false);
    if (players[currentPlayer].x>=1604) {
      currentTutorialSound=7;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
      tutorialDrawLimit=14;
    }
  }
  if (tutorialPos==9) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
    }
  }
  if (tutorialPos==10) {
    playerMovementManager.setJump(false);
    if (dead) {
      currentTutorialSound=8;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==11) {
    if (players[currentPlayer].x>=1819) {
      currentTutorialSound=9;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==12) {
    if (players[currentPlayer].x>=3875) {
      currentTutorialSound=10;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==13) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
      tutorialDrawLimit=28;
    }
  }

  if (tutorialPos==14) {
    if (players[currentPlayer].x>=5338) {
      currentTutorialSound=11;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==15) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
    }
  }

  if (tutorialPos==16) {
    if (coinCount>=10) {
      currentTutorialSound=12;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
    }
  }
  if (tutorialPos==17) {
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      currentTutorialSound=13;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
      tutorialPos++;
      coinCount=0;
    }
  }
  if (tutorialPos==18) {
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
      tutorialDrawLimit=51;
    }
  }
  if (tutorialPos==19) {
    if (players[currentPlayer].x>=7315) {
      tutorialPos++;
      currentTutorialSound=14;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
    }
  }
  if (tutorialPos==20) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
      tutorialDrawLimit=600;
    }
  }
  if (tutorialPos==21) {
    if (currentStageIndex==1) {
      tutorialPos++;
      currentTutorialSound=15;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
    }
  }
  if (tutorialPos==22) {
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      tutorialPos++;
    }
  }
  if (tutorialPos==23) {
    if (players[currentPlayer].x >= 6739 && currentStageIndex == 1 && players[currentPlayer].x <= 7000) {
      println((players[currentPlayer].x >= 6739)+" "+(currentStageIndex == 1)+" "+(players[currentPlayer].x <= 7000)+" "+players[currentPlayer].x);
      tutorialPos++;
      currentTutorialSound=16;
      soundHandler.playNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
    }
  }

  if (tutorialPos==24) {
    playerMovementManager.setLeft(false);
    playerMovementManager.setRight(false);
    playerMovementManager.setJump(false);
    if (!soundHandler.isNarrationPlaying(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound])) {
      soundHandler.setMusicVolume(settings.getSoundMusicVolume());
      tutorialMode=false;
    }
  }
}

/**Opens the UGC levels folder in the system file explorer
*/
void openUGCFolder() {
  Desktop desktop = Desktop.getDesktop();
  File dirToOpen = null;
  try {
    dirToOpen = new File(appdata+"/CBi-games/skinny mann/UGC/levels");
    desktop.open(dirToOpen);
  }
  catch (Throwable iae) {
    System.out.println("folder Not Found, creating folder");
    new File(appdata+"/CBi-games/skinny mann/UGC/levels").mkdirs();
    openUGCFolder();
  }
}

/**Opens the level creator levels folder in the system file explorer
*/
void openLevelCreatorLevelsFolder() {
  Desktop desktop = Desktop.getDesktop();
  File dirToOpen = null;
  try {
    dirToOpen = new File(appdata+"/CBi-games/skinny mann level creator/levels");
    desktop.open(dirToOpen);
  }
  catch (Throwable iae) {
    System.out.println("folder Not Found, creating folder");
    new File(appdata+"/CBi-games/skinny mann level creator/levels").mkdirs();
    openUGCFolder();
  }
}

/**Checks if the given folder is a level.<br>
Additinally this function also checks if a given level is compatable with this verion of the game. That result is stored in levelCompatible
@param fil the file path of the folder to test
@return wether the provided path points to a level
*/
boolean FileIsLevel(String fil) {
  try {
    JSONObject job =loadJSONArray(appdata+"/CBi-games/skinny mann/UGC/levels/"+fil+"/index.json").getJSONObject(0);
    String createdVersion=job.getString("game version");
    if (gameVersionCompatibilityCheck(createdVersion)) {
      levelCompatible=true;
    } else {
      levelCompatible=false;
    }
  }
  catch(Throwable e) {
    return false;
  }
  return true;
}

/**Checks if the input game version is compable with the current verion of the game
@param vers the verion the check compatablility of
@return true if the input verion is compatable
*/
boolean gameVersionCompatibilityCheck(String vers) {//returns ture if the inputed version is compatible
  if (levelCreator) {
    levelCompatible=true;
    return true;
  }
  for (int i=0; i<compatibleVersions.length; i++) {//look through all listed compatable versions
    if (vers.equals(compatibleVersions[i])) {
      levelCompatible=true;
      return true;
    }
  }
  levelCompatible=false;
  return false;
}

/**Prepairs for GUI rendering.<br>
This is acomplished by resetting the camera, disabling any set lightings, and finally disabling the depth test.
*/
void engageHUDPosition() {
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
}

/**Enables the depth test to re allow normal rendering.
*/
void disEngageHUDPosition() {
  hint(ENABLE_DEPTH_TEST);
}

/**Used to handel any uncought errors in a way that allows users to report issues.<br>
Displays a window containing error information including the stack trace, then closes the program when then window is closed.
@param e the unhandled error
*/
void handleError(Throwable e) {
  System.err.println("an error occored but was intercepted");
  e.printStackTrace();
  StackTraceElement[] elements = e.getStackTrace();
  String stack="";
  for (int ele=0; ele<elements.length; ele++) {//convert the stace trace elements inton a single string
    stack+=elements[ele].toString()+"\n";
  }
  stack+="\nyou may wish to take a screenshot of this window and resport this as an issue on github";
  JFrame jf=new JFrame();
  jf.setAlwaysOnTop(true);//make sure the error ends up on top of the game
  JOptionPane.showMessageDialog(jf, stack, e.toString(), JOptionPane.ERROR_MESSAGE);//show the error to the user
  exit(-1);//close the game
}

/**Overrides the default exit function so that the program only closes when we actually want it to.<br>
To close the program use exit(code)
*/
void exit() {
  println("somehitng attempted to close the program");
}

/**closes the program and prints the provided code in the console
@param i the exit code (note: this will not be the actual process exit code)
*/
void exit(int i) {
  println("exited with code: "+i);
  super.exit();
}

/**Displays the glitch effect
*/
void glitchEffect() {
  int bsepnum = 25;//a magical value
  int n = millis() / 100 % bsepnum;//witch set of boxes to target for display
  //n=9;
  int bsep = glitchBoxes.size() / bsepnum;//the number of boxes to display at once
  strokeWeight(0);
  for(int i=0;i<bsep;i++){//display bsep glitch boxes on the screen
    glitchBoxes.get(i+bsep*n).draw();
  }
}

/**A simple datastrcture for holde the size, position and color of a single box in the glitch effect
*/
class GlitchBox{
  int x,y,w,h,c;
  /**
  @param in the string containing the box information (x,y,width,hright,color)
  */
  GlitchBox(String in){
    String[] bs = in.split(",");
    x=Integer.parseInt(bs[0]);
    y=Integer.parseInt(bs[1]);
    w=Integer.parseInt(bs[2]);
    h=Integer.parseInt(bs[3]);
    c=Integer.parseInt(bs[4]);
  }
  /**draw this glitch box on the screen
  */
  void draw(){
    fill(c,128);
    rect(ui.topX()+x*ui.scale(),ui.topY()+y*ui.scale(),w*ui.scale(),h*ui.scale());
  }
}

/**Give various classes static refrences to this class to make the function properly.<br>
NOTE: we are going to get rid of this :tm:
*/
void sourceInitilize() {
  Level.source=this;
  Stage.source=this;
  StageComponent.source=this;
  LogicBoard.source=this;
  CheckPoint.source=this;
  StageSound.source=this;
  LogicComponent.source=this;
  Client.source=this;
  Server.source=this;
  Player.source=this;
}

/**Hanlde any errors that pop up in multyplayer netwiorking.<br>
Show the disconnect screen with the reason for the disconnection.
@param error The error that was thrown
*/
void networkError(Throwable error) {
  if (clientQuitting) {//if the client was quitting then just do nothing
    clientQuitting=false;
    return;
  }
  menue=true;//open the disconnected screen
  inGame=false;
  error.printStackTrace();//print the error to the console
  Menue="disconnected";
  disconnectReason=error.toString();
  multiplayer=false;
}

/**Draws the developer menu
*/
void drawDevMenue() {
  background(#EDEDED);
  fill(0);
  dev_title.draw();
  dev_info.draw();

  dev_main.draw();
  dev_quit.draw();
  dev_levels.draw();
  dev_tutorial.draw();
  dev_settings.draw();
  dev_UGC.draw();
  dev_multiplayer.draw();
  dev_levelCreator.draw();
  dev_testLevel.draw();
}
/**Handles mouse clicks for the developer menu
*/
void clickDevMenue() {
  if (dev_main.isMouseOver()) {
    Menue="main";
  }
  if (dev_quit.isMouseOver()) {
    exit(1);
  }
  if (dev_levels.isMouseOver()) {
    Menue="level select";
  }
  if (dev_tutorial.isMouseOver()) {
    menue=false;
    tutorialMode=true;
    tutorialPos=0;
  }
  if (dev_settings.isMouseOver()) {
    Menue="settings";
  }
  if (dev_UGC.isMouseOver()) {
    Menue="level select UGC";
    loadUGCList();
    UGC_lvl_indx=0;
    return;
  }
  if (dev_multiplayer.isMouseOver()) {
    Menue="multiplayer strart";
    return;
  }
  if (dev_levelCreator.isMouseOver()) {
    Menue="level select UGC";
    loadUGCList();
    UGC_lvl_indx=0;
    if (scr2==null)//create the 2nd screen if it does not exsist
      scr2 =new ToolBox(millis());
    startup=true;
    loading=false;
    newLevel=false;
    editingStage=false;
    levelOverview=false;
    newFile=false;
    levelCreator=true;
    return;
  }
  if(dev_testLevel.isMouseOver()){//go to the test level by simulating human input very quickly to painlessly open the level
    mouseButton = LEFT;
    mouseX = (int)(dev_levelCreator.x + dev_levelCreator.lengthX/2);
    mouseY = (int)(dev_levelCreator.y + dev_levelCreator.lengthY/2);
    mouseClicked();
    mouseX = (int)(loadLevelButton.x + loadLevelButton.lengthX/2);
    mouseY = (int)(loadLevelButton.y + loadLevelButton.lengthY/2);
    mouseClicked();
    lcEnterLevelTextBox.setContence("test");
    mouseX = (int)(lcLoadLevelButton.x + lcLoadLevelButton.lengthX/2);
    mouseY = (int)(lcLoadLevelButton.y + lcLoadLevelButton.lengthY/2);
    mouseClicked();
    return;
  }
}
/**Old function used to calculate the largest text size that can fit in a given width.
@param text The text to find the size of
@param width the length of the area to fit the text in
*/
@Deprecated
void calcTextSize(String text, float width) {
  calcTextSize(text, width, 4837521);
}

/**Old function used to calculate the largest text size that can fit in a given width.
@param text The text to find the size of
@param width The length of the area to fit the text in
@param max The maximum text size the output
*/
@Deprecated
void calcTextSize(String text, float width, int max) {
  for (int i=1; i<max; i++) {
    textSize(i);
    if (textWidth(text)>width) {
      textSize(i-1);
      return;
    }
  }
}

/**Generate the level info the for the selected multyplayer level. The result is placed in multyplayerSelectedLevel
@param path The file path to the level folder
@param UGC Wether the level is UGC or not
*/
void genSelectedInfo(String path, boolean UGC) {
  String name, author, gameVersion;
  int multyplayerMode=1, maxPlayers=-1, minPlayers=-1, id=0;
  JSONArray index = loadJSONArray(path+"/index.json");
  JSONObject info = index.getJSONObject(0);
  name = info.getString("name");
  author=info.getString("author");
  gameVersion=info.getString("game version");
  id=info.getInt("level_id");
  try {
    multyplayerMode=info.getInt("multyplayer mode");
    maxPlayers=info.getInt("max players");
    minPlayers=info.getInt("min players");
  } catch(Exception e) {
  }

  multyplayerSelectedLevel=new SelectedLevelInfo(name, author, gameVersion, multyplayerMode, minPlayers, maxPlayers, id, UGC);
}

/**Tells all connected clients to go back to the multplayer selcetion menu
*/
void returnToSlection() {
  BackToMenuRequest mrq = new BackToMenuRequest();//create the request
  try {
    for (int i=0; i<clients.size(); i++) {//send it to each client
      clients.get(i).dataToSend.add(mrq);
    }
  } catch(Exception e) {
  }
}

/**formats a given number of milliseconds into a time string
@param millis The ammount of time in milliseconds
@return A string showing how many minuets and seconds the input milliseconds are equivelent to
*/
String formatMillis(int millis) {
  int mins=millis/60000;
  float secs=(millis/1000.0)-mins*60;
  return mins+":"+String.format("%.3f", secs);
}

/**Thread responcible for most of the loading and configuration of the game during startup
*/
void programLoad() {
  try{
    //do this first becasue it causes a momentary freez on the render thread that we want to avoid later in the animation
    println("loading shaders");
    depthBufferShader = loadShader("data/shaders/depthBufferFrag.glsl","data/shaders/depthBufferVert.glsl");
    shadowShader = loadShader("data/shaders/shadowMapFrag.glsl","data/shaders/shadowMapVert.glsl");
  
    requestDepthBufferInit = true;
    //this init can only happen on the main render thread because it requires an open Gl context
    
    println("loading 3D coin modle");//load the 3D coin modle
    coin3D=loadShape("data/modles/coin/tinker.obj");
    loadProgress++;
    coin3D.scale(3);
    
    //load the default author value
    defaultAuthorNameTextBox.setContence(settings.getDefaultAuthor());
    author = settings.getDefaultAuthor();
    loadProgress++;
  
    println("loading level progress");
    try {//load level prgress
      levelProgress=loadJSONArray(appdata+"/CBi-games/skinny mann/progressions.json");
      levelProgress.getJSONObject(0);//throw an error if loadin failed
      loadProgress++;
    } catch(Throwable e) {//basically if there is not progress loaded then create the file with new progress
      println("failed to load level progress. creating new progress data");
      levelProgress=new JSONArray();
      JSONObject p=new JSONObject();
      p.setInt("progress", 0);
      levelProgress.setJSONObject(0, p);
      saveJSONArray(levelProgress, appdata+"/CBi-games/skinny mann/progressions.json");
      loadProgress++;
    }
  
    //initilize each player in the players array, this does not really need to be done here
    println("inililizing players");
    players[0]=new Player(20, 699, 1, 0);
    players[1]=new Player(20, 699, 1, 1);
    players[2]=new Player(20, 699, 1, 2);
    players[3]=new Player(20, 699, 1, 3);
    players[4]=new Player(20, 699, 1, 4);
    players[5]=new Player(20, 699, 1, 5);
    players[6]=new Player(20, 699, 1, 6);
    players[7]=new Player(20, 699, 1, 7);
    players[8]=new Player(20, 699, 1, 8);
    players[9]=new Player(20, 699, 1, 9);
    loadProgress++;
    
    //register all the classes in the corresponding registries
    registerThings();
  
    println("initlizing sound handler");
    //create the sound handler
    SoundHandler.Builder soundBuilder = SoundHandler.builder(this);
    //load the list of music tracks
    String[] musicTracks=loadStrings("data/music/music.txt");
    for (int i=0; i<musicTracks.length; i++) {
      soundBuilder.addMusic(musicTracks[i], 0);
    }
    //load the list of global sounds
    String[] sfxTracks=loadStrings("data/sounds/sounds.txt");
    for (int i=0; i<sfxTracks.length; i++) {
      soundBuilder.addSound(sfxTracks[i]);
    }
  
    int[] idcb = {0};//narration id call back array. used to get the id of the narration, will be set to out of the builder
    //register all the narrations for the tutorial
    soundBuilder.addNarration("data/sounds/tutorial/T1a.wav",idcb);
    tutorialNarration[0][0]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T2a.wav",idcb);
    tutorialNarration[0][1]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T3.wav",idcb);
    tutorialNarration[0][2]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T4a.wav",idcb);
    tutorialNarration[0][3]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T5a.wav",idcb);
    tutorialNarration[0][4]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T6a.wav",idcb);
    tutorialNarration[0][5]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T7.wav",idcb);
    tutorialNarration[0][6]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T8a.wav",idcb);
    tutorialNarration[0][7]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T9a.wav",idcb);
    tutorialNarration[0][8]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T10.wav",idcb);
    tutorialNarration[0][9]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T11.wav",idcb);
    tutorialNarration[0][10]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T12.wav",idcb);
    tutorialNarration[0][11]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T13.wav",idcb);
    tutorialNarration[0][12]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T14a.wav",idcb);
    tutorialNarration[0][13]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T15.wav",idcb);
    tutorialNarration[0][14]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T16.wav",idcb);
    tutorialNarration[0][15]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T17.wav",idcb);
    tutorialNarration[0][16]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T1b.wav",idcb);
    tutorialNarration[1][0]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T2b.wav",idcb);
    tutorialNarration[1][1]=idcb[0];
   
    soundBuilder.addNarration("data/sounds/tutorial/T3.wav",idcb);
    tutorialNarration[1][2]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T4b.wav",idcb);
    tutorialNarration[1][3]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T5b.wav",idcb);
    tutorialNarration[1][4]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T6b.wav",idcb);
    tutorialNarration[1][5]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T7.wav",idcb);
    tutorialNarration[1][6]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T8b.wav",idcb);
    tutorialNarration[1][7]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T9b.wav",idcb);
    tutorialNarration[1][8]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T10.wav",idcb);
    tutorialNarration[1][9]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T11.wav",idcb);
    tutorialNarration[1][10]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T12.wav",idcb);
    tutorialNarration[1][11]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T13.wav",idcb);
    tutorialNarration[1][12]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T14b.wav",idcb);
    tutorialNarration[1][13]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T15.wav",idcb);
    tutorialNarration[1][14]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T16.wav",idcb);
    tutorialNarration[1][15]=idcb[0];
    
    soundBuilder.addNarration("data/sounds/tutorial/T17.wav",idcb);
    tutorialNarration[1][16]=idcb[0];
    
    println("loading sounds");
    soundHandler = soundBuilder.build();//finilze the sound handler. this is what accualy loads the sound files
    loadProgress++;
  
    //set the volumes to what is set in settings
    soundHandler.setMusicVolume(settings.getSoundMusicVolume());
    soundHandler.setSoundsVolume(settings.getSoundSoundVolume());
    soundHandler.setNarrationVolume(settings.getSoundNarrationVolume());
    
    
    
    //load the saved colors for the level creator or create them if they do not exsist
    println("loading saved colors");
    if (new File(appdata+"/CBi-games/skinny mann level creator/colors.json").exists()) {
      colors=loadJSONArray(appdata+"/CBi-games/skinny mann level creator/colors.json");//load saved colors
    } else {
      colors=JSONArray.parse("[{\"red\": 0,\"green\": 175,\"blue\": 0},{\"red\": 145,\"green\": 77,\"blue\": 0}]");
    }
    loadProgress++;
  
    //load 3D modles for 3D transfomrations
    println("loading 3D arrows and scalar moddles");
    redArrow=loadShape("data/modles/red arrow/arrow.obj");
    loadProgress++;
    greenArrow=loadShape("data/modles/green arrow/arrow.obj");
    loadProgress++;
    blueArrow=loadShape("data/modles/blue arrow/arrow.obj");
    loadProgress++;
    yellowArrow=loadShape("data/modles/yellow arrow/arrow.obj");
    loadProgress++;
  
    redScaler=loadShape("data/modles/red scaler/obj.obj");
    loadProgress++;
    greenScaler=loadShape("data/modles/green scaler/obj.obj");
    loadProgress++;
    blueScaler=loadShape("data/modles/blue scaler/obj.obj");
    loadProgress++;
    yellowScaler=loadShape("data/modles/yellow scaler/obj.obj");
    loadProgress++;
    rotateCircleX = loadShape("data/modles/Rotate_X/obj.obj");
    loadProgress++;
    rotateCircleY = loadShape("data/modles/Rotate_Y/obj.obj");
    loadProgress++;
    rotateCircleZ = loadShape("data/modles/Rotate_Z/obj.obj");
    loadProgress++;
    rotateCircleHilight = loadShape("data/modles/Rotate_Hilight/obj.obj");
    loadProgress++;
  
    //load the level creator logo
    LevelCreatorLogo=loadShape("data/modles/LevelCreatorLogo/LCL.obj");
    loadProgress++;
    LevelCreatorLogo.scale(3*Scale);
    
    //setup the various sliders in the settings menu
    musicVolumeSlider.setValue(settings.getSoundMusicVolume()*100);
    SFXVolumeSlider.setValue(settings.getSoundSoundVolume()*100);
    narrationVolumeSlider.setValue(settings.getSoundNarrationVolume()*100);
    verticleEdgeScrollSlider.setValue(settings.getSrollVertical());
    horozontalEdgeScrollSlider.setValue(settings.getScrollHorozontal());
    fovSlider.setValue(degrees(settings.getFOV()));
    
    //load the boxes for the glitch effect
    String[] rawGlitchBoxes = loadStrings("data/glitch.txt");
    loadProgress++;
    for(int i=0;i<rawGlitchBoxes.length;i++){
      glitchBoxes.add(new GlitchBox(rawGlitchBoxes[i]));
    }
    
    //load statistics
    println("loading stats");
    stats = new StatisticManager(appdata+"/CBi-games/skinny mann/stats.json",this);
    loadProgress++;
     
    //load UV test image
    uvTester = loadImage("data/assets/ic.png");
  
    //spawn the physics thread
    println("starting physics thread");
    thread("thrdCalc2");
    //signal loading has completed
    loaded=true;
    println("loading complete");
    println(loadProgress);
  } catch(Throwable e) {
    handleError(e);
  }
}

/**Initilise the depth buffer's render targets and initilize the sub shaodw maps.<br>
IMPORTANT: This funtion must be run on a thread with an OpenGL context
*/
void initDepthBuffer(){
  int bufferSize;
  switch(settings.getShadows()){//figureout the buffer resolution
    case 2: 
      bufferSize =1024;
      break;
    case 3:
      bufferSize = 2048;
      break;
    case 4:
      bufferSize = 4096;
      break;
    case 5: 
      bufferSize = 6114;
      break;
    case 6:
      bufferSize = 8192;
    default:
      bufferSize = 512;
  };
  //create the on GPU buffers
  shadowMap = createGraphics(bufferSize, bufferSize, P3D);
  subShadowMaps[0] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  subShadowMaps[1] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  subShadowMaps[2] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  subShadowMaps[3] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  cameraMatrixMap = createGraphics(bufferSize/2, bufferSize/2, P3D);//this one is just for getting camera matrixes not for actual rendering
  
  println(bufferSize);
  
  //set the light direction
  lightDir.set(-0.8, -1, 0.35);
  lightDir.mult(800);

  shadowMap.noSmooth(); // Antialiasing on the shadowMap leads to weird artifacts
  
  shadowMap.beginDraw();
  
  shadowMap.shader(depthBufferShader);
  //set the area coverd by shadows here
  int shadowMapClibBoxSize = 2000;
  shadowMap.ortho(-shadowMapClibBoxSize, shadowMapClibBoxSize, -shadowMapClibBoxSize, shadowMapClibBoxSize, 1, 13000); // Setup orthogonal view matrix for the directional light
  shadowMap.endDraw();
  //disable anti alising on the sub shaodw maps
  subShadowMaps[0].noSmooth();
  subShadowMaps[1].noSmooth();
  subShadowMaps[2].noSmooth();
  subShadowMaps[3].noSmooth();
  
  cameraMatrixMap.beginDraw();//setup the size of the camera matrix to be used for fun math
  cameraMatrixMap.ortho(-shadowMapClibBoxSize/2, shadowMapClibBoxSize/2, -shadowMapClibBoxSize/2, shadowMapClibBoxSize/2, 1, 13000);
  cameraMatrixMap.endDraw();
  
  //attempt to compile the shader now instread of later
  shader(shadowShader);
  resetShader();
  
  for(int i=0;i<subShadowMaps.length;i++){//set the starting background on each sub map to be the infinite distance
    subShadowMaps[i].beginDraw();
    subShadowMaps[i].background(255);
    subShadowMaps[i].endDraw();
  }
  
}

/**Initilize all buttons.<br>
This is nessrray becuse buttons require the renderer to exsist to properly get set up
*/
void  initButtons() {
  //there buttons I do not need to explain them
  select_lvl_1=new UiButton(ui, (100), (100), (200), (100), "lvl 1", -59135, -1791).setStrokeWeight( (10));
  select_lvl_back=new UiButton(ui, (100), (600), (200), (50), "Back", -59135, -1791).setStrokeWeight( (10));
  select_lvl_next=new UiButton(ui, (600), (600), (200), (50), "Next", -59135, -1791).setStrokeWeight( (10));
  select_lvl_2 =new UiButton(ui, (350), (100), (200), (100), "lvl 2", -59135, -1791).setStrokeWeight( (10));
  select_lvl_3 =new UiButton(ui, (600), (100), (200), (100), "lvl 3", -59135, -1791).setStrokeWeight( (10));
  select_lvl_4 =new UiButton(ui, (850), (100), (200), (100), "lvl 4", -59135, -1791).setStrokeWeight( (10));
  sdSlider=new UiButton(ui, (800), (50), (440), (30), 255, 0).setStrokeWeight( (5));
  horozontalEdgeScrollSlider = new UiSlider(ui, 800, 50, 440, 30).setStrokeWeight(5).setColors(255, 0).showValue(false).setRounding(1).setMax(630).setMin(100);
  disableFPS =new UiButton(ui, (1130), (50), (40), (40), 255, 0).setStrokeWeight( (5));
  enableFPS =new UiButton(ui, (1200), (50), (40), (40), 255, 0).setStrokeWeight( (5));
  disableDebug =new UiButton(ui, (1130), (120), (40), (40), 255, 0).setStrokeWeight( (5));
  enableDebug =new UiButton(ui, (1200), (120), (40), (40), 255, 0).setStrokeWeight( (5));
  select_lvl_5=new UiButton(ui, (100), (250), (200), (100), "lvl 5", -59135, -1791).setStrokeWeight( (10));
  select_lvl_6 =new UiButton(ui, (350), (250), (200), (100), "lvl 6", -59135, -1791).setStrokeWeight( (10));
  sttingsGPL = new UiButton(ui, (40), (550), (150), (40), "Game Play", -59135, -1791).setStrokeWeight( (10));
  settingsDSP = new UiButton(ui, (240), (550), (150), (40), "Display", -59135, -1791).setStrokeWeight( (10));
  settingsSND = new UiButton(ui, (440), (550), (150), (40), "Sound", -59135, -1791).setStrokeWeight( (10));
  settingsOUT = new UiButton(ui, (640), (550), (150), (40), "Outher", -59135, -1791).setStrokeWeight( (10));
  rez720 = new UiButton(ui, (920), (50), (40), (40), 255, 0).setStrokeWeight(5);
  rez900 = new UiButton(ui, (990), (50), (40), (40), 255, 0).setStrokeWeight(5);
  rez1080 = new UiButton(ui, (1060), (50), (40), (40), 255, 0).setStrokeWeight(5);
  rez1440 = new UiButton(ui, (1130), (50), (40), (40), 255, 0).setStrokeWeight(5);
  rez4k = new UiButton(ui, (1200), (50), (40), (40), 255, 0).setStrokeWeight(5);
  fullScreenOn = new UiButton(ui, (1200), (120), (40), (40), 255, 0).setStrokeWeight(5);
  fullScreenOff = new UiButton(ui, (1130), (120), (40), (40), 255, 0).setStrokeWeight(5);
  vsdSlider =new UiButton(ui, (800), (120), (440), (30), 255, 0).setStrokeWeight( (5));
  MusicSlider=new UiButton(ui, (800), (190), (440), (30), 255, 0).setStrokeWeight( (5));
  SFXSlider=new UiButton(ui, (800), (260), (440), (30), 255, 0).setStrokeWeight( (5));
  musicVolumeSlider = new UiSlider(ui, 800, 70, 440, 30).setStrokeWeight(5).setColors(255, 0).showValue(false).setRounding(1);
  SFXVolumeSlider = new UiSlider(ui, 800, 140, 440, 30).setStrokeWeight(5).setColors(255, 0).showValue(false).setRounding(1);
  narrationVolumeSlider = new UiSlider(ui,800,210,440,30).setStrokeWeight(5).setColors(255,0).showValue(false).setRounding(1);
  verticleEdgeScrollSlider = new UiSlider(ui, 800, 120, 440, 30).setStrokeWeight(5).setColors(255, 0).showValue(false).setRounding(1).setMax(320).setMin(100);
  fovSlider = new UiSlider(ui, 800, 190, 440, 30).setStrokeWeight(5).setColors(255,0).showValue(false).setRounding(0.5).setMax(170).setMin(10);
  shadows4 = new UiButton(ui, (1200), (190), (40), (40), 255, 0).setStrokeWeight(5);
  shadows3 = new UiButton(ui, (1130), (190), (40), (40), 255, 0).setStrokeWeight(5);
  shadows2 = new UiButton(ui, 1060, 190, 40, 40, 255, 0).setStrokeWeight(5);
  shadows1 = new UiButton(ui, 990, 190, 40, 40, 255, 0).setStrokeWeight(5);
  shadows0 = new UiButton(ui, 920, 190, 40, 40, 255, 0).setStrokeWeight(5);
  narrationMode1 =new UiButton(ui, (1200), (340), (40), (40), 255, 0).setStrokeWeight(5);
  narrationMode0 = new UiButton(ui, (1130), (340), (40), (40), 255, 0).setStrokeWeight(5);
  select_lvl_UGC=new UiButton(ui, (350), (600), (200), (50), "UGC", -59135, -1791).setStrokeWeight( (10));
  UGC_open_folder=new UiButton(ui, (350), (600), (200), (50), "Open Folder", -59135, -1791).setStrokeWeight( (10));
  UGC_lvls_next=new UiButton(ui, (1030), (335), (200), (50), "Next", -59135, -1791).setStrokeWeight( (10));
  UGC_lvls_prev=new UiButton(ui, (50), (335), (200), (50), "Prevous", -59135, -1791).setStrokeWeight( (10));
  UGC_lvl_play=new UiButton(ui, (600), (600), (200), (50), "Play", -59135, -1791).setStrokeWeight( (10));
  levelcreatorLink=new UiButton(ui, (980), (600), (200), (50), "create", -59135, -1791).setStrokeWeight( (10));
  select_lvl_7=new UiButton(ui, (600), (250), (200), (100), "lvl 7", -59135, -1791).setStrokeWeight( (10));
  select_lvl_8 =new UiButton(ui, (850), (250), (200), (100), "lvl 8", -59135, -1791).setStrokeWeight( (10));
  select_lvl_9 = new UiButton(ui, (100), (400), (200), (100), "lvl 9", -59135, -1791).setStrokeWeight( (10));
  select_lvl_10 = new UiButton(ui, (350), (400), (200), (100), "lvl 10", -59135, -1791).setStrokeWeight( (10));
  select_lvl_11 = new UiButton(ui, 600, 400, 200, 100 , "lvl 11",-59135, -1791).setStrokeWeight(10);
  select_lvl_12 = new UiButton(ui, 850, 400, 200, 100, "lvl 12",-59135, -1791).setStrokeWeight(10);
  playButton=new UiButton(ui, 540, 310, 200, 50, "Play", #FF1900, #FFF900).setStrokeWeight(10);
  mainMenuButtonConfig.add(new ButtonInMenu(playButton, 0, 0));
  exitButton=new UiButton(ui, 540, 470, 200, 50, "Exit", #FF1900, #FFF900).setStrokeWeight(10);
  mainMenuButtonConfig.add(new ButtonInMenu(exitButton, 0, 1));
  joinButton=new UiButton(ui, 540, 390, 200, 50, "Multiplayer", #FF1900, #FFF900).setStrokeWeight(10);
  settingsButton=new UiButton(ui, 540, 550, 200, 50, "Settings", #FF1900, #FFF900).setStrokeWeight(10);
  mainMenuButtonConfig.add(new ButtonInMenu(settingsButton, 0, 2));
  howToPlayButton=new UiButton(ui, 540, 630, 200, 50, "Tutorial", #FF1900, #FFF900).setStrokeWeight(10);
  mainMenuButtonConfig.add(new ButtonInMenu(howToPlayButton, 0, 3));
  downloadUpdateButton=new UiButton(ui, 390, 350, 500, 50, "Download & Install", #FF0004, #FFF300).setStrokeWeight(10);
  updateGetButton=new UiButton(ui, 390, 150, 500, 50, "Get it", #FF0004, #FFF300).setStrokeWeight(10);
  updateOkButton=new UiButton(ui, 390, 250, 500, 50, "Ok", #FF0004, #FFF300).setStrokeWeight(10);
  pauseRestart=new UiButton(ui, 500, 100, 300, 60, "Restart", #FF0004, #FFF300).setStrokeWeight(10);
  settingsBackButton = new UiButton(ui, 40, 620, 200, 50, "Back", #FF1900, #FFF900).setStrokeWeight(10);
  pauseResumeButton = new UiButton(ui, 500, 200, 300, 60, "Resume", #FF1900, #FFF900).setStrokeWeight(10);
  pauseOptionsButton = new UiButton(ui, 500, 300, 300, 60, "Options", #FF1900, #FFF900).setStrokeWeight(10);
  pauseQuitButton = new UiButton(ui, 500, 400, 300, 60, "Quit", #FF1900, #FFF900).setStrokeWeight(10);
  endOfLevelButton = new UiButton(ui, 550, 450, 200, 40, "Continue", #FF1900, #FFF900).setStrokeWeight(10);
  enableMenuTransitionButton = new UiButton(ui, (1130), (260), (40), (40), 255, 0).setStrokeWeight(5);
  disableMenuTransistionsButton = new UiButton(ui, (1200), (260), (40), (40), 255, 0).setStrokeWeight(5);
  select_lvl_13 = new UiButton(ui, (100), (100), (200), (100), "lvl 13", -59135, -1791).setStrokeWeight( (10));
  select_lvl_14 = new UiButton(ui, (350), (100), (200), (100), "lvl 14", -59135, -1791).setStrokeWeight( (10));
  select_lvl_15 =new UiButton(ui, (600), (100), (200), (100), "lvl 15", -59135, -1791).setStrokeWeight( (10));
  select_lvl_16 =new UiButton(ui, (850), (100), (200), (100), "lvl 16", -59135, -1791).setStrokeWeight( (10));




  dev_main = new UiButton(ui, 210, 100, 200, 50, "main menu");
  dev_quit = new UiButton(ui, 430, 100, 200, 50, "exit");
  dev_levels  = new UiButton(ui, 650, 100, 200, 50, "level select");
  dev_tutorial  = new UiButton(ui, 870, 100, 200, 50, "tutorial");
  dev_settings = new UiButton(ui, 210, 170, 200, 50, "settings");
  dev_UGC = new UiButton(ui, 430, 170, 200, 50, "UGC");
  dev_multiplayer = new UiButton(ui, 650, 170, 200, 50, "Multiplayer");
  dev_levelCreator=new UiButton(ui, 870, 170, 200, 50, "Level Creator");
  dev_testLevel = new UiButton(ui, 210, 240, 200, 50, "Test Level");

  multyplayerJoin = new UiButton(ui, 400, 300, 200, 50, "Join", #FF0004, #FFF300).setStrokeWeight(10);
  multyplayerHost = new UiButton(ui, 680, 300, 200, 50, "Host", #FF0004, #FFF300).setStrokeWeight(10);
  multyplayerExit = new UiButton(ui, 100, 600, 200, 50, "back", -59135, -1791).setStrokeWeight(10);
  multyplayerGo = new UiButton(ui, 640-100, 600, 200, 50, "GO", -59135, -1791).setStrokeWeight(10);
  multyplayerLeave = new UiButton(ui, 10, 660, 200, 50, "Leave", -59135, -1791).setStrokeWeight(10);

  multyplayerSpeedrun = new Button(this, width*0.18125, height*0.916666, width*0.19296875, height*0.0694444444, "Speed Run", -59135, -1791).setStrokeWeight(10*Scale);
  multyplayerCoop = new Button(this, width*0.38984375, height*0.916666, width*0.19375, height*0.0694444444, "co-op", -59135, -1791).setStrokeWeight(10*Scale);
  multyplayerUGC = new Button(this, width*0.59921875, height*0.916666, width*0.19296875, height*0.0694444444, "UGC", -59135, -1791).setStrokeWeight(10*Scale);
  multyplayerPlay = new Button(this, width*0.809375, height*0.916666, width*0.1828125, height*0.0694444444, "Play", -59135, -1791).setStrokeWeight(10*Scale);
  increaseTime = new Button(this, width*0.80546875, height*0.7, width*0.03, width*0.03, "^", -59135, -1791).setStrokeWeight(5*Scale);
  decreaseTime = new Button(this, width*0.96609375, height*0.7, width*0.03, width*0.03, "v", -59135, -1791).setStrokeWeight(5*Scale);

  newBlueprint=new UiButton(ui, 200, 500, 200, 80, "New Blueprint", #BB48ED, #4857ED).setStrokeWeight(10);
  loadBlueprint=new UiButton(ui, 800, 500, 200, 80, "Load Blueprint", #BB48ED, #4857ED).setStrokeWeight(10);
  newLevelButton=new UiButton(ui, 200, 300, 200, 80, "NEW", #BB48ED, #4857ED).setStrokeWeight(10);
  loadLevelButton=new UiButton(ui, 800, 300, 200, 80, "LOAD", #BB48ED, #4857ED).setStrokeWeight(10);

  newStage=new UiButton(ui, 1200, 10, 60, 60, "+", #0092FF, 0).setStrokeWeight(3);
  newFileCreate=new UiButton(ui, 300, 600, 200, 40, "Create", #BB48ED, #4857ED).setStrokeWeight(5);
  newFileBack=new UiButton(ui, 600, 600, 200, 40, "Back", #BB48ED, #4857ED).setStrokeWeight(5);
  chooseFileButton=new UiButton(ui, 300, 540, 200, 40, "Choose File", #BB48ED, #4857ED).setStrokeWeight(5);
  lc_newSoundAsSoundButton = new UiButton(ui,600,540,200,40,"Sound",#BB48ED, #4857ED).setStrokeWeight(5);
  lc_newSoundAsNarrationButton  = new UiButton(ui,820,540,200,40,"Narration",#BB48ED, #4857ED).setStrokeWeight(5);

  edditStage=new UiButton(ui, 1100, 10, 60, 60, #0092FF, 0).setStrokeWeight(3);

  setMainStage=new UiButton(ui, 1000, 10, 60, 60, #0092FF, 0).setHoverText("set as main stage").setStrokeWeight(3);


  selectStage=new UiButton(ui, 1200, 10, 60, 60, #0092FF, 0).setStrokeWeight(3);


  new2DStage=new UiButton(ui, 400, 200, 80, 80, "2D", #BB48ED, #4857ED).setStrokeWeight(5);
  new3DStage=new UiButton(ui, 600, 200, 80, 80, "3D", #BB48ED, #4857ED).setStrokeWeight(5);
  addSound=new UiButton(ui, 800, 200, 80, 80, #BB48ED, #4857ED).setStrokeWeight(5);

  overview_saveLevel=new UiButton(ui, 60, 20, 50, 50, #0092FF, 0).setStrokeWeight(5);
  help=new UiButton(ui, 130, 20, 50, 50, " ? ", #0092FF, 0).setStrokeWeight(3);
  overviewUp=new UiButton(ui, 270, 20, 50, 50, " ^ ", #0092FF, 0).setStrokeWeight(3);
  overviewDown=new UiButton(ui, 200, 20, 50, 50, " v ", #0092FF, 0).setStrokeWeight(3);
  createBlueprintGo=new UiButton(ui, 40, 400, 200, 40, "Start", #BB48ED, #4857ED).setStrokeWeight(10);

  lcLoadLevelButton=new UiButton(ui, 40, 400, 200, 40, "Load", #BB48ED, #4857ED).setStrokeWeight(10);
  lcNewLevelButton=new UiButton(ui, 40, 400, 200, 40, "Start", #BB48ED, #4857ED).setStrokeWeight(10);
  lc_backButton=new UiButton(ui, 20, 650, 200, 40, "Back", #BB48ED, #4857ED).setStrokeWeight(10);
  lcOverviewExitButton= new UiButton(ui, 340, 20, 100, 50, "Exit", #0092FF, 0);

  lc_exitConfirm = new UiButton(ui, 240, 400, 200, 50, "Exit", #BB48ED, #4857ED).setStrokeWeight(10);
  lc_exitCancle = new UiButton(ui, 840, 400, 200, 50, "Cancle", #BB48ED, #4857ED).setStrokeWeight(10);

  lc_openLevelsFolder = new UiButton(ui, 1060, 650, 200, 40, "Open Folder", #BB48ED, #4857ED).setStrokeWeight(10);
  
  lcEnterLevelTextBox = new UiTextBox(ui, 40, 100, 1160, 50).setColors(#48EDD8,0).setTextSize(20).setPlaceHolder("Level Name Here");
  lcNewFileTextBox = new UiTextBox(ui, 100, 375, 1100, 75).setColors(#0092FF,0).setTextSize(70).setPlaceHolder("");
  
  defaultAuthorNameTextBox = new UiTextBox(ui,900,330,340,40).setColors(#FFFFFF,0).setStrokeWeight(5).setTextSize(26).setPlaceHolder("Name Goes Here").setContence(defaultAuthor);
  
  //perhapse dont use default suthor for this, or do
  multyPlayerNameTextBox = new UiTextBox(ui, 128, 108, 1024, 36).setColors(#FF8000,0).setTextSize(25).setPlaceHolder("Your Name Here").setContence(defaultAuthor);
  multyPlayerPortTextBox = new UiTextBox(ui, 128, 187, 1024, 36).setColors(#FF8000,0).setTextSize(25).setPlaceHolder("Port Here").setContence(port+"").setAllowList("0123456789");
  multyPlayerIpTextBox = new UiTextBox(ui, 128, 266, 1024, 36).setColors(#FF8000,0).setTextSize(25).setPlaceHolder("Host Address Here").setContence("localhost").setAllowList(".0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-");


  //DO NOT EDIT BELOW THIS LINE ON THE MAIN PROJECT!
  //===================================================
  //DO NOT EDIT THEESE LINES, EVER
  //+++++++++++++++++++++++++++++++++++++++++++++++++++
  //===================================================
  //reserved for arcade edition vars
  
  levelCompleteScreenContinue = new UiButton(ui,550, 620, 200, 40, "Continue", #FF1900, #FFF900).setStrokeWeight(10);

  onScreenKeyboardButtons[0] = new Button[10];
  onScreenKeyboardButtons[1] = new Button[10];
  onScreenKeyboardButtons[2] = new Button[9];
  onScreenKeyboardButtons[3] = new Button[9];
  //onScreenKeyboardButtonLabels
  for(int j=0;j<2;j++){
    for(int i=0;i<onScreenKeyboardButtons[j].length;i++){
      onScreenKeyboardButtons[j][i]=new UiButton(ui,60+120*i,308+100*j,60,60,onScreenKeyboardButtonLabels[j].charAt(i)+"",#FF1900, #FFF900).setStrokeWeight(10);
    }
  }
  for(int i=0;i<onScreenKeyboardButtons[2].length;i++){
    onScreenKeyboardButtons[2][i]=new UiButton(ui,75+120*i,508,60,60,onScreenKeyboardButtonLabels[2].charAt(i)+"",#FF1900, #FFF900).setStrokeWeight(10);
  }

  for(int i=0;i<onScreenKeyboardButtons[3].length-2;i++){
    onScreenKeyboardButtons[3][i]=new UiButton(ui,105+120*i,608,60,60,onScreenKeyboardButtonLabels[3].charAt(i)+"",#FF1900, #FFF900).setStrokeWeight(10);
  }

  onScreenKeyboardButtons[3][7] = new UiButton(ui,945,608,90,60,"Shift",#FF1900, #FFF900).setStrokeWeight(10);
  onScreenKeyboardButtons[3][8] = new UiButton(ui,1095,608,90,60,"Enter",#FF1900, #FFF900).setStrokeWeight(10);

  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_1, 0, 0));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_2, 1, 0));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_3, 2, 0));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_4, 3, 0));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_5, 0, 1));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_6, 1, 1));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_7, 2, 1));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_8, 3, 1));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_9, 0, 2));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_10, 1, 2));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_11, 2, 2));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_12, 3, 2));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_back, 0, 3));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_UGC, 1, 3));
  levelSelectMenuButtonConfig.add(new ButtonInMenu(select_lvl_next, 2, 3));

  levelSelect2MenuButtonConfig.add(new ButtonInMenu(select_lvl_back, 0, 1));
  levelSelect2MenuButtonConfig.add(new ButtonInMenu(select_lvl_13, 0, 0));
  levelSelect2MenuButtonConfig.add(new ButtonInMenu(select_lvl_14, 1, 0));
  

  pauseMenuButtonConfig.add(new ButtonInMenu(pauseResumeButton, 0, 0));
  pauseMenuButtonConfig.add(new ButtonInMenu(pauseOptionsButton, 0, 1));
  pauseMenuButtonConfig.add(new ButtonInMenu(pauseQuitButton, 0, 2));

  levelSelectUGCMenuButtonConfig.add(new ButtonInMenu(select_lvl_back, 0, 1));
  levelSelectUGCMenuButtonConfig.add(new ButtonInMenu(UGC_lvl_play, 1, 1));
  levelSelectUGCMenuButtonConfig.add(new ButtonInMenu(UGC_lvls_prev, 0, 0));
  levelSelectUGCMenuButtonConfig.add(new ButtonInMenu(UGC_lvls_next, 1, 0));

  settingsGameplayMenuConfig.add(new ButtonInMenu(sttingsGPL, 0, 3));
  settingsGameplayMenuConfig.add(new ButtonInMenu(settingsDSP, 1, 3));
  settingsGameplayMenuConfig.add(new ButtonInMenu(settingsSND,2, 3));
  settingsGameplayMenuConfig.add(new ButtonInMenu(settingsOUT, 3, 3));
  settingsGameplayMenuConfig.add(new ButtonInMenu(settingsBackButton, 0, 4));
  settingsGameplayMenuConfig.add(new ButtonInMenu(horozontalEdgeScrollSlider, 2, 0));
  settingsGameplayMenuConfig.add(new ButtonInMenu(verticleEdgeScrollSlider, 2, 1));
  settingsGameplayMenuConfig.add(new ButtonInMenu(fovSlider, 2, 2));

  settingsDisplayMenuConfig.add(new ButtonInMenu(settingsDSP, 1, 2));
  settingsDisplayMenuConfig.add(new ButtonInMenu(sttingsGPL, 0, 2));
  settingsDisplayMenuConfig.add(new ButtonInMenu(settingsSND,2,2));
  settingsDisplayMenuConfig.add(new ButtonInMenu(settingsOUT, 3, 2));
  settingsDisplayMenuConfig.add(new ButtonInMenu(settingsBackButton, 0, 3));
  settingsDisplayMenuConfig.add(new ButtonInMenu(rez720, 0, 0));
  settingsDisplayMenuConfig.add(new ButtonInMenu(rez900, 1, 0));
  settingsDisplayMenuConfig.add(new ButtonInMenu(rez1080, 2, 0));
  settingsDisplayMenuConfig.add(new ButtonInMenu(rez1440, 3, 0));
  settingsDisplayMenuConfig.add(new ButtonInMenu(rez4k, 4, 0));
  settingsDisplayMenuConfig.add(new ButtonInMenu(fullScreenOff, 3, 1));
  settingsDisplayMenuConfig.add(new ButtonInMenu(fullScreenOn, 4, 1));

  settingsSoundMenuConfig.add(new ButtonInMenu(settingsSND,2,4));
  settingsSoundMenuConfig.add(new ButtonInMenu(settingsDSP, 1, 4));
  settingsSoundMenuConfig.add(new ButtonInMenu(sttingsGPL, 0, 4));
  settingsSoundMenuConfig.add(new ButtonInMenu(settingsOUT, 3, 4));
  settingsSoundMenuConfig.add(new ButtonInMenu(settingsBackButton, 0, 5));
  settingsSoundMenuConfig.add(new ButtonInMenu(narrationMode0,3,3));
  settingsSoundMenuConfig.add(new ButtonInMenu(narrationMode1,4,3));
  settingsSoundMenuConfig.add(new ButtonInMenu(musicVolumeSlider,3,0));
  settingsSoundMenuConfig.add(new ButtonInMenu(SFXVolumeSlider,3,1));
  settingsSoundMenuConfig.add(new ButtonInMenu(narrationVolumeSlider,3,2));

  settingsOutherMenuConfig.add(new ButtonInMenu(settingsOUT, 3, 4));
  settingsOutherMenuConfig.add(new ButtonInMenu(sttingsGPL, 0, 4));
  settingsOutherMenuConfig.add(new ButtonInMenu(settingsDSP, 1, 4));
  settingsOutherMenuConfig.add(new ButtonInMenu(settingsSND, 2, 4));
  settingsOutherMenuConfig.add(new ButtonInMenu(settingsBackButton, 0, 5));
  settingsOutherMenuConfig.add(new ButtonInMenu(disableFPS, 3, 0));
  settingsOutherMenuConfig.add(new ButtonInMenu(enableFPS, 4, 0));
  settingsOutherMenuConfig.add(new ButtonInMenu(disableDebug, 3, 1));
  settingsOutherMenuConfig.add(new ButtonInMenu(enableDebug, 4, 1));
  //shadows0
  settingsOutherMenuConfig.add(new ButtonInMenu(shadows0, 0, 2));
  settingsOutherMenuConfig.add(new ButtonInMenu(shadows1, 1, 2));
  settingsOutherMenuConfig.add(new ButtonInMenu(shadows2, 2, 2));
  settingsOutherMenuConfig.add(new ButtonInMenu(shadows3, 3, 2));
  settingsOutherMenuConfig.add(new ButtonInMenu(shadows4, 4, 2));
  settingsOutherMenuConfig.add(new ButtonInMenu(enableMenuTransitionButton, 3, 3));
  settingsOutherMenuConfig.add(new ButtonInMenu(disableMenuTransistionsButton, 4, 3));

  //settingsOutherMenuConfig.add(new ButtonInMenu(narrationMode0, 2, 5));
  //settingsOutherMenuConfig.add(new ButtonInMenu(narrationMode1, 3, 5));
  //settingsOutherMenuConfig.add(new ButtonInMenu(musicVolumeSlider, 2, 2));
  //settingsOutherMenuConfig.add(new ButtonInMenu(SFXVolumeSlider, 2, 3));

  levelCompleteMenuConfig.add(new ButtonInMenu(levelCompleteScreenContinue,0,0));
  

  for(int i=0;i<onScreenKeyboardButtons.length;i++){
    for(int j=0;j<onScreenKeyboardButtons[i].length;j++){
      onScreenKeyboardMenuConfig.add(new ButtonInMenu(onScreenKeyboardButtons[i][j],j,i));
    }
  }
  
  buttonMenuConfigMapping.put("main",mainMenuButtonConfig);
  buttonMenuConfigMapping.put("level select",levelSelectMenuButtonConfig);
  buttonMenuConfigMapping.put("pause",pauseMenuButtonConfig);
  buttonMenuConfigMapping.put("level select UGC",levelSelectUGCMenuButtonConfig);
  buttonMenuConfigMapping.put("settings_game play",settingsGameplayMenuConfig);
  buttonMenuConfigMapping.put("settings_display",settingsDisplayMenuConfig);
  buttonMenuConfigMapping.put("settings_sound",settingsSoundMenuConfig);
  buttonMenuConfigMapping.put("settings_outher",settingsOutherMenuConfig);
  buttonMenuConfigMapping.put("level complete",levelCompleteMenuConfig);
  buttonMenuConfigMapping.put("high score",onScreenKeyboardMenuConfig);
  buttonMenuConfigMapping.put("level select 2",levelSelect2MenuButtonConfig);

  //
  currentMenuConfig.set();
  
  
  //===================================================
  //DO NOT EDIT THEESE LINES, EVER
  //+++++++++++++++++++++++++++++++++++++++++++++++++++
  //===================================================

}

/**Get the combined file hash of a given level
@param path The file path to the level folder of the level to calculaet the hash of
@return the concatenated SHA-256 hash of all the files that make up a level
*/
String getLevelHash(String path) {
  String basePath="";
  if (path.startsWith("data")) {//check for levels that are bundled with the sketch (their paths will begin with data/)
    basePath=sketchPath()+"/"+path;//prepend the sketch path to the path of local levels
  } else {
    basePath=path;
  }
  String hash="";//get the hash of the level index file
  hash+=Hasher.getFileHash(basePath+"/index.json");

  JSONArray file = loadJSONArray(basePath+"/index.json");//load the index file
  JSONObject job;
  //for each file listed in the index file
  for (int i=1; i<file.size(); i++) {
    job=file.getJSONObject(i);
    //extract the file name for each component and generate its hash
    if (job.getString("type").equals("stage")||job.getString("type").equals("3Dstage")) {
      hash+=Hasher.getFileHash(basePath+job.getString("location"));
      continue;
    }
    if (job.getString("type").equals("sound")) {
      hash+=Hasher.getFileHash(basePath+job.getString("location"));
      continue;
    }
    if (job.getString("type").equals("logicBoard")) {
      hash+=Hasher.getFileHash(basePath+job.getString("location"));
    }
  }
  //return the total hash calculated
  return hash;
}

/**Generate the list of avawable UGC levels
*/
void loadUGCList() {
  new File(appdata+"/CBi-games/skinny mann/UGC/levels").mkdirs();//create the level folder if it does not exsist
  String[] files=new File(appdata+"/CBi-games/skinny mann/UGC/levels").list();//get the list of files/folder in the levels folder

  compatibles=new ArrayList<>();//list of comparable levels
  UGCNames=new ArrayList<>();//list of the level names
  try {
    if (files.length==0){//if there are not levels stop
      return;
    }
  } catch(NullPointerException e) {//if there are no levels and no object was returned
    return;
  }
  //go through the levels and check if they are compatable with this verison of the game
  for (int i=0; i<files.length; i++) {
    if (FileIsLevel(files[i])) {
      UGCNames.add(files[i]);
      if (levelCompatible) {
        compatibles.add(false);
      } else {
        compatibles.add(true);
      }
    }
  }
}

/**Rest various level creator variables to their default/off states.<br>
Primarily used when switching tools to make sure everything is in the correct stsate
*/
void turnThingsOff() {
  selectedIndex=-1;
  deleteing=false;
  moving_player=false;
  levelOverview=false;
  drawingPortal=false;
  drawingPortal3=false;
  selecting=false;
  selectingBlueprint=false;
  connectingLogic=false;
  moveLogicComponents=false;
  settingPlayerSpawn=false;
  placingGoon=false;
  currentlyPlaceing = null;
  rotating = false;
}

/**File selection callback from the level creator add sound screen
@param selection The file that was selected
*/
void fileSelected(File selection) {
  if (selection == null) {//if there was no selection just return
    return;
  }
  String path = selection.getAbsolutePath();//get the file path
  System.out.println(path);
  String extenchen=path.substring(path.length()-3, path.length()).toLowerCase();//get the extention
  System.out.println(extenchen);
  if (extenchen.equals("wav")||extenchen.equals("mp3")||extenchen.equals("aif")) {//check if the file type is valid
    fileToCoppyPath=path;
  } else {
    System.out.println("invalid extenchen");
    return;
  }
}

/**Initilize all scale managed text.<br>
This is nessrray becuse text require the renderer to exsist to properly get set up
*/
void initText() {
  //very simple not going to explain what is happening heres
  mm_title = new UiText(ui, "Skinny Mann", 640, 80, 100, CENTER, CENTER);
  mm_EarlyAccess = new UiText(ui, "Arcade Edition  ", 640, 180, 100, CENTER, CENTER);
  mm_version = new UiText(ui, version, 0, 718, 20, LEFT, BOTTOM);
  ls_levelSelect = new UiText(ui, "Level Select", 640, 54, 50, CENTER, CENTER);
  lsUGC_title = new UiText(ui, "User Generated Levels", 640, 54, 35, CENTER, CENTER);
  lsUGC_noLevelFound = new UiText(ui, "no levels found", 640, 360, 50, CENTER, CENTER);
  lsUGC_levelNotCompatible = new UiText(ui, "this level is not compatible with this version of the game", 640, 432, 50, CENTER, CENTER);
  lsUGC_levelName = new UiText(ui, "V", 640, 360, 50, CENTER, CENTER);
  st_title = new UiText(ui, "Settings", 640, 720, 100, CENTER, BOTTOM);
  st_Hssr = new UiText(ui, "horozontal screen scrolling location", 40, 90, 40, LEFT, BOTTOM);
  st_Vssr = new UiText(ui, "vertical  screen scrolling location", 40, 160, 40, LEFT, BOTTOM);
  st_gameplay = new UiText(ui, "Game Play", 640, 0, 50, CENTER, TOP);
  st_vsrp = new UiText(ui, "V", 700, 160, 40, LEFT, BOTTOM);
  st_hsrp = new UiText(ui, "V", 700, 90, 40, LEFT, BOTTOM);
  st_gmp_fovdesc = new UiText(ui, "Camera FOV", 40, 230, 40, LEFT, BOTTOM);
  st_gmp_fovdisp =  new UiText(ui,"V", 700, 230, 40, LEFT, BOTTOM);
  st_dsp_vsr = new UiText(ui, "verticle screen resolution (requires restart)", 40, 80, 40, LEFT, BOTTOM);
  st_dsp_fs = new UiText(ui, "full screen (requires restart)", 40, 140, 40, LEFT, BOTTOM);
  st_dsp_4k = new UiText(ui, "2160(4K)", 1190, 45, 20, LEFT, BOTTOM);
  st_dsp_1440 = new UiText(ui, "1440", 1120, 45, 20, LEFT, BOTTOM);
  st_dsp_1080 = new UiText(ui, "1080", 1055, 45, 20, LEFT, BOTTOM);
  st_dsp_900 = new UiText(ui, "900", 990, 45, 20, LEFT, BOTTOM);
  st_dsp_720 = new UiText(ui, "720", 920, 45, 20, LEFT, BOTTOM);
  st_dsp_fsYes = new UiText(ui, "yes", 1190, 115, 20, LEFT, BOTTOM);
  st_dsp_fsNo = new UiText(ui, "no", 1120, 115, 20, LEFT, BOTTOM);
  st_display = new UiText(ui, "Display", 640, 0, 50, CENTER, TOP);
  st_sound = new UiText(ui, "Sound",640,0,50,CENTER,TOP);
  st_snd_narrationVol = new UiText(ui, "narration volume", 40, 250, 40, LEFT, BOTTOM);
  st_snd_currentNarrationVolume = new UiText(ui, "N", 700, 250, 40, LEFT, BOTTOM);
  st_o_displayFPS = new UiText(ui, "display fps", 40, 70, 40, LEFT, BOTTOM);
  st_o_debugINFO = new UiText(ui, "display debug info", 40, 140, 40, LEFT, BOTTOM);
  st_snd_musicVol = new UiText(ui, "music volume", 40, 110, 40, LEFT, BOTTOM);
  st_snd_SFXvol = new UiText(ui, "sounds volume", 40, 180, 40, LEFT, BOTTOM);
  st_o_3DShadow = new UiText(ui, "3D shadows", 40, 210, 40, LEFT, BOTTOM);
  st_snd_narration = new UiText(ui, "narration mode", 40, 380, 40, LEFT, BOTTOM);
  st_o_yes = new UiText(ui, "yes", 1190, 45, 20, LEFT, BOTTOM);
  st_o_no = new UiText(ui, "no", 1120, 45, 20, LEFT, BOTTOM);
  st_o_shadowsOff    = new UiText(ui, "Off", 940, 175, 20, CENTER, CENTER);
  st_o_shadowsOld    = new UiText(ui, "Old", 1010, 175, 20, CENTER, CENTER);
  st_o_shadowsLow    = new UiText(ui, "Low", 1080, 175, 20, CENTER, CENTER);
  st_o_shadowsMedium = new UiText(ui, "Medium", 1150, 175, 20, CENTER, CENTER);
  st_o_shadowsHigh   = new UiText(ui, "High", 1220, 175, 20, CENTER, CENTER);
  
  st_o_diableTransitions = new UiText(ui,"Disable Menu Transitions",40,280,40,LEFT,BOTTOM);
  st_o_defaultAuthor = new UiText(ui,"Default Level Creator Author",40,350,40,LEFT,BOTTOM);
  st_snd_better = new UiText(ui, "better", 1190, 340, 20, LEFT, BOTTOM);
  st_snd_demonitized = new UiText(ui, "please don't\ndemonetize\nme youtube", 1070, 340, 20, LEFT, BOTTOM);
  st_snd_currentMusicVolume = new UiText(ui, "V", 700, 110, 40, LEFT, BOTTOM);
  st_snd_currentSoundsVolume = new UiText(ui, "B", 700, 180, 40, LEFT, BOTTOM);
  st_other = new UiText(ui, "Outher", 640, 0, 50, CENTER, TOP);
  initMultyplayerScreenTitle = new UiText(ui, "Multiplayer", 640, 36, 50, CENTER, CENTER);
  mp_hostSeccion = new UiText(ui, "Host session", 640, 36, 50, CENTER, CENTER);
  mp_host_Name = new UiText(ui, "Name", 640, 93.6, 25, CENTER, CENTER);
  mp_host_port = new UiText(ui, "Port", 640, 172.8, 25, CENTER, CENTER);
  mp_joinSession = new UiText(ui, "Join session", 640, 36, 50, CENTER, CENTER);
  mp_join_name = new UiText(ui, "Name", 640, 93.6, 25, CENTER, CENTER);
  mp_join_port = new UiText(ui, "Port", 640, 172.8, 25, CENTER, CENTER);
  mp_join_ip = new UiText(ui, "IP address", 640, 252, 25, CENTER, CENTER);
  mp_disconnected = new UiText(ui, "Disconnected", 640, 36, 50, CENTER, CENTER);
  mp_dc_reason = new UiText(ui, "V", 640, 216, 25, CENTER, CENTER);
  dev_title = new UiText(ui, "Developer Menue", 640, 36, 50, CENTER, CENTER);
  dev_info = new UiText(ui, "this is a development build of the game, there may be bugs or unfinished features", 640, 72, 25, CENTER, CENTER);
  tut_notToday = new UiText(ui, "this feture is disabled during the tutorial\npres C to return", 640, 360, 50, CENTER, CENTER);
  tut_disclaimer = new UiText(ui, "ATTENTION\n\nThe folowing contains content language\nthat some may find disterbing.\nIf you don't like foul language,\nmake shure you setting are set accordingly.\n\nAudio in use turn your volume up!", 640, 360, 50, CENTER, CENTER);
  tut_toClose = new UiText(ui, "press C to close", 640, 698.4, 25, CENTER, CENTER);
  coinCountText = new UiText(ui, "coins: ", 0, 0, 50, LEFT, TOP);
  pa_title = new UiText(ui, "GAME PAUSED", 640, 100, 100, CENTER, BOTTOM);
  logoText = new UiText(ui, "GAMES", 640, 600, 100, CENTER, CENTER);
  up_title = new UiText(ui, "UPDATE!!!", 640, 102.857, 50, CENTER, BASELINE);
  up_info = new UiText(ui, "A new version of this game has been released!!!", 640, 120, 20, CENTER, BASELINE);
  up_wait = new UiText(ui, "please wait", 640, 102.857, 50, CENTER, BASELINE);
  lc_start_version = new UiText(ui, "game ver: "+GAME_version+ "  editor ver: "+EDITOR_version, 0, 718, 15, LEFT, BOTTOM);
  lc_start_author = new UiText(ui, "author: ", 10, 30, 15, LEFT, BOTTOM);
  lc_load_new_describe = new UiText(ui, "enter level name", 40, 100, 20, LEFT, BOTTOM);
  lc_load_notFound = new UiText(ui, "Level Not Found!", 640, 300, 50, CENTER, CENTER);
  lc_newf_fileName = new UiText(ui, "VAL", 305, 520, 30, LEFT, BOTTOM);
  lc_dp2_info = new UiText(ui, "select destenation stage", 640, 30, 60, CENTER, CENTER);
  lc_newbp_describe = new UiText(ui, "enter blueprint name", 40, 100, 20, LEFT, BOTTOM);
  lc_exit_question = new UiText(ui, "Are you sure?", 640, 120, 50, CENTER, CENTER);
  lc_exit_disclaimer = new UiText(ui, "Any unsaved data will be lost.", 640, 200, 50, CENTER, CENTER);
  lc_fullScreenWarning = new UiText(ui, "Full screen mode is not recommended for the Level Creator", 640, 420, 45, CENTER, CENTER);
  deadText = new UiText(ui, "you died", 640, 360, 50, CENTER, CENTER);
  fpsText = new UiText(ui, "fps: ", 1220, 10, 10, LEFT, BOTTOM);
  dbg_mspc = new UiText(ui, "mspc: V", 1275, 10, 10, RIGHT, TOP);
  dbg_playerX = new UiText(ui, "player X: V", 1275, 20, 10, RIGHT, TOP);
  dbg_playerY = new UiText(ui, "player Y: V", 1275, 30, 10, RIGHT, TOP);
  dbg_vertvel = new UiText(ui, "player vertical velocity: V", 1275, 40, 10, RIGHT, TOP);
  dbg_animationCD = new UiText(ui, "player animation Cooldown: V", 1275, 50, 10, RIGHT, TOP);
  dbg_pose = new UiText(ui, "player pose: V", 1275, 60, 10, RIGHT, TOP);
  dbg_camX = new UiText(ui, "camera x: V", 1275, 70, 10, RIGHT, TOP);
  dbg_camY = new UiText(ui, "camera y: V", 1275, 80, 10, RIGHT, TOP);
  dbg_tutorialPos = new UiText(ui, "tutorial position: V", 1275, 90, 10, RIGHT, TOP);
  game_displayText = new UiText(ui, "V", 640, 144, 200, CENTER, CENTER);
  lebelCompleteText = new UiText(ui, "LEVEL COMPLETE!!!", 200, 400, 100, LEFT, BOTTOM);
  settingPlayerSpawnText = new UiText(ui, "Select the spawn location of the player",640,72,35,CENTER,CENTER);
  narrationCaptionText = new UiText(ui,"*Narration in progress*",640,695,20,CENTER,BOTTOM);
  dbg_ping = new UiText(ui,"Ping: N/A",1275,100,10,RIGHT,TOP);
  
  //DO NOT EDIT BELOW THIS LINE ON THE MAIN PROJECT!
  //===================================================
  //DO NOT EDIT THEESE LINES, EVER
  //+++++++++++++++++++++++++++++++++++++++++++++++++++
  //===================================================
  //reserved for arcade edition vars
  
  elapsedTimeDisplay = new UiText(ui, "TIME" ,640,20,20,CENTER,CENTER);
  levelCompleteTitle = new UiText(ui, "Level Complete!!",640, 40, 50,CENTER,CENTER);
  levelCompleteLevelName = new UiText(ui, "LEVEL NAME HERE",640, 90, 30,CENTER,CENTER);
  levelCompleteLeaderBoardLeftColumn = new UiText(ui,"1)\n2)\n3)\n4)\n5)\n6)\n7)\n8)\n9)\n10)",250,200,20,LEFT,TOP);
  levelCompleteLeaderBoardCenterColumn = new UiText(ui,"NAME\nNAME\nNAME\nNAME\nNAME\nNAME\nNAME\nNAME\nNAME\nNAME",300,200,20,LEFT,TOP);
  levelCompleteLeaderBoardRightColumn = new UiText(ui,"0:0:0\n0:0:0\n0:0:0\n0:0:0\n0:0:0\n0:0:0\n0:0:0\n0:0:0\n0:0:0\n0:0:0",840,200,20,LEFT,TOP);
  enterNameText = new UiText(ui,"Enter Name",640,40,50,CENTER,CENTER);
  highScoreName = new UiText(ui,"NAME HERE",640,150,60,CENTER,CENTER);
  yourScore = new UiText(ui,"Your Time: 0:0:0",640,120,30,CENTER,CENTER);

  mainMenuWebsite = new UiText(ui, "More at: https://cbi-games.org",640,415,60,CENTER,CENTER);
  
  //===================================================
  //DO NOT EDIT THEESE LINES, EVER
  //+++++++++++++++++++++++++++++++++++++++++++++++++++
  //===================================================
}

//DO NOT EDIT BELOW THIS LINE ON THE MAIN PROJECT!
//===================================================
//DO NOT EDIT THEESE LINES, EVER
//+++++++++++++++++++++++++++++++++++++++++++++++++++
//===================================================
//reserved for arcade edition vars

ButtonMenuConfig mainMenuButtonConfig=new ButtonMenuConfig(1, 4), levelSelectMenuButtonConfig = new ButtonMenuConfig(4, 4), levelSelect2MenuButtonConfig = new ButtonMenuConfig(4, 2), pauseMenuButtonConfig = new ButtonMenuConfig(1, 3), levelSelectUGCMenuButtonConfig = new UGCButtonMenuConfig(),
  settingsGameplayMenuConfig=new ButtonMenuConfig(4, 5), settingsDisplayMenuConfig=new ButtonMenuConfig(5, 4),settingsSoundMenuConfig = new ButtonMenuConfig(5,6), settingsOutherMenuConfig = new ButtonMenuConfig(5, 8),levelCompleteMenuConfig = new ButtonMenuConfig(1,1),onScreenKeyboardMenuConfig=new ButtonMenuConfig(10,4);


ButtonMenuConfig currentMenuConfig=mainMenuButtonConfig;
boolean controller_set_b=false, controller_set_a=false, controllerConfigSlider=false;
int currentSelectedButton=0, lastMenuControllerInput=0;
void handleControllerState() {
  if (menue) {//if nagigating a menu
    if (controllerConfigSlider) {
      if (!controller_set_a&&gamepad.a()) {
        controllerConfigSlider=false;
        currentMenuConfig.get(currentSelectedButton).getSlider().setSelecetd(false);
      }
      controller_set_a = gamepad.a();
      if (millis()-lastMenuControllerInput>80) {
      if (gamepad.leftStickX()>0.3) {
          lastMenuControllerInput = millis();
          UiSlider slider = currentMenuConfig.get(currentSelectedButton).getSlider();
          slider.setValue(slider.getValue()+1);
          updateSettingsFromSliderValues();
        }
        if (gamepad.leftStickX()<-0.3) {
          lastMenuControllerInput = millis();
          UiSlider slider = currentMenuConfig.get(currentSelectedButton).getSlider();
          slider.setValue(slider.getValue()-1);
          updateSettingsFromSliderValues();
        }
      }
    } else {
      //joystick inputs
      if (millis()-lastMenuControllerInput>200) {
        if (gamepad.leftStickY()>0.3) {
          lastMenuControllerInput = millis();
          handleNewMenuButtonSelection(currentMenuConfig.down(currentSelectedButton));
        }
        if (gamepad.leftStickY()<-0.3) {
          lastMenuControllerInput = millis();
          handleNewMenuButtonSelection(currentMenuConfig.up(currentSelectedButton));
        }
        if (gamepad.leftStickX()>0.3) {
          lastMenuControllerInput = millis();
          handleNewMenuButtonSelection(currentMenuConfig.right(currentSelectedButton));
        }
        if (gamepad.leftStickX()<-0.3) {
          lastMenuControllerInput = millis();
          handleNewMenuButtonSelection(currentMenuConfig.left(currentSelectedButton));
        }
      }
      
      //check if the current menu config needs to be changed and chnage it if so
      ButtonMenuConfig screenConfig;
      if (Menue.equals("settings")) {
        screenConfig = buttonMenuConfigMapping.get(Menue+"_"+settingsMenue);
      }else{
        screenConfig = buttonMenuConfigMapping.get(Menue);
      }
      if(screenConfig!=null){
        if (currentMenuConfig!=screenConfig) {
          currentMenuConfig.reset();
          screenConfig.set();
          currentSelectedButton=0;
          currentMenuConfig=screenConfig;
        }
      }
      
      if (tutorialMode&&!inGame&&gamepad.y()) {
          Menue="pause";
          inGame=true;
          prevousInGame=false;
      }



      //use button action
      if (!controller_set_a&&gamepad.a()) {//rizeing edge pulse only
        if (currentMenuConfig.get(currentSelectedButton).isSlider()) {
          controllerConfigSlider=true;
          currentMenuConfig.get(currentSelectedButton).getSlider().setSelecetd(true);
        } else {
          Button button =currentMenuConfig.get(currentSelectedButton).button();
          int xpos =(int)( button.x + button.lengthX/2), ypos = (int)(button.y + button.lengthY/2);
          mouseX=xpos;
          mouseY=ypos;
          mouseClicked();
          lastMenuControllerInput = millis();
        }
      }
      controller_set_a = gamepad.a();
    }
  } else if (inGame) {//if in game
    //playerMovementManager.setLeft(true);
    //playerMovementManager.setRight(true);
    //playerMovementManager.setJump(true);
    playerMovementManager.setRight(gamepad.leftStickX()>0.4);
    playerMovementManager.setLeft(gamepad.leftStickX()<-0.4);
    playerMovementManager.setIn(gamepad.leftStickY()<-0.4);
    playerMovementManager.setOut(gamepad.leftStickY()>0.4);
    if (millis()-lastMenuControllerInput>200)
      playerMovementManager.setJump(gamepad.a());
    cam_left=gamepad.rightStickX()<-0.4;
    cam_right=gamepad.rightStickX()>0.4;
    cam_down=gamepad.rightStickY()>0.4;
    cam_up=gamepad.rightStickY()<-0.4;
    if (!controller_set_b&&gamepad.b()) {
      E_pressed=true;
    }
    controller_set_b = gamepad.b();
    if (!controller_set_b) {
      E_pressed=false;
    }
    if (gamepad.y()) {
      menue=true;
      Menue="pause";
    }
  }

  if (!menue&&tutorialMode&&gamepad.y()&&tutorialPos<3) {
    Menue="main";
    menue=true;
    tutorialMode=false;
    soundHandler.stopNarration(tutorialNarration[settings.getSoundNarrationMode()][currentTutorialSound]);
  }

}

void handleNewMenuButtonSelection(int newSelection) {
  if (newSelection!=currentSelectedButton) {
    currentMenuConfig.get(currentSelectedButton).button().selected(false);
    currentMenuConfig.get(newSelection).button().selected(true);
    currentSelectedButton=newSelection;
  }
}

class ButtonInMenu {
  Button b;
  UiSlider s;
  int x, y;
  boolean isSlider=false;
  ButtonInMenu(Button button, int x, int y) {
    b=button;
    this.x=x;
    this.y=y;
  }
  ButtonInMenu(UiSlider slider, int x, int y) {
    s=slider;
    this.x=x;
    this.y=y;
    isSlider=true;
  }
  Button button() {
    if (!isSlider)
      return b;
    else {
      return s.button;
    }
  }
  UiSlider getSlider() {
    return s;
  }
  float distance(int x, int y) {
    return dist(1.0*this.x, this.y, x, y);
  }
  int x() {
    return x;
  }
  int y() {
    return y;
  }
  boolean isSlider() {
    return isSlider;
  }
}

class ButtonMenuConfig {
  ArrayList<ButtonInMenu> buttons=new ArrayList<>();
  int maxX, maxY;
  ButtonMenuConfig(int width, int height) {
    maxX=width;
    maxY=height;
  }

  ButtonInMenu get(int index) {
    return buttons.get(index);
  }

  void add(ButtonInMenu button) {
    buttons.add(button);
  }

  int nearest(int ix, int iy, int index) {
    float dist=10000;
    int nerindx=0;
    for (int i=0; i<buttons.size(); i++) {
      if (i==index)//don't return the element being moved from
        continue;
      float nd = get(i).distance(ix, iy);
      if (nd < dist) {
        dist=nd;
        nerindx=i;
      }
    }
    return nerindx;
  }

  int right(int index) {
    int x=get(index).x()+1;
    int y=get(index).y();
    if (x>=maxX) {
      return index;
    }
    return nearest(x, y, index);
  }

  int left(int index) {
    int x=get(index).x()-1;
    int y=get(index).y();
    if (x<0) {
      return index;
    }
    return nearest(x, y, index);
  }

  int down(int index) {
    int x=get(index).x();
    int y=get(index).y()+1;
    if (y>=maxY) {
      return index;
    }
    return nearest(x, y, index);
  }
  int up(int index) {
    int x=get(index).x();
    int y=get(index).y()-1;
    if (y<0) {
      return index;
    }
    return nearest(x, y, index);
  }

  void reset() {
    for (int i=0; i<buttons.size(); i++) {
      get(i).button().selected(false);
    }
  }

  void set() {
    get(0).button().selected(true);
  }
}
/*
if (UGC_lvl_indx<UGCNames.size()-1) {
 UGC_lvls_next.draw();
 }
 if (UGC_lvl_indx>0) {
 UGC_lvls_prev.draw();
 }
 */
class UGCButtonMenuConfig extends ButtonMenuConfig {
  UGCButtonMenuConfig() {
    super(2, 2);
  }

  int right(int index) {
    int x=get(index).x()+1;
    int y=get(index).y();
    if (x>=maxX) {
      return index;
    }
    int near = nearest(x, y, index);
    if (!(UGC_lvl_indx<UGCNames.size()-1) && index==2) {
      return 1;
    }
    return near;
  }

  int left(int index) {
    int x=get(index).x()-1;
    int y=get(index).y();
    if (x<0) {
      return index;
    }
    if (!(UGC_lvl_indx>0)&& index ==3) {
      return 1;
    }
    return nearest(x, y, index);
  }


  int up(int index) {
    int x=get(index).x();
    int y=get(index).y()-1;
    if (y<0) {
      return index;
    }
    int near = nearest(x, y, index);
    if (!(UGC_lvl_indx>0) && near==2) {
      if (UGC_lvl_indx<UGCNames.size()-1) {
        return 3;
      } else {
        return index;
      }
    }
    if (!(UGC_lvl_indx<UGCNames.size()-1) && near == 3) {
      if (UGC_lvl_indx>0) {
        return 2;
      } else {
        return index;
      }
    }
    return near;
  }
}

void populateLeaderBoardVisual(){
  String[][] scores = leaderBoards.getScores(level.name);
  String names="",times="";
  for(int i=0;i<scores.length;i++){
    names+=scores[i][0]+"\n";
    times+=scores[i][1]+"\n";
  }
  levelCompleteLeaderBoardCenterColumn.setText(names);
  levelCompleteLeaderBoardRightColumn.setText(times);

}

void highScoreMouseClicked(){
  for(int i=0;i<onScreenKeyboardButtons.length;i++){
    for(int j=0;j<onScreenKeyboardButtons[i].length;j++){
      if(onScreenKeyboardButtons[i][j].isMouseOver()){
        if(onScreenKeyboardButtons[i][j].getText().length()==1){
          highScoreName.setText(highScoreName.getText()+onScreenKeyboardButtons[i][j].getText());
          if(onScreenKeyboardButtons[1][0].getText().equals("Q")){//if the keyboard is uppercase
            changeOnScreenKeyboardCase(false);
          }
        }else{
          if(onScreenKeyboardButtons[i][j].getText().equals("Shift")){
            if(onScreenKeyboardButtons[1][0].getText().equals("Q")){//if the keyboard is uppercase
              changeOnScreenKeyboardCase(false);
            }else{
              changeOnScreenKeyboardCase(true);
            }
          }
          if(onScreenKeyboardButtons[i][j].getText().equals("Enter")){
            Menue="level complete";
            leaderBoards.addScore(level.name,formatMillis(clearTime).replaceAll("\\.",":"),highScoreName.getText());
            populateLeaderBoardVisual();
            leaderBoards.save(arcadeLeaderBoardFilePath,this);
            levelCompleteLevelName.setText(level.name);
            yourScore.setText("Your Time:  "+formatMillis(clearTime).replaceAll("\\.",":"));
          }
        }
      }
    }
  }
}

void changeOnScreenKeyboardCase(boolean upper){
  for(int i=0;i<onScreenKeyboardButtons.length;i++){
    for(int j=0;j<onScreenKeyboardButtons[i].length;j++){
      if(onScreenKeyboardButtons[i][j].getText().length()==1){
        if(upper){
          onScreenKeyboardButtons[i][j].setText(onScreenKeyboardButtonLabelsUpperCase[i].charAt(j)+"");
        }else{
          onScreenKeyboardButtons[i][j].setText(onScreenKeyboardButtonLabels[i].charAt(j)+"");
        }
      }
    }
  }
}
/**Synchronize access to a json array for multy threading applications
*/
synchronized JSONArray saveLoadJSONArray(JSONArray data,String path,boolean save){
  if(save){
    saveJSONArray(data,path);
    return null;
  }else{
    return loadJSONArray(path);
  }
}


//===================================================
//DO NOT EDIT THEESE LINES, EVER
//+++++++++++++++++++++++++++++++++++++++++++++++++++
//===================================================
//end of skiny_mann.pde
