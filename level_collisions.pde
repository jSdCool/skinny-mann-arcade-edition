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
  if (stage.type.equals("stage")) {//if the cuurent thing that is being drawn is a stage
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
      stage.parts.get(i).draw(g);//draw the element
      if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
        viewingItemIndex=i;//set the cuurent viewing item to this element
      }
    }
    noStroke();
    //render all the Entites on this stage
    for (int i=0; i<stage.entities.size(); i++) {
      if (!stage.entities.get(i).isDead())//if not dead
        stage.entities.get(i).draw(this, g);
    }
    players[currentPlayer].in3D=false;
    if (clients.size()>0)
      for (int i=currentNumberOfPlayers-1; i>=0; i--) {
        if (i==currentPlayer)
          continue;
        if (players[i].stage==currentStageIndex&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
          draw_mann(Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY), players[i].getPose(), Scale*players[i].getScale(), players[i].getColor(), g);//draw the outher players
          fill(255);
          textSize(15*Scale);
          textAlign(CENTER, CENTER);
          text(players[i].name, Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY-85));
        }
      }

    draw_mann(Scale*(players[currentPlayer].getX()-drawCamPosX), Scale*(players[currentPlayer].getY()+drawCamPosY), players[currentPlayer].getPose(), Scale*players[currentPlayer].getScale(), players[currentPlayer].getColor(), g);//draw this users player
    players[currentPlayer].stage=currentStageIndex;
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
    //====================================================================================================================================================================================================
  } else if (stage.type.equals("3Dstage")) {//if the stage is a 3D stage
    if (e3DMode) {//if 3D mode is turned on
      ArrayList<Collider3D> stageCollisions = generateLevel3DComboBox(stage);

      if ((simulating&&levelCreator)||!levelCreator)
        camera3DpositionSimulating(stageCollisions);
      else
        camera3DpositionNotSimulating();

      camera(cam3Dx+DX, cam3Dy-DY, cam3Dz-DZ, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);//set the camera
      directionalLight(255, 255, 255, 0.8, 1, -0.35);//set up the old lighting (for when shadows are old or off)
      ambientLight(102, 102, 102);
      perspective(settings.getFOV(),width*1.0/height,0.5,1048576);
      
      coinRotation+=3;//rotate the coins
      if (coinRotation>360)//reset the coin totation if  it is over 360 degrees
        coinRotation-=360;
      drawCamPosX=camPos;//versions of the camera position variblaes that only get updated once every frame and not on every physics tick
      drawCamPosY=camPosY;


      players[currentPlayer].in3D=true;

      players[currentPlayer].stage=currentStageIndex;
      
      float ppx =  players[currentPlayer].getX(), ppy =  players[currentPlayer].getY(), ppz = players[currentPlayer].getZ();
      int ppp =  players[currentPlayer].getPose();
      float pps =  players[currentPlayer].getScale();
      int ppc =  players[currentPlayer].getColor();

      //if proper shadows are enabled
      if ( settings.getShadows() > 1) {
        shadowMap.beginDraw();
        shadowMap.camera(cam3Dx+lightDir.x, cam3Dy+lightDir.y, cam3Dz+lightDir.z, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);
        shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
        //render to the depth buffer
        render3DLevel(shadowMap, stage,ppx,ppy,ppz,ppp,pps,ppc);
        shadowMap.endDraw();
        //shadowMap.updatePixels();


        shader(shadowShader);
        perepLightingPass();
      }
      render3DLevel(g, stage,ppx,ppy,ppz,ppp,pps,ppc);

      if ( settings.getShadows() > 1) {
        resetShader();
      }

      if (settings.getShadows() == 1) {//if the 3D shadow is enabled
        float shadowAltitude=players[currentPlayer].y;
        boolean shadowHit=false;
        for (int i=0; i<500&&!shadowHit; i++) {//ray cast to find solid ground underneath the player
          Collider3D groundDetect = players[currentPlayer].getHitBox3D(0, i, 0);
          if (level_colide(groundDetect, stageCollisions)) {
            shadowAltitude+=i-1;
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
          translate(-players[currentPlayer].x, -(shadowAltitude-2), -players[currentPlayer].z);
        }
      }
      //prespecitve is reset in the main draw function acter all stage drawings have finished
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
        stage.parts.get(i).draw(g);//draw the element
        if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
          viewingItemIndex=i;//set the cuurent viewing item to this element
        }
      }

      //render all the Entites on this stage
      //TODO: respect wether the entoity is renderd in 3D or not
      noStroke();
      for (int i=0; i<stage.entities.size(); i++) {
        stage.entities.get(i).draw(this, g);
      }

      players[currentPlayer].in3D=false;
      if (clients.size()>0)
        for (int i=currentNumberOfPlayers-1; i>=0; i--) {
          if (i==currentPlayer)
            continue;
          if (players[i].stage==currentStageIndex&&!players[i].in3D&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
            draw_mann(Scale*(players[i].getX()-camPos), Scale*(players[i].getY()+camPosY), players[i].getPose(), Scale*players[i].getScale(), players[i].getColor(), g);//draw the outher players
            fill(255);
            textSize(15*Scale);
            textAlign(CENTER, CENTER);
            text(players[i].name, Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY-Scale*85));
          }
        }
      draw_mann(Scale*(players[currentPlayer].getX()-camPos), Scale*(players[currentPlayer].getY()+camPosY), players[currentPlayer].getPose(), Scale*players[currentPlayer].getScale(), players[currentPlayer].getColor(), g);//draw the player
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

    if(level.levelID==-1){
      inGame=false;
      menue=true;
      Menue="level select";
    }else if(leaderBoards.checkScore(level.name,formatMillis(clearTime).replaceAll("\\.",":"))){
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
      text("press B to continue", width/2, height*0.85);
      displayTextUntill=millis()-1;//make shure that "Press R" is not displayed on the screen while in the sign
    }
    disEngageHUDPosition();//rest the hud condishen
  }
}

