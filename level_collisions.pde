//===================================================================================
int xangle=25+180, yangle=15, dist=700;//camera presets
float DY=sin(radians(yangle))*dist, hd=cos(radians(yangle))*dist, DX=sin(radians(xangle))*hd, DZ=cos(radians(xangle))*hd;//camera rotation

void stageLevelDraw() {
  Stage stage=level.stages.get(currentStageIndex);
  background(stage.skyColor);
  int selectIndex=-1;
  if(selecting){
    selectIndex=colid_index(mouseX+camPos,mouseY-camPosY,stage);
  }
  if (E_pressed&&viewingItemContents) {
        E_pressed=false;
        viewingItemContents=false;
        viewingItemIndex=-1;
      }
  if (stage.type.equals("stage")) {
    e3DMode=false;
    camera();
    for (int i=0; stageLoopCondishen(i, stage); i++) {
      strokeWeight(0);
      noStroke();
      if(selectIndex==i){
       stroke(#FFFF00);
       strokeWeight(2);
      }
      if(selectedIndex==i){
       stroke(#0A03FF);
       strokeWeight(2);
      }
      stage.parts.get(i).draw();
      if(viewingItemContents&&viewingItemIndex==-1){
        viewingItemIndex=i;
      }
    }


    draw_mann(Scale*(player1.getX()-camPos), Scale*(player1.getY()+camPosY), player1.getPose(), Scale*player1.getScale(), player1.getColor());
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
  } else if (stage.type.equals("3Dstage")) {
    if (e3DMode) {//render the level in 3D
      camera(player1.x+DX, player1.y-DY, player1.z-DZ, player1.x, player1.y, player1.z, 0, 1, 0);
      directionalLight(255, 255, 255, 0.8, 1, -0.35);
      ambientLight(102, 102, 102);
      coinRotation+=3;
      if (coinRotation>360)
        coinRotation-=360;

      for (int i=0; stageLoopCondishen(i, stage); i++) {
        strokeWeight(0);
        noStroke();
        stage.parts.get(i).draw3D();
        if(viewingItemContents&&viewingItemIndex==-1){
        viewingItemIndex=i;
      }
      }

      draw_mann_3D(player1.x, player1.y, player1.z, player1.getPose(), player1.getScale(), player1.getColor());

      if (shadow3D) {
        float shadowAltitude=player1.y;
        boolean shadowHit=false;
        for (int i=0; i<500&&!shadowHit; i++) {//ray cast to find solid ground underneath the player
          if (level_colide(player1.x, shadowAltitude+i, player1.z)) {
            shadowAltitude+=i;
            shadowHit=true;
            continue;
          }
        }
        if (shadowHit) {//if solid ground was found under the player then draw the shadow
          translate(player1.x, shadowAltitude-1.1, player1.z);
          fill(0, 127);
          rotateX(radians(90));
          ellipse(0, 0, 40, 40);
          rotateX(radians(-90));
          translate(-player1.x, -(shadowAltitude-1), -player1.z);
        }
      }
    } else {//redner the level in 2D
      camera();
      for (int i=0; stageLoopCondishen(i, stage); i++) {
        strokeWeight(0);
       noStroke(); 
        if(selectIndex==i){
       stroke(#FFFF00);
       strokeWeight(2);
      }
      if(selectedIndex==i){
       stroke(#0A03FF);
       strokeWeight(2);
      }
        stage.parts.get(i).draw();
        
        if(viewingItemContents&&viewingItemIndex==-1){
          viewingItemIndex=i;
        }
      }
      draw_mann(Scale*(player1.getX()-camPos), Scale*(player1.getY()+camPosY), player1.getPose(), Scale*player1.getScale(), player1.getColor());
    }
  }


  if (level_complete) {
    textAlign(BOTTOM,LEFT);
    textSize(Scale*100);
    fill(255, 255, 0);
    text("LEVEL COMPLETE!!!", Scale*200, Scale*400);

    fill(255, 126, 0);
    stroke(255, 0, 0);
    strokeWeight(Scale*10);
    rect(Scale*550, Scale*450, Scale*200, Scale*40);
    fill(0);
    textSize(Scale*40);
    text("continue", Scale*565, Scale*480);
  }
  
  if(viewingItemContents){
   engageHUDPosition(); 
   StageComponent item = level.stages.get(currentStageIndex).parts.get(viewingItemIndex);
   if(item.type.equals("WritableSign")){//if your are reeding a sign then show the contents of the sign
     fill(#A54A00);
     rect(width*0.05,height*0.05,width*0.9,height*0.9);
     fill(#C4C4C4);
     rect(width*0.1,height*0.1,width*0.8,height*0.8);
     textAlign(CENTER,CENTER);
     textSize(50*Scale);
     fill(0);
     text(item.getData(),width/2,height/2);
     textSize(20*Scale);
     text("press E to continue",width/2,height*0.85);
     displayTextUntill=millis()-1;
   }
   disEngageHUDPosition();
  }
}

void blueprintEditDraw(){
  int selectIndex=-1;
  if(selecting){
    selectIndex=colid_index(mouseX+camPos,mouseY-camPosY,workingBlueprint);
  }
  if (workingBlueprint.type.equals("blueprint")) {
    e3DMode=false;
    camera();
    for (int i=0; stageLoopCondishen(i, workingBlueprint); i++) {
      strokeWeight(0);
      noStroke();
      if(selectIndex==i){
       stroke(#FFFF00);
       strokeWeight(2);
      }
      if(selectedIndex==i){
       stroke(#0A03FF);
       strokeWeight(2);
      }
      workingBlueprint.parts.get(i).draw();
      if(viewingItemContents&&viewingItemIndex==-1){
        viewingItemIndex=i;
      }
    }
  }
}
//////////////////////////////////////////-----------------------------------------------------



void playerPhysics() {

  if(viewingItemContents){//stop movment while intertacting with an object
    player1_moving_right=false;
    player1_moving_left=false;
    player1_jumping=false;
    WPressed=false;
    SPressed=false;
    
  }

  if (!e3DMode) {
    if (player1_moving_right) {//move the player right
      float newpos=player1.getX()+mspc*0.4;//calculate new position
      if (!level_colide(newpos+10, player1.getY())) {//check if the player can walk up "stairs"
        if (!level_colide(newpos+10, player1.getY()-25)) {
          if (!level_colide(newpos+10, player1.getY()-50)) {
            if (!level_colide(newpos+10, player1.getY()-75)) {
              player1.setX(newpos);
            }
          }
        }
      } else if ((!level_colide(newpos+10, player1.getY()-10)&&!level_colide(newpos+10, player1.getY()-50)&&!level_colide(newpos+10, player1.getY()-75))&&player1.verticalVelocity<0.008) {//check if the new posaition would place the player inside of a wall
        if (!level_colide(newpos+10, player1.getY()-1)) {//autojump
          player1.setX(newpos);
          player1.setY(player1.getY()-1);
        } else if (!level_colide(newpos-10, player1.getY()-2)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-2);
        } else if (!level_colide(newpos-10, player1.getY()-3)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-3);
        } else if (!level_colide(newpos-10, player1.getY()-4)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-4);
        } else if (!level_colide(newpos-10, player1.getY()-5)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-5);
        } else if (!level_colide(newpos-10, player1.getY()-6)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-6);
        } else if (!level_colide(newpos-10, player1.getY()-7)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-7);
        } else if (!level_colide(newpos-10, player1.getY()-8)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-8);
        } else if (!level_colide(newpos-10, player1.getY()-9)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-9);
        } else if (!level_colide(newpos-10, player1.getY()-10)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-10);
        }
      }

      if (player1.getAnimationCooldown()<=0) {//chmage the player pose to make them look like there waljking
        player1.setPose(player1.getPose()+1);
        player1.setAnimationCooldown(4);
        if (player1.getPose()==13) {
          player1.setPose(1);
        }
      } else {
        player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
      }
    }

    if (player1_moving_left) {//player moving left
      float newpos=player1.getX()-mspc*0.4;//calculte new position
      if (!level_colide(newpos-10, player1.getY())) {
        if (!level_colide(newpos-10, player1.getY()-25)) {
          if (!level_colide(newpos-10, player1.getY()-50)) {
            if (!level_colide(newpos-10, player1.getY()-75)) {
              player1.setX(newpos);
            }
          }
        }
      } else if ((!level_colide(newpos-10, player1.getY()-10)&&!level_colide(newpos-10, player1.getY()-50)&&!level_colide(newpos-10, player1.getY()-75))&&player1.verticalVelocity<0.008) {
        if (!level_colide(newpos+10, player1.getY()-1)) {//auto jump
          player1.setX(newpos);
          player1.setY(player1.getY()-1);
        } else if (!level_colide(newpos-10, player1.getY()-2)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-2);
        } else if (!level_colide(newpos-10, player1.getY()-3)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-3);
        } else if (!level_colide(newpos-10, player1.getY()-4)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-4);
        } else if (!level_colide(newpos-10, player1.getY()-5)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-5);
        } else if (!level_colide(newpos-10, player1.getY()-6)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-6);
        } else if (!level_colide(newpos-10, player1.getY()-7)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-7);
        } else if (!level_colide(newpos-10, player1.getY()-8)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-8);
        } else if (!level_colide(newpos-10, player1.getY()-9)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-9);
        } else if (!level_colide(newpos-10, player1.getY()-10)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-10);
        }
      }

      if (player1.getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
        player1.setPose(player1.getPose()-1);
        player1.setAnimationCooldown(4);
        if (player1.getPose()==0) {
          player1.setPose(12);
        }
      } else {
        player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
      }
    }

    if (!player1_moving_right&&!player1_moving_left) {//reset the player pose if the player is not moving
      player1.setPose(1);
      player1.setAnimationCooldown(4);
    }


    
      if (true) {//gravity
        float pd = (player1.verticalVelocity*mspc+0.5*gravity*(float)Math.pow(mspc, 2))+player1.y;//calculate the new verticle position the player shoud be at

        if ((!level_colide(player1.getX()-10, pd)&&!level_colide(player1.getX()-5, pd)&&!level_colide(player1.getX(), pd)&&!level_colide(player1.getX()+5, pd)&&!level_colide(player1.getX()+10, pd))) {//check if that location would be inside of the ground
          if ((!level_colide(player1.getX()-10, pd-75-1)&&!level_colide(player1.getX()-5, pd-75-1)&&!level_colide(player1.getX(), pd-75-1)&&!level_colide(player1.getX()+5, pd-75-1)&&!level_colide(player1.getX()+10, pd-75-1))||player1.verticalVelocity>0.001) {//check if that location would cause the player's head to be indide of something
            player1.verticalVelocity=player1.verticalVelocity+gravity*mspc;
            player1.y=pd;
          } else {
            player1.verticalVelocity=0;
          }
        } else {
          player1.verticalVelocity=0;
        }
      }


    //death plane
    if (player_kill(player1.getX()-10, player1.getY()+1)||player_kill(player1.getX()-5, player1.getY()+1)||player_kill(player1.getX(), player1.getY()+1)||player_kill(player1.getX()+5, player1.getY()+1)||player_kill(player1.getX()+10, player1.getY()+1)) {
      dead=true;
      death_cool_down=0;
    }

    //in ground detection and rectification
    if (!(!level_colide(player1.getX()-10, player1.getY())&&!level_colide(player1.getX()-5, player1.getY())&&!level_colide(player1.getX(), player1.getY())&&!level_colide(player1.getX()+5, player1.getY())&&!level_colide(player1.getX()+10, player1.getY()))) {
      player1.setY(player1.getY()-1);
      player1.verticalVelocity=0;
    }


    if (player1_jumping) {//jumping
      if (!(!level_colide(player1.getX()-10, player1.getY()+2)&&!level_colide(player1.getX()-5, player1.getY()+2)&&!level_colide(player1.getX(), player1.getY()+2)&&!level_colide(player1.getX()+5, player1.getY()+2)&&!level_colide(player1.getX()+10, player1.getY()+2))) {
        player1.verticalVelocity=-0.75;  //if the player is on the ground and they are trying to jump then set thire verticle velocity
      }
    } else if (player1.verticalVelocity<0) {//if the player stops pressing space bar then start moving the player down
      player1.verticalVelocity=0.01;
    }


    
      if (player1.getX()-camPos>(1280-eadgeScroleDist)) {
        camPos=(int)(player1.getX()-(1280-eadgeScroleDist));
      }

    
      if (player1.getX()-camPos<eadgeScroleDist&&camPos>0) {
        camPos=(int)(player1.getX()-eadgeScroleDist);
      }
    
      if (player1.getY()+camPosY>720-eadgeScroleDistV&&camPosY>0) {
        camPosY-=player1.getY()+camPosY-(720-eadgeScroleDistV);
      }
    
      if (player1.getY()+camPosY<eadgeScroleDistV+75) {
        camPosY-=player1.getY()+camPosY-(eadgeScroleDistV+75);
      }
    if (camPos<0)
      camPos=0;
    if (camPosY<0)
      camPosY=0;
  } else {//end of not 3D mode


    if (player1_moving_right) {//move the player right
      float newpos=player1.getX()+mspc*0.4;

      if (!level_colide(newpos+10, player1.getY(), player1.z-7)&&!level_colide(newpos+10, player1.getY(), player1.z+7)) {
        if (!level_colide(newpos+10, player1.getY()-25, player1.z-7)&&!level_colide(newpos+10, player1.getY()-25, player1.z+7)) {
          if (!level_colide(newpos+10, player1.getY()-50, player1.z-7)&&!level_colide(newpos+10, player1.getY()-50, player1.z+7)) {
            if (!level_colide(newpos+10, player1.getY()-75, player1.z-7)&&!level_colide(newpos+10, player1.getY()-75, player1.z+7)) {
              player1.setX(newpos);
            }
          }
        }
      } else if ((!level_colide(newpos+10, player1.getY()-10, player1.z)&&!level_colide(newpos+10, player1.getY()-50, player1.z)&&!level_colide(newpos+10, player1.getY()-75, player1.z))&&player1.verticalVelocity<0.008) {
        if (!level_colide(newpos+10, player1.getY()-1, player1.z)) {//autojump
          player1.setX(newpos);
          player1.setY(player1.getY()-1);
        } else if (!level_colide(newpos-10, player1.getY()-2, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-2);
        } else if (!level_colide(newpos-10, player1.getY()-3, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-3);
        } else if (!level_colide(newpos-10, player1.getY()-4, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-4);
        } else if (!level_colide(newpos-10, player1.getY()-5, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-5);
        } else if (!level_colide(newpos-10, player1.getY()-6, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-6);
        } else if (!level_colide(newpos-10, player1.getY()-7, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-7);
        } else if (!level_colide(newpos-10, player1.getY()-8, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-8);
        } else if (!level_colide(newpos-10, player1.getY()-9, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-9);
        } else if (!level_colide(newpos-10, player1.getY()-10, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-10);
        } else if (!level_colide(newpos-10, player1.getY()-11, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-11);
        }
      }

      if (player1.getAnimationCooldown()<=0) {//chmage the player pose to make them look like there waljking
        player1.setPose(player1.getPose()+1);
        player1.setAnimationCooldown(4);
        if (player1.getPose()==13) {
          player1.setPose(1);
        }
      } else {
        player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
      }
    }

    if (player1_moving_left) {//player moving left
      float newpos=player1.getX()-mspc*0.4;
      if (!level_colide(newpos-10, player1.getY(), player1.z-7)&&!level_colide(newpos-10, player1.getY(), player1.z+7)) {
        if (!level_colide(newpos-10, player1.getY()-25, player1.z-7)&&!level_colide(newpos-10, player1.getY()-25, player1.z+7)) {
          if (!level_colide(newpos-10, player1.getY()-50, player1.z-7)&&!level_colide(newpos-10, player1.getY()-50, player1.z+7)) {
            if (!level_colide(newpos-10, player1.getY()-75, player1.z-7)&&!level_colide(newpos-10, player1.getY()-75, player1.z+7)) {
              player1.setX(newpos);
            }
          }
        }
      } else if ((!level_colide(newpos-10, player1.getY()-10, player1.z)&&!level_colide(newpos-10, player1.getY()-50, player1.z)&&!level_colide(newpos-10, player1.getY()-75, player1.z))&&player1.verticalVelocity<0.008) {
        if (!level_colide(newpos+10, player1.getY()-1, player1.z)) {//auto jump
          player1.setX(newpos);
          player1.setY(player1.getY()-1);
        } else if (!level_colide(newpos-10, player1.getY()-2, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-2);
        } else if (!level_colide(newpos-10, player1.getY()-3, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-3);
        } else if (!level_colide(newpos-10, player1.getY()-4, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-4);
        } else if (!level_colide(newpos-10, player1.getY()-5, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-5);
        } else if (!level_colide(newpos-10, player1.getY()-6, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-6);
        } else if (!level_colide(newpos-10, player1.getY()-7, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-7);
        } else if (!level_colide(newpos-10, player1.getY()-8, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-8);
        } else if (!level_colide(newpos-10, player1.getY()-9, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-9);
        } else if (!level_colide(newpos-10, player1.getY()-10, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-10);
        } else if (!level_colide(newpos-10, player1.getY()-11, player1.z)) {
          player1.setX(newpos);
          player1.setY(player1.getY()-11);
        }
      }

      if (player1.getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
        player1.setPose(player1.getPose()-1);
        player1.setAnimationCooldown(4);
        if (player1.getPose()==0) {
          player1.setPose(12);
        }
      } else {
        player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
      }
    }

    if (WPressed) {
      float newpos=player1.z-mspc*0.4;
      if (!level_colide(player1.x, player1.getY(), newpos-10)) {
        if (!level_colide(player1.x, player1.getY()-25, newpos-10)) {
          if (!level_colide(player1.x, player1.getY()-50, newpos-10)) {
            if (!level_colide(player1.x, player1.getY()-75, newpos-10)) {
              player1.z=newpos;
            }
          }
        }
      } else if ((!level_colide(player1.x, player1.getY()-10, newpos-10)&&!level_colide(player1.x, player1.getY()-50, newpos-10)&&!level_colide(player1.x, player1.getY()-75, newpos-10))&&player1.verticalVelocity<0.008) {
        if (!level_colide(player1.x, player1.getY()-1, newpos-10)) {//auto jump
          player1.z=newpos;
          player1.setY(player1.getY()-1);
        } else if (!level_colide(player1.x, player1.getY()-2, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-2);
        } else if (!level_colide(player1.x, player1.getY()-3, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-3);
        } else if (!level_colide(player1.x, player1.getY()-4, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-4);
        } else if (!level_colide(player1.x, player1.getY()-5, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-5);
        } else if (!level_colide(player1.x, player1.getY()-6, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-6);
        } else if (!level_colide(player1.x, player1.getY()-7, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-7);
        } else if (!level_colide(player1.x, player1.getY()-8, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-8);
        } else if (!level_colide(player1.x, player1.getY()-9, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-9);
        } else if (!level_colide(player1.x, player1.getY()-10, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-10);
        } else if (!level_colide(player1.x, player1.getY()-11, newpos-10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-11);
        }
      }

      if (player1.getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
        player1.setPose(player1.getPose()-1);
        player1.setAnimationCooldown(4);
        if (player1.getPose()==0) {
          player1.setPose(12);
        }
      } else {
        player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
      }
    }

    if (SPressed) {
      float newpos=player1.z+mspc*0.4;
      if (!level_colide(player1.x, player1.getY(), newpos+10)) {
        if (!level_colide(player1.x, player1.getY()-25, newpos+10)) {
          if (!level_colide(player1.x, player1.getY()-50, newpos+10)) {
            if (!level_colide(player1.x, player1.getY()-75, newpos+10)) {
              player1.z=newpos;
            }
          }
        }
      } else if ((!level_colide(player1.x, player1.getY()-10, newpos+10)&&!level_colide(player1.x, player1.getY()-50, newpos+10)&&!level_colide(player1.x, player1.getY()-75, newpos+10))&&player1.verticalVelocity<0.008) {
        if (!level_colide(player1.x, player1.getY()-1, newpos-10)) {//auto jump
          player1.z=newpos;
          player1.setY(player1.getY()-1);
        } else if (!level_colide(player1.x, player1.getY()-2, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-2);
        } else if (!level_colide(player1.x, player1.getY()-3, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-3);
        } else if (!level_colide(player1.x, player1.getY()-4, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-4);
        } else if (!level_colide(player1.x, player1.getY()-5, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-5);
        } else if (!level_colide(player1.x, player1.getY()-6, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-6);
        } else if (!level_colide(player1.x, player1.getY()-7, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-7);
        } else if (!level_colide(player1.x, player1.getY()-8, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-8);
        } else if (!level_colide(player1.x, player1.getY()-9, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-9);
        } else if (!level_colide(player1.x, player1.getY()-10, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-10);
        } else if (!level_colide(player1.x, player1.getY()-11, newpos+10)) {
          player1.z=newpos;
          player1.setY(player1.getY()-11);
        }
      }

      if (player1.getAnimationCooldown()<=0) {//change the playerb pose to make them look lie there walking
        player1.setPose(player1.getPose()-1);
        player1.setAnimationCooldown(4);
        if (player1.getPose()==0) {
          player1.setPose(12);
        }
      } else {
        player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
      }
    }

    if (!player1_moving_right&&!player1_moving_left&&!WPressed&&!SPressed) {//reset the player pose if the player is not moving
      player1.setPose(1);
      player1.setAnimationCooldown(4);
    }


    

      if (true) {//gravity
        float pd = (player1.verticalVelocity*mspc+0.5*gravity*(float)Math.pow(mspc, 2))+player1.y;//calculate the new verticle position the player shoud be at

        if (!level_colide(player1.getX(), pd, player1.z+7)&&!level_colide(player1.getX(), pd, player1.z-7)) {//check if that location would be inside of the ground
          if ((!level_colide(player1.getX()-10, pd-75-1, player1.z)&&!level_colide(player1.getX()-5, pd-75-1, player1.z)&&!level_colide(player1.getX(), pd-75-1, player1.z)&&!level_colide(player1.getX()+5, pd-75-1, player1.z)&&!level_colide(player1.getX()+10, pd-75-1, player1.z))||player1.verticalVelocity>0.001) {//check if that location would cause the player's head to be indide of something
            player1.verticalVelocity=player1.verticalVelocity+gravity*mspc;
            player1.y=pd;
          } else {
            player1.verticalVelocity=0;
          }
        } else {
          player1.verticalVelocity=0;
        }
      }

    //in ground detection and rectification
    if (!(!level_colide(player1.getX(), player1.getY(), player1.z+7)&&!level_colide(player1.getX(), player1.getY(), player1.z-7))) {
      player1.setY(player1.getY()-1);
      player1.verticalVelocity=0;
    }

    if (player1_jumping) {//jumping
      if (!(!level_colide(player1.getX(), player1.y+2, player1.z+7)&&!level_colide(player1.getX(), player1.y+2, player1.z-7))) {
        player1.verticalVelocity=-0.75;  //if the player is on the ground and they are trying to jump then set thire verticle velocity
      }
    } else if (player1.verticalVelocity<0) {//if the player stops pressing space bar then start moving the player down
      player1.verticalVelocity=0.01;
    }
  }//end of 3D mode
  if (player1.getY()>720) {
    dead=true;
    death_cool_down=0;
  }

  if (dead) {
    //file_path=rootPath+mainIndex.getJSONObject(respawnStage).getString("location");
    //level_terain=loadJSONArray(file_path);
    currentStageIndex=respawnStage;
    stageIndex=respawnStage;

    player1.setX(respawnX);
    player1.setY(respawnY);
    if (checkpointIn3DStage) {
      player1.z=respawnZ;
    }
  }
  if (setPlayerPosTo) {
    player1.setX(tpCords[0]).setY(tpCords[1]);
    player1.z=tpCords[2];
    setPlayerPosTo=false;
    player1.verticalVelocity=0;
  }
  //////////////////////////////
}

boolean level_colide(float x, float y) {
  Stage stage=level.stages.get(currentStageIndex);
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    if (stage.parts.get(i).colide(x, y, false)) {
      return true;
    }
  }



  return false;
}

boolean level_colide(float x, float y, float z) {//3d collions
  Stage stage=level.stages.get(currentStageIndex);
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    if (stage.parts.get(i).colide(x, y, z)) {

      return true;
    }
  }
  return false;
}

boolean player_kill(float x, float y) {
  Stage stage=level.stages.get(currentStageIndex);
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    if (stage.parts.get(i).colideDethPlane(x, y)) {
      return true;
    }
  }

  return false;
}

int colid_index(float x, float y,Stage stage) {
  for (int i=stage.parts.size()-1; i>=0; i--) {
    if (stage.parts.get(i).colide(x, y, true)) {
      return i;
    }
  }
  return -1;
}

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
