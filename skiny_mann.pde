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
import net.java.games.input.*;
import net.java.games.util.plugins.*;
import net.java.games.util.*;


void settings() {//first function called
  UniversalErrorManager.init(this);
  if (platform==WINDOWS) {
    appdata=System.getenv("AppData");
  } else {
    appdata=System.getenv("HOME");
  }
  try {
    println("attempting to load settings");
    settings = new Settings(appdata+"/CBi-games/skinny mann/settings.json");
    
    if (!settings.getFullScreen()) {//check for fullscreeen
      //Scale=rez.getFloat("scale");//TODO, replace scale
      size(settings.getResolutionHorozontal(), settings.getResolutionVertical(), P3D);
    } else {
      fullScreen(P3D, settings.getFullScreenScreen());//if full screen then turn full screen on
    }
    println("loading window icon");
    PJOGL.setIcon("data/assets/skinny mann face.PNG");
    sourceInitilize();
  }
  catch(Throwable e) {
    println("an error orrored in the settings function");
    handleError(e);
  }
}



void setup() {//seccond function called
  try {
    frameRate(60);//limet the frame reate
    background(0);
    if (settings.getFullScreen()) {//get and set some data if in fullscreen
      Scale=height/720.0;
    }else{
      Scale = settings.getScale();
    }
    ui=new UiFrame(this, 1280, 720);
    println(height+" "+Scale);//debung info
    println("loading texture for start screen");
    CBi = loadImage("data/assets/CBi.png");//load the CBi logo

    textSize(100*Scale);//500
    println("initilizing buttons");
    initButtons();
    initText();

    ptsW=100;
    ptsH=100;
    println("initilizing CBi sphere");
    initializeSphere(ptsW, ptsH);
    textureSphere(200, 200, 200, CBi);

    //add entites to the entity regisrty
    entityRegistry.put("simple entity",new SimpleEntity(0,0,0,null));
    entityRegistry.put("goon",new Goon(0,0,0,null));
    //start the load thread
    thread("programLoad");
    leaderBoards = new ArcadeLeaderBoard(arcadeLeaderBoardFilePath,this);
    println("leaderBoards:\n"+leaderBoards);

  }
  catch(Throwable e) {
    println("an error occored in the setup function");
    handleError(e);
  }

}
//define a shit tone of varibles


PApplet primaryWindow=this;

Player players[] =new Player[10];
ArrayList<Client> clients= new ArrayList<>();


//int

//button





















//▄