void render3DLevel(PGraphics render, Stage stage,float playerX,float playerY, float playerZ,int playerPose,float playerScale,int playerColor) {
  for (int i=0; stageLoopCondishen(i, stage); i++) {//loop through all elements in the stage
    render.strokeWeight(0);
    render.noStroke();
    if (selectedIndex==i) {//if the current element is the element the mouse is hovering over while the selection tool is active
      render.stroke(#FFFF00);//give that element a blue border
      render.strokeWeight(2);
    }
    stage.parts.get(i).draw3D(render);//draw the element in 3D
    if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
      viewingItemIndex=i;//set the cuurent viewing item to this element
    }
  }
  if (clients.size()>0)
    for (int i=currentNumberOfPlayers-1; i>=0; i--) {
      if (i==currentPlayer)
        continue;
      if (players[i].stage==currentStageIndex&&i!=currentPlayer&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
        if (players[i].in3D) {
          draw_mann_3D(players[i].x, players[i].y, players[i].z, players[i].getPose(), players[i].getScale(), players[i].getColor(), render);//draw the players in 3D
          render.fill(255);
          render.textSize(15*Scale);
          render.textAlign(CENTER, CENTER);
          render.translate(0, 0, players[i].z);
          render.text(players[i].name, (players[i].getX()), (players[i].getY()-85));
          render.translate(0, 0, -players[i].z);
        } else {
          draw_mann((players[i].getX()), (players[i].getY()), players[i].getPose(), players[i].getScale(), players[i].getColor(), render);//draw the outher players in 2D
          render.fill(255);
          render.textSize(15);
          render.textAlign(CENTER, CENTER);
          render.text(players[i].name, players[i].getX(), players[i].getY()-85);
        }
      }
    }

  draw_mann_3D(playerX, playerY, playerZ, playerPose, playerScale, playerColor, render);//draw the player

  //render all the Entites on this stage
  //TODO: respect wether the entoity is renderd in 3D or not
  render.noStroke();
  for (int i=0; i<stage.entities.size(); i++) {
    if (!stage.entities.get(i).isDead())//if not dead
      stage.entities.get(i).draw3D(this, render);
  }
}

