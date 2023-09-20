int xangle=25+180, yangle=15, dist=700;//camera presets
float DY=sin(radians(yangle))*dist, hd=cos(radians(yangle))*dist, DX=sin(radians(xangle))*hd, DZ=cos(radians(xangle))*hd, cam3Dx, cam3Dy, cam3Dz;//camera rotation

/**draws all the elements of a stage
 
 */
void stageLevelDraw() {
  Stage stage=level.stages.get(currentStageIndex);
  background(stage.skyColor);//sky color
  int selectIndex=-1;//reset the selected obejct
  if (selecting) {//if you are currently using the selection tool
    selectIndex=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, stage);//figure out what eleiment you are hovering over
  }
  if (E_pressed&&viewingItemContents) {//if you are viewing the contence of an element and you press E
    E_pressed=false;//close the contence of the eleiment
    viewingItemContents=false;
    viewingItemIndex=-1;
  }
  if (stage.type.equals("stage")) {//if tthe cuurent thing that is being drawn is a stage
    SPressed=false;
    WPressed=false;
    e3DMode=false;//turn 3D mode off
    camera();//reset the camera
    drawCamPosX=camPos;//versions of the camera position variblaes that only get updated once every frame and not on every physics tick
    drawCamPosY=camPosY;
    for (int i=0; stageLoopCondishen(i, stage); i++) {//loop through all elements in the stage
      strokeWeight(0);
      noStroke();
      if (selectIndex==i) {//if the current element is the element the mouse is hovering over while the selection tool is active
        stroke(#FFFF00);//give that element a blue border
        strokeWeight(2);
      }
      if (selectedIndex==i) {//if the current element is the element that has been selected
        stroke(#0A03FF);//give that element a yellow border
        strokeWeight(2);
      }
      stage.parts.get(i).draw();//draw the element
      if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
        viewingItemIndex=i;//set the cuurent viewing item to this element
      }
    }
    players[currentPlayer].in3D=false;
    if (clients.size()>0)
      for (int i=currentNumberOfPlayers-1; i>=0; i--) {
        if (i==currentPlayer)
          continue;
        if (players[i].stage==currentStageIndex&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
          draw_mann(Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY), players[i].getPose(), Scale*players[i].getScale(), players[i].getColor());//draw the outher players
          fill(255);
          textSize(15*Scale);
          textAlign(CENTER, CENTER);
          text(players[i].name, Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY-85));
        }
      }

    draw_mann(Scale*(players[currentPlayer].getX()-drawCamPosX), Scale*(players[currentPlayer].getY()+drawCamPosY), players[currentPlayer].getPose(), Scale*players[currentPlayer].getScale(), players[currentPlayer].getColor());//draw this users player
    players[currentPlayer].stage=currentStageIndex;
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
  } else if (stage.type.equals("3Dstage")) {//if the stage is a 3D stage
    if (e3DMode) {//if 3D mode is turned on


      if ((simulating&&levelCreator)||!levelCreator)
        camera3DpositionSimulating();
      else
        camera3DpositionNotSimulating();

      camera(cam3Dx+DX, cam3Dy-DY, cam3Dz-DZ, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);//set the camera
      directionalLight(255, 255, 255, 0.8, 1, -0.35);//setr up the lighting
      ambientLight(102, 102, 102);
      coinRotation+=3;//rotate the coins
      if (coinRotation>360)//reset the coin totation if  it is over 360 degrees
        coinRotation-=360;
      drawCamPosX=camPos;//versions of the camera position variblaes that only get updated once every frame and not on every physics tick
      drawCamPosY=camPosY;
      for (int i=0; stageLoopCondishen(i, stage); i++) {//loop through all elements in the stage
        strokeWeight(0);
        noStroke();
        if (selectedIndex==i) {//if the current element is the element the mouse is hovering over while the selection tool is active
          stroke(#FFFF00);//give that element a blue border
          strokeWeight(2);
        }
        stage.parts.get(i).draw3D();//draw the element in 3D
        if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
          viewingItemIndex=i;//set the cuurent viewing item to this element
        }
      }
      players[currentPlayer].in3D=true;
      if (clients.size()>0)
        for (int i=currentNumberOfPlayers-1; i>=0; i--) {
          if (i==currentPlayer)
            continue;
          if (players[i].stage==currentStageIndex&&i!=currentPlayer&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
            if (players[i].in3D) {
              draw_mann_3D(players[i].x, players[i].y, players[i].z, players[i].getPose(), players[i].getScale(), players[i].getColor());//draw the players in 3D
              fill(255);
              textSize(15*Scale);
              textAlign(CENTER, CENTER);
              translate(0, 0, players[i].z);
              text(players[i].name, (players[i].getX()), (players[i].getY()-85));
              translate(0, 0, -players[i].z);
            } else {
              draw_mann((players[i].getX()), (players[i].getY()), players[i].getPose(), players[i].getScale(), players[i].getColor());//draw the outher players in 2D
              fill(255);
              textSize(15);
              textAlign(CENTER, CENTER);
              text(players[i].name, players[i].getX(), players[i].getY()-85);
            }
          }
        }

      draw_mann_3D(players[currentPlayer].x, players[currentPlayer].y, players[currentPlayer].z, players[currentPlayer].getPose(), players[currentPlayer].getScale(), players[currentPlayer].getColor());//draw the player
      players[currentPlayer].stage=currentStageIndex;

      if (shadow3D) {//if the 3D shadow is enabled
        float shadowAltitude=players[currentPlayer].y;
        boolean shadowHit=false;
        for (int i=0; i<500&&!shadowHit; i++) {//ray cast to find solid ground underneath the player
          if (level_colide(players[currentPlayer].x, shadowAltitude+i, players[currentPlayer].z)) {
            shadowAltitude+=i;
            shadowHit=true;
            continue;
          }
        }
        if (shadowHit) {//if solid ground was found under the player then draw the shadow
          translate(players[currentPlayer].x, shadowAltitude-1.1, players[currentPlayer].z);
          fill(0, 127);
          rotateX(radians(90));
          ellipse(0, 0, 40, 40);
          rotateX(radians(-90));
          translate(-players[currentPlayer].x, -(shadowAltitude-1), -players[currentPlayer].z);
        }
      }
    } else {//redner the level in 2D
    SPressed=false;
    WPressed=false;
      camera();//reset the camera
      drawCamPosX=camPos;//versions of the camera position variblaes that only get updated once every frame and not on every physics tick
      drawCamPosY=camPosY;
      for (int i=0; stageLoopCondishen(i, stage); i++) {//loop through all elements in the stage
        strokeWeight(0);
        noStroke();
        if (selectIndex==i) {//if the current element is the element the mouse is hovering over while the selection tool is active
          stroke(#FFFF00);//give that element a blue border
          strokeWeight(2);
        }
        if (selectedIndex==i) {//if the current element is the element that has been selected
          stroke(#0A03FF);//give that element a yellow border
          strokeWeight(2);
        }
        stage.parts.get(i).draw();//draw the element
        if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
          viewingItemIndex=i;//set the cuurent viewing item to this element
        }
      }

      players[currentPlayer].in3D=false;
      if (clients.size()>0)
        for (int i=currentNumberOfPlayers-1; i>=0; i--) {
          if (i==currentPlayer)
            continue;
          if (players[i].stage==currentStageIndex&&!players[i].in3D&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
            draw_mann(Scale*(players[i].getX()-camPos), Scale*(players[i].getY()+camPosY), players[i].getPose(), Scale*players[i].getScale(), players[i].getColor());//draw the outher players
            fill(255);
            textSize(15*Scale);
            textAlign(CENTER, CENTER);
            text(players[i].name, Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY-Scale*85));
          }
        }
      draw_mann(Scale*(players[currentPlayer].getX()-camPos), Scale*(players[currentPlayer].getY()+camPosY), players[currentPlayer].getPose(), Scale*players[currentPlayer].getScale(), players[currentPlayer].getColor());//draw the player
      players[currentPlayer].stage=currentStageIndex;
    }
  }


  if (level_complete) {//if the level has been completed
    fill(255, 255, 0);
    lebelCompleteText.draw();
    if (level.multyplayerMode!=2||isHost) {
      endOfLevelButton.draw();
    }
    clearTime = millis()-startTime;
    if(leaderBoards.checkScore(level.name,formatMillis(clearTime).replaceAll("\\.",":"))){
      populateLeaderBoardVisual();
      highScoreName.setText("");
      inGame=false;
      menue=true;
      Menue="high score";
    }else{
      populateLeaderBoardVisual();
      levelCompleteLevelName.setText(level.name);
      yourScore.setText("Your Time:  "+formatMillis(clearTime).replaceAll("\\.",":"));
      inGame=false;
      menue=true;
      Menue="level complete";
    }
    
  }

  if (viewingItemContents) {//if viewing the contence of an element
    engageHUDPosition();//engage the HUD position in case of 3D mode to make shure it renders on top
    StageComponent item = level.stages.get(currentStageIndex).parts.get(viewingItemIndex);
    if (item.type.equals("WritableSign")) {//if your are reeding a sign then show the contents of the sign
      fill(#A54A00);
      rect(width*0.05, height*0.05, width*0.9, height*0.9);//background of the sign
      fill(#C4C4C4);
      rect(width*0.1, height*0.1, width*0.8, height*0.8);//"paper" of the sign
      textAlign(CENTER, CENTER);
      textSize(50*Scale);
      fill(0);
      text(item.getData(), width/2, height/2);//the text of the sign
      textSize(20*Scale);
      text("press E to continue", width/2, height*0.85);
      displayTextUntill=millis()-1;//make shure that "Press R" is not displayed on the screen while in the sign
    }
    disEngageHUDPosition();//rest the hud condishen
  }
}
/**draws all the elements of a blueprint
 
 */
void blueprintEditDraw() {
  int selectIndex=-1;
  if (selecting) {//if you are currently using the selection tool
    selectIndex=colid_index(mouseX+camPos, mouseY-camPosY, workingBlueprint);//figure out what eleiment you are hovering over
  }
  if (workingBlueprint.type.equals("blueprint")) {//if the type is a normalk blueprint
    e3DMode=false;//turn 3D mode off
    camera();//reset the camera
    drawCamPosX=camPos;//camera positions used for drawing that only gets updted once every fram instead of evcery physics tick
    drawCamPosY=camPosY;
    for (int i=0; stageLoopCondishen(i, workingBlueprint); i++) {//loop through all elements in the blueprint
      strokeWeight(0);
      noStroke();
      if (selectIndex==i) {//blue selection highlighting
        stroke(#FFFF00);
        strokeWeight(2);
      }
      if (selectedIndex==i) {//yellow selection highlighting
        stroke(#0A03FF);
        strokeWeight(2);
      }
      workingBlueprint.parts.get(i).draw();//draw sll the elements in the blueprint
      if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
        viewingItemIndex=i;//set the cuurent viewing item to this element
      }
    }
  }
}

void camera3DpositionSimulating() {
  cam3Dx=players[currentPlayer].x;
  cam3Dy=players[currentPlayer].y;
  cam3Dz=players[currentPlayer].z;
  if (cam_left) {
    xangle+=2;
    if (xangle>240)
      xangle=240;
  }
  if (cam_right) {
    xangle-=2;
    if (xangle<190)
      xangle=190;
  }
  if (cam_up) {
    yangle+=1;
    if (yangle>=30)
      yangle=30;
  }
  if (cam_down) {
    yangle-=1;
    if (yangle<10)
      yangle=10;
  }
  //xangle=205;
  //yangle=15;
  DY=sin(radians(yangle))*dist;
  hd=cos(radians(yangle))*dist;
  DX=sin(radians(xangle))*hd;
  DZ=cos(radians(xangle))*hd;
}

void camera3DpositionNotSimulating() {
  if (space3D) {
    cam3Dy-=20;
  }
  if (shift3D) {
    cam3Dy+=20;
  }
  if (w3D) {
    cam3Dx+=20*sin(radians(-xangle));
    cam3Dz+=20*cos(radians(-xangle));
  }
  if (s3D) {
    cam3Dx-=20*sin(radians(-xangle));
    cam3Dz-=20*cos(radians(-xangle));
  }
  if (a3D) {
    cam3Dx+=20*cos(radians(xangle));
    cam3Dz+=20*sin(radians(xangle));
  }
  if (d3D) {
    cam3Dx-=20*cos(radians(xangle));
    cam3Dz-=20*sin(radians(xangle));
  }


  if (cam_left) {
    xangle+=2;
  }
  if (cam_right) {
    xangle-=2;
  }
  if (cam_up) {
    yangle+=1;
    if (yangle>=90)
      yangle=89;
  }
  if (cam_down) {
    yangle-=1;
    if (yangle<0)
      yangle=0;
  }
  DY=sin(radians(yangle))*dist;
  hd=cos(radians(yangle))*dist;
  DX=sin(radians(xangle))*hd;
  DZ=cos(radians(xangle))*hd;
}
//////////////////////////////////////////-----------------------------------------------------



void playerPhysics() {
  int calcingPlayer = currentPlayer;

  if (viewingItemContents) {//stop movment while intertacting with an object
    player1_moving_right=false;
    player1_moving_left=false;
    player1_jumping=false;
    WPressed=false;
    SPressed=false;
  }

  if (!e3DMode) {
    if (simulating||!levelCreator) {
      if (player1_moving_right) {//move the player right
        float newpos=players[calcingPlayer].getX()+mspc*0.4;//calculate new position
        if (!level_colide(newpos+10, players[calcingPlayer].getY())) {//check if the player can walk up "stairs"
          if (!level_colide(newpos+10, players[calcingPlayer].getY()-25)) {//check if there is something blocking the player 25 from his feet
            if (!level_colide(newpos+10, players[calcingPlayer].getY()-50)) {//check if there is something blocking the player 50 from his feet
              if (!level_colide(newpos+10, players[calcingPlayer].getY()-75)) {//check if there is something blocking the player 75 from his feet
                players[calcingPlayer].setX(newpos);//move the player if all is good
              }
            }
          }
        } else if ((!level_colide(newpos+10, players[calcingPlayer].getY()-10)&&!level_colide(newpos+10, players[calcingPlayer].getY()-50)&&!level_colide(newpos+10, players[calcingPlayer].getY()-75))&&players[calcingPlayer].verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
          if (!level_colide(newpos+10, players[calcingPlayer].getY()-1)) {//autojump move the player up if they could concivaly go up a stair
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-2)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-2);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-3)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-3);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-4)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-4);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-5)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-5);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-6)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-6);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-7)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-7);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-8)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-8);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-9)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-9);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-10)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-10);
          }
        }

        if (players[calcingPlayer].getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
          players[calcingPlayer].setPose(players[calcingPlayer].getPose()+1);
          players[calcingPlayer].setAnimationCooldown(4);
          if (players[calcingPlayer].getPose()==13) {
            players[calcingPlayer].setPose(1);
          }
        } else {
          players[calcingPlayer].setAnimationCooldown(players[calcingPlayer].getAnimationCooldown()-0.05*mspc);//animation cooldown
        }
      }

      if (player1_moving_left) {//player moving left
        float newpos=players[calcingPlayer].getX()-mspc*0.4;//calculte new position
        if (!level_colide(newpos-10, players[calcingPlayer].getY())) {//check if the player can walk up "stairs"
          if (!level_colide(newpos-10, players[calcingPlayer].getY()-25)) {//check if there is something blocking the player 25 from his feet
            if (!level_colide(newpos-10, players[calcingPlayer].getY()-50)) {//check if there is something blocking the player 50 from his feet
              if (!level_colide(newpos-10, players[calcingPlayer].getY()-75)) {//check if there is something blocking the player 75 from his feet
                players[calcingPlayer].setX(newpos);//move the player
              }
            }
          }
        } else if ((!level_colide(newpos-10, players[calcingPlayer].getY()-10)&&!level_colide(newpos-10, players[calcingPlayer].getY()-50)&&!level_colide(newpos-10, players[calcingPlayer].getY()-75))&&players[calcingPlayer].verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
          if (!level_colide(newpos+10, players[calcingPlayer].getY()-1)) {//autojump move the player up if they could concivaly go up a stair
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-2)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-2);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-3)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-3);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-4)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-4);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-5)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-5);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-6)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-6);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-7)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-7);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-8)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-8);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-9)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-9);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-10)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-10);
          }
        }

        if (players[calcingPlayer].getAnimationCooldown()<=0) {//change the player pose to make them look lie there walking
          players[calcingPlayer].setPose(players[calcingPlayer].getPose()-1);
          players[calcingPlayer].setAnimationCooldown(4);
          if (players[calcingPlayer].getPose()==0) {
            players[calcingPlayer].setPose(12);
          }
        } else {
          players[calcingPlayer].setAnimationCooldown(players[calcingPlayer].getAnimationCooldown()-0.05*mspc);//animation cooldown
        }
      }

      if (!player1_moving_right&&!player1_moving_left) {//reset the player pose if the player is not moving
        players[calcingPlayer].setPose(1);
        players[calcingPlayer].setAnimationCooldown(4);
      }
    }

    if (simulating||!levelCreator)
      if (true) {//gravity
        float pd = (players[calcingPlayer].verticalVelocity*mspc+0.5*gravity*(float)Math.pow(mspc, 2))+players[calcingPlayer].y;//calculate the new verticle position the player shoud be at

        if ((!level_colide(players[calcingPlayer].getX()-10, pd)&&!level_colide(players[calcingPlayer].getX()-5, pd)&&!level_colide(players[calcingPlayer].getX(), pd)&&!level_colide(players[calcingPlayer].getX()+5, pd)&&!level_colide(players[calcingPlayer].getX()+10, pd))) {//check if that location would be inside of the ground
          if ((!level_colide(players[calcingPlayer].getX()-10, pd-75-1)&&!level_colide(players[calcingPlayer].getX()-5, pd-75-1)&&!level_colide(players[calcingPlayer].getX(), pd-75-1)&&!level_colide(players[calcingPlayer].getX()+5, pd-75-1)&&!level_colide(players[calcingPlayer].getX()+10, pd-75-1))||players[calcingPlayer].verticalVelocity>0.001) {//check if that location would cause the player's head to be indide of something
            players[calcingPlayer].verticalVelocity=players[calcingPlayer].verticalVelocity+gravity*mspc;//calculate the players new verticle velocity
            players[calcingPlayer].y=pd;//update the postiton of the player
          } else {
            players[calcingPlayer].verticalVelocity=0;//stop the player's verticle motion
          }
        } else {
          players[calcingPlayer].verticalVelocity=0;//stop the player's verticle motion
        }
      }


    //death plane
    if (player_kill(players[calcingPlayer].getX()-10, players[calcingPlayer].getY()+1)||player_kill(players[calcingPlayer].getX()-5, players[calcingPlayer].getY()+1)||player_kill(players[calcingPlayer].getX(), players[calcingPlayer].getY()+1)||player_kill(players[calcingPlayer].getX()+5, players[calcingPlayer].getY()+1)||player_kill(players[calcingPlayer].getX()+10, players[calcingPlayer].getY()+1)) {//if the player is on top of a death plane
      dead=true;//kill the player
      death_cool_down=0;
    }

    //in ground detection and rectification
    if (!(!level_colide(players[calcingPlayer].getX()-10, players[calcingPlayer].getY())&&!level_colide(players[calcingPlayer].getX()-5, players[calcingPlayer].getY())&&!level_colide(players[calcingPlayer].getX(), players[calcingPlayer].getY())&&!level_colide(players[calcingPlayer].getX()+5, players[calcingPlayer].getY())&&!level_colide(players[calcingPlayer].getX()+10, players[calcingPlayer].getY()))) {//check if the player's position is in the ground
      players[calcingPlayer].setY(players[calcingPlayer].getY()-1);//move the player up
      players[calcingPlayer].verticalVelocity=0;//stop verticle veloicty
    }


    if (player1_jumping) {//jumping
      if (!(!level_colide(players[calcingPlayer].getX()-10, players[calcingPlayer].getY()+2)&&!level_colide(players[calcingPlayer].getX()-5, players[calcingPlayer].getY()+2)&&!level_colide(players[calcingPlayer].getX(), players[calcingPlayer].getY()+2)&&!level_colide(players[calcingPlayer].getX()+5, players[calcingPlayer].getY()+2)&&!level_colide(players[calcingPlayer].getX()+10, players[calcingPlayer].getY()+2))) {//check if the player is on the ground
        players[calcingPlayer].verticalVelocity=-0.75;  //if the player is on the ground and they are trying to jump then set thire verticle velocity
      }
    } else if (players[calcingPlayer].verticalVelocity<0) {//if the player stops pressing space bar before they stop riseing then start moving the player down
      players[calcingPlayer].verticalVelocity=0.01;
    }


    if (simulating||!levelCreator)
      if (players[calcingPlayer].getX()-camPos>(1280-eadgeScroleDist)) {//move the camera if the player goes too close to the end of the screen
        camPos=(int)(players[calcingPlayer].getX()-(1280-eadgeScroleDist));
      }

    if (simulating||!levelCreator)
      if (players[calcingPlayer].getX()-camPos<eadgeScroleDist&&camPos>0) {//move the camera if the player goes too close to the end of the screen
        camPos=(int)(players[calcingPlayer].getX()-eadgeScroleDist);
      }

    if (simulating||!levelCreator)
      if (players[calcingPlayer].getY()+camPosY>720-eadgeScroleDistV&&camPosY>0) {//move the camera if the player goes too close to the end of the screen
        camPosY-=players[calcingPlayer].getY()+camPosY-(720-eadgeScroleDistV);
      }

    if (simulating||!levelCreator)
      if (players[calcingPlayer].getY()+camPosY<eadgeScroleDistV+75) {//move the camera if the player goes too close to the end of the screen
        camPosY-=players[calcingPlayer].getY()+camPosY-(eadgeScroleDistV+75);
      }
    if (camPos<0)//prevent the camera from moving out of the valid areia
      camPos=0;
    if (camPosY<0)
      camPosY=0;
  } else {//end of not 3D mode

    if (simulating||!levelCreator) {
      if (player1_moving_right) {//move the player right
        float newpos=players[calcingPlayer].getX()+mspc*0.4;//calculate new position

        if (!level_colide(newpos+10, players[calcingPlayer].getY(), players[calcingPlayer].z-7)&&!level_colide(newpos+10, players[calcingPlayer].getY(), players[calcingPlayer].z+7)) {//check if the player can walk up "stairs"
          if (!level_colide(newpos+10, players[calcingPlayer].getY()-25, players[calcingPlayer].z-7)&&!level_colide(newpos+10, players[calcingPlayer].getY()-25, players[calcingPlayer].z+7)) {//check if there is something blocking the player 25 from his feet
            if (!level_colide(newpos+10, players[calcingPlayer].getY()-50, players[calcingPlayer].z-7)&&!level_colide(newpos+10, players[calcingPlayer].getY()-50, players[calcingPlayer].z+7)) {//check if there is something blocking the player 50 from his feet
              if (!level_colide(newpos+10, players[calcingPlayer].getY()-75, players[calcingPlayer].z-7)&&!level_colide(newpos+10, players[calcingPlayer].getY()-75, players[calcingPlayer].z+7)) {//check if there is something blocking the player 75 from his feet
                players[calcingPlayer].setX(newpos);//move the player
              }
            }
          }
        } else if ((!level_colide(newpos+10, players[calcingPlayer].getY()-10, players[calcingPlayer].z)&&!level_colide(newpos+10, players[calcingPlayer].getY()-50, players[calcingPlayer].z)&&!level_colide(newpos+10, players[calcingPlayer].getY()-75, players[calcingPlayer].z))&&players[calcingPlayer].verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
          if (!level_colide(newpos+10, players[calcingPlayer].getY()-1, players[calcingPlayer].z)) {//autojump move the player up if they could concivaly go up a stair
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-2, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-2);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-3, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-3);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-4, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-4);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-5, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-5);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-6, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-6);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-7, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-7);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-8, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-8);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-9, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-9);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-10, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-10);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-11, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-11);
          }
        }

        if (players[calcingPlayer].getAnimationCooldown()<=0) {//chmage the player pose to make them look like there waljking
          players[calcingPlayer].setPose(players[calcingPlayer].getPose()+1);
          players[calcingPlayer].setAnimationCooldown(4);
          if (players[calcingPlayer].getPose()==13) {
            players[calcingPlayer].setPose(1);
          }
        } else {
          players[calcingPlayer].setAnimationCooldown(players[calcingPlayer].getAnimationCooldown()-0.05*mspc);//animation cooldown
        }
      }

      if (player1_moving_left) {//player moving left
        float newpos=players[calcingPlayer].getX()-mspc*0.4;//calculate new position
        if (!level_colide(newpos-10, players[calcingPlayer].getY(), players[calcingPlayer].z-7)&&!level_colide(newpos-10, players[calcingPlayer].getY(), players[calcingPlayer].z+7)) {//check if the player can walk up "stairs"
          if (!level_colide(newpos-10, players[calcingPlayer].getY()-25, players[calcingPlayer].z-7)&&!level_colide(newpos-10, players[calcingPlayer].getY()-25, players[calcingPlayer].z+7)) {//check if there is something blocking the player 25 from his feet
            if (!level_colide(newpos-10, players[calcingPlayer].getY()-50, players[calcingPlayer].z-7)&&!level_colide(newpos-10, players[calcingPlayer].getY()-50, players[calcingPlayer].z+7)) {//check if there is something blocking the player 50 from his feet
              if (!level_colide(newpos-10, players[calcingPlayer].getY()-75, players[calcingPlayer].z-7)&&!level_colide(newpos-10, players[calcingPlayer].getY()-75, players[calcingPlayer].z+7)) {//check if there is something blocking the player 75 from his feet
                players[calcingPlayer].setX(newpos);//move the player
              }
            }
          }
        } else if ((!level_colide(newpos-10, players[calcingPlayer].getY()-10, players[calcingPlayer].z)&&!level_colide(newpos-10, players[calcingPlayer].getY()-50, players[calcingPlayer].z)&&!level_colide(newpos-10, players[calcingPlayer].getY()-75, players[calcingPlayer].z))&&players[calcingPlayer].verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
          if (!level_colide(newpos+10, players[calcingPlayer].getY()-1, players[calcingPlayer].z)) {//autojump move the player up if they could concivaly go up a stair
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-2, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-2);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-3, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-3);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-4, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-4);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-5, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-5);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-6, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-6);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-7, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-7);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-8, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-8);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-9, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-9);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-10, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-10);
          } else if (!level_colide(newpos-10, players[calcingPlayer].getY()-11, players[calcingPlayer].z)) {
            players[calcingPlayer].setX(newpos);
            players[calcingPlayer].setY(players[calcingPlayer].getY()-11);
          }
        }

        if (players[calcingPlayer].getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
          players[calcingPlayer].setPose(players[calcingPlayer].getPose()-1);
          players[calcingPlayer].setAnimationCooldown(4);
          if (players[calcingPlayer].getPose()==0) {
            players[calcingPlayer].setPose(12);
          }
        } else {
          players[calcingPlayer].setAnimationCooldown(players[calcingPlayer].getAnimationCooldown()-0.05*mspc);//animation cooldown
        }
      }

      if (WPressed) {
        float newpos=players[calcingPlayer].z-mspc*0.4;//calculate new position
        if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY(), newpos-10)) {//check if the player can walk up "stairs"
          if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-25, newpos-10)) {//check if there is something blocking the player 25 from his feet
            if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-50, newpos-10)) {//check if there is something blocking the player 50 from his feet
              if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-75, newpos-10)) {//check if there is something blocking the player 75 from his feet
                players[calcingPlayer].z=newpos;//move the player
              }
            }
          }
        } else if ((!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-10, newpos-10)&&!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-50, newpos-10)&&!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-75, newpos-10))&&players[calcingPlayer].verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
          if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-1, newpos-10)) {//autojump move the player up if they could concivaly go up a stair
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-2, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-2);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-3, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-3);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-4, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-4);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-5, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-5);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-6, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-6);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-7, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-7);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-8, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-8);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-9, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-9);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-10, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-10);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-11, newpos-10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-11);
          }
        }

        if (players[calcingPlayer].getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
          players[calcingPlayer].setPose(players[calcingPlayer].getPose()-1);
          players[calcingPlayer].setAnimationCooldown(4);
          if (players[calcingPlayer].getPose()==0) {
            players[calcingPlayer].setPose(12);
          }
        } else {
          players[calcingPlayer].setAnimationCooldown(players[calcingPlayer].getAnimationCooldown()-0.05*mspc);//animation cooldown
        }
      }

      if (SPressed) {
        float newpos=players[calcingPlayer].z+mspc*0.4;//calculate new position
        if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY(), newpos+10)) {//check if the player can walk up "stairs"
          if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-25, newpos+10)) {//check if there is something blocking the player 25 from his feet
            if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-50, newpos+10)) {//check if there is something blocking the player 50 from his feet
              if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-75, newpos+10)) {//check if there is something blocking the player 75 from his feet
                players[calcingPlayer].z=newpos;//move the player
              }
            }
          }
        } else if ((!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-10, newpos+10)&&!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-50, newpos+10)&&!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-75, newpos+10))&&players[calcingPlayer].verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
          if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-1, newpos-10)) {//autojump move the player up if they could concivaly go up a stair
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-2, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-2);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-3, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-3);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-4, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-4);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-5, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-5);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-6, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-6);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-7, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-7);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-8, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-8);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-9, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-9);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-10, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-10);
          } else if (!level_colide(players[calcingPlayer].x, players[calcingPlayer].getY()-11, newpos+10)) {
            players[calcingPlayer].z=newpos;
            players[calcingPlayer].setY(players[calcingPlayer].getY()-11);
          }
        }

        if (players[calcingPlayer].getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
          players[calcingPlayer].setPose(players[calcingPlayer].getPose()-1);
          players[calcingPlayer].setAnimationCooldown(4);
          if (players[calcingPlayer].getPose()==0) {
            players[calcingPlayer].setPose(12);
          }
        } else {
          players[calcingPlayer].setAnimationCooldown(players[calcingPlayer].getAnimationCooldown()-0.05*mspc);//animation cooldown
        }
      }

      if (!player1_moving_right&&!player1_moving_left&&!WPressed&&!SPressed) {//reset the player pose if the player is not moving
        players[calcingPlayer].setPose(1);
        players[calcingPlayer].setAnimationCooldown(4);
      }
    }


    if (simulating||!levelCreator)
      if (true) {//gravity
        float pd = (players[calcingPlayer].verticalVelocity*mspc+0.5*gravity*(float)Math.pow(mspc, 2))+players[calcingPlayer].y;//calculate the new verticle position the player shoud be at

        if (!level_colide(players[calcingPlayer].getX(), pd, players[calcingPlayer].z+7)&&!level_colide(players[calcingPlayer].getX(), pd, players[calcingPlayer].z-7)) {//check if that location would be inside of the ground
          if ((!level_colide(players[calcingPlayer].getX()-10, pd-75-1, players[calcingPlayer].z)&&!level_colide(players[calcingPlayer].getX()-5, pd-75-1, players[calcingPlayer].z)&&!level_colide(players[calcingPlayer].getX(), pd-75-1, players[calcingPlayer].z)&&!level_colide(players[calcingPlayer].getX()+5, pd-75-1, players[calcingPlayer].z)&&!level_colide(players[calcingPlayer].getX()+10, pd-75-1, players[calcingPlayer].z))||players[calcingPlayer].verticalVelocity>0.001) {//check if that location would cause the player's head to be indide of something
            players[calcingPlayer].verticalVelocity=players[calcingPlayer].verticalVelocity+gravity*mspc;//calculate the new verticle velocity
            players[calcingPlayer].y=pd;//update position
          } else {
            players[calcingPlayer].verticalVelocity=0;//stop the player's verticle motion
          }
        } else {
          players[calcingPlayer].verticalVelocity=0;//stop the player's verticle motion
        }
      }

    //in ground detection and rectification
    if (!(!level_colide(players[calcingPlayer].getX(), players[calcingPlayer].getY(), players[calcingPlayer].z+7)&&!level_colide(players[calcingPlayer].getX(), players[calcingPlayer].getY(), players[calcingPlayer].z-7))) {
      players[calcingPlayer].setY(players[calcingPlayer].getY()-1);
      players[calcingPlayer].verticalVelocity=0;
    }

    if (player1_jumping) {//jumping
      if (!(!level_colide(players[calcingPlayer].getX(), players[calcingPlayer].y+2, players[calcingPlayer].z+7)&&!level_colide(players[calcingPlayer].getX(), players[calcingPlayer].y+2, players[calcingPlayer].z-7))) {//check if the player is standing on the ground
        players[calcingPlayer].verticalVelocity=-0.75;  //if the player is on the ground and they are trying to jump then set thire verticle velocity
      }
    } else if (players[calcingPlayer].verticalVelocity<0) {//if the player stops pressing space bar then start moving the player down
      players[calcingPlayer].verticalVelocity=0.01;
    }
  }//end of 3D mode
  if (players[calcingPlayer].getY()>720) {//kill the player if they go below the stage
    dead=true;
    death_cool_down=0;
  }

  if (dead) {//if the player is dead
    currentStageIndex=respawnStage;//go back to the stage they last checkpointed on
    stageIndex=respawnStage;

    players[calcingPlayer].setX(respawnX);//move the player back to their spawnpoint
    players[calcingPlayer].setY(respawnY);
    players[calcingPlayer].z=respawnZ;
  }
  if (setPlayerPosTo) {//move the player to a position that is wanted
    players[calcingPlayer].setX(tpCords[0]).setY(tpCords[1]);
    players[calcingPlayer].z=tpCords[2];
    setPlayerPosTo=false;
    players[calcingPlayer].verticalVelocity=0;
  }
  //////////////////////////////
  if ((!levelCreator && (level.multyplayerMode==1 || (level.multyplayerMode==2 && isHost))) || (levelCreator&&simulating)) {
    if (!logicTickingThread.isAlive()) {//if the ticking thread has stoped for some reason
      logicTickingThread=new LogicThread();
      logicTickingThread.shouldRun=true;//then start it
      logicTickingThread.start();
    }
  } else {
    if (logicTickingThread.isAlive()) {//if the ticking thread is running when we dont want it to be
      logicTickingThread.shouldRun=false;//then stop it
    }
  }
}
/**check if a point is inside of a solid object
 
 */