//camera() = camera(defCameraX, defCameraY, defCameraZ,    defCameraX, defCameraY, 0,    0, 1, 0);
//defCameraX = width/2;
//defCameraY = height/2;
//defCameraFOV = 60 * DEG_TO_RAD;
//defCameraZ = defCameraY / ((float) Math.tan(defCameraFOV / 2.0f));
void draw() {// the function that is called every fraim
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
  if(requestDepthBufferInit){
    requestDepthBufferInit=false;
    initDepthBuffer();
    skipFrameInumeration = true;
  }
  

  try {//catch all fatal errors and display them

    if (saveColors) {//save the saved colors if you want to save colors
      saveJSONArray(colors, appdata+"/CBi-games/skinny mann level creator/colors.json");
      saveColors=false;
    }

    if (!levelCreator) {
      if (transitioningMenu) {
        menuTransition();
      }

      if (menue) {//when in a menue
        if (Menue.equals("creds")) {//the inital loading screen
          background(0);
          noStroke();

          drawlogo(true, true);

          if (start_wate>=2&&loaded) {// wait for the animation to complete and loading to finish before continuing to the game 
            soundHandler.startSounds();
            if (dev_mode) {
              Menue="dev";
              println("dev mode activated");
              return;
            }

            try {
              String inver = readFileFromGithub("https://raw.githubusercontent.com/jSdCool/CBI-games-version-checker/master/skinny_mann.txt");//check for updates  inver = internet version
              inver =inver.substring(0, inver.length()-1);
              internetVersion=inver;
              if (false) {//if an update exists
                Menue="update";//go to update menue
              } else {//if no update exists go to main menue
                if (settings.getSettingsAfterStart()) {
                  menue=false;
                  Menue="settings";
                  initMenuTransition(Transitions.LOGO_TO_SETTINGS);
                  return;
                } else {
                  menue=false;
                  Menue="main";
                  initMenuTransition(Transitions.LOGO_TO_MAIN);
                  return;
                }
              }
            }
            catch(Throwable e) {//if an error occors or no return then go to main menue
              println(e);//print to console the cause of the error
              if (settings.getSettingsAfterStart()) {
                menue=false;
                Menue="settings";
                initMenuTransition(Transitions.LOGO_TO_SETTINGS);
                return;
              } else {
                menue=false;
                Menue="main";
                initMenuTransition(Transitions.LOGO_TO_MAIN);
                return;
              }
            }
          }
        }

        if (Menue.equals("update")) {//if there is an updat draw the update screen
          draw_updae_screen();
        }
        if (Menue.equals("downloading update")) {
          drawUpdateDownloadingScreen();
        }

        if (Menue.equals("main")) {//if on main menue
          hint(DISABLE_KEY_REPEAT);
          drawMainMenu(true);
        }
        if (Menue.equals("level select")) {//if selecting level
          drawLevelSelect(true,0);
        }
        if (Menue.equals("level select UGC")) {
          drawLevelSelectUGC();
        }
        if(Menue.equals("level select 2")){
         drawLevelSelect2(true);
        }
        if (Menue.equals("pause")) {//when in the pause emnue cancle all motion
          player1_moving_right=false;
          player1_moving_left=false;
          player1_jumping=false;
        }


        if (Menue.equals("settings")) {//the settings menue
          hint(ENABLE_KEY_REPEAT);
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

        if (Menue.equals("multiplayer strart")) {
          background(#FF8000);
          hint(ENABLE_KEY_REPEAT);
          fill(0);
          initMultyplayerScreenTitle.draw();

          multyplayerJoin.draw();
          multyplayerHost.draw();
          multyplayerExit.draw();
        }

        if (Menue.equals("start host")) {
          background(#FF8000);
          fill(0);
          mp_hostSeccion.draw();
          mp_host_Name.draw();
          //mp_host_enterdName.setText(name+((enteringName)? cursor:""));
          //mp_host_enterdName.draw();
          mp_host_port.draw();
          //mp_host_endterdPort.setText(port+((enteringPort)? cursor:""));
          //mp_host_endterdPort.draw();
          
          multyPlayerNameTextBox.draw();
          multyPlayerPortTextBox.draw();

          //noStroke();
          //rect(width/2-width*0.4, height*0.2, width*0.8, 2*Scale);

          //rect(width/2-width*0.05, height*0.31, width*0.1, 2*Scale);

          multyplayerExit.draw();
          multyplayerGo.draw();
        }
        if (Menue.equals("start join")) {
          background(#FF8000);
          fill(0);
          mp_joinSession.draw();
          mp_join_name.draw();
          //mp_join_enterdName.setText(name+((enteringName)? cursor:""));
          //mp_join_enterdName.draw();
          mp_join_port.draw();
          //mp_join_enterdPort.setText(port+((enteringPort)? cursor:""));
          //mp_join_enterdPort.draw();
          mp_join_ip.draw();
          //mp_join_enterdIp.setText(ip+((enteringIP)?cursor:""));
          //mp_join_enterdIp.draw();
          
          multyPlayerNameTextBox.draw();
          multyPlayerPortTextBox.draw();
          multyPlayerIpTextBox.draw();
          
          //noStroke();
          //rect(width/2-width*0.4, height*0.2, width*0.8, 2*Scale);
          //rect(width/2-width*0.05, height*0.31, width*0.1, 2*Scale);
          //rect(width/2-width*0.3, height*0.42, width*0.6, 2*Scale);

          multyplayerExit.draw();
          multyplayerGo.draw();
        }
        if (Menue.equals("disconnected")) {

          background(200);
          fill(0);
          mp_disconnected.draw();
          mp_dc_reason.setText(disconnectReason);
          mp_dc_reason.draw();

          multyplayerExit.draw();
        }
        //TODO: update text in multyplayer selection menu to UiText
        if (Menue.equals("multiplayer selection")) {
          background(-9131009);
          fill(0);
          rect(width*0.171875, 0, 2*Scale, height);//verticle line on the left of the screen
          textAlign(CENTER, CENTER);
          textSize(20*Scale);
          text("players", width*0.086, height*0.015);
          rect(0, height*0.04, width*0.171875, height*(2.0/720));//horozontal line ath the top of the left colum

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
          if (multyplayerSelectedLevel.exsists) {
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
            if (multyplayerSelectedLevel.gameVersion!=null&&!gameVersionCompatibilityCheck(multyplayerSelectedLevel.gameVersion)) {
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
        }//end of multyplayer selection

        if (Menue.equals("dev")) {
          drawDevMenue();
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


      if (inGame) {
        hint(DISABLE_KEY_REPEAT);
        //================================================================================================
        background(7646207);
        stageLevelDraw();
        if (level_complete&&!levelCompleteSoundPlayed) {
          if (multiplayer) {
            if (level.multyplayerMode==1) {
              players[currentPlayer].setX(-100);
              players[currentPlayer].setY(-100);
              level.psudoLoad();
              level_complete=false;
              int completeTime=millis()-startTime;
              println("completed in: "+completeTime+" "+formatMillis(completeTime));
              if (completeTime<bestTime||bestTime==0) {
                bestTime=completeTime;
              }
              startTime=millis();
            }
          } else {
            soundHandler.addToQueue(0);
            levelCompleteSoundPlayed=true;
          }
        }
      }
      perspective();//reset the perspecive / fov fro 3D mode

      if (tutorialMode&&!inGame) {
        if (Menue.equals("settings")) {
          background(0);
          fill(255);
          tut_notToday.draw();
        } else {
          background(0);
          fill(255);
          tut_disclaimer.draw();
          tut_toClose.draw();
        }
      }
      engageHUDPosition();//anything hud

      if (inGame) {
        fill(255);
        coinCountText.setText("coins: "+coinCount);
        coinCountText.draw();
      }

      if (menue) {
        if (Menue.equals("pause")) {//when paused
          fill(50, 200);
          rect(0, 0, width, height);
          fill(0);
          pa_title.draw();

          pauseResumeButton.draw();
          pauseOptionsButton.draw();
          pauseQuitButton.draw();

          if (multiplayer) {
            if (level.multyplayerMode==1) {
              pauseRestart.draw();
            }
          }
        }
      }
      //level creator here
    } else {
      if (startup) {//if on the startup screen
        hint(ENABLE_KEY_REPEAT);
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

        if (rootPath!=null) {//manual cursor blinking becasue apperently I hadent made the global system yet
          if (entering_file_path&&coursor) {
            lc_load_new_enterd.setText(rootPath+"|");
          } else {
            lc_load_new_enterd.setText(rootPath);
          }
        } else if (entering_file_path&&coursor) {
          lc_load_new_enterd.setText("|");
        }
        lc_load_new_enterd.draw();
        if (levelNotFound) {
          fill(200, 0, 0);
          lc_load_notFound.draw();
        }
        stroke(0);
        strokeWeight(1*Scale);
        line(40*Scale, 152*Scale, 1200*Scale, 152*Scale);//draw the line the the text sits on
        stroke(#4857ED);
        fill(#BB48ED);
        strokeWeight(10*Scale);
        lcLoadLevelButton.draw();//draw load button
        lc_backButton.draw();
        lc_openLevelsFolder.draw();
      }//end of loading level

      if (newLevel) {//if creating a new level
      hint(ENABLE_KEY_REPEAT);
        background(#48EDD8);
        fill(0);
        lc_load_new_describe.draw();
        if (new_name!=null) {//manual cursor blinking becasue apperently I hadent made the global system yet
          if (entering_name&&coursor) {
            lc_load_new_enterd.setText(new_name+"|");
          } else {
            lc_load_new_enterd.setText(new_name);
          }
        } else if (entering_name&&coursor) {
          lc_load_new_enterd.setText("|");
        }
        lc_load_new_enterd.draw();

        lcNewLevelButton.draw();//start button
        lc_backButton.draw();
        fill(0);
        stroke(0);
        strokeWeight(1*Scale);
        line(40*Scale, 152*Scale, 800*Scale, 152*Scale);//line for name text
        lc_openLevelsFolder.draw();
      }//end of make new level

      if (editingStage) {//if edditing the stage
      hint(DISABLE_KEY_REPEAT);
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

        stageLevelDraw();//level draw code
        
        //if placing a blueprint in 3D, render the blueprint that is being palced
        if (e3DMode && selectingBlueprint && blueprints.length!=0){
          generateDisplayBlueprint3D();
          renderBlueprint3D();
          float cdx = blueprintMax[0]-blueprintMin[0];
          float cdy = blueprintMax[1]-blueprintMin[1];
          float cdz = blueprintMax[2]-blueprintMin[2];
          renderTranslationArrows(blueprintMin[0],blueprintMin[1],blueprintMin[2],cdx,cdy,cdz);
        }
        
        stageEditGUI();//level gui code

        if (selectingBlueprint&&blueprints.length!=0) {//if selecting blueprint
        if(!e3DMode){
            generateDisplayBlueprint();//visualize the blueprint that is selected
            renderBlueprint();//render blueprint
          }
        }
        perspective();//reset the perspecive / fov
        engageHUDPosition();
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
            if (level.stages.get(overviewSelection).type.equals("stage")) {//if the selected thing is a stage
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
          } else if (i+ filesScrole<level.stages.size()+level.sounds.size()) {//if the thing is in the range of sounds
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


        textAlign(CENTER, CENTER);
        newStage.draw();//draw the new file button
        textAlign(LEFT, BOTTOM);
        respawnX=(int)level.SpawnX;//set the respawn info to that of the current level
        respawnY=(int)level.SpawnY;
        respawnStage=level.mainStage;

        overview_saveLevel.draw();//draw save button
        help.draw();//draw help button
        if (filesScrole>0)//draw scroll buttons
          overviewUp.draw();
        if (filesScrole+11<level.stages.size()+level.sounds.size()+level.logicBoards.size())
          overviewDown.draw();
        lcOverviewExitButton.draw();
      }//end of level over view

      if (newFile) {//if on the new file screen
        hint(ENABLE_KEY_REPEAT);
        background(#0092FF);
        stroke(0);
        strokeWeight(2*Scale);
        line(100*Scale, 450*Scale, 1200*Scale, 450*Scale);
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
          lc_newf_enterdName.setText("name: "+newFileName+coursorr);//display the entered name
          String pathSegments[]=fileToCoppyPath.split("/|\\\\");
          lc_newf_fileName.setText(pathSegments[pathSegments.length-1]);//display the name of the selected file
          lc_newf_fileName.draw();
          chooseFileButton.draw();
          if(newSoundAsNarration){
            lc_newSoundAsSoundButton.setColor(#BB48ED, #4857ED);
            lc_newSoundAsNarrationButton.setColor(#BB48ED, #51DFFA);
          }else{
            lc_newSoundAsSoundButton.setColor(#BB48ED, #51DFFA);
            lc_newSoundAsNarrationButton.setColor(#BB48ED, #4857ED);
          }
          lc_newSoundAsSoundButton.draw();
          lc_newSoundAsNarrationButton.draw();
        } else {
          lc_newf_enterdName.setText(newFileName+coursorr);//display the entered name
        }
        lc_newf_enterdName.draw();
      }//end of new file

      if (drawingPortal2) {//if drawing portal part 2 aka outher overview selection screen
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
        if (new_name!=null) {//display the name entered
          lc_load_new_enterd.setText(new_name+coursorr);
        } else if (coursor) {
          lc_load_new_enterd.setText("|");
        }
        lc_load_new_enterd.draw();

        createBlueprintGo.draw();//create button
        lc_backButton.draw();
        if(newBlueprintIs3D){
          new2DStage.setColor(#BB48ED, #4857ED);
          new3DStage.setColor(#BB48ED, #51DFFA);
        }else{
          new2DStage.setColor(#BB48ED, #51DFFA);
          new3DStage.setColor(#BB48ED, #4857ED);
        }
        new2DStage.draw();
        new3DStage.draw();
        stroke(0);
        strokeWeight(1*Scale);
        line(40*Scale, 152*Scale, 800*Scale, 152*Scale);//text line
      }//end of creating new blueprint

      if (loadingBlueprint) {//if loading blueprint
        background(#48EDD8);
        fill(0);
        lc_newbp_describe.draw();
        if (new_name!=null) {//coursor and entrd name
          lc_load_new_enterd.setText(new_name+coursorr);
        } else if (coursor) {
          lc_load_new_enterd.setText("|");
        }
        lc_load_new_enterd.draw();
        stroke(0);
        strokeWeight(1*Scale);
        line(40*Scale, 152*Scale, 1200*Scale, 152*Scale);
        createBlueprintGo.setText("load");//load button
        createBlueprintGo.draw();
        lc_backButton.draw();
      }//end of loading blueprint

      if (editingBlueprint) {//if edditing blueprint
        background(7646207);
        if(!e3DMode){
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
          if (selectedIndex==i) {
            strokeWeight(0);
            fill(255, 0, 0);
            rect((level.logicBoards.get(logicBoardIndex).components.get(i).x-5-camPos)*Scale, (level.logicBoards.get(logicBoardIndex).components.get(i).y-5-camPosY)*Scale, (level.logicBoards.get(logicBoardIndex).components.get(i).button.lengthX+10*Scale), (level.logicBoards.get(logicBoardIndex).components.get(i).button.lengthY+10*Scale));
          }
          level.logicBoards.get(logicBoardIndex).components.get(i).draw();
        }
        for (int i=0; i<level.logicBoards.get(logicBoardIndex).components.size(); i++) {//draw the connections
          level.logicBoards.get(logicBoardIndex).components.get(i).drawConnections();
        }

        if (connectingLogic&&connecting) {//draw the connnecting line
          float[] nodePos = level.logicBoards.get(logicBoardIndex).components.get(connectingFromIndex).getTerminalPos(2);
          stroke(0);
          strokeWeight(5*Scale);
          line(nodePos[0]*Scale, nodePos[1]*Scale, mouseX, mouseY);
        }

        if (movingLogicComponent&&moveLogicComponents) {
          level.logicBoards.get(logicBoardIndex).components.get(movingLogicIndex).setPos(mouseX/Scale+camPos, mouseY/Scale+camPosY);
        }
        if (cam_left&&camPos>0) {
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

      if (exitLevelCreator) {
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
      deadText.draw();
      death_cool_down++;
      if (death_cool_down>75) {// respawn cool down
        dead=false;
        inGame=true;
        player1_moving_right=false;
        player1_moving_left=false;
        player1_jumping=false;
        SPressed=false;
        WPressed=false;
      }
      if(!inGame){
        dead=false;
      }
    }
    
    if (settingPlayerSpawn && levelCreator) {
      draw_mann(mouseX, mouseY, 1, Scale, 0,g);
      fill(0);
      settingPlayerSpawnText.draw();
    }


    if (settings.getDebugFPS()) {
      fill(255);
      fpsText.setText("FPS: "+ frameRate);
      fpsText.draw();
    }
    if (settings.getDebugInfo()) {
      fill(255);
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
      if(multiplayer){
        if(clients.size()==0){
          dbg_ping.setText("Ping: N/A");
        }else if(clients.size()==1){
          long pingl = clients.get(0).ping;
          float pingDisp = (int)(pingl/10000)/100.0;
          dbg_ping.setText("Ping: "+pingDisp);
        }else{
          long totalPing = clients.stream().map( c -> c.ping).reduce(0l, Long::sum);
          long avgPingl = totalPing / clients.size();
          float pingDisp = (int)(avgPingl/10000)/100.0;
          dbg_ping.setText("avgPing: "+pingDisp);
        }
      }else{
        dbg_ping.setText("Ping: N/A");
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

    if (millis()<gmillis) {
      glitchEffect();
    }
    
    if(showDepthBuffer&&dev_mode&&shadowMap!=null){
      image(shadowMap,0,height/2,width/2,height/2);
    }

    if (displayTextUntill>=millis()) {
      fill(255);
      game_displayText.setText(displayText);
      game_displayText.draw();
    }

    if(inGame&&!tutorialMode&&level.levelID!=-1){
      fill(255);
      String curtime_=formatMillis(millis()-startTime);
      elapsedTimeDisplay.setText(curtime_);
      elapsedTimeDisplay.draw();
    }
    
    if(soundHandler!=null && settings.getSoundNarrationVolume()< 0.2 && soundHandler.anyNarrationPlaying()){
      fill(255);
      narrationCaptionText.draw();
    }
    //TODO: text stuff for multyplayer in game
    if (multiplayer&&inGame) {
      if (level.multyplayerMode==1) {
        fill(255);
        String curtime=formatMillis(millis()-startTime);
        calcTextSize(curtime, width*0.06);
        textAlign(CENTER, CENTER);
        text(curtime, width/2, height*0.015);

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
        String lb ="Leader Board\n";
        for (int i=0; i<leaderBoard.leaderboard.length; i++) {
          lb+=leaderBoard.leaderboard[i]+"\n";
        }
        text(lb, width*0.01, height*0.15);
        String timeLeft=formatMillis(timerEndTime-millis());
        calcTextSize(timeLeft, width*0.05);
        text(timeLeft, width*0.01, height*0.12);
        calcTextSize("Time Left", width*0.05);
        text("Time Left", width*0.01, height*0.1);
        if (isHost) {
          if (timerEndTime-millis()<=0) {
            Menue="multiplayer selection";
            returnToSlection();
            menue=true;
            inGame=false;
          }
        }
      }
      if (level.multyplayerMode==2) {
        if (isHost) {
          boolean allDone=true;
          for (int i=0; i<clients.size(); i++) {
            //println(clients.get(i).reachedEnd+" "+i);
            allDone=allDone && clients.get(i).reachedEnd;
          }
          allDone = allDone && reachedEnd;
          if (allDone) {
            level_complete=true;
          }
        }
      }
    }


    disEngageHUDPosition();
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




void mouseClicked() {// when you click the mouse

  try {
    if (!levelCreator) {

      if (menue) {//if your in a menue
        if (Menue.equals("main")) {//if that menue is the main menue
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
        if (Menue.equals("level select")) {//if that menue is level select
          int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
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
          
          

          if (select_lvl_back.isMouseOver()) {
            Menue="main";
            menue=false;
            initMenuTransition(Transitions.LEVEL_SELECT_TO_MAIN);
          }
          if (select_lvl_next.isMouseOver()) {
            Menue="level select 2";
            menue=false;
            initMenuTransition(Transitions.LEVEL_SELECT_TO_LEVEL_SELECT_2);
          }
          if (select_lvl_UGC.isMouseOver()) {
            Menue="level select UGC";
            menue=false;
            loadUGCList();
            UGC_lvl_indx=0;
            initMenuTransition(Transitions.LEVEL_SELECT_TO_UGC);
            return;
          }


          return;
        }
        if (Menue.equals("level select 2")) {//if that menue is level select
          int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
          if (select_lvl_13.isMouseOver()&&progress>=13) {
            loadLevel("data/levels/level-13");
            menue=false;
            inGame=true;
          }
          if (select_lvl_2.isMouseOver()&&progress>=14) {
            loadLevel("data/levels/level-14");
            menue=false;
            inGame=true;
          }

          if (select_lvl_back.isMouseOver()) {
            Menue="level select";
            menue=false;
            initMenuTransition(Transitions.LEVEL_SELECT_2_TO_LEVEL_SELECT);
          }
        }

        if (Menue.equals("level select UGC")) {
          if (select_lvl_back.isMouseOver()) {
            Menue="level select";
            menue=false;
            initMenuTransition(Transitions.UGC_TO_LEVEL_SELECT);
          }
          if (UGC_open_folder.isMouseOver()) {
            openUGCFolder();
          }

          if (UGCNames.size()==0) {
          } else {
            if (UGC_lvl_indx<UGCNames.size()-1) {
              if (UGC_lvls_next.isMouseOver()) {
                UGC_lvl_indx++;
              }
            }
            if (UGC_lvl_indx>0) {
              if (UGC_lvls_prev.isMouseOver()) {
                UGC_lvl_indx--;
              }
            }
            if (UGC_lvl_play.isMouseOver()) {
              loadLevel(appdata+"/CBi-games/skinny mann/UGC/levels/"+UGCNames.get(UGC_lvl_indx));
              if (!levelCompatible) {
                Menue="level select";
                return;
              }
              UGC_lvl=true;
              inGame=true;
              menue=false;
            }
          }
          if (levelcreatorLink.isMouseOver()) {//this now opens the level creator
            //link("https://cbi-games.glitch.me/level%20creator.html");
            if (scr2==null)//create the 2nd screen if it does not exsist
              scr2 =new ToolBox(millis());
            startup=true;
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
        }

        if (Menue.equals("pause")) {//if that menue is pause
          if (pauseResumeButton.isMouseOver()) {//resume game button
            menue=false;
          }
          if (pauseOptionsButton.isMouseOver()) {//resume game button
            Menue="settings";
            prevousInGame=true;
            inGame=false;
          }
          if (pauseQuitButton.isMouseOver()) {//quit button
            menue=true;
            inGame=false;
            tutorialMode=false;
            if (multiplayer) {
              if (isHost) {
                Menue="multiplayer selection";
                returnToSlection();
              } else {
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
            soundHandler.setMusicVolume(settings.getSoundMusicVolume());
            coinCount=0;
          }
          if (multiplayer) {
            if (level.multyplayerMode==1) {
              if (pauseRestart.isMouseOver()) {
                level.psudoLoad();
                startTime=millis();
                menue=false;
              }
            }
          }
        }

        if (Menue.equals("settings")) {     //if that menue is settings

          if (settingsMenue.equals("game play")) {

            verticleEdgeScrollSlider.mouseClicked();
            horozontalEdgeScrollSlider.mouseClicked();
            fovSlider.mouseClicked();
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

          if (settingsMenue.equals("display")) {
            String arat = "16:9";
            if (rez4k.isMouseOver()) {//2160 resolution button
              settings.setResolution(1260,2160*16/9);
              settings.save();
            }

            if (rez1440.isMouseOver()) {// 1440 resolition button
              settings.setResolution(1440,1440*16/9);
              settings.save();
            }

            if (rez1080.isMouseOver()) {// 1080 resolution button
              settings.setResolution(1080,1080*16/9);
              settings.save();
            }

            if (rez900.isMouseOver()) {////900 resolution button
              settings.setResolution(900,900*16/9);
              settings.save();
            }

            if (rez720.isMouseOver()) {// 720 resolution button
              settings.setResolution(720,720*16/9);
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

          if (settingsMenue.equals("sound")) {
            
            musicVolumeSlider.mouseClicked();
            SFXVolumeSlider.mouseClicked();
            narrationVolumeSlider.mouseClicked();
            
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
            
            if (narrationMode0.isMouseOver()) {
              settings.setSoundNarrationMode(0);
              settings.save();
            }
            if (narrationMode1.isMouseOver()) {
              settings.setSoundNarrationMode(1);
              settings.save();
            }
            
          }//end of sound settings
          if (settingsMenue.equals("outher")) {
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


            defaultAuthorNameTextBox.mouseClicked();
            
          }//end of outher settings menue

          if (sttingsGPL.isMouseOver()){
            settingsMenue="game play";
            defaultAuthorNameTextBox.resetState();
          }
          if (settingsDSP.isMouseOver()){
            settingsMenue="display";
            defaultAuthorNameTextBox.resetState();
          }
          if (settingsSND.isMouseOver()){
            settingsMenue="sound";
            defaultAuthorNameTextBox.resetState();
          }
          if (settingsOUT.isMouseOver())
            settingsMenue="outher";

          if (settingsBackButton.isMouseOver()) {//back button
            defaultAuthorNameTextBox.resetState();
            if (prevousInGame) {
              Menue="pause";
              inGame=true;
              prevousInGame=false;
            } else {
              Menue ="main";
              menue=false;
              initMenuTransition(Transitions.SETTINGS_TO_MAIN);
            }
            stats.save();
          }
        }

        //back button for the old how to play menue NOT REMOVING THIS!
        if (Menue.equals("how to play")) {//if that menue is how to play
          if (mouseX >= 40*Scale && mouseX <= 240*Scale && mouseY >= 610*Scale && mouseY <= 660*Scale) {//back button
            Menue ="main";
          }
        }

        if (Menue.equals("update")) {//if that menue is update
          updae_screen_click(); //check the update clicks
        }
        if (Menue.equals("downloading update")) {
          updateDownloadingScreenClick();
        }

        if (Menue.equals("multiplayer strart")) {
          if (multyplayerExit.isMouseOver()) {
            Menue="main";
          }
          if (multyplayerJoin.isMouseOver()) {
            Menue="start join";
          }
          if (multyplayerHost.isMouseOver()) {
            Menue="start host";
          }
        }
        if (Menue.equals("start host")) {
          if (multyplayerExit.isMouseOver()) {
            Menue="main";
            multyPlayerNameTextBox.resetState();
            multyPlayerPortTextBox.resetState();
          }
          //if (mouseX >= width/2-width*0.4 && mouseX <= width/2+width*0.4 && mouseY >= height*0.15 && mouseY <= height*0.2) {//name line
          //  enteringName=true;
          //  enteringPort=false;
          //}
          //if (mouseX >= width/2-width*0.05 && mouseX <= width/2+width*0.05 && mouseY >= height*0.26 && mouseY <= height*0.31) {//port line
          //  enteringName=false;
          //  enteringPort=true;
          //}
          multyPlayerNameTextBox.mouseClicked();
          multyPlayerPortTextBox.mouseClicked();
          if (multyplayerGo.isMouseOver()) {
            name = multyPlayerNameTextBox.getContence();
            port = Integer.parseInt(multyPlayerPortTextBox.getContence());
            multyPlayerNameTextBox.resetState();
            multyPlayerPortTextBox.resetState();
            
            isHost=true;
            Menue="multiplayer selection";
            multiplayer = true;
            server= new Server(port);
            players[0].name=name;
          }
          return;
        }
        if (Menue.equals("start join")) {
          if (multyplayerExit.isMouseOver()) {
            Menue="main";
            multyPlayerNameTextBox.resetState();
            multyPlayerPortTextBox.resetState();
            multyPlayerIpTextBox.resetState();
          }
          //if (mouseX >= width/2-width*0.4 && mouseX <= width/2+width*0.4 && mouseY >= height*0.15 && mouseY <= height*0.2) {//name line
          //  enteringName=true;
          //  enteringPort=false;
          //  enteringIP=false;
          //}
          //if (mouseX >= width/2-width*0.05 && mouseX <= width/2+width*0.05 && mouseY >= height*0.26 && mouseY <= height*0.31) {//port line
          //  enteringName=false;
          //  enteringPort=true;
          //  enteringIP=false;
          //}
          //if (mouseX >= width/2-width*0.3 && mouseX <= width/2+width*0.3 && mouseY >= height*0.37 && mouseY <= height*0.42) {//ip line
          //  enteringName=false;
          //  enteringPort=false;
          //  enteringIP=true;
          //}
          multyPlayerNameTextBox.mouseClicked();
          multyPlayerPortTextBox.mouseClicked();
          multyPlayerIpTextBox.mouseClicked();
          if (multyplayerGo.isMouseOver()) {
            name = multyPlayerNameTextBox.getContence();
            port = Integer.parseInt(multyPlayerPortTextBox.getContence());
            ip = multyPlayerIpTextBox.getContence();
            multyPlayerNameTextBox.resetState();
            multyPlayerPortTextBox.resetState();
            multyPlayerIpTextBox.resetState();
            isHost=false;
            Menue="multiplayer selection";
            multiplayer=true;
            try {
              clients.add(new Client(new Socket(ip, port)));
            }
            catch(Exception c) {
              c.printStackTrace();
              multiplayer=false;
              Menue="disconnected";
              disconnectReason="failed to connect to server\n"+c.toString();
            }
            return;
          }
        }
        if (Menue.equals("disconnected")) {
          if (multyplayerExit.isMouseOver()) {
            Menue="start join";
            multiplayer=false;
            currentPlayer=0;
          }
        }

        if (Menue.equals("dev")) {
          clickDevMenue();
          return;
        }
        if (Menue.equals("multiplayer selection")) {
          if (isHost) {
            if (multyplayerLeave.isMouseOver()) {
              println("quitting multyplayer host");
              server.end();
              println("returning to main menu");
              Menue="main";
              multiplayer=false;
              waitingForReady=false;
              currentPlayer=0;
              return;
            }
            if (mouseX>=width*0.171875 && mouseX<= width*0.8 && mouseY >=height*0.09 && mouseY <=height*0.91666) {//if the mouse is in the area to select a level
              int slotSelected=(int)( (mouseY - height*0.09)/(height*0.8127777777/16));
              if (multyplayerSelectionLevels.equals("speed")) {
                if (slotSelected<=13) {//set speed run max levels here for selection
                  multyplayerSelectedLevelPath="data/levels/level-"+(slotSelected+1);
                  genSelectedInfo(multyplayerSelectedLevelPath, false);
                }
              }
              if (multyplayerSelectionLevels.equals("coop")) {
                if (slotSelected<=1) {// set co op max levels here for selection
                  multyplayerSelectedLevelPath="data/levels/co-op_"+(slotSelected+1);
                  genSelectedInfo(multyplayerSelectedLevelPath, false);
                }
              }
              if (multyplayerSelectionLevels.equals("UGC")) {
                if (slotSelected<=UGCNames.size()-1) {// set co op max levels here for selection
                  multyplayerSelectedLevelPath=appdata+"/CBi-games/skinny mann/UGC/levels/"+UGCNames.get(slotSelected);
                  genSelectedInfo(multyplayerSelectedLevelPath, true);
                }
              }
              return;
            }
            if (multyplayerSelectedLevel.gameVersion!=null && gameVersionCompatibilityCheck(multyplayerSelectedLevel.gameVersion)) {
              if (multyplayerPlay.isMouseOver()) {
                if (!multyplayerSelectedLevel.isUGC) {
                  if (multyplayerSelectedLevel.multyplayerMode==1) {
                    LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevelPath);
                    for (int i=0; i<clients.size(); i++) {
                      clients.get(i).dataToSend.add(req);
                    }
                    loadLevel(multyplayerSelectedLevelPath);
                    waitingForReady=true;
                    bestTime=0;
                  }

                  if (multyplayerSelectedLevel.multyplayerMode==2) {
                    if (clients.size()+1 >= multyplayerSelectedLevel.minPlayers && clients.size()+1 <= multyplayerSelectedLevel.maxPlayers) {
                      LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevelPath);
                      for (int i=0; i<clients.size(); i++) {
                        clients.get(i).dataToSend.add(req);
                      }
                      loadLevel(multyplayerSelectedLevelPath);
                      waitingForReady=true;
                    }
                  }
                } else {
                  if (multyplayerSelectedLevel.multyplayerMode==1) {

                    loadLevel(multyplayerSelectedLevelPath);
                    LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevel.id, getLevelHash(multyplayerSelectedLevelPath));
                    for (int i=0; i<clients.size(); i++) {
                      clients.get(i).dataToSend.add(req);
                    }

                    waitingForReady=true;
                    bestTime=0;
                  }

                  if (multyplayerSelectedLevel.multyplayerMode==2) {
                    if (clients.size()+1 >= multyplayerSelectedLevel.minPlayers && clients.size()+1 <= multyplayerSelectedLevel.maxPlayers) {
                      loadLevel(multyplayerSelectedLevelPath);
                      LoadLevelRequest req =new LoadLevelRequest(multyplayerSelectedLevel.id, getLevelHash(multyplayerSelectedLevelPath));
                      for (int i=0; i<clients.size(); i++) {
                        clients.get(i).dataToSend.add(req);
                      }

                      waitingForReady=true;
                    }
                  }
                }
              }//end of multyplayer play button
            }
            if (multyplayerSelectedLevel.multyplayerMode==1) {
              if (increaseTime.isMouseOver()) {
                sessionTime+=30000;
              }
              if (decreaseTime.isMouseOver()) {
                if (sessionTime>30000)
                  sessionTime-=30000;
              }
            }
            if (multyplayerCoop.isMouseOver()) {
              multyplayerSelectionLevels="coop";
            }
            if (multyplayerSpeedrun.isMouseOver()) {
              multyplayerSelectionLevels="speed";
            }
            if (multyplayerUGC.isMouseOver()) {
              multyplayerSelectionLevels="UGC";
              //load a list of all the UGC levels
              loadUGCList();
            }
          } else {//if joined
            if (multyplayerLeave.isMouseOver()) {
              println("quitting multyplayer joined");
              clientQuitting=true;
              clients.get(0).disconnect();
              println("returning to main menu");
              Menue="main";
              multiplayer=false;
              currentPlayer=0;
              return;
            }
          }
        }

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
      }
      if (level_complete&&(level.multyplayerMode!=2||isHost)) {//if you completed a level and have not joined
        if (endOfLevelButton.isMouseOver()) {//continue button
          if (multiplayer) {
            menue=true;
            inGame=false;
            level_complete=false;
            Menue="multiplayer selection";
            returnToSlection();
          } else {
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
            stats.incrementLevelsCompleted();
            stats.save();
          }
        }
      }
    } else {//level creator
      if (mouseButton==LEFT) {//if the button pressed was the left button
        //System.out.println(mouseX+" "+mouseY);//print the location the mouse clicked to the console
        if (startup) {//if on the startup screen
          if (newLevelButton.isMouseOver()) {//new level button
            startup=false;
            newLevel=true;
            entering_name=true;
            rootPath="";
          }
          if (loadLevelButton.isMouseOver()) {//load level button
            startup=false;
            loading=true;
            entering_file_path=true;
            rootPath="";
          }
          if (newBlueprint.isMouseOver()) {//new blurprint button
            startup=false;
            creatingNewBlueprint=true;
            new_name="my blueprint";
            entering_name=true;
          }
          if (loadBlueprint.isMouseOver()) {//loaf blueprint button
            startup=false;
            loadingBlueprint=true;
            new_name="";
            entering_name=true;
          }
          if (lc_backButton.isMouseOver()) {
            levelCreator=false;
          }
        }
        if (loading) {//if loading level
          if (mouseX >=40*Scale && mouseX <= 1200*Scale && mouseY >= 100*Scale && mouseY <= 150*Scale) {//click box for the line to type the name
            entering_file_path=true;
          }
          if (lcLoadLevelButton.isMouseOver()) {//load button
          JSONArray mainIndex = null;
            try {//attempt to load the level
              String tmp=rootPath;
              rootPath=appdata+"/CBi-games/skinny mann level creator/levels/"+rootPath;
              boolean exsists=new File(rootPath+"/index.json").exists();
              if (!exsists) {
                levelNotFound=true;
                rootPath=tmp;
                return;
              }
              mainIndex=loadJSONArray(rootPath+"/index.json");
              entering_file_path=false;
              loading=false;
              levelOverview=true;
              levelNotFound=false;
            }
            catch(Throwable e) {//do nothign if loading fails
              e.printStackTrace();
            }
            level=new Level(mainIndex);
            level.logicBoards.get(level.loadBoard).superTick();
            if (level.multyplayerMode==2) {
              currentNumberOfPlayers=level.maxPLayers;
            }
            return;
          }
          if (lc_backButton.isMouseOver()) {
            startup=true;
            loading=false;
            entering_file_path=false;
          }
          if (lc_openLevelsFolder.isMouseOver()) {
            openLevelCreatorLevelsFolder();
          }
        }
        if (newLevel) {//if creating a new level
          if (mouseX >=40*Scale && mouseX <= 1200*Scale && mouseY >= 100*Scale && mouseY <= 150*Scale) {//text line click box
            entering_name=true;
          }//rect(40,400,200,40);
          if (lcNewLevelButton.isMouseOver()) {//create button
            entering_name=false;
            newLevel=false;
            rootPath=appdata+"/CBi-games/skinny mann level creator/levels/"+new_name;
            JSONArray mainIndex=new JSONArray();//set up a new level
            JSONObject terain = new JSONObject();
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
            mainIndex.setJSONObject(0, terain);
            levelOverview=true;
            level=new Level(mainIndex);
            level.save(true);
            return;
          }
          if (lc_backButton.isMouseOver()) {
            startup=true;
            newLevel=false;
            entering_name=false;
          }
          if (lc_openLevelsFolder.isMouseOver()) {
            openLevelCreatorLevelsFolder();
          }
        }
        if (!e3DMode)
          GUImouseClicked();//gui clicking code
        else {
          mouseClicked3D();
        }



        if (levelOverview) {//if on level overview
          if (newStage.isMouseOver()) {//if the new file button is clicked
            levelOverview=false;
            newFile=true;
            newFileName="";
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
            link("https://youtu.be/anmV3GknDL4");
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

          if (filesScrole>0&&overviewUp.isMouseOver())//scroll up button
            filesScrole--;
          if (filesScrole+11<level.stages.size()+level.sounds.size()+level.logicBoards.size()&&overviewDown.isMouseOver())//scroll down button
            filesScrole++;

          if (lcOverviewExitButton.isMouseOver()) {
            levelOverview=false;
            exitLevelCreator=true;
          }
        }//end of level overview

        if (newFile) {//if on the new file page
          if (newFileBack.isMouseOver()) {//back button
            levelOverview=true;
            newFile=false;
          }

          if (newFileCreate.isMouseOver()) {//create button
            if (newFileName.equals("")) {//if no name has been entered
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
              }
              catch(IOException i) {
                i.printStackTrace();
              }
              System.out.println("adding sound to level");
              level.sounds.put(newFileName, new StageSound(newFileName, "/"+pathSegments[pathSegments.length-1],newSoundAsNarration));//add the sound to the level
              System.out.println("saving level");
              level.save(true);//save the level
              gmillis=millis()+400;///glitch effect
              System.out.println("save complete"+gmillis);
              newFile=false;//return back to the obverview
              newFileName="";
              fileToCoppyPath="";
              levelOverview=true;
              return;
            }
            currentStageIndex=level.stages.size();//set the current sateg to the new stage
            respawnStage=currentStageIndex;
            if (newFileType.equals("2D")) {//create the approriate type of stage based on what is selectd
              level.stages.add(new Stage(newFileName, "stage"));
            }
            if (newFileType.equals("3D")) {
              level.stages.add(new Stage(newFileName, "3Dstage"));
            }

            editingStage=true;
            newFile=false;
          }
          if (newFileType.equals("sound")) {
            if (chooseFileButton.isMouseOver()) {//choose file button for when the type is sound
              selectInput("select audio file: .WAV .AFI .MP3:", "fileSelected");//open file selection diaglog
            }
            if(lc_newSoundAsSoundButton.isMouseOver()){
              newSoundAsNarration=false;
            }
            if(lc_newSoundAsNarrationButton.isMouseOver()){
              newSoundAsNarration=true;
            }
          }

          if (new3DStage.isMouseOver()) {//buttons to set type
            newFileType="3D";
          }
          if (new2DStage.isMouseOver()) {
            newFileType="2D";
          }
          if (addSound.isMouseOver()) {
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
          if (createBlueprintGo.isMouseOver()) {//create button
            if (new_name!=null&&!new_name.equals("")) {//if something was entered
              if(newBlueprintIs3D){
                workingBlueprint=new Stage(new_name, "3D blueprint");//creat and load the new blueprint
              }else{
                workingBlueprint=new Stage(new_name, "blueprint");//creat and load the new blueprint
              }
              entering_name=false;//set up enviormatn vaibles
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
            entering_name=false;
          }
          if (new3DStage.isMouseOver()) {//buttons to set type
            newBlueprintIs3D=true;
          }
          if (new2DStage.isMouseOver()) {
            newBlueprintIs3D=false;
          }
        }//end of creating new bluepint

        if (loadingBlueprint) {//if loading blueprint
          if (createBlueprintGo.isMouseOver()) {//load button
            if (new_name!=null&&!new_name.equals("")) {//if something was entered
              rootPath=System.getenv("appdata")+"/CBi-games/skinny mann level creator/blueprints";
              workingBlueprint=new Stage(loadJSONArray(rootPath+"/"+new_name+".json"));//load the blueprint
              entering_name=false;//set enviormaent varibles
              loadingBlueprint=false;
              editingBlueprint=true;
              camPos=-640;
              camPosY=360;
            }//end of thing were entered
          }//end of load button
          if (lc_backButton.isMouseOver()) {
            startup=true;
            loadingBlueprint=false;
            entering_name=false;
          }
        }//end of loading blueprint
        if (editinglogicBoard) {
          if (placingAndGate) {
            level.logicBoards.get(logicBoardIndex).components.add(new AndGate(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingOrGate) {
            level.logicBoards.get(logicBoardIndex).components.add(new OrGate(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingXorGate) {
            level.logicBoards.get(logicBoardIndex).components.add(new XorGate(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingNandGate) {
            level.logicBoards.get(logicBoardIndex).components.add(new NAndGate(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingNorGate) {
            level.logicBoards.get(logicBoardIndex).components.add(new NOrGate(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingXnorGate) {
            level.logicBoards.get(logicBoardIndex).components.add(new XNorGate(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (deleteing) {
            for (int i=0; i< level.logicBoards.get(logicBoardIndex).components.size(); i++) {
              if (level.logicBoards.get(logicBoardIndex).components.get(i).button.isMouseOver()) {
                level.logicBoards.get(logicBoardIndex).remove(i);
                return;
              }
            }
          }
          if (placingTestLogic) {
            //level.logicBoards.get(logicBoardIndex).components.add(new GIL(mouseX-50+camPos, mouseY-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingOnSingal) {
            level.logicBoards.get(logicBoardIndex).components.add(new ConstantOnSignal(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingSetVaravle) {
            level.logicBoards.get(logicBoardIndex).components.add(new SetVariable(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingReadVariable) {
            level.logicBoards.get(logicBoardIndex).components.add(new ReadVariable(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (selecting) {
            for (int i=0; i< level.logicBoards.get(logicBoardIndex).components.size(); i++) {
              if (level.logicBoards.get(logicBoardIndex).components.get(i).button.isMouseOver()) {
                selectedIndex=i;
              }
            }
          }
          if (placingSetVisibility) {
            level.logicBoards.get(logicBoardIndex).components.add(new SetVisibility(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingXOffset) {
            level.logicBoards.get(logicBoardIndex).components.add(new SetXOffset(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingYOffset) {
            level.logicBoards.get(logicBoardIndex).components.add(new SetYOffset(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingDelay) {
            level.logicBoards.get(logicBoardIndex).components.add(new Delay(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingZOffset) {
            level.logicBoards.get(logicBoardIndex).components.add(new SetZOffset(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placing3Dsetter) {
            level.logicBoards.get(logicBoardIndex).components.add(new Set3DMode(mouseX/Scale-50+camPos, mouseY/Scale-40+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placing3Dreader) {
            level.logicBoards.get(logicBoardIndex).components.add(new Read3DMode(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingPlaySoundLogic) {
            level.logicBoards.get(logicBoardIndex).components.add(new LogicPlaySound(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingPulse) {
            level.logicBoards.get(logicBoardIndex).components.add(new Pulse(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
          if (placingRandom) {
            level.logicBoards.get(logicBoardIndex).components.add(new Random(mouseX/Scale-50+camPos, mouseY/Scale-20+camPosY, level.logicBoards.get(logicBoardIndex)));
          }
        }//end of edditing logic board

        if (settingPlayerSpawn) {
          level.SpawnX=mouseX/Scale+camPos;
          level.SpawnY=mouseY/Scale-camPosY;
          level.RewspawnX=mouseX/Scale+camPos;
          level.RespawnY=mouseY/Scale-camPosY;
          settingPlayerSpawn=false;
        }
        if (exitLevelCreator) {
          if (lc_exitConfirm.isMouseOver()) {
            exitLevelCreator=false;
            levelCreator=false;
            inGame=false;
            menue=true;
            
          }

          if (lc_exitCancle.isMouseOver()) {
            exitLevelCreator=false;
            levelOverview=true;
          }
        }
      }//end of left mouse button clicked
    }//end of level creator
  }
  catch(Throwable e) {
    handleError(e);
  }
}


void keyPressed() {// when a key is pressed
  try {
    if (!menue&&tutorialMode&&key == ESC&&tutorialPos<3) {
      exit(1);
    }

    if (inGame||(levelCreator&&editingStage&&simulating)) {//if in game
      if (key == ESC&&!levelCreator) {
        key = 0;  //clear the key so it doesnt close the program
        menue=true;
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
      if (key=='e'||key=='E') {
        E_pressed=true;
      }
      if (keyCode==87) {//w
        playerMovementManager.setIn(true);
      }
      if (keyCode==83) {//s
        playerMovementManager.setOut(true);
      }
      if (e3DMode) {
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
    if (menue&&!levelCreator) {
      if (Menue.equals("level select")) {
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
      }
      if (Menue.equals("level select UGC")) {
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="level select";
        }
      }
      if (Menue.equals("settings")) {
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
        if (settingsMenue.equals("outher")) {
          defaultAuthorNameTextBox.keyPressed();
          if(!defaultAuthorNameTextBox.getContence().equals(defaultAuthor)){
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
      if (Menue.equals("how to play")) {
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
      }
      if (Menue.equals("main")) {
        if (key == ESC)
          exit(0);
      }
      if (Menue.equals("start host")) {
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
        //if (enteringName) {
        //  name=getInput(name, 0);
        //}
        //if (enteringPort) {
        //  if (getInput(port+"", 1).equals("")) {
        //    port=0;
        //  } else {
        //    if (port==0) {
        //      port=Integer.parseInt(getInput("0", 1));
        //    } else {
        //      try {
        //        port=Integer.parseInt(getInput(port+"", 1));
        //      }
        //      catch(java.lang.NumberFormatException n) {
        //      }
        //    }
        //  }
        //}
        multyPlayerNameTextBox.keyPressed();
        multyPlayerPortTextBox.keyPressed();
      }
      if (Menue.equals("start join")) {
        if (key == ESC) {
          key = 0;  //clear the key so it doesnt close the program
          Menue="main";
        }
        //if (enteringName) {
        //  name=getInput(name, 0);
        //}
        //if (enteringPort) {
        //  if (getInput(port+"", 1).equals("")) {
        //    port=0;
        //  } else {
        //    if (port==0) {
        //      port=Integer.parseInt(getInput("0", 1));
        //    } else {
        //      try {
        //        port=Integer.parseInt(getInput(port+"", 1));
        //      }
        //      catch(java.lang.NumberFormatException n) {
        //      }
        //    }
        //  }
        //}
        //if (enteringIP) {
        //  ip=getInput(ip, 4);
        //}
        multyPlayerNameTextBox.keyPressed();
        multyPlayerPortTextBox.keyPressed();
        multyPlayerIpTextBox.keyPressed();
      }
    }
    if (levelCreator) {
      if (key == ESC){
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

      if (entering_file_path) {//if ennering "file path"
        if (keyCode>=48&&keyCode<=57/*numbers*/||keyCode==46/*decimal*/||keyCode==32/*space*/||(keyCode>=65&&keyCode<=90)/*a-z*/||keyCode==59/*;:*/||keyCode==92/*\*/||keyCode==45/*-_*/) {

          if (rootPath==null) {//if the path is blank
            rootPath=key+"";//add current key pressed to path
          } else {
            rootPath+=key;//add current key pressed to path
          }
        }
        if (keyCode==8) {//if the key is BACKSPACE
          if (rootPath==null) {//if there3 is nothing then do nothing
          } else {
            if (rootPath.length()==1) {//delet if only 1 charcter
              rootPath=null;
            } else {
              rootPath=rootPath.substring(0, rootPath.length()-1);//remove last charicter
            }
          }
        }
      }//end of entering file path

      if (entering_name) {//if entering anme
        if (keyCode>=48&&keyCode<=57/*numbers*/||keyCode==46/*decimal*/||keyCode==32/*space*/||(keyCode>=65&&keyCode<=90)/*a-z*/||keyCode==59/*;:*/||keyCode==92/*\*/||keyCode==45/*-_*/) {

          if (new_name==null) {//if the path is blank
            new_name=key+"";//add current key pressed to path
          } else {
            new_name+=key;//add current key pressed to path
          }
        }
        if (keyCode==8) {//if the key is BACKSPACE
          if (new_name==null) {
          } else {
            if (new_name.length()==1) {
              new_name=null;
            } else {
              new_name=new_name.substring(0, new_name.length()-1);//remove the last charicter
            }
          }
        }
      }//end of entering name
      if (newFile) {//if new file
        newFileName=getInput(newFileName, 0);//use the cencable typing functions
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
      }
    }

    if(keyCode == 108 && dev_mode){//F12
      showDepthBuffer = !showDepthBuffer;
    }
    if(keyCode == 107 && dev_mode){//F11
      shadowShaderOutputSampledDepthInfo = !shadowShaderOutputSampledDepthInfo;
    }
    if(keyCode == 106 && dev_mode){//F10
      shadowShader = loadShader("shaders/shadowMapFrag.glsl","shaders/shadowMapVert.glsl");
      println("Relaoded Shaders");
    }
    
    //System.out.println(keyCode);
    if (key=='b'||key=='B') {
      println("p");
    }
  }
  catch(Throwable e) {
    handleError(e);
  }
}

void keyReleased() {//when you release a key
  try {
    if (inGame||(levelCreator&&editingStage)) {//when in a level or when in the levelcreate and in a level
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
      
      if (e3DMode) {
        //level creater 3D camera inputs
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
      if (!simulating||editinglogicBoard||e3DMode) {//this seems to be for the logic boards as the pervous section hanldes all insatces of being in the stage editor
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
    if(menue){
      if (Menue.equals("settings")) {
        if (settingsMenue.equals("outher")) {
          defaultAuthorNameTextBox.keyReleased();
        }
      }
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
  }
  catch(Throwable e) {
    handleError(e);
  }
}

void keyTyped(){
  if(menue){
    if (Menue.equals("settings")) {
      if (settingsMenue.equals("outher")) {
        defaultAuthorNameTextBox.keyTyped();
        if(!defaultAuthorNameTextBox.getContence().equals(defaultAuthor)){
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
}

void mouseDragged() {
  try {
    if (levelCreator) {
      if (Menue.equals("settings")) {
        if (settingsMenue.equals("game play")) {
        }
        if (settingsMenue.equals("outher")) {
        }
      }
    } else {
      if (Menue.equals("settings")) {     //if that menue is settings

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
  }
  catch(Throwable e) {
    handleError(e);
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

void windowResized() {
  ui.reScale();
  Scale = height/720.0;
}

void loadLevel(String path) {
  soundHandler.dumpLS();
  try {
    reachedEnd=false;
    rootPath=path;
    JSONArray mainIndex=loadJSONArray(rootPath+"/index.json");
    level=new Level(mainIndex);
    level.logicBoards.get(level.loadBoard).superTick();
    startTime = millis();
  }
  catch(Throwable e) {
    handleError(e);
  }
}

int curMills=0, lasMills=0, mspc=0;

/**physics thread main loop
*/
void thrdCalc2() {

  //while the thread should be active
  while (loopThread2) {
    //calculate how long has passed since the last time the loop started
    curMills=millis();
    mspc=curMills-lasMills;

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
      }
      catch(Throwable e) {
        e.printStackTrace();
      }
    } else {
      if (logicTickingThread.isAlive()) {//if the ticking thread is running when we dont want it to be
        logicTickingThread.shouldRun=false;//then stop it
      }
      random(10);//some how make it so processing doesent stop the thread(also increase CPU useage :D )
    }
    lasMills=curMills;
    //println(mspc);
  }
}

void mousePressed() {
  if (levelCreator) {
    if (mouseButton==LEFT) {
      if (editingStage||editingBlueprint) {//if edditing a stage or blueprint
        GUImousePressed();
      }
      if (editinglogicBoard) {
        if (connectingLogic) {
          LogicBoard board=level.logicBoards.get(logicBoardIndex);
          for (int i=0; i<board.components.size(); i++) {
            float[] nodePos=board.components.get(i).getTerminalPos(2);
            if (Math.sqrt(Math.pow(nodePos[0]-mouseX/Scale, 2)+Math.pow(nodePos[1]-mouseY/Scale, 2))<=10) {
              connecting=true;
              connectingFromIndex=i;
              return;
            }
          }
        }
        if (moveLogicComponents) {
          LogicBoard board=level.logicBoards.get(logicBoardIndex);
          for (int i=0; i<board.components.size(); i++) {
            if (board.components.get(i).button.isMouseOver()) {
              movingLogicIndex=i;
              movingLogicComponent=true;
              return;
            }
          }
        }
      }//end of editng logic board
      if (e3DMode&&selectedIndex!=-1) {
        StageComponent ct = null;
          if (editingStage) {
            ct=level.stages.get(currentStageIndex).parts.get(selectedIndex);
          }
          if (editingBlueprint) {
            ct = workingBlueprint.parts.get(selectedIndex);
          }
        
        for (int i=0; i<5000; i++) {
          Point3D testPoint=genMousePoint(i);
          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= ct.z+ct.dz && testPoint.z <= ct.z+ct.dz+60) {
            translateZaxis=true;
            transformComponentNumber=1;
            break;
          }

          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= ct.z-60 && testPoint.z <= ct.z) {
            translateZaxis=true;
            transformComponentNumber=2;
            break;
          }

          if (testPoint.x >= ct.x-60 && testPoint.x <= ct.x && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            translateXaxis=true;
            transformComponentNumber=2;
            break;
          }

          if (testPoint.x >= ct.x+ct.dx && testPoint.x <= ct.x+ct.dx+60 && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            translateXaxis=true;
            transformComponentNumber=1;
            break;
          }

          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= ct.y-60 && testPoint.y <= ct.y && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            translateYaxis=true;
            transformComponentNumber=2;
            break;
          }

          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= ct.y+ct.dy && testPoint.y <= ct.y+ct.dy+60 && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            translateYaxis=true;
            transformComponentNumber=1;
            break;
          }
        }
        initalMousePoint=mousePoint;
        initalObjectPos=new Point3D(ct.x, ct.y, ct.z);
        initialObjectDim=new Point3D(ct.dx, ct.dy, ct.dz);
      }
      
      //placing a blueprint in 3D movement
      if (e3DMode && selectingBlueprint && blueprints.length!=0){
        float cdx = blueprintMax[0]-blueprintMin[0];
        float cdy = blueprintMax[1]-blueprintMin[1];
        float cdz = blueprintMax[2]-blueprintMin[2];
        for (int i=0; i<5000; i++) {
          Point3D testPoint=genMousePoint(i);
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
        initalMousePoint=mousePoint;
        initalObjectPos=new Point3D(blueprintPlacemntX, blueprintPlacemntY, blueprintPlacemntZ);
      }
    }
  }
}

void mouseReleased() {
  if (levelCreator) {
    if (mouseButton==LEFT) {
      if (editingStage||editingBlueprint) {//if edditing a stage or blueprint
        GUImouseReleased();
      }
      if (editinglogicBoard) {
        if (connectingLogic&&connecting) {//if attempting to connect terminals
          connecting=false;//stop more connecting
          LogicBoard board=level.logicBoards.get(logicBoardIndex);
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
            if (Math.sqrt(Math.pow(nodePos2[0]-mouseX/Scale, 2)+Math.pow(nodePos2[1]-mouseY/Scale, 2))<=10) {//if the mmouse is over terminal 1
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
        if (moveLogicComponents) {
          if (movingLogicComponent) {
            movingLogicComponent=false;
            level.logicBoards.get(logicBoardIndex).components.get(movingLogicIndex).setPos(mouseX/Scale+camPos, mouseY/Scale+camPosY);
          }
        }
      }//end of editing logic board
      if (e3DMode&&selectedIndex!=-1) {
        translateZaxis=false;
        translateXaxis=false;
        translateYaxis=false;
      }
      if (e3DMode && selectingBlueprint){
        translateZaxis=false;
        translateXaxis=false;
        translateYaxis=false;
      }
    }
  }
}

void drawMainMenu(boolean background) {
  if (background)
    background(7646207);
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

void drawSettings() {
  fill(0);
  background(7646207);
  st_title.draw();

  if (settingsMenue.equals("game play")) {
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

  if (settingsMenue.equals("display")) {
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
  
  if(settingsMenue.equals("sound")){
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
  if (settingsMenue.equals("outher")) {
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
  if (true) {
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
      //enableFPS,disableFPS,enableDebug,disableDebug
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

      //shadows0, shadows1, shadows2, shadows3, shadows4
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

  sttingsGPL.draw();
  settingsDSP.draw();
  settingsSND.draw();
  settingsOUT.draw();

  settingsBackButton.draw();
}//end of draw settings

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
  int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
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

void drawLevelSelect2(boolean bcakground){
  levelCompleteSoundPlayed=false;
  if (bcakground)
    background(#66696F);
  fill(0);
  ls_levelSelect.draw();
  int progress=levelProgress.getJSONObject(0).getInt("progress")+1;
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

  select_lvl_13.draw();
  select_lvl_14.draw();
  select_lvl_back.draw();
}

void drawLevelSelectUGC() {
  background(7646207);
  fill(0);
  lsUGC_title.draw();//menue title

  select_lvl_back.draw();
  //UGC_open_folder.draw();
  //levelcreatorLink.draw();
  fill(0);
  if (UGCNames.size()==0) {
    lsUGC_noLevelFound.draw();
  } else {
    lsUGC_levelName.setText(UGCNames.get(UGC_lvl_indx));
    lsUGC_levelName.draw();
    if ((boolean)compatibles.get(UGC_lvl_indx)) {
      lsUGC_levelNotCompatible.draw();
    }
    if (UGC_lvl_indx<UGCNames.size()-1) {
      UGC_lvls_next.draw();
    }
    if (UGC_lvl_indx>0) {
      UGC_lvls_prev.draw();
    }
    UGC_lvl_play.draw();
  }
}

void chechMark(float x, float y) {
  line(x-15*Scale, y, x, y+15*Scale);
  line(x+25*Scale, y-15*Scale, x, y+15*Scale);
}

void tutorialLogic() {
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

boolean gameVersionCompatibilityCheck(String vers) {//returns ture if the inputed version is compatible
  if (levelCreator) {
    levelCompatible=true;
    return true;
  }
  for (int i=0; i<compatibleVersions.length; i++) {
    if (vers.equals(compatibleVersions[i])) {
      levelCompatible=true;
      return true;
    }
  }
  levelCompatible=false;
  return false;
}

void engageHUDPosition() {

  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
}

void disEngageHUDPosition() {

  hint(ENABLE_DEPTH_TEST);
}

void handleError(Throwable e) {
  System.err.println("an error occored but was intercepted");
  e.printStackTrace();
  StackTraceElement[] elements = e.getStackTrace();
  String stack="";
  for (int ele=0; ele<elements.length; ele++) {
    stack+=elements[ele].toString()+"\n";
  }
  stack+="\nyou may wish to take a screenshot of this window and resport this as an issue on github";
  JFrame jf=new JFrame();
  jf.setAlwaysOnTop(true);
  JOptionPane.showMessageDialog(jf, stack, e.toString(), JOptionPane.ERROR_MESSAGE);
  exit(-1);
}

void exit() {
  println("somehitng attempted to close the program");
}

void exit(int i) {
  println("exited with code: "+i);
  super.exit();
}

void glitchEffect() {
  int bsepnum = 25;
  int n=millis()/100%bsepnum;
  //n=9;
  int bsep = glitchBoxes.size()/bsepnum;
  strokeWeight(0);
  for(int i=0;i<bsep;i++){
    glitchBoxes.get(i+bsep*n).draw();
  }
}

class GlitchBox{
  int x,y,w,h,c;
  GlitchBox(String in){
    String[] bs = in.split(",");
    x=Integer.parseInt(bs[0]);
    y=Integer.parseInt(bs[1]);
    w=Integer.parseInt(bs[2]);
    h=Integer.parseInt(bs[3]);
    c=Integer.parseInt(bs[4]);
  }
  
  void draw(){
    fill(c,128);
    rect(ui.topX()+x*ui.scale(),ui.topY()+y*ui.scale(),w*ui.scale(),h*ui.scale());
  }
}

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
  StageEntityCollisionManager.set(this);
}

void networkError(Throwable error) {
  if (clientQuitting) {
    clientQuitting=false;
    return;
  }
  menue=true;
  inGame=false;
  error.printStackTrace();
  Menue="disconnected";
  disconnectReason=error.toString();
  multiplayer=false;
}

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
}

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
}

void calcTextSize(String text, float width) {
  calcTextSize(text, width, 4837521);
}
void calcTextSize(String text, float width, int max) {
  for (int i=1; i<max; i++) {
    textSize(i);
    if (textWidth(text)>width) {
      textSize(i-1);
      return;
    }
  }
}

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
  }
  catch(Exception e) {
  }

  multyplayerSelectedLevel=new SelectedLevelInfo(name, author, gameVersion, multyplayerMode, minPlayers, maxPlayers, id, UGC);
}

void returnToSlection() {
  BackToMenuRequest mrq = new BackToMenuRequest();
  try {
    for (int i=0; i<clients.size(); i++) {
      clients.get(i).dataToSend.add(mrq);
    }
  }
  catch(Exception e) {
  }
}

String formatMillis(int millis) {
  int mins=millis/60000;
  float secs=(millis/1000.0)-mins*60;
  return mins+":"+String.format("%.3f", secs);
}


void programLoad() {
  //do this first becasue it causes a momentary freez on the render thread that we want to avoid later in the animation
  println("loading shaders");
  depthBufferShader = loadShader("shaders/depthBufferFrag.glsl","shaders/depthBufferVert.glsl");
  shadowShader = loadShader("shaders/shadowMapFrag.glsl","shaders/shadowMapVert.glsl");

  requestDepthBufferInit = true;
  //this init can only happen on the main render thread
  
  println("loading 3D coin modle");
  coin3D=loadShape("data/modles/coin/tinker.obj");
  loadProgress++;
  coin3D.scale(3);

  defaultAuthorNameTextBox.setContence(settings.getDefaultAuthor());
  author = settings.getDefaultAuthor();
  loadProgress++;

  println("loading level progress");
  try {//load level prgress
    levelProgress=loadJSONArray(appdata+"/CBi-games/skinny mann/progressions.json");
    levelProgress.getJSONObject(0);
    loadProgress++;
  }
  catch(Throwable e) {
    println("failed to load level progress. creating new progress data");
    levelProgress=new JSONArray();
    JSONObject p=new JSONObject();
    p.setInt("progress", 0);
    levelProgress.setJSONObject(0, p);
    saveJSONArray(levelProgress, appdata+"/CBi-games/skinny mann/progressions.json");
    loadProgress++;
  }

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

  SoundHandler.Builder soundBuilder = SoundHandler.builder(this);
  String[] musicTracks=loadStrings("data/music/music.txt");
  for (int i=0; i<musicTracks.length; i++) {
    soundBuilder.addMusic(musicTracks[i], 0);
  }
  String[] sfxTracks=loadStrings("data/sounds/sounds.txt");
  for (int i=0; i<sfxTracks.length; i++) {
    soundBuilder.addSound(sfxTracks[i]);
  }

  int[] idcb = {0};//narration id call back array. used to get the id the narration will be set to out of the builder
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

  soundHandler.setMusicVolume(settings.getSoundMusicVolume());
  soundHandler.setSoundsVolume(settings.getSoundSoundVolume());
  soundHandler.setNarrationVolume(settings.getSoundNarrationVolume());
  
  
  

  println("loading saved colors");
  if (new File(appdata+"/CBi-games/skinny mann level creator/colors.json").exists()) {
    colors=loadJSONArray(appdata+"/CBi-games/skinny mann level creator/colors.json");//load saved colors
  } else {
    colors=JSONArray.parse("[{\"red\": 0,\"green\": 175,\"blue\": 0},{\"red\": 145,\"green\": 77,\"blue\": 0}]");
  }
  loadProgress++;

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

  LevelCreatorLogo=loadShape("data/modles/LevelCreatorLogo/LCL.obj");
  loadProgress++;
  LevelCreatorLogo.scale(3*Scale);

  musicVolumeSlider.setValue(settings.getSoundMusicVolume()*100);
  SFXVolumeSlider.setValue(settings.getSoundSoundVolume()*100);
  narrationVolumeSlider.setValue(settings.getSoundNarrationVolume()*100);
  verticleEdgeScrollSlider.setValue(settings.getSrollVertical());
  horozontalEdgeScrollSlider.setValue(settings.getScrollHorozontal());
  fovSlider.setValue(degrees(settings.getFOV()));
  
  String[] rawGlitchBoxes = loadStrings("data/glitch.txt");
  loadProgress++;
  for(int i=0;i<rawGlitchBoxes.length;i++){
    glitchBoxes.add(new GlitchBox(rawGlitchBoxes[i]));
  }

  println("loading stats");
  stats = new StatisticManager(appdata+"/CBi-games/skinny mann/stats.json",this);
  loadProgress++;
 
  uvTester = loadImage("data/assets/ic.png");

  println("starting physics thread");
  thread("thrdCalc2");
  loaded=true;
  println("loading complete");
  println(loadProgress);
}

void initDepthBuffer(){
  int bufferSize;
  switch(settings.getShadows()){
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
  shadowMap = createGraphics(bufferSize, bufferSize, P3D);
  subShadowMaps[0] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  subShadowMaps[1] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  subShadowMaps[2] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  subShadowMaps[3] = createGraphics(bufferSize/2, bufferSize/2, P3D);
  cameraMatrixMap = createGraphics(bufferSize/2, bufferSize/2, P3D);
  
  println(bufferSize);
  
  //set the light direction
  lightDir.set(-0.8, -1, 0.35);
  lightDir.mult(800);

  shadowMap.noSmooth(); // Antialiasing on the shadowMap leads to weird artifacts
  //shadowMap.loadPixels(); // Will interfere with noSmooth() (probably a bug in Processing)
  shadowMap.beginDraw();
  //shadowMap.noStroke();
  shadowMap.shader(depthBufferShader);
  //TODO: set the area coverd by shadows here
  int shadowMapClibBoxSize = 2000;
  shadowMap.ortho(-shadowMapClibBoxSize, shadowMapClibBoxSize, -shadowMapClibBoxSize, shadowMapClibBoxSize, 1, 13000); // Setup orthogonal view matrix for the directional light
  shadowMap.endDraw();
  subShadowMaps[0].noSmooth();
  subShadowMaps[1].noSmooth();
  subShadowMaps[2].noSmooth();
  subShadowMaps[3].noSmooth();
  
  cameraMatrixMap.beginDraw();
  cameraMatrixMap.ortho(-shadowMapClibBoxSize/2, shadowMapClibBoxSize/2, -shadowMapClibBoxSize/2, shadowMapClibBoxSize/2, 1, 13000);
  cameraMatrixMap.endDraw();
  
  //attempt to compile the shader now instread of later
  shader(shadowShader);
  resetShader();
  
  for(int i=0;i<subShadowMaps.length;i++){
    subShadowMaps[i].beginDraw();
    subShadowMaps[i].background(255);
    subShadowMaps[i].endDraw();
  }
  
}

//musicVolumeSlider,SFXVolumeSlider,verticleEdgeScrollSlider,horozontalEdgeScrollSlider;
void  initButtons() {
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




  dev_main = new UiButton(ui, 210, 100, 200, 50, "main menu");
  dev_quit = new UiButton(ui, 430, 100, 200, 50, "exit");
  dev_levels  = new UiButton(ui, 650, 100, 200, 50, "level select");
  dev_tutorial  = new UiButton(ui, 870, 100, 200, 50, "tutorial");
  dev_settings = new UiButton(ui, 210, 170, 200, 50, "settings");
  dev_UGC = new UiButton(ui, 430, 170, 200, 50, "UGC");
  dev_multiplayer = new UiButton(ui, 650, 170, 200, 50, "Multiplayer");
  dev_levelCreator=new UiButton(ui, 870, 170, 200, 50, "Level Creator");

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

  overview_saveLevel=new UiButton(ui, 60, 20, 50, 50, "Save", #0092FF, 0).setStrokeWeight(5);
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
  
  defaultAuthorNameTextBox = new UiTextBox(ui,900,330,340,40).setColors(#FFFFFF,0).setStrokeWeight(5).setTextSize(26).setPlaceHolder("Name Goes Here").setContence(defaultAuthor);
  
  //perhapse dont use default suthor for this, or do
  multyPlayerNameTextBox = new UiTextBox(ui, 128, 108, 1024, 36).setColors(#FF8000,0).setTextSize(25).setPlaceHolder("Your Name Here").setContence(defaultAuthor);
  multyPlayerPortTextBox = new UiTextBox(ui, 128, 187, 1024, 36).setColors(#FF8000,0).setTextSize(25).setPlaceHolder("Port Here").setContence(port+"").setAllowList("0123456789");
  multyPlayerIpTextBox = new UiTextBox(ui, 128, 266, 1024, 36).setColors(#FF8000,0).setTextSize(25).setPlaceHolder("Host Address Here").setContence("localhost").setAllowList(".0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-");



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
}


String getLevelHash(String path) {
  String basePath="";
  if (path.startsWith("data")) {
    basePath=sketchPath()+"/"+path;
  } else {
    basePath=path;
  }
  String hash="";
  hash+=Hasher.getFileHash(basePath+"/index.json");

  JSONArray file = loadJSONArray(basePath+"/index.json");
  JSONObject job;
  for (int i=1; i<file.size(); i++) {
    job=file.getJSONObject(i);
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
  return hash;
}

void loadUGCList() {
  new File(appdata+"/CBi-games/skinny mann/UGC/levels").mkdirs();
  String[] files=new File(appdata+"/CBi-games/skinny mann/UGC/levels").list();

  compatibles=new ArrayList<>();
  UGCNames=new ArrayList<>();
  try {
    if (files.length==0)
      return;
  }
  catch(NullPointerException e) {
    return;
  }
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

void turnThingsOff() {
  selectedIndex=-1;
  ground=false;
  check_point=false;
  goal=false;
  deleteing=false;
  moving_player=false;
  holo_gram=false;
  levelOverview=false;
  drawCoins=false;
  drawingPortal=false;
  drawingPortal3=false;
  sloap=false;
  holoTriangle=false;
  dethPlane=false;
  draw3DSwitch1=false;
  draw3DSwitch2=false;
  drawingSign=false;
  selecting=false;
  selectedIndex=-1;
  selectingBlueprint=false;
  placingSound=false;
  connectingLogic=false;
  moveLogicComponents=false;
  placingAndGate=false;
  placingOrGate=false;
  placingXorGate=false;
  placingNandGate=false;
  placingNorGate=false;
  placingXnorGate=false;
  placingTestLogic=false;
  placingOnSingal=false;
  placingSetVaravle=false;
  placingReadVariable=false;
  placingSetVisibility=false;
  placingYOffset=false;
  placingXOffset=false;
  placingLogicButton=false;
  placingDelay=false;
  placingZOffset=false;
  settingPlayerSpawn=false;
  placing3Dreader=false;
  placing3Dsetter=false;
  placingPlaySoundLogic=false;
  placingPulse=false;
  placingRandom=false;
  placingGoon=false;
}

void fileSelected(File selection) {
  if (selection == null) {
    return;
  }
  String path = selection.getAbsolutePath();
  System.out.println(path);
  String extenchen=path.substring(path.length()-3, path.length()).toLowerCase();
  System.out.println(extenchen);
  if (extenchen.equals("wav")||extenchen.equals("mp3")||extenchen.equals("afi")) {//check if the file type is valid

    fileToCoppyPath=path;
  } else {
    System.out.println("invalid extenchen");
    return;
  }
}

void initText() {
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
  //mp_host_enterdName = new UiText(ui, "V", 640, 126, 25, CENTER, CENTER);
  mp_host_port = new UiText(ui, "Port", 640, 172.8, 25, CENTER, CENTER);
  //mp_host_endterdPort = new UiText(ui, "V", 640, 205.2, 25, CENTER, CENTER);
  mp_joinSession = new UiText(ui, "Join session", 640, 36, 50, CENTER, CENTER);
  mp_join_name = new UiText(ui, "Name", 640, 93.6, 25, CENTER, CENTER);
  //mp_join_enterdName = new UiText(ui, "V", 640, 126, 25, CENTER, CENTER);
  mp_join_port = new UiText(ui, "Port", 640, 172.8, 25, CENTER, CENTER);
  //mp_join_enterdPort = new UiText(ui, "V", 640, 205.2, 25, CENTER, CENTER);
  mp_join_ip = new UiText(ui, "IP address", 640, 252, 25, CENTER, CENTER);
  //mp_join_enterdIp = new UiText(ui, "?V", 640, 284.4, 25, CENTER, CENTER);
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
  lc_load_new_enterd = new UiText(ui, "EEEEEEEEE", 40, 150, 20, LEFT, BOTTOM);
  lc_load_notFound = new UiText(ui, "Level Not Found!", 640, 300, 50, CENTER, CENTER);
  lc_newf_enterdName = new UiText(ui, "VAL", 100, 445, 70, LEFT, BOTTOM);
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
}


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