void perepLightingPass() {
  int halfBuffer = shadowMap.width/2;
  //split the high res shadow map into serveal smaller ones
  subShadowMaps[0].beginDraw();
  subShadowMaps[0].image(/*shadowShaderOutputSampledDepthInfo? uvTester :*/ shadowMap, 0, 0);
  subShadowMaps[0].endDraw();
  subShadowMaps[1].beginDraw();
  subShadowMaps[1].image(/*shadowShaderOutputSampledDepthInfo? uvTester :*/ shadowMap, -halfBuffer, 0);
  subShadowMaps[1].endDraw();
  subShadowMaps[2].beginDraw();
  subShadowMaps[2].image(/*shadowShaderOutputSampledDepthInfo? uvTester :*/ shadowMap, -halfBuffer, -halfBuffer);
  subShadowMaps[2].endDraw();
  subShadowMaps[3].beginDraw();
  subShadowMaps[3].image(/*shadowShaderOutputSampledDepthInfo? uvTester :*/ shadowMap, 0, -halfBuffer);
  subShadowMaps[3].endDraw();

  // Bias matrix to move homogeneous shadowCoords into the UV texture space
  //TODO: make this an array
  PMatrix3D shadowTransform[] = new PMatrix3D[4];
  shadowTransform[0] = new PMatrix3D(
    0.5, 0.0, 0.0, 0.5,
    0.0, 0.5, 0.0, 0.5,
    0.0, 0.0, 0.5, 0.5,
    0.0, 0.0, 0.0, 1.0
  );
  shadowTransform[1] = new PMatrix3D(
    0.5, 0.0, 0.0, 0.5,
    0.0, 0.5, 0.0, 0.5,
    0.0, 0.0, 0.5, 0.5,
    0.0, 0.0, 0.0, 1.0
  );
  shadowTransform[2] = new PMatrix3D(
    0.5, 0.0, 0.0, 0.5,
    0.0, 0.5, 0.0, 0.5,
    0.0, 0.0, 0.5, 0.5,
    0.0, 0.0, 0.0, 1.0
  );
  shadowTransform[3] = new PMatrix3D(
    0.5, 0.0, 0.0, 0.5,
    0.0, 0.5, 0.0, 0.5,
    0.0, 0.0, 0.5, 0.5,
    0.0, 0.0, 0.0, 1.0
  );
  
  PMatrix3D oldShadowTransform= new PMatrix3D(
    0.5, 0.0, 0.0, 0.5,
    0.0, 0.5, 0.0, 0.5,
    0.0, 0.0, 0.5, 0.5,
    0.0, 0.0, 0.0, 1.0
  );
  //lightDir.set(-0.8, -1, 0.35);
  //lightDir.mult(800);
  
  
  PVector uve = new PVector(-0.8,0,0.35);
  PVector superNormalLight = PVector.div(lightDir,lightDir.magSq());
  
  //calculate the vecators for the supporting plane the camera is being moved in
  PVector v1 = PVector.sub(uve,PVector.mult(superNormalLight,PVector.dot(uve,lightDir)));
  v1.normalize();
  PVector v2 = PVector.cross(lightDir,v1,null);
  v2.normalize();
  
  //calculate the direction vectors
  PVector d0 = PVector.add(PVector.mult(v1,cos(3*PI/4)),PVector.mult(v2,sin(3*PI/4)));
  PVector d1 = PVector.add(PVector.mult(v1,cos(PI/4)),PVector.mult(v2,sin(PI/4)));
  PVector d2 = PVector.add(PVector.mult(v1,cos(-PI/4)),PVector.mult(v2,sin(-PI/4)));
  PVector d3 = PVector.add(PVector.mult(v1,cos(-3*PI/4)),PVector.mult(v2,sin(-3*PI/4)));
  
  d0.normalize();
  d1.normalize();
  d2.normalize();
  d3.normalize();
  
  float plainerDist = sqrt(2*pow(2000/2,2));
  
  d0.mult(plainerDist);
  d1.mult(plainerDist);
  d2.mult(plainerDist);
  d3.mult(plainerDist);

  cameraMatrixMap.beginDraw();
  cameraMatrixMap.camera(cam3Dx+lightDir.x+d0.x, cam3Dy+lightDir.y+d0.y, cam3Dz+lightDir.z+d0.z, cam3Dx+d0.x, cam3Dy+d0.y, cam3Dz+d0.z, 0, 1, 0);
  // Apply project modelview matrix from the shadow pass (light direction)
  shadowTransform[0].apply(((PGraphicsOpenGL)cameraMatrixMap).projmodelview);
  
  cameraMatrixMap.camera(cam3Dx+lightDir.x+d1.x, cam3Dy+lightDir.y+d1.y, cam3Dz+lightDir.z+d1.z, cam3Dx+d1.x, cam3Dy+d1.y, cam3Dz+d1.z, 0, 1, 0);
  // Apply project modelview matrix from the shadow pass (light direction)
  shadowTransform[1].apply(((PGraphicsOpenGL)cameraMatrixMap).projmodelview);
  
  cameraMatrixMap.camera(cam3Dx+lightDir.x+d2.x, cam3Dy+lightDir.y+d2.y, cam3Dz+lightDir.z+d2.z, cam3Dx+d2.x, cam3Dy+d2.y, cam3Dz+d2.z, 0, 1, 0);
  // Apply project modelview matrix from the shadow pass (light direction)
  shadowTransform[2].apply(((PGraphicsOpenGL)cameraMatrixMap).projmodelview);
  
  cameraMatrixMap.camera(cam3Dx+lightDir.x+d3.x, cam3Dy+lightDir.y+d3.y, cam3Dz+lightDir.z+d3.z, cam3Dx+d3.x, cam3Dy+d3.y, cam3Dz+d3.z, 0, 1, 0);
  // Apply project modelview matrix from the shadow pass (light direction)
  shadowTransform[3].apply(((PGraphicsOpenGL)cameraMatrixMap).projmodelview);
  cameraMatrixMap.endDraw();
  
  oldShadowTransform.apply(((PGraphicsOpenGL)shadowMap).projmodelview);

  // Apply the inverted modelview matrix from the default pass to get the original vertex
  // positions inside the shader. This is needed because Processing is pre-multiplying
  // the vertices by the modelview matrix (for better performance).
  PMatrix3D modelviewInv = ((PGraphicsOpenGL)g).modelviewInv;
  shadowTransform[0].apply(modelviewInv);
  shadowTransform[1].apply(modelviewInv);
  shadowTransform[2].apply(modelviewInv);
  shadowTransform[3].apply(modelviewInv);
  oldShadowTransform.apply(modelviewInv);

  // Convert column-minor PMatrix to column-major GLMatrix and send it to the shader.
  // PShader.set(String, PMatrix3D) doesn't convert the matrix for some reason.
  shadowShader.set("shadowTransform0", new PMatrix3D(
    shadowTransform[0].m00, shadowTransform[0].m10, shadowTransform[0].m20, shadowTransform[0].m30,
    shadowTransform[0].m01, shadowTransform[0].m11, shadowTransform[0].m21, shadowTransform[0].m31,
    shadowTransform[0].m02, shadowTransform[0].m12, shadowTransform[0].m22, shadowTransform[0].m32,
    shadowTransform[0].m03, shadowTransform[0].m13, shadowTransform[0].m23, shadowTransform[0].m33
    ));
  shadowShader.set("shadowTransform1", new PMatrix3D(
    shadowTransform[1].m00, shadowTransform[1].m10, shadowTransform[1].m20, shadowTransform[1].m30,
    shadowTransform[1].m01, shadowTransform[1].m11, shadowTransform[1].m21, shadowTransform[1].m31,
    shadowTransform[1].m02, shadowTransform[1].m12, shadowTransform[1].m22, shadowTransform[1].m32,
    shadowTransform[1].m03, shadowTransform[1].m13, shadowTransform[1].m23, shadowTransform[1].m33
    ));
  shadowShader.set("shadowTransform2", new PMatrix3D(
    shadowTransform[2].m00, shadowTransform[2].m10, shadowTransform[2].m20, shadowTransform[2].m30,
    shadowTransform[2].m01, shadowTransform[2].m11, shadowTransform[2].m21, shadowTransform[2].m31,
    shadowTransform[2].m02, shadowTransform[2].m12, shadowTransform[2].m22, shadowTransform[2].m32,
    shadowTransform[2].m03, shadowTransform[2].m13, shadowTransform[2].m23, shadowTransform[2].m33
    ));  
  shadowShader.set("shadowTransform3", new PMatrix3D(
    shadowTransform[3].m00, shadowTransform[3].m10, shadowTransform[3].m20, shadowTransform[3].m30,
    shadowTransform[3].m01, shadowTransform[3].m11, shadowTransform[3].m21, shadowTransform[3].m31,
    shadowTransform[3].m02, shadowTransform[3].m12, shadowTransform[3].m22, shadowTransform[3].m32,
    shadowTransform[3].m03, shadowTransform[3].m13, shadowTransform[3].m23, shadowTransform[3].m33
    ));

  // Calculate light direction normal, which is the transpose of the inverse of the
  // modelview matrix and send it to the default shader.
  float lightNormalX = lightDir.x * modelviewInv.m00 + lightDir.y * modelviewInv.m10 + lightDir.z * modelviewInv.m20;
  float lightNormalY = lightDir.x * modelviewInv.m01 + lightDir.y * modelviewInv.m11 + lightDir.z * modelviewInv.m21;
  float lightNormalZ = lightDir.x * modelviewInv.m02 + lightDir.y * modelviewInv.m12 + lightDir.z * modelviewInv.m22;
  float normalLength = sqrt(lightNormalX * lightNormalX + lightNormalY * lightNormalY + lightNormalZ * lightNormalZ);
  shadowShader.set("lightDirection", lightNormalX / -normalLength, lightNormalY / -normalLength, lightNormalZ / -normalLength);


  //TODO: send each section of the shadow map to the shader
  // Send the shadowmap to the default shader
  shadowShader.set("shadowMap0", subShadowMaps[0]);
  shadowShader.set("shadowMap1", subShadowMaps[3]);
  shadowShader.set("shadowMap2", subShadowMaps[2]);
  shadowShader.set("shadowMap3", subShadowMaps[1]);
  
  shadowShader.set("outputSampledValue",shadowShaderOutputSampledDepthInfo);
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
      workingBlueprint.parts.get(i).draw(g);//draw sll the elements in the blueprint
      if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
        viewingItemIndex=i;//set the cuurent viewing item to this element
      }
    }
  }
  if (workingBlueprint.type.equals("3D blueprint")) {//if the type is a normalk blueprint
    if (e3DMode) {
      cam3Dx=0;
      cam3Dy=0;
      cam3Dz=0;
      camera3DpositionNotSimulating();
      cam3Dx=0;
      cam3Dy=0;
      cam3Dz=0;
      camera(cam3Dx+DX, cam3Dy-DY, cam3Dz-DZ, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);//set the camera
      directionalLight(255, 255, 255, 0.8, 1, -0.35);//setr up the lighting
      ambientLight(102, 102, 102);
      coinRotation+=3;//rotate the coins
      if (coinRotation>360)//reset the coin totation if  it is over 360 degrees
        coinRotation-=360;
      stroke(255, 0, 0);
      strokeWeight(2);
      line(-700, 0, 0, 700, 0, 0);//x-axis
      stroke(0, 255, 0);
      line(0, 700, 0, 0, -700, 0);
      stroke(0, 0, 255);
      line(0, 0, 700, 0, 0, -700);
      noStroke();
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
        workingBlueprint.parts.get(i).draw3D(g);//draw sll the elements in the blueprint
        if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
          viewingItemIndex=i;//set the cuurent viewing item to this element
        }
      }
    } else {
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
        workingBlueprint.parts.get(i).draw(g);//draw sll the elements in the blueprint
        if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
          viewingItemIndex=i;//set the cuurent viewing item to this element
        }
      }
    }
  }
}