boolean level_colide(float x, float y) {
  Stage stage=level.stages.get(currentStageIndex);
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    if (stage.parts.get(i).colide(x, y, false)) {
      return true;
    }
  }



  return false;
}

/**check if a point is inside of a solid object IN 3D
 
 */
boolean level_colide(float x, float y, float z) {//3d collions
  Stage stage=level.stages.get(currentStageIndex);
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    if (stage.parts.get(i).colide(x, y, z, false)) {

      return true;
    }
  }
  return false;
}

/**check if the given point would kill they player
 
 */
boolean player_kill(float x, float y) {
  Stage stage=level.stages.get(currentStageIndex);
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    if (stage.parts.get(i).colideDethPlane(x, y)) {
      return true;
    }
  }

  return false;
}

/**the index of the element that the point is inside of
 
 */
int colid_index(float x, float y, Stage stage) {
  for (int i=stage.parts.size()-1; i>=0; i--) {
    if (stage.parts.get(i).colide(x, y, true)) {
      return i;
    }
  }
  return -1;
}

/**the index of the 3d element that the point is inside of
 
 */
int colid_index(float x, float y, float z, Stage stage) {
  for (int i=stage.parts.size()-1; i>=0; i--) {
    if (stage.parts.get(i).colide(x, y, z, true)) {
      return i;
    }
  }
  return -1;
}

/** wather the for loop drawing the stage shouold continue
 
 */
boolean stageLoopCondishen(int i, Stage stage) {
  if (!tutorialMode) {
    return i<stage.parts.size();
  } else {
    if (tutorialDrawLimit<stage.parts.size()) {
      return i<tutorialDrawLimit;
    } else {
      return i<stage.parts.size();
    }
  }
}

/**thread responcable for ticking the logic baord tick
 
 */
class LogicThread extends Thread {
  boolean shouldRun=true;
  int lastRun;
  LogicThread() {
    super("logic ticking thread");
  }
  void run() {
    lastRun=millis();
    while (shouldRun) {//whlie we want the logic board to be ticked
      if (millis()-lastRun>=20) {//once 20 millisecconds have passed seince the last tick
        //System.out.println(millis()-lastRun);
        lastRun=millis();//update the time of the last tick
        level.logicBoards.get(level.tickBoard).tick();//tick the logic board
        //activate world interaction on all stage components that require it
        for (int i=0; i<level.stages.size(); i++) {
          for (int j=0; j<level.stages.get(i).interactables.size(); j++) {
            level.stages.get(i).interactables.get(j).worldInteractions(i);
          }
        }
      }
    }
  }
}
