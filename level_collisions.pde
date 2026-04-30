//start of render_and_physics.pde
int xangle=25+180, yangle=15, dist=700;//camera presets
float DY=sin(radians(yangle))*dist, hd=cos(radians(yangle))*dist, DX=sin(radians(xangle))*hd, DZ=cos(radians(xangle))*hd, cam3Dx, cam3Dy, cam3Dz;//camera rotation

/**Draws all the elements of a stage
 */
void stageLevelDraw() {
  Stage stage=level.stages.get(currentStageIndex);//get the current stage
  background(stage.skyColor);//sky color
  int selectIndex=-1;//reset the selcting obejct
  if (selecting) {//if you are currently using the selection tool
    selectIndex=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, stage);//figure out what element you are hovering over
  }
  //currently only being used by signs
  if (E_pressed && viewingItemContents) {//if you are viewing the contence of an element and you press E
    E_pressed=false;//reset E being pressed
    viewingItemContents=false;//close the contence of the eleiment
    viewingItemIndex=-1;
  }
  if (stage.type.equals("stage")) {//if the cuurent thing that is being drawn is a 2D stage
    SPressed=false;//reset the state of the 3rd dimention movemnt
    WPressed=false;
    e3DMode=false;//turn 3D mode off
    camera();//reset the camera
    drawCamPosX=camPos;//get versions of the camera position variblaes that only get updated once every frame and not on every physics tick
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
      if (viewingItemContents && viewingItemIndex == -1) {//if the current element has decided that you want to view it's contence but no element has been selected
        viewingItemIndex=i;//set the cuurent viewing item to this element
      }
    }
    noStroke();//turn the outline off again
    
    for (int i=0; i<stage.entities.size(); i++) {//render all the Entites on this stage
      if (!stage.entities.get(i).isDead())//if this entity is not dead
        stage.entities.get(i).draw(this, g);//render the entity
    }
    players[currentPlayer].in3D=false;//set this player to be in 2D mode
    if (clients.size()>0){//if anyone is connected / you are connected to someone
      for (int i=currentNumberOfPlayers-1; i>=0; i--) {//draw each player in reverse order
        if (i==currentPlayer){//if this index is for the player being played as
          continue;//skip this render, it will happen latter
        }
        if (players[i].stage==currentStageIndex&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as you then
          draw_mann(Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY), players[i].getPose(), Scale*players[i].getScale(), players[i].getColor(), g);//draw the outher player
          fill(255);
          textSize(15*Scale);
          textAlign(CENTER, CENTER);
          //draw their name above them
          text(players[i].name, Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY-85));
        }
      }
    }

    draw_mann(Scale*(players[currentPlayer].getX()-drawCamPosX), Scale*(players[currentPlayer].getY()+drawCamPosY), players[currentPlayer].getPose(), Scale*players[currentPlayer].getScale(), players[currentPlayer].getColor(), g);//draw this users player
    players[currentPlayer].stage=currentStageIndex;//update the stage this player is in
    //end of rendering 2D stage
  } else if (stage.type.equals("3Dstage")) {//if the stage is a 3D stage
    if (e3DMode) {//if 3D mode is turned on
      ArrayList<Collider3D> stageCollisions = generateLevel3DComboBox(stage);//generate the hitboxes for this stage

      if ((simulating && levelCreator) || !levelCreator){//if not in the level creator or not paused while in the level cretor
        camera3DpositionSimulating(stageCollisions);//calculate the position of the 3D camera
      } else {//if paused and in the level creator
        camera3DpositionNotSimulating();//calculate the manually controlled poisiton of the camera
      }

      camera(cam3Dx+DX, cam3Dy-DY, cam3Dz-DZ, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);//set the camera
      directionalLight(255, 255, 255, 0.8, 1, -0.35);//set up the old lighting (for when shadows are old or off)
      ambientLight(102, 102, 102);
      
      perspective(settings.getFOV(),width*1.0/height,0.5,1048576);//set the FOV and min/max draw distance for 3D
      
      //TODO decouple this from frame rate
      coinRotation+=3;//rotate the coins
      
      if (coinRotation>360) {//reset the coin totation if  it is over 360 degrees
        coinRotation-=360;
      }
      drawCamPosX=camPos;//get versions of the camera position variblaes that only get updated once every frame and not on every physics tick
      drawCamPosY=camPosY;


      players[currentPlayer].in3D=true;//set this player to be rendering in 3D
      players[currentPlayer].stage=currentStageIndex;//set this player to be on this stage
      
      //get local versions of the player's position and other properties that will not change during the rendering of this frame
      float ppx =  players[currentPlayer].getX(), ppy =  players[currentPlayer].getY(), ppz = players[currentPlayer].getZ();
      int ppp =  players[currentPlayer].getPose();
      float pps =  players[currentPlayer].getScale();
      int ppc =  players[currentPlayer].getColor();

      //if proper shadows are enabled
      if ( settings.getShadows() > 1) {
        shadowMap.beginDraw();//start the process of rendering to the depth buffer
        shadowMap.camera(cam3Dx+lightDir.x, cam3Dy+lightDir.y, cam3Dz+lightDir.z, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);//pocition the depth buffer camera
        shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth) by default
        //render to the depth buffer
        render3DLevel(shadowMap, stage,ppx,ppy,ppz,ppp,pps,ppc);
        shadowMap.endDraw();//finish provideing data to the depth buffer and trigger the GPU to render it


        shader(shadowShader);//apply the shadowing shader to the main renderer
        perepLightingPass();//prepair adn apply the lighting uniforms
      }
      
      render3DLevel(g, stage,ppx,ppy,ppz,ppp,pps,ppc);//redner the level to what will be shown on the screen

      if ( settings.getShadows() > 1) {//if proper shadows are enabled
        resetShader();//turn the shadow shader off so UI elemtns render correctly
      }

      if (settings.getShadows() == 1) {//if the old 3D shadow is enabled
        float shadowAltitude=players[currentPlayer].y;//set the starting y posoiton to search form 
        boolean shadowHit=false;
        for (int i=0; i<500&&!shadowHit; i++) {//ray cast to find solid ground underneath the player
          Collider3D groundDetect = players[currentPlayer].getHitBox3D(0, i, 0);//create a simple hitbox to use in detecting the ground
          if (level_colide(groundDetect, stageCollisions)) {//if the hitbox detecteds the ground
            shadowAltitude+=i-1;//reduce the number by 1 so it will be renderd on top
            shadowHit=true;
            continue;
          }
        }
        if (shadowHit) {//if solid ground was found under the player then draw the shadow
          translate(players[currentPlayer].x, shadowAltitude-1.1, players[currentPlayer].z);//move to the postition
          fill(0, 127);
          rotateX(radians(90));
          ellipse(0, 0, 40, 40);//draw the shadow
          rotateX(radians(-90));
          translate(-players[currentPlayer].x, -(shadowAltitude-2), -players[currentPlayer].z);//reser the position
        }
      }
      //prespecitve is reset in the main draw function acter all stage drawings have finished
    } else {//if rednering the level in 2D
      SPressed=false;//reset the state of the 3rd dimention movemnt
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
      //TODO: respect wether the entity is renderd in 3D or not
      noStroke();
      for (int i=0; i<stage.entities.size(); i++) {
        stage.entities.get(i).draw(this, g);//redner this entity
      }

      players[currentPlayer].in3D=false;//set this player to not be in 3D
      if (clients.size()>0){//if any one is connected to you / you are connected to someone
        for (int i=currentNumberOfPlayers-1; i>=0; i--) {//for each connected player
          if (i==currentPlayer){//if that player is you then SKIP
            continue;
          }
          if (players[i].stage==currentStageIndex&&!players[i].in3D&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the userser then
            draw_mann(Scale*(players[i].getX()-camPos), Scale*(players[i].getY()+camPosY), players[i].getPose(), Scale*players[i].getScale(), players[i].getColor(), g);//draw the outher player
            fill(255);
            textSize(15*Scale);
            textAlign(CENTER, CENTER);
            //render the player's name above them
            text(players[i].name, Scale*(players[i].getX()-drawCamPosX), Scale*(players[i].getY()+drawCamPosY-Scale*85));
          }
        }
      }
      
      draw_mann(Scale*(players[currentPlayer].getX()-camPos), Scale*(players[currentPlayer].getY()+camPosY), players[currentPlayer].getPose(), Scale*players[currentPlayer].getScale(), players[currentPlayer].getColor(), g);//draw the player
      players[currentPlayer].stage=currentStageIndex;//set the player as on this stage
    }
  }//end of stage is 3D stage


  if (level_complete) {//if the level has been completed
    fill(255, 255, 0);
    //wow this variable is mispelled
    lebelCompleteText.draw();
    if (level.multyplayerMode!=2||isHost) {//if in speed run mode or hosting the level
      endOfLevelButton.draw();//draw the continue button
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
    StageComponent item = level.stages.get(currentStageIndex).parts.get(viewingItemIndex);//get the thing that is being viewed
    //TODO make this modular
    if (item instanceof WritableSign) {//if your are reeding a sign then show the contents of the sign
      WritableSign sign = (WritableSign)item;
      fill(#A54A00);
      rect(width*0.05, height*0.05, width*0.9, height*0.9);//background of the sign
      fill(#C4C4C4);
      rect(width*0.1, height*0.1, width*0.8, height*0.8);//"paper" of the sign
      textAlign(CENTER, CENTER);
      textSize(50*Scale);
      fill(0);
      text(sign.getContent(), width/2, height/2);//the text of the sign
      textSize(20*Scale);
      text("press B to continue", width/2, height*0.85);//closing instructions
      displayTextUntill = millis()-1;//make shure that "Press B" is not displayed on the screen while in the sign

    }
    disEngageHUDPosition();//rest the hud situation
  }
}//end of stage level draw

/**Render a stage in 3D
@param render The place to render the stage to
@param stage The stage to render
@param playerX The x position of the player
@param playerY The y position of the player
@param playerZ The z position of the player
@param playerPose The current pose the player is in
@param playerScale The scale to draw the player at
@param playerColor The shirt color index of the player
*/
void render3DLevel(PGraphics render, Stage stage,float playerX,float playerY, float playerZ,int playerPose,float playerScale,int playerColor) {
  for (int i=0; stageLoopCondishen(i, stage); i++) {//loop through all elements in the stage
    render.strokeWeight(0);
    render.noStroke();
    if (selectedIndex==i) {//if the current element is selected
      render.stroke(#FFFF00);//give that element a yellow border
      render.strokeWeight(2);
    }
    stage.parts.get(i).draw3D(render);//draw the element in 3D
    if (viewingItemContents && viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
      viewingItemIndex=i;//set the cuurent viewing item to this element
    }
  }
  if (clients.size()>0){//if anyone is connected to you / you are connected to someone
    for (int i=currentNumberOfPlayers-1; i>=0; i--) {//go through each player
      if (i==currentPlayer){//if the current player index is you
        continue;//SKIP
      }
      if (players[i].stage==currentStageIndex&&i!=currentPlayer&&clients.get(0).viablePlayers[i]) {//if this player is on the same stage as the you then
        if (players[i].in3D) {//if this player is in 3D
          draw_mann_3D(players[i].x, players[i].y, players[i].z, players[i].getPose(), players[i].getScale(), players[i].getColor(), render);//draw that player in 3D
          render.fill(255);
          render.textSize(15*Scale);
          render.textAlign(CENTER, CENTER);
          render.translate(0, 0, players[i].z);
          //draw the text above the player's head
          render.text(players[i].name, (players[i].getX()), (players[i].getY()-85));
          render.translate(0, 0, -players[i].z);
        } else {//if the player is in 2D
          draw_mann((players[i].getX()), (players[i].getY()), players[i].getPose(), players[i].getScale(), players[i].getColor(), render);//draw that player in 2D
          render.fill(255);
          render.textSize(15);
          render.textAlign(CENTER, CENTER);
          //draw their name above their head
          render.text(players[i].name, players[i].getX(), players[i].getY()-85);
        }
      }
    }
  }
  draw_mann_3D(playerX, playerY, playerZ, playerPose, playerScale, playerColor, render);//draw the player

  //render all the Entites on this stage
  //TODO: respect wether the entoity is renderd in 3D or not
  render.noStroke();
  for (int i=0; i<stage.entities.size(); i++) {//for each entity on this stage
    if (!stage.entities.get(i).isDead()){//if not dead
      stage.entities.get(i).draw3D(this, render);//render this entity
    }
  }
}//end of draw 3D stage

/**Do various calculations to prepair the uniform values for the shadow creation on the main shader.<br>
This includes splitting the depth buffer up into 4 smaller images to improve shadow resolution
*/
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
  
  PMatrix3D oldShadowTransform = new PMatrix3D(
    0.5, 0.0, 0.0, 0.5,
    0.0, 0.5, 0.0, 0.5,
    0.0, 0.0, 0.5, 0.5,
    0.0, 0.0, 0.0, 1.0
  );
  
  //do not rememer what uve was but it does seem important
  PVector uve = new PVector(-0.8,0,0.35);
  PVector superNormalLight = PVector.div(lightDir,lightDir.magSq());
  
  //calculate the vecators for the supporting plane the camera is being moved in for the smaller depth buffers
  PVector v1 = PVector.sub(uve,PVector.mult(superNormalLight,PVector.dot(uve,lightDir)));
  v1.normalize();
  PVector v2 = PVector.cross(lightDir,v1,null);
  v2.normalize();
  
  //calculate the direction vectors for each small depth buffer
  PVector d0 = PVector.add(PVector.mult(v1,cos(3*PI/4)),PVector.mult(v2,sin(3*PI/4)));
  PVector d1 = PVector.add(PVector.mult(v1,cos(PI/4)),PVector.mult(v2,sin(PI/4)));
  PVector d2 = PVector.add(PVector.mult(v1,cos(-PI/4)),PVector.mult(v2,sin(-PI/4)));
  PVector d3 = PVector.add(PVector.mult(v1,cos(-3*PI/4)),PVector.mult(v2,sin(-3*PI/4)));
  
  d0.normalize();
  d1.normalize();
  d2.normalize();
  d3.normalize();
  
  float plainerDist = sqrt(2*pow(2000/2,2));//calculate the distacne from the center of the big depth buffer each of the smaller depth buffer's center is
  
  //apply that distance to the directions we found earlier
  d0.mult(plainerDist);
  d1.mult(plainerDist);
  d2.mult(plainerDist);
  d3.mult(plainerDist);
  
  //use theese center position with the camera command to calculate the proper camera projection matricies for each of the sub depth buffers
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
  
  oldShadowTransform.apply(((PGraphicsOpenGL)shadowMap).projmodelview);//the paraent matrix for the origional depth buffer

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

  // Send each section the shadowmap to the default shader
  shadowShader.set("shadowMap0", subShadowMaps[0]);
  shadowShader.set("shadowMap1", subShadowMaps[3]);//apperently I got the order of theese wrong, simple fix tho
  shadowShader.set("shadowMap2", subShadowMaps[2]);
  shadowShader.set("shadowMap3", subShadowMaps[1]);
  
  shadowShader.set("outputSampledValue",shadowShaderOutputSampledDepthInfo);//not really used, why am I keeping this arround?
}


/**draws all the elements of a blueprint
 */
void blueprintEditDraw() {
  int selectIndex=-1;
  if (selecting) {//if you are currently using the selection tool
    selectIndex=colid_index(mouseX+camPos, mouseY-camPosY, workingBlueprint);//figure out what eleiment you are hovering over
  }
  if (workingBlueprint.type.equals("blueprint")) {//if the type is a normal blueprint
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
      workingBlueprint.parts.get(i).draw(g);//draw this component
      //why is this in the blurpeint drawerer?
      if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
        viewingItemIndex=i;//set the current viewing item to this element
      }
    }
  }
  if (workingBlueprint.type.equals("3D blueprint")) {//if the type is a 3D blueprint
    if (e3DMode) {//if in 3D mode
      cam3Dx=0;//force the camera to 0 0 0
      cam3Dy=0;
      cam3Dz=0;
      camera3DpositionNotSimulating();//camera rotating 
      cam3Dx=0;//reset the camera again for some reason
      cam3Dy=0;
      cam3Dz=0;
      camera(cam3Dx+DX, cam3Dy-DY, cam3Dz-DZ, cam3Dx, cam3Dy, cam3Dz, 0, 1, 0);//set the camera
      directionalLight(255, 255, 255, 0.8, 1, -0.35);//set up the lighting ofr old/off shadow modes
      ambientLight(102, 102, 102);
      coinRotation+=3;//rotate the coins
      if (coinRotation>360){//reset the coin totation if  it is over 360 degrees
        coinRotation-=360;
      }
      stroke(255, 0, 0);
      strokeWeight(2);
      line(-700, 0, 0, 700, 0, 0);//draw the x-axis
      stroke(0, 255, 0);
      line(0, 700, 0, 0, -700, 0);//draw the y-axis
      stroke(0, 0, 255);
      line(0, 0, 700, 0, 0, -700);//draw the z-axis
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
        workingBlueprint.parts.get(i).draw3D(g);//draw the blurprint component
        //why is this nessarry for a blueprint
        if (viewingItemContents&&viewingItemIndex==-1) {//if the current element has decided that you want to view it's contence but no element has been selected
          viewingItemIndex=i;//set the cuurent viewing item to this element
        }
      }
    } else {//if in 2D mode
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

/**Calculate the camera position for nomral 3D gameplay, including the cmera colliding with the stage between the normal position and the player
@param stageCollision The hitboxes of the stage
*/
void camera3DpositionSimulating(ArrayList<Collider3D> stageCollision) {
  //set the center position of the camera to be in the player
  cam3Dx=players[currentPlayer].getX();
  cam3Dy=players[currentPlayer].getY()-37;//camera Y pos in the middle of the body instead of the bottom
  cam3Dz=players[currentPlayer].getZ();
  //handle roatation
  //TODO: decouple this from FPS
  if (cam_left) {//if the user is trying to rotate the camera left
    xangle+=2;//increase the angle by a bit
    if (xangle>240){//if the angle exceeds the limit
      xangle=240;//force it back to the limit
    }
  }
  if (cam_right) {//if the user is truong to rotate the camera right
    xangle-=2;//decrese the angle by a bit
    if (xangle<190){//if hte angle exceeds the limit
      xangle=190;//force it back to the limit
    }
  }
  if (cam_up) {//if the user is trying  to rotate the camera up
    yangle+=1;//increse the angle by a bit
    if (yangle>=30){//if the angle exceeds the limit
      yangle=30;//force it back to the limit
    }
  }
  if (cam_down) {//if the user is trying  to rotate the camera down
    yangle-=1;//decrease the angle by a bit
    if (yangle<10){//if the angle exceeds the limit
      yangle=10;//force it back to the limit
    }
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
    int iterations = 10;//narrow it down 10 times
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

  //calculate the coordinates of the camrea's eye position
  DY=sin(radians(yangle))*camDist;
  hd=cos(radians(yangle))*camDist;
  DX=sin(radians(xangle))*hd;
  DZ=cos(radians(xangle))*hd;
  //+ - -
}

/**Calculate a point for the camrea's eyes that is a certain distace from the player
@param dist The distace from the player the point is at
@return A point in line with the camera's eyes that is the given distacne from the cmarea center
*/
PVector calcCameraBasePoint(float dist){
  float tmp = cos(radians(yangle)) * dist;//tmp distacne frop the X and Z coord calulcattions
  return new PVector(cam3Dx+sin(radians(xangle))*tmp,cam3Dy-sin(radians(yangle))*dist,cam3Dz-cos(radians(xangle))*tmp);
}

/**Generate a hitbox for the camrea between the near and far coordinate avlues provided
@param near The near distance to the camera center to calculate the hit box from
@param far The far distnce from the camera center to calulcate the hit box from
@return A hitbox covering a possible area the camrea could be in
*/
Collider3D calcCameraHitBox(PVector near,PVector far){
  float smalDist=0.1;//the bit box needs to be a bit more then a 1D line so this is that little bit of depth we give it
  return new Collider3D(
    new PVector[]{//basically just add/subtract that small distacne from the near and far points to form the 8 verticies of the hitbox
      new PVector(near.x+smalDist,near.y,near.z+smalDist),new PVector(near.x+smalDist,near.y,near.z-smalDist),new PVector(near.x-smalDist,near.y,near.z-smalDist),new PVector(near.x-smalDist,near.y,near.z+smalDist),
      new PVector(far.x+smalDist,far.y,far.z+smalDist),new PVector(far.x+smalDist,far.y,far.z-smalDist),new PVector(far.x-smalDist,far.y,far.z-smalDist),new PVector(far.x-smalDist,far.y,far.z+smalDist)
    });
}

/**Calculate the position of the camera for 3D level creation. manual camera controll with almost no angle limits
*/
void camera3DpositionNotSimulating() {
  //TODO decouple this from FPs
  if (space3D) {//if the user is attempting to go up
    cam3Dy-=20;//move the camera postion up
  }
  if (shift3D) {//if the user is attempting to go down
    cam3Dy+=20;//move the camrea position down
  }
  if (w3D) {//if the user is trying to move forwards
    cam3Dx+=20*sin(radians(-xangle));//calulcate a new position forwards of the current position
    cam3Dz+=20*cos(radians(-xangle));
  }
  if (s3D) {//if the user is trying to move backwards
    cam3Dx-=20*sin(radians(-xangle));//calculate a new position beckwards of the current position
    cam3Dz-=20*cos(radians(-xangle));
  }
  if (a3D) {//if the user is trying to move left
    cam3Dx+=20*cos(radians(xangle));//calculate a new position left of the current position
    cam3Dz+=20*sin(radians(xangle));
  }
  if (d3D) {//if the user is trying to move right
    cam3Dx-=20*cos(radians(xangle));//calcukate a new position right of the player
    cam3Dz-=20*sin(radians(xangle));
  }

  //bla bla bla camera rotations. if you can not figure this out look at the simulation position function
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
  //calculate the new camera eye position
  DY=sin(radians(yangle))*dist;
  hd=cos(radians(yangle))*dist;
  DX=sin(radians(xangle))*hd;
  DZ=cos(radians(xangle))*hd;
}

//end of the render zone
//////////////////////////////////////////-----------------------------------------------------
//start of the physics zone

/**Preform p[hyscics calucaltions for the current player and all entities if nessarry.<br>
note this method also preforms monitoring for the logic thread.
Executed on the physcics thread
*/
void playerPhysics() {
  int calcingPlayer = currentPlayer;//store the current player
  ArrayList<Collider2D> stageBoxes = generateLevel2DComboBox(level.stages.get(currentStageIndex));//genreate the hitboxes for this stage
  ArrayList<Collider3D> stageBoxes3D = null;
  if(level.stages.get(currentStageIndex).is3D){//if this stage is 3D then generate the 3D hitboxes as well
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
  Collider2D player2DHitbox = players[calcingPlayer].getHitBox2D(0, 0);//get the player hitboxes
  Collider3D player3DHitbox = players[calcingPlayer].getHitBox3D(0, 0, 0);
  PlayerIniteractionResult result = null;
  for (int i=0; i<level.stages.get(currentStageIndex).entities.size(); i++) {//for each entity in the current stage
    if (!level.stages.get(currentStageIndex).entities.get(i).isDead()) {//if this entity is not dead
      if (e3DMode) {//3d mdoe
        Collider3D enitiyHitBox = level.stages.get(currentStageIndex).entities.get(i).getHitBox3D(0, 0, 0);
        if (enitiyHitBox!=null && CollisionDetection.collide3D(player3DHitbox, enitiyHitBox)) {
          //if collideing
          result = level.stages.get(currentStageIndex).entities.get(i).playerInteraction(player3DHitbox);//get a result
        }
      } else {//not 3D mode
        Collider2D entityHitBox = level.stages.get(currentStageIndex).entities.get(i).getHitBox2D(0, 0);
        if (entityHitBox !=null && CollisionDetection.collide2D(player2DHitbox, entityHitBox)) {
          //if collideing
          result = level.stages.get(currentStageIndex).entities.get(i).playerInteraction(player2DHitbox);//get a result
        }
      }
      //(still in loop) hanle the result of that interaction
      if (result!=null) {
        if (result.isKill()) {//if the result says to kill
          dead=true;//kill the player
          death_cool_down=0;
          if (!levelCreator) {
            stats.incrementTimesDied();
          }
          break;//stop this looop
        }
      }
      
      if (level.multyplayerMode==2 && !isHost && clients.size() > 0 /*dont try to do this if in the level creator*/) {//if in co op mode or not hosting
        //if the entitie was killed
        if (level.stages.get(currentStageIndex).entities.get(i).isDead()) {
          //inform the server of the death
          clients.get(0).dataToSend.add(new KillEntityDataPacket(currentStageIndex, i));
        }
      }
    }
  }//end of each entity looop

  if (dead) {//if the player is dead
    currentStageIndex=respawnStage;//go back to the stage they last checkpointed on
    stageIndex=respawnStage;

    players[calcingPlayer].setX(respawnX);//move the player back to their spawnpoint
    players[calcingPlayer].setY(respawnY);
    players[calcingPlayer].setZ(respawnZ);
    //set 3D mode based on last chekpoint pass
  }
  if (setPlayerPosTo) {//move the player to a position that is wanted
    players[calcingPlayer].setX(tpCords[0]).setY(tpCords[1]);
    players[calcingPlayer].setZ(tpCords[2]);
    setPlayerPosTo=false;
    players[calcingPlayer].setVerticalVelocity(0);
  }

  //if in coop multyplayer mode and this player is the host or is in the level creator
  if (level.multyplayerMode==2 && (isHost||levelCreator)) {
    //loop through all the stages
    for (Stage stage : level.stages) {
      //get the 2 and 3D hitboxes for each stage
      ArrayList<Collider2D> entityStageBoxes;
      ArrayList<Collider3D> entityStageBoxes3D;
      //if this iteration of the loop refers to the current stage
      if(stage.equals(level.stages.get(currentStageIndex))){
        //dont recalculate it
        entityStageBoxes = stageBoxes;
        entityStageBoxes3D = stageBoxes3D;
      }else{
        //calculate the hitboxs
        entityStageBoxes = generateLevel2DComboBox(stage);
        entityStageBoxes3D = generateLevel3DComboBox(stage);
      }
      int stageIndex;
      //figure out the index of this stage
      for(stageIndex = 0;stageIndex < level.stages.size();stageIndex++){
        if(level.stages.get(stageIndex) == stage){
          break;
        }
      }
      ArrayList<Player> playerOnStage = new ArrayList<>();
      //collect all the players on the current stage
      for(int i=0;i<players.length;i++){
        if(players[i].stage == stageIndex){
          playerOnStage.add(players[i]);
        }
      }
      EntityAgentContext agentContext = new EntityAgentContext(mspc,entityStageBoxes,entityStageBoxes3D,playerOnStage.toArray(Player[]::new),stage.entities);
      //calculate the physics for each entity in this stage
      for (int i=0; i<stage.entities.size(); i++) {
        stage.entities.get(i).update(agentContext);
        entityPhysics(stage.entities.get(i), stage, entityStageBoxes,entityStageBoxes3D);
      }
    }
  } else if (level.multyplayerMode!=2) {//if the level is not in co-op mode
    //calculate the physics for only the entites on this stage
    EntityAgentContext agentContext = new EntityAgentContext(mspc,stageBoxes,stageBoxes3D,new Player[]{players[currentPlayer]},level.stages.get(currentStageIndex).entities);
    for (int i=0; i<level.stages.get(currentStageIndex).entities.size(); i++) {
      level.stages.get(currentStageIndex).entities.get(i).update(agentContext);
      entityPhysics(level.stages.get(currentStageIndex).entities.get(i), level.stages.get(currentStageIndex),stageBoxes,stageBoxes3D);
    }
  }

  ////////////////////////////// Logic Thread monitroing
  //if: (not in the level cretaor and (in speed run mode or is the host))  or in the level creator and not paused
  if ((!levelCreator && (level.multyplayerMode==1 || (level.multyplayerMode==2 && isHost))) || (levelCreator && simulating)) {
    if (!logicTickingThread.isAlive()) {//if the ticking thread has stoped for some reason
      logicTickingThread=new LogicThread();//re create the thread
      logicTickingThread.shouldRun=true;//then start it
      logicTickingThread.start();
    }
  } else {//otherwise
    if (logicTickingThread.isAlive()) {//if the ticking thread is running when we dont want it to be
      logicTickingThread.shouldRun=false;//then stop it
    }
  }
}//player physics

/**Calculate in stage physics for an entity
@param entity The entity to calculate physics for
@param stage The stage the entity is on
@param stageHitBoxs2D The 2D hitboxs for the stage
@param stageHitBoxs3D The 3D hitboxs for the stage(if it has them)
*/
void entityPhysics(Entity entity, Stage stage, ArrayList<Collider2D> stageHitBoxs2D, ArrayList<Collider3D> stageHitBoxs3D) {
  MovementManager movement = entity.getMovementmanager();//get the movement manager for this entity
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

  if (viewingItemContents && movement instanceof PlayerMovementManager) {//if this entity is a player then stop movment while intertacting with an object, but still process gravity
    movement.reset();
  }

  if (!entity.in3D(e3DMode) || stageHitBoxs3D == null) {//if the entity is not in 3D mode or no 3D hitboxes exists

    if (simulating||!levelCreator) {//if not in the level creator or not paused

      if (movement.right()) {//move the entity right
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getX()+offset;//calculate how far to offset them to the right
        Collider2D newboxPos = entity.getHitBox2D(offset, 0);//calculate a hit box for the new position

        if (!level_colide(newboxPos, stageHitBoxs2D)) {//check if the new posistion collids with anything
          //if it does not
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {//if this entity can collide with other entities check if this noew position would
            entity.setX(newpos);//move the entity if all is good
          }
          //if it collided with the ground check if it can climb stairs
        } else if (entity.getVerticalVelocity()<0.008) {//check if the player is not falling
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox2D(offset, -i);//generate a new hitbox
            if (!level_colide(newboxPos, stageHitBoxs2D)) {//if it does not hit something then
              //maby allow use of entites as stairs
              entity.setX(newpos);//move the entity forwards (anti in ground will take care of moving the entity up)
              break;
            }
          }
        }

        if (entity instanceof Player) {//if this entity is a player
          //walking animation
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there walking
            player.setPose(player.getPose()+1);
            player.setAnimationCooldown(4);
            if (player.getPose()==13) {
              player.setPose(1);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }//end of moving right

      if (movement.left()) {//move entity moving left
        float offset  = mspc*((entity instanceof StageEntity)? 0.2: 0.4), newpos = entity.getX()-offset;//calculate how far to offset them to the left
        Collider2D newboxPos = entity.getHitBox2D(-offset, 0);//calculate a hit box for the new position
        if (!level_colide(newboxPos, stageHitBoxs2D)) {//check if the new posistion collids with anything
          //if the entity can coolide with other entites check if it is doing so, otherwise continue
          if (!entity.collidesWithEntites() || !entityCollide(entity, newboxPos, stage)) {
            entity.setX(newpos);//move the entity if all is good
          }
        } else if (entity.getVerticalVelocity()<0.008) {//check if the player is not falling
          //check to see if the player can walk up a "step"
          for (int i=1; i<11; i++) {//check to see if the player can walk up a "step"
            newboxPos = entity.getHitBox2D(-offset, -i);//generate a new hitbox
            if (!level_colide(newboxPos, stageHitBoxs2D)) {
              entity.setX(newpos);//move the entity backwards (anti in ground will take care of moving the entity up)
              break;
            }
          }
        }

        if (entity instanceof Player) {//if this entity is a player
          Player player = (Player)entity;
          if (player.getAnimationCooldown()<=0) {//change the player pose to make them look like there walking
            player.setPose(player.getPose()-1);
            player.setAnimationCooldown(4);
            if (player.getPose()==0) {
              player.setPose(12);
            }
          } else {
            player.setAnimationCooldown(player.getAnimationCooldown()-0.05*mspc);//animation cooldown
          }
        }
      }//end of move left

      if (entity instanceof Player) {
        Player player = (Player)entity;
        if (!movement.right()&&!movement.left()) {//reset the player pose if the player is not moving
          player.setPose(1);
          player.setAnimationCooldown(4);
        }
      }
    }

    if (simulating || !levelCreator){
        //gravity
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
          } else {//if you collided with an entity
            entity.setVerticalVelocity(0);//stop moving down/up
          }
        } else {
          //if the new position would collide with something
          entity.setVerticalVelocity(0);//stop the entity's verticle motion
        }
      }//end of gravity

    //prbly should add a can be killed by this check
    Collider2D dethCheck = entity.getHitBox2D(0, 1);//check to see if standing on death plane
    if ((entity instanceof Player || entity instanceof Killable )&& player_kill(dethCheck, stage)) {//if the entity is on top of a death plane
      if (entity instanceof Killable) {
        Killable k = (Killable) entity;
        k.kill();//kill them
      } else {
        dead=true;//kill the player
        death_cool_down=0;
        if (!levelCreator) {
          stats.incrementTimesDied();
        }
      }
    }

    //in ground detection and rectification
    if (level_colide(entity.getHitBox2D(0, 0.5), stageHitBoxs2D)) {//check if the entitie's position is in the ground
      //if the entity can colide with other entites check if it is doing so, otherwise continue

      //TODO make this conditional on not colliding with something else. this is hard becasue this whole thing is colliding with something 
      entity.setY(entity.getY()-1);//move the player up
      entity.setVerticalVelocity(0);//stop the entitie's verticle motion
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
          //TODO: this does not seems to work
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

    if (movement instanceof PlayerMovementManager) {//if the entity is a player
      if (simulating||!levelCreator){
        if (entity.getX()-camPos>(1280-settings.getScrollHorozontal())) {//move the camera if the player goes too close to the end of the screen
          camPos=(int)(entity.getX()-(1280-settings.getScrollHorozontal()));
        }

        if (entity.getX()-camPos<settings.getScrollHorozontal()&&camPos>0) {//move the camera if the player goes too close to the end of the screen
          camPos=(int)(entity.getX()-settings.getScrollHorozontal());
        }


        if (entity.getY()+camPosY>720-settings.getSrollVertical()&&camPosY>0) {//move the camera if the player goes too close to the end of the screen
          camPosY-=entity.getY()+camPosY-(720-settings.getSrollVertical());
        }

        if (entity.getY()+camPosY<settings.getSrollVertical()+75) {//move the camera if the player goes too close to the end of the screen
          camPosY-=entity.getY()+camPosY-(settings.getSrollVertical()+75);
        }
      }
      if (camPos<0){//prevent the camera from moving out of the valid areia
        camPos=0;
      }
      if (camPosY<0){
        camPosY=0;
      }
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
    //never tested this and have no idea if it works
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


/**Check if a point is inside of a solid object
@param hitbox The hitbox to check for collision of
@param stageBoxes All the hitboxes of the stage to test with
@return true if a collision occors
 */
boolean level_colide(Collider2D hitbox, ArrayList<Collider2D> stageBoxes) {
  for (Collider2D stageBox:stageBoxes) {//loop over all the objects in the stage
    if (CollisionDetection.collide2D(hitbox, stageBox)) {//check if the objects collide
      return true;
    }
  }

  return false;
}

/**check if a point is inside of a solid object IN 3D
@param hitbox The hitbox to check for collision of
@param stageBoxes All the hitboxes of the stage to test with
@return true if a collision occors
*/
boolean level_colide(Collider3D hitbox, ArrayList<Collider3D> stageBoxes) {//3d collions
  for (Collider3D stageBox:stageBoxes) {//loop over all the objects in the stage
    if (CollisionDetection.collide3D(hitbox, stageBox)) {//check if the objects collide
      return true;
    }
  }
  return false;
}

/**Generate all the hitboxes 2D hitboxes for the given stage
@param stage The stage to generate the hitboxes for
@return A collection containing all the hitboxes for this stage
*/
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
  if(counter != 0){//if the number of boxes was not evenly divisable by 10
    boxes.add(comboBox);//add the last combo box to the main list
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
  if(counter != 0){//if the number of boxes was not evenly divisable by 10
    boxes.add(comboBox);//add the last combo box to the main list
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
  if(counter != 0){//if the number of boxes was not evenly divisable by 10. At this point it is unlikely that there will be more then 1 box but there is a chance
    boxes.add(comboBox);//add the last combo box to the main list
  }
  
  return boxes;
}
/**Generate all the hitboxes 3D hitboxes for the given stage
@param stage The stage to generate the hitboxes for
@return A collection containing all the hitboxes for this stage
*/
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

/**Test if an entity collides with other entities
@param self The entity to check collision for
@param hitbox The hitbox of the entity
@param stage The stage to check the collision of ther entities
@return true if this entity colliders with any onther on the same stage
*/
boolean entityCollide(Entity self, Collider2D hitbox, Stage stage) {
  return entityCollideObject(self, hitbox, stage) != null;
}

/**Test if an entity collides with other entities
@param self The entity to check collision for
@param hitbox The hitbox of the entity
@param stage The stage to check the collision of ther entities
@return The entitiy that was collided with or null if no collison occored
*/
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
/**Test if an entity collides with other entities
@param self The entity to check collision for
@param hitbox The hitbox of the entity
@param stage The stage to check the collision of ther entities
@return true if this entity colliders with any onther on the same stage
*/
boolean entityCollide(Entity self, Collider3D hitbox, Stage stage) {
  return entityCollideObject(self, hitbox, stage) != null;
}
/**Test if an entity collides with other entities
@param self The entity to check collision for
@param hitbox The hitbox of the entity
@param stage The stage to check the collision of ther entities
@return The entitiy that was collided with or null if no collison occored
*/
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
 @param hitbox The hitbox of the entity
 @param stage The stage the entity is on
 @return true if the entitiy is touching a death plane
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

/**Get the index of the element that the point is inside of
 @param x The x position of the point to check
 @param y The y position of the point to check
 @param stage The stage to check the point in
 @return The index of the element collided with or -1 if no collision occored
 */
int colid_index(float x, float y, Stage stage) {
  for (int i=stage.parts.size()-1; i>=0; i--) {
    if (stage.parts.get(i).colide(x, y, true)) {
      return i;
    }
  }
  return -1;
}

/**Get the index of the 3D element that the point is inside of
 @param x The x position of the point to check
 @param y The y position of the point to check
 @param z The z position of the point to check
 @param stage The stage to check the point in
 @return The index of the element collided with or -1 if no collision occored
 */
int colid_index(float x, float y, float z, Stage stage) {
  for (int i=stage.parts.size()-1; i>=0; i--) {
    if (stage.parts.get(i).colide(x, y, z, true)) {
      return i;
    }
  }
  return -1;
}

/**Only draw as much of the staeg as is required for the tutorial (or all for everything else)
@param i The current index of the loop
@param stage The stage that is being looped over
@return Wather the for loop drawing the stage shouold continue
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

/**Thread responcable for ticking the logic baord tick
 */
class LogicThread extends Thread {
  boolean shouldRun=true;
  int lastRun;
  /**Create a new logic ticking thread
  */
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
//end of render_and_physics.pde