void camera3DpositionSimulating(ArrayList<Collider3D> stageCollision) {
  cam3Dx=players[currentPlayer].x;
  cam3Dy=players[currentPlayer].y-37;//camera Y pos in the bille of the body instead of the bottom
  cam3Dz=players[currentPlayer].z;
  //handle roatation
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

  //create a hit box for the entire range of camera positions
  float neard = 10,fard = 700;
  PVector basePointNear = calcCameraBasePoint(neard);
  PVector basePointFar = calcCameraBasePoint(fard);
  
  //create the default box
  Collider3D cameraBox = calcCameraHitBox(basePointNear,basePointFar);
  boolean possibleCollision = false;
  
  //check if there is anything between the camera and the player
  for(Collider3D sb:stageCollision){
    if(CollisionDetection.collide3D(cameraBox,sb)){
      possibleCollision = true;
      break;
    }
  }
  
  float camDist = 700;
  
  //if there is something between the camera and player,
  if(possibleCollision){
    //if it collides
    //split the box in 2
    //select the box closest to the player
    //narrow down where it is
    int iterations = 10;
    for(int i=0;i<iterations;i++){
      //divide the collision area in 2
      float mid = (fard - neard)/2 + neard;
      basePointNear = calcCameraBasePoint(neard);
      basePointFar = calcCameraBasePoint(mid);
      //create the new hit box
      cameraBox = calcCameraHitBox(basePointNear,basePointFar);
      
      boolean result = false;
      //loop
      //check if the selected box collides with the level
      for(Collider3D sb:stageCollision){
        if(CollisionDetection.collide3D(cameraBox,sb)){
          result = true;
          break;
        }
      }
      //if so split that box in 2
      //if not split the box not selected in 2
      if(result){
        fard = mid;
      }else{
        neard = mid;
      }
      //if at the final level return the number
      if(i == iterations-1){
        camDist = neard;
      }
      
      //select the new split box that is closest to the player
      //restart loop
    }
  }
  //if the box did not collide
  //retun 700

  DY=sin(radians(yangle))*camDist;
  hd=cos(radians(yangle))*camDist;
  DX=sin(radians(xangle))*hd;
  DZ=cos(radians(xangle))*hd;
  //+ - -
}

PVector calcCameraBasePoint(float dist){
  float tmp = cos(radians(yangle)) * dist;
  return new PVector(cam3Dx+sin(radians(xangle))*tmp,cam3Dy-sin(radians(yangle))*dist,cam3Dz-cos(radians(xangle))*tmp);
}

Collider3D calcCameraHitBox(PVector near,PVector far){
  float smalDist=0.1;
  return new Collider3D(
    new PVector[]{
      new PVector(near.x+smalDist,near.y,near.z+smalDist),new PVector(near.x+smalDist,near.y,near.z-smalDist),new PVector(near.x-smalDist,near.y,near.z-smalDist),new PVector(near.x-smalDist,near.y,near.z+smalDist),
      new PVector(far.x+smalDist,far.y,far.z+smalDist),new PVector(far.x+smalDist,far.y,far.z-smalDist),new PVector(far.x-smalDist,far.y,far.z-smalDist),new PVector(far.x-smalDist,far.y,far.z+smalDist)
    });
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
  ArrayList<Collider2D> stageBoxes = generateLevel2DComboBox(level.stages.get(currentStageIndex));
  ArrayList<Collider3D> stageBoxes3D = null;
  if(level.stages.get(currentStageIndex).is3D){
    stageBoxes3D = generateLevel3DComboBox(level.stages.get(currentStageIndex));
  }

  //calculate the players physics
  entityPhysics(players[calcingPlayer], level.stages.get(currentStageIndex),stageBoxes,stageBoxes3D);

  //code specific to the current player
  if (players[calcingPlayer].getY()>720) {//kill the player if they go below the stage
    dead=true;
    death_cool_down=0;
    if (!levelCreator) {
      stats.incrementTimesDied();
    }
  }

  //test for entity interactions
  Collider2D player2DHitbox = players[calcingPlayer].getHitBox2D(0, 0);
  Collider3D player3DHitbox = players[calcingPlayer].getHitBox3D(0, 0, 0);
  PlayerIniteractionResult result = null;
  for (int i=0; i<level.stages.get(currentStageIndex).entities.size(); i++) {
    if (!level.stages.get(currentStageIndex).entities.get(i).isDead()) {
      if (e3DMode) {//3d mdoe
        Collider3D enitiyHitBox = level.stages.get(currentStageIndex).entities.get(i).getHitBox3D(0, 0, 0);
        if (enitiyHitBox!=null && collisionDetection.collide3D(player3DHitbox, enitiyHitBox)) {
          //if collideing
          result = level.stages.get(currentStageIndex).entities.get(i).playerInteraction(player3DHitbox);
        }
      } else {//not 3D mode
        Collider2D entityHitBox = level.stages.get(currentStageIndex).entities.get(i).getHitBox2D(0, 0);
        if (entityHitBox !=null && collisionDetection.collide2D(player2DHitbox, entityHitBox)) {
          //if collideing
          result = level.stages.get(currentStageIndex).entities.get(i).playerInteraction(player2DHitbox);
        }
      }

      if (result!=null) {
        if (result.isKill()) {
          dead=true;
          death_cool_down=0;
          if (!levelCreator) {
            stats.incrementTimesDied();
          }
          break;
        }
      }
      if (level.multyplayerMode==2 && !isHost) {
        //if the entitie was killed
        if (level.stages.get(currentStageIndex).entities.get(i).isDead()) {
          //inform the server of the death
          clients.get(0).dataToSend.add(new KillEntityDataPacket(currentStageIndex, i));
        }
      }
    }
  }

  if (dead) {//if the player is dead
    currentStageIndex=respawnStage;//go back to the stage they last checkpointed on
    stageIndex=respawnStage;

    players[calcingPlayer].setX(respawnX);//move the player back to their spawnpoint
    players[calcingPlayer].setY(respawnY);
    players[calcingPlayer].z=respawnZ;
    //set 3D mode based on last chekpoint pass
  }
  if (setPlayerPosTo) {//move the player to a position that is wanted
    players[calcingPlayer].setX(tpCords[0]).setY(tpCords[1]);
    players[calcingPlayer].z=tpCords[2];
    setPlayerPosTo=false;
    players[calcingPlayer].verticalVelocity=0;
  }

  if (level.multyplayerMode==2 && (isHost||levelCreator)) {
    for (Stage stage : level.stages) {
      ArrayList<Collider2D> entityStageBoxes;
      ArrayList<Collider3D> entityStageBoxes3D;
      if(stage.equals(level.stages.get(currentStageIndex))){
        entityStageBoxes = stageBoxes;
        entityStageBoxes3D = stageBoxes3D;
      }else{
        entityStageBoxes = generateLevel2DComboBox(stage);
        entityStageBoxes3D = generateLevel3DComboBox(stage);
      }
      for (int i=0; i<stage.entities.size(); i++) {
        entityPhysics(stage.entities.get(i), stage, entityStageBoxes,entityStageBoxes3D);
      }
    }
  } else if (level.multyplayerMode!=2) {
    for (int i=0; i<level.stages.get(currentStageIndex).entities.size(); i++) {
      entityPhysics(level.stages.get(currentStageIndex).entities.get(i), level.stages.get(currentStageIndex),stageBoxes,stageBoxes3D);
    }
  }

  ////////////////////////////// Logic Thread monitroing
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

void entityPhysics(Entity entity, Stage stage, ArrayList<Collider2D> stageHitBoxs2D, ArrayList<Collider3D> stageHitBoxs3D) {
  MovementManager movement = entity.getMovementmanager();
  //if the movement manager is no movement manager then stop becasue it does not move on its own
  if (movement instanceof NoMovementManager) {
    return;
  }

  //if the entity is dead then do not calculate physics on them
  if (entity instanceof Killable) {
    Killable k = (Killable) entity;
    if (k.isDead()) {
      return;
    }
  }

  if (viewingItemContents && movement instanceof PlayerMovementManager) {//stop movment while intertacting with an object
    movement.reset();
  }

  if (!entity.in3D(e3DMode) || stageHitBoxs3D == null) {

    if (simulating||!levelCreator) {

      if (movement.right()) {//move the player right
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getX()+offset;
        Collider2D newboxPos = entity.getHitBox2D(offset, 0);

        if (!level_colide(newboxPos, stageHitBoxs2D)) {//check if the new posistion collids with anything
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setX(newpos);//move the player if all is good
          }
          //if it does check if it can climb stairs
        } else if (entity.getVerticalVelocity()<0.008) {//check if the player is not falling
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox2D(offset, -i);
            if (!level_colide(newboxPos, stageHitBoxs2D)) {
              //maby allw use of entites as stairs
              entity.setX(newpos);
              break;
            }
          }
        }

        if (entity instanceof Player) {
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
            player.setPose(player.getPose()+1);
            player.setAnimationCooldown(4);
            if (player.getPose()==13) {
              player.setPose(1);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }

      if (movement.left()) {//player moving left
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getX()-offset;
        Collider2D newboxPos = entity.getHitBox2D(-offset, 0);
        if (!level_colide(newboxPos, stageHitBoxs2D)) {//check if the new posistion collids with anything
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setX(newpos);//move the player if all is good
          }
        } else if (entity.getVerticalVelocity()<0.008) {//check if the player is not falling
          //check to see if the player can walk up a "step"
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox2D(-offset, -i);
            if (!level_colide(newboxPos, stageHitBoxs2D)) {
              entity.setX(newpos);
              break;
            }
          }
        }

        if (entity instanceof Player) {
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
            player.setPose(player.getPose()-1);
            player.setAnimationCooldown(4);
            if (player.getPose()==0) {
              player.setPose(12);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }

      if (entity instanceof Player) {
        Player player = (Player)entity;
        if (!movement.right()&&!movement.left()) {//reset the player pose if the player is not moving
          player.setPose(1);
          player.setAnimationCooldown(4);
        }
      }
    }

    if (simulating||!levelCreator)
      if (true) {//gravity
        //    d  =                      vi*t          + 0.5 * a * t^2
        float pd = (entity.getVerticalVelocity()*mspc + 0.5*gravity*(float)Math.pow(mspc, 2));//calculate the new verticle position the player shoud be at
        float newPos = pd +  entity.getY();
        Collider2D newBox = entity.getHitBox2D(0, pd+0.5);
        if (!level_colide(newBox, stageHitBoxs2D)) {//check if that location would be inside of the ground or ceiling
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newBox, stage)) {
            //if the new pos is not colliding with anything
            //           vf          =         vi                  +    a * t
            entity.setVerticalVelocity(entity.getVerticalVelocity()+gravity*mspc);//calculate the players new verticle velocity
            entity.setY(newPos);//update the postiton of the player
          } else {
            entity.setVerticalVelocity(0);
          }
        } else {
          //if the new position would collide with something
          entity.setVerticalVelocity(0);//stop the entity's verticle motion
        }
      }

    //prbly should add a can be killed by this check
    Collider2D dethCheck = entity.getHitBox2D(0, 1);
    if ((entity instanceof Player || entity instanceof Killable )&& player_kill(dethCheck, stage)) {//if the player is on top of a death plane
      if (entity instanceof Killable) {
        Killable k = (Killable) entity;
        k.kill();
      } else {
        dead=true;//kill the player
        death_cool_down=0;
        if (!levelCreator) {
          stats.incrementTimesDied();
        }
      }
    }

    //in ground detection and rectification
    if (level_colide(entity.getHitBox2D(0, 0.5), stageHitBoxs2D)) {//check if the player's position is in the ground
      //if the entity can coolide with other entites check if it is doing so, otherwise continue

      entity.setY(entity.getY()-1);//move the player up
      entity.setVerticalVelocity(0);//stop the entity's verticle motion
    }

    if (entity.collidesWithEntites()) {
      //if colliding with other entitys
      Collider2D hb = entity.getHitBox2D(0, 0.5);
      Collider2D otherEntity = entityCollideObject(entity, hb, stage);
      //if there was a collision
      if (otherEntity != null) {
        //if your center is gerter y then the other
        if (otherEntity.getCenter().y < hb.getCenter().y) {
          //if the new position would not collide with terrain
          if (level_colide(entity.getHitBox2D(0, 2), stageHitBoxs2D)) {
            entity.setY(entity.getY()+1);//move the entity down
            entity.setVerticalVelocity(0);//stop the entity's verticle motion
          }
        } else {
          //if the new position would not collide with terrain
          if (level_colide(entity.getHitBox2D(0, -2), stageHitBoxs2D)) {
            entity.setY(entity.getY()-1);//move the entity up
            entity.setVerticalVelocity(0);//stop the entity's verticle motion
          }
        }
      }
    }

    if (movement.jump()) {//jumping
      Collider2D groundDetect = entity.getHitBox2D(0, 2);
      if (level_colide(groundDetect, stageHitBoxs2D)|| (entity.collidesWithEntites() && entityCollide(entity, groundDetect, stage))) {//check if the entiy is on the ground
        entity.setVerticalVelocity(-0.75);  //if the entity is on the ground and they are trying to jump then set thire verticle velocity
      }
    } else if (entity.getVerticalVelocity()<0) {//if the player stops pressing space bar before they stop riseing then start moving the player down
      entity.setVerticalVelocity(0.01);//make the entity move down
    }

    if (movement instanceof PlayerMovementManager) {
      if (simulating||!levelCreator)
        if (entity.getX()-camPos>(1280-settings.getScrollHorozontal())) {//move the camera if the player goes too close to the end of the screen
          camPos=(int)(entity.getX()-(1280-settings.getScrollHorozontal()));
        }

      if (simulating||!levelCreator)
        if (entity.getX()-camPos<settings.getScrollHorozontal()&&camPos>0) {//move the camera if the player goes too close to the end of the screen
          camPos=(int)(entity.getX()-settings.getScrollHorozontal());
        }

      if (simulating||!levelCreator)
        if (entity.getY()+camPosY>720-settings.getSrollVertical()&&camPosY>0) {//move the camera if the player goes too close to the end of the screen
          camPosY-=entity.getY()+camPosY-(720-settings.getSrollVertical());
        }

      if (simulating||!levelCreator)
        if (entity.getY()+camPosY<settings.getSrollVertical()+75) {//move the camera if the player goes too close to the end of the screen
          camPosY-=entity.getY()+camPosY-(settings.getSrollVertical()+75);
        }
      if (camPos<0)//prevent the camera from moving out of the valid areia
        camPos=0;
      if (camPosY<0)
        camPosY=0;
    }
  } else {//end of not in 3D mode
    if (simulating||!levelCreator) {

      if (movement.right()) {//move the player right
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getX()+offset;
        Collider3D newboxPos = entity.getHitBox3D(offset, 0, 0);

        if (!level_colide(newboxPos, stageHitBoxs3D)) {//check if the player can walk up "stairs"
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setX(newpos);//move the player
          }
        } else if (entity.getVerticalVelocity()<0.008) {//check if the new posaition would place the player inside of a wall
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox3D(offset, -i, 0);
            if (!level_colide(newboxPos, stageHitBoxs3D)) {
              entity.setX(newpos);
              break;
            }
          }
        }

        if (entity instanceof Player) {
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
            player.setPose(player.getPose()+1);
            player.setAnimationCooldown(4);
            if (player.getPose()==13) {
              player.setPose(1);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }

      if (movement.left()) {//player moving left
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getX()-offset;
        Collider3D newboxPos = entity.getHitBox3D(-offset, 0, 0);
        if (!level_colide(newboxPos, stageHitBoxs3D)) {//check if the player can walk up "stairs"
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setX(newpos);//move the player
          }
        } else if (entity.getVerticalVelocity()<0.008) {//check if the new posaition would place the player inside of a wall
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox3D(-offset, -i, 0);
            if (!level_colide(newboxPos, stageHitBoxs3D)) {
              entity.setX(newpos);
              break;
            }
          }
        }

        if (entity instanceof Player) {
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
            player.setPose(player.getPose()-1);
            player.setAnimationCooldown(4);
            if (player.getPose()==0) {
              player.setPose(12);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }

      if (movement.in()) {
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getZ()-offset;
        Collider3D newboxPos = entity.getHitBox3D(0, 0, -offset);
        if (!level_colide(newboxPos, stageHitBoxs3D)) {//check if the player can walk up "stairs"
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setZ(newpos);//move the player
          }
        } else if (entity.getVerticalVelocity()<0.008) {//check if the new posaition would place the player inside of a wall
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox3D(0, -i, -offset);
            if (!level_colide(newboxPos, stageHitBoxs3D)) {
              entity.setZ(newpos);
              break;
            }
          }
        }

        if (entity instanceof Player) {
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
            player.setPose(player.getPose()-1);
            player.setAnimationCooldown(4);
            if (player.getPose()==0) {
              player.setPose(12);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }

      if (movement.out()) {
        float offset  = mspc*((entity instanceof StageEntity)? 0.4: 0.4), newpos = entity.getZ()+offset;
        Collider3D newboxPos = entity.getHitBox3D(0, 0, offset);

        if (!level_colide(newboxPos, stageHitBoxs3D)) {//check if the player can walk up "stairs"
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setZ(newpos);//move the player
          }
        } else if (entity.getVerticalVelocity()<0.008) {//check if the new posaition would place the player inside of a wall
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox3D(0, -i, offset);
            if (!level_colide(newboxPos, stageHitBoxs3D)) {
              entity.setZ(newpos);
              break;
            }
          }
        }

        if (entity instanceof Player) {
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there waljking
            player.setPose(player.getPose()+1);
            player.setAnimationCooldown(4);
            if (player.getPose()==13) {
              player.setPose(1);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }

      if (entity instanceof Player) {
        Player player = (Player)entity;
        if (!movement.right() && !movement.left() && !movement.in() && !movement.out()) {//reset the player pose if the player is not moving
          player.setPose(1);
          player.setAnimationCooldown(4);
        }
      }
    }

    if (simulating||!levelCreator)
      if (true) {//gravity

        //    d  =                      vi*t          + 0.5 * a * t^2
        float pd = (entity.getVerticalVelocity()*mspc + 0.5*gravity*(float)Math.pow(mspc, 2));//calculate the new verticle position the player shoud be at
        float newPos = pd +  entity.getY();
        Collider3D newboxPos = entity.getHitBox3D(0, pd+0.5, 0);
        if (!level_colide(newboxPos, stageHitBoxs3D)) {//check if that location would be inside of the ground or ceiling
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            //           vf          =         vi                  +    a * t
            entity.setVerticalVelocity(entity.getVerticalVelocity()+gravity*mspc);//calculate the players new verticle velocity
            entity.setY(newPos);//update the postiton of the player
          } else {
            entity.setVerticalVelocity(0);
          }
        } else {
          //if the new position would collide with something
          entity.setVerticalVelocity(0);//stop the entity's verticle motion
        }
      }

    //ground detetcion and reftification
    if (level_colide(entity.getHitBox3D(0, 0.5, 0), stageHitBoxs3D)) {
      //if the entity can coolide with other entites check if it is doing so, otherwise continue
      entity.setY(entity.getY()-1);
      entity.setVerticalVelocity(0);
    }
    /*//entity on entity collisoion
     if(entity.collidesWithEntites()){
     //if colliding with other entitys
     Collider2D hb = entity.getHitBox2D(0, 0.5);
     Collider2D otherEntity = entityCollideObject(entity,hb,stage);
     //if there was a collision
     if(otherEntity != null){
     //if your center is gerter y then the other
     if(otherEntity.getCenter().y < hb.getCenter().y){
     //if the new position would not collide with terrain
     if(level_colide(entity.getHitBox2D(0, 2), stage)){
     entity.setY(entity.getY()+1);//move the entity down
     entity.setVerticalVelocity(0);//stop the entity's verticle motion
     }
     }else{
     //if the new position would not collide with terrain
     if(level_colide(entity.getHitBox2D(0, -2), stage)){
     entity.setY(entity.getY()-1);//move the entity up
     entity.setVerticalVelocity(0);//stop the entity's verticle motion
     }
     }
     }
     }*/


    if (movement.jump()) {//jumping
      Collider3D groundDetect = entity.getHitBox3D(0, 2, 0);
      if (level_colide(groundDetect, stageHitBoxs3D)) {//check if the player is standing on the ground
        //if the entity can coolide with other entites check if it is doing so, otherwise continue
        if (!entity.collidesWithEntites() || !entityCollide(entity, groundDetect, stage)) {
          entity.setVerticalVelocity(-0.75);  //if the player is on the ground and they are trying to jump then set thire verticle velocity
        }
      }
    } else if (entity.getVerticalVelocity()<0) {//if the player stops pressing space bar then start moving the player down
      entity.setVerticalVelocity(0.01);
    }
  }
  //end of 3D physics

  //if an entity can be killed and is below 720 kill it
  if (entity instanceof Killable) {
    Killable k = (Killable) entity;
    if (entity.getY() > 720) {
      k.kill();
    }
  }
}


/**check if a point is inside of a solid object
 
 */
boolean level_colide(Collider2D hitbox, ArrayList<Collider2D> stageBoxes) {
  for (Collider2D stageBox:stageBoxes) {//loop over all the objects in the stage
    if (collisionDetection.collide2D(hitbox, stageBox)) {//check if the objects collide
      return true;
    }
  }

  return false;
}

/**check if a point is inside of a solid object IN 3D
 
 */
boolean level_colide(Collider3D hitbox, ArrayList<Collider3D> stageBoxes) {//3d collions
  for (Collider3D stageBox:stageBoxes) {//loop over all the objects in the stage
    if (collisionDetection.collide3D(hitbox, stageBox)) {//check if the objects collide
      return true;
    }
  }
  return false;
}

ArrayList<Collider2D> generateLevel2DComboBox(Stage stage){
  ArrayList<Collider2D> boxes = new ArrayList<>();
  //generate stage 1
  int counter =0;
  ComboBox2D comboBox = new ComboBox2D();
  
  for (int i=0; stageLoopCondishen(i, stage); i++) {//loop over all the objects in the stage
    Collider2D objectBox = stage.parts.get(i).getCollider2D();
    //if the current object provided a hitbox
    if(objectBox != null){
      counter++;
      //add that object to the current combo box
      comboBox.addBox(objectBox);
      
      if(counter==10){//if the current combo box has 10 sub boxes
      //finilze this one and make a new one
        boxes.add(comboBox);
        counter = 0;
        comboBox = new ComboBox2D();
      }
    }
  }
  if(counter != 0){
    boxes.add(comboBox);
  }
  comboBox = new ComboBox2D();
  counter = 0;
  
  //generate stage 2
  ArrayList<Collider2D> pboxes = boxes;
  boxes = new ArrayList<>();
  
  for (Collider2D box: pboxes) {//loop over all the objects in the stage
      counter++;
      //add that object to the current combo box
      comboBox.addBox(box);
      
      if(counter==10){//if the current combo box has 10 sub boxes
      //finilze this one and make a new one
        boxes.add(comboBox);
        counter = 0;
        comboBox = new ComboBox2D();
      }
    
  }
  if(counter != 0){
    boxes.add(comboBox);
  }
  comboBox = new ComboBox2D();
  counter = 0;
  //generate stage 3
  pboxes = boxes;
  boxes = new ArrayList<>();
  for (Collider2D box: pboxes) {//loop over all the objects in the stage
      counter++;
      //add that object to the current combo box
      comboBox.addBox(box);
      
      if(counter==10){//if the current combo box has 10 sub boxes
      //finilze this one and make a new one
        boxes.add(comboBox);
        counter = 0;
        comboBox = new ComboBox2D();
      }
    
  }
  if(counter != 0){
    boxes.add(comboBox);
  }
  
  
  return boxes;
}

ArrayList<Collider3D> generateLevel3DComboBox(Stage stage){
  ArrayList<Collider3D> boxes = new ArrayList<>();
  //generate stage 1
  int counter =0;
  ComboBox3D comboBox = new ComboBox3D();
  
  for (int i=0; stageLoopCondishen(i, stage); i++) {//loop over all the objects in the stage
    Collider3D objectBox = stage.parts.get(i).getCollider3D();
    //if the current object provided a hitbox
    if(objectBox != null){
      counter++;
      //add that object to the current combo box
      comboBox.addBox(objectBox);
      
      if(counter==10){//if the current combo box has 10 sub boxes
      //finilze this one and make a new one
        boxes.add(comboBox);
        counter = 0;
        comboBox = new ComboBox3D();
      }
    }
  }
  if(counter != 0){
    boxes.add(comboBox);
  }
  comboBox = new ComboBox3D();
  counter = 0;
  
  //generate stage 2
  ArrayList<Collider3D> pboxes = boxes;
  boxes = new ArrayList<>();
  
  for (Collider3D box: pboxes) {//loop over all the objects in the stage
      counter++;
      //add that object to the current combo box
      comboBox.addBox(box);
      
      if(counter==10){//if the current combo box has 10 sub boxes
      //finilze this one and make a new one
        boxes.add(comboBox);
        counter = 0;
        comboBox = new ComboBox3D();
      }
    
  }
  if(counter != 0){
    boxes.add(comboBox);
  }
  comboBox = new ComboBox3D();
  counter = 0;
  //generate stage 3
  pboxes = boxes;
  boxes = new ArrayList<>();
  for (Collider3D box: pboxes) {//loop over all the objects in the stage
      counter++;
      //add that object to the current combo box
      comboBox.addBox(box);
      
      if(counter==10){//if the current combo box has 10 sub boxes
      //finilze this one and make a new one
        boxes.add(comboBox);
        counter = 0;
        comboBox = new ComboBox3D();
      }
    
  }
  if(counter != 0){
    boxes.add(comboBox);
  }
  
  
  return boxes;
}

boolean entityCollide(Entity self, Collider2D hitbox, Stage stage) {
  return entityCollideObject(self, hitbox, stage) != null;
}

Collider2D entityCollideObject(Entity self, Collider2D hitbox, Stage stage) {
  for (Entity other : stage.entities) {
    if (self == other)//dont check for collison with self
      continue;
    if (other.collidesWithEntites()) {
      Collider2D otherbox = other.getHitBox2D(0, 0);
      if (otherbox == null)//if the object has no collider then go to the next object
        continue;
      if (collisionDetection.collide2D(hitbox, otherbox)) {//check if the objects collide
        return otherbox;
      }
    }
  }
  return null;
}

boolean entityCollide(Entity self, Collider3D hitbox, Stage stage) {
  return entityCollideObject(self, hitbox, stage) != null;
}

Collider3D entityCollideObject(Entity self, Collider3D hitbox, Stage stage) {
  for (Entity other : stage.entities) {
    if (self == other)//dont check for collison with self
      continue;
    if (other.collidesWithEntites()) {
      Collider3D otherbox = other.getHitBox3D(0, 0, 0);
      if (otherbox == null)//if the object has no collider then go to the next object
        continue;
      if (collisionDetection.collide3D(hitbox, otherbox)) {//check if the objects collide
        return otherbox;
      }
    }
  }
  return null;
}

/**check if entity hitbox is touching a death plane
 
 */
boolean player_kill(Collider2D hitbox, Stage stage) {
  for (int i=0; stageLoopCondishen(i, stage); i++) {
    StageComponent part = stage.parts.get(i);
    //if this part is a deth plane a nd the hitbox position is colliding with it
    if (part instanceof DethPlane) {
      Collider2D dhb = part.getCollider2D();
      if (dhb!=null && collisionDetection.collide2D(hitbox, dhb)) {
        return true;
      }
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
