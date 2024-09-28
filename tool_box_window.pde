class ToolBox extends PApplet {

  public ToolBox(int miliOffset) {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    millisOffset=miliOffset;
  }

  public int redVal=0, greenVal=0, blueVal=0, CC=0;
  int rsp=0, gsp=0, bsp=0, selectedColor=0, millisOffset, variableScroll=0, groupScroll=0;
  String page="colors", newGroopName="";
  Button colorPage, toolsPage, draw_coin, draw_portal, draw_sloap, draw_holoTriangle, draw_dethPlane, toggle3DMode, switch3D1, switch3D2, saveLevel, exitStageEdit, sign, select, selectionPage, stageSettings, skyColorB1, setSkyColor, resetSkyColor, placeBlueprint, nexBlueprint, prevBlueprint, playSound, nextSound, prevSound, checkpointButton, playPauseButton, groundButton, goalButton, deleteButton, movePlayerButton, gridModeButton, holoButton, connectLogicButton, moveComponentsButton, andGateButton, orGateButton, xorGateButton, nandGateButton, norGateButton, xnorGateButton, testLogicPlaceButton, constantOnButton, setVariableButton, readVariableButton, setVisabilityButton, xOffsetButton, yOffsetButton, increase, increaseMore, increaseAlot, decrease, decreaseMore, decreaseAlot, nextGroup, prevGroup, variablesAndGroups, variablesUP, variablesDOWN, groupsUP, groupsDOWN, addVariable, addGroup, typeGroopName, logicButtonButton, runLoad, delayButton, zOffsetButton, logicHelpButton, move3DButton, size3DButton, set3DButton, read3DButton, levelSettingsPage, multyplayerModeSpeedrunButton, multyplayerModeCoOpButton, minplayersIncrease, minPlayersDecrease, maxplayersIncrease, maxplayersDecrease, prevousPlayerButton, nextPlayerButton, playLogicSoundButton, pulseButton, randomButton, tickLogicButton,placeBlueprint3DButton,respawnEntitiesButton;
  Button goonEntity;
  boolean typingSign=false, settingSkyColor=false, typingGroopName=false;

  public void settings() {
    size(1280, 720, P2D);//mac os requires a render to be specified
    smooth();
  }
  void setup() {
    textSize(50);
    //all page buttons
    colorPage=new Button(this, 50, 50, 100, 50, "colors/depth");
    toolsPage=new Button(this, 155, 50, 100, 50, "tools");
    selectionPage=new Button(this, 260, 50, 100, 50, "selection");
    stageSettings=new Button(this, 365, 50, 100, 50, "stage settings");
    variablesAndGroups=new Button(this, 470, 50, 100, 50, "variables/groups");
    levelSettingsPage=new Button(this, 575, 50, 100, 50, "level settings");

    prevousPlayerButton=new Button(this, 330, 105, 28, 28, "<");
    nextPlayerButton=new Button(this, 400, 105, 28, 28, ">");
    
    //stage editing tools
    toggle3DMode=new Button(this, 820, 40+100, 50, 50, "  3D  ", 255, 203).setStrokeWeight(5).setHoverText("toggle 3D mode");
    switch3D1=new Button(this, 880, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("turn 3D on switch");
    switch3D2=new Button(this, 940, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("turn 3D off switch");
    saveLevel=new Button(this, 1000, 40+100, 50, 50, "save", 255, 203).setStrokeWeight(5).setHoverText("save level");
    draw_sloap=new Button(this, 700, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("sloap");
    draw_holoTriangle=new Button(this, 760, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("holographic sloap(no colision)");
    draw_dethPlane=new Button(this, 820, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("death plane");
    draw_coin=new Button(this, 580, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("coin");
    draw_portal=new Button(this, 640, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("interdimentional portal");
    exitStageEdit= new Button(this, 520, 40+100, 50, 50, " < ", 255, 203).setStrokeWeight(5).setHoverText("exit to overview");
    sign=new Button(this, 1060, 140, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("sign");
    select=new Button(this, 1120, 140, 50, 50, "select", 255, 203).setStrokeWeight(5).setHoverText("select");
    skyColorB1=new Button(this, 150, 165, 40, 40, 255, 203).setStrokeWeight(0);
    setSkyColor=new Button(this, 300, 580, 100, 30, "set sky color").setStrokeWeight(2);
    resetSkyColor=new Button(this, 200, 165, 40, 40, "reset", 255, 203).setStrokeWeight(0);
    placeBlueprint=new Button(this, 1180, 140, 50, 50, #0F1AD3, 203).setStrokeWeight(5).setHoverText("place blurprint");
    nexBlueprint=new Button(this, width/2+200, height*0.7-25, 50, 50, ">", 255, 203).setStrokeWeight(5);
    prevBlueprint=new Button(this, width/2-200, height*0.7-25, 50, 50, "<", 255, 203).setStrokeWeight(5);
    playSound=new Button(this, 40, 200, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("place sound");
    nextSound=new Button(this, width/2+300, height*0.4-25, 50, 50, ">", 255, 203).setStrokeWeight(5);
    prevSound=new Button(this, width/2-300, height*0.4-25, 50, 50, "<", 255, 203).setStrokeWeight(5);
    checkpointButton=new Button(this, 160, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("check point");
    playPauseButton=new Button(this, 40, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("play/pause the simulation");
    groundButton=new Button(this, 100, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("solid ground");
    goalButton=new Button(this, 220, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("finish line");
    deleteButton=new Button(this, 280, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("delete");
    movePlayerButton=new Button(this, 340, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("move player");
    gridModeButton=new Button(this, 400, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("grid mode");
    holoButton=new Button(this, 460, 40+100, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("hologram (no collision)");
    logicButtonButton=new Button(this, 100, 200, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("place button");
    move3DButton=new Button(this, 160, 200, 50, 50, "move", 255, 203).setStrokeWeight(5).setHoverText("move things in 3D");
    size3DButton=new Button(this, 220, 200, 50, 50, "size", 255, 203).setStrokeWeight(5).setHoverText("resize things in 3D");
    goonEntity = new Button(this,280,200,50,50,255,203).setStrokeWeight(5).setHoverText("Goon");

    //logic editor tools
    connectLogicButton=new Button(this, 40, 40+100, 50, 50, "connect", 255, 203).setStrokeWeight(5).setHoverText("connect logic nodes");
    moveComponentsButton=new Button(this, 100, 40+100, 50, 50, "move", 255, 203).setStrokeWeight(5).setHoverText("move components arround");
    andGateButton=new Button(this, 160, 40+100, 50, 50, "AND", 255, 203).setStrokeWeight(5).setHoverText("and gate");
    orGateButton=new Button(this, 220, 40+100, 50, 50, "OR", 255, 203).setStrokeWeight(5).setHoverText("or gate");
    xorGateButton=new Button(this, 340, 40+100, 50, 50, "XOR", 255, 203).setStrokeWeight(5).setHoverText("exclucuve or gate");
    nandGateButton=new Button(this, 400, 40+100, 50, 50, "NAND", 255, 203).setStrokeWeight(5).setHoverText("inverted and gate");
    norGateButton=new Button(this, 460, 40+100, 50, 50, "NOR", 255, 203).setStrokeWeight(5).setHoverText("inverted or gate");
    xnorGateButton=new Button(this, 580, 40+100, 50, 50, "XNOR", 255, 203).setStrokeWeight(5).setHoverText("inverted exclucive or gate");
    testLogicPlaceButton=new Button(this, 40, 100+100, 50, 50, "test", 255, 203).setStrokeWeight(5).setHoverText("this should not exsist");
    constantOnButton=new Button(this, 640, 40+100, 50, 50, "ON", 255, 203).setStrokeWeight(5).setHoverText("constant on signal");
    readVariableButton=new Button(this, 700, 40+100, 50, 50, "read", 255, 203).setStrokeWeight(5).setHoverText("read the state of a variable");
    setVariableButton=new Button(this, 760, 40+100, 50, 50, "set", 255, 203).setStrokeWeight(5).setHoverText("set the state of a varable");
    setVisabilityButton=new Button(this, 820, 40+100, 50, 50, "vis", 255, 203).setStrokeWeight(5).setHoverText("set visability of a group");
    xOffsetButton=new Button(this, 880, 40+100, 50, 50, "offset X", 255, 203).setStrokeWeight(5).setHoverText("offset a group in the x-axis");
    yOffsetButton=new Button(this, 940, 40+100, 50, 50, "offset y", 255, 203).setStrokeWeight(5).setHoverText("offset a group in the y-axis");
    delayButton=new Button(this, 1060, 140, 50, 50, "delay", 255, 203).setStrokeWeight(5).setHoverText("delay a pulse in your logic");
    zOffsetButton=new Button(this, 40, 200, 50, 50, "offset z", 255, 203).setStrokeWeight(5).setHoverText("offset a group in the z-axis");
    logicHelpButton=new Button(this, 100, 200, 50, 50, "?", 255, 203).setStrokeWeight(5).setHoverText("help");
    set3DButton=new Button(this, 160, 200, 50, 50, "s 3D", 255, 203).setStrokeWeight(5).setHoverText("set the state of 3D mode");
    read3DButton=new Button(this, 220, 200, 50, 50, "r 3D", 255, 203).setStrokeWeight(5).setHoverText("read the state of 3D mode");
    playLogicSoundButton=new Button(this, 280, 200, 50, 50, 255, 203).setStrokeWeight(5).setHoverText("play sounds woth logic");
    pulseButton=new Button(this, 340, 200, 50, 50, "pulse", 255, 203).setStrokeWeight(5).setHoverText("generates a 1 tick pulse");
    randomButton= new Button(this, 400, 200, 50, 50, "random", 255, 203).setStrokeWeight(5).setHoverText("sets its output randomly each tick");
    
    //variables and groups buttons
    increase=new Button(this, width/2+180, height*0.5, 50, 50, "+", 255, 203).setStrokeWeight(5);
    increaseMore=new Button(this, width/2+240, height*0.5, 50, 50, "++", 255, 203).setStrokeWeight(5);
    increaseAlot=new Button(this, width/2+300, height*0.5, 50, 50, "+++", 255, 203).setStrokeWeight(5);
    decrease=new Button(this, width/2-180, height*0.5, 50, 50, "-", 255, 203).setStrokeWeight(5);
    decreaseMore=new Button(this, width/2-240, height*0.5, 50, 50, "--", 255, 203).setStrokeWeight(5);
    decreaseAlot=new Button(this, width/2-300, height*0.5, 50, 50, "---", 255, 203).setStrokeWeight(5);
    nextGroup=new Button(this, width/2+225, height*0.9-25, 50, 50, ">", 255, 203).setStrokeWeight(5);
    prevGroup=new Button(this, width/2-250, height*0.9-25, 50, 50, "<", 255, 203).setStrokeWeight(5);
    variablesUP=new Button(this, 45, 190, 30, 30, "^");
    variablesDOWN=new Button(this, 45, 440, 30, 30, "v");
    groupsUP=new Button(this, 520, 190, 30, 30, "^");
    groupsDOWN=new Button(this, 520, 440, 30, 30, "v");
    addVariable=new Button(this, 180, 190, 30, 30, "+");
    addGroup=new Button(this, 640, 190, 30, 30, "+");
    typeGroopName=new Button(this, 680, 190, 400, 30);
    runLoad=new Button(this, 500, 550, 200, 50, "load").setHoverText("run the load logic board");
    tickLogicButton = new Button(this, 500, 650, 200, 50, "tick").setHoverText("run 1 logic tick on the current logic board");
    placeBlueprint3DButton = new Button(this,590,600,100,50,"Place").setHoverText("place the current blueprint");

    //level settings screen buttons
    multyplayerModeSpeedrunButton=new Button(this, 220, 190, 80, 30, "speed run", 255, #F6FF03);
    multyplayerModeCoOpButton=new Button(this, 320, 190, 80, 30, "co-op", 255, 100);
    minplayersIncrease=new Button(this, 230, 240, 30, 30, ">");
    minPlayersDecrease=new Button(this, 160, 240, 30, 30, "<");
    maxplayersIncrease=new Button(this, 230, 290, 30, 30, ">");
    maxplayersDecrease=new Button(this, 160, 290, 30, 30, "<");
    respawnEntitiesButton = new Button(this, 160,340, 80,30,"Respawn Entities",255,100);
  }


  public void draw() {
    if (levelCreator) {
      redVal=(int)((rsp/1080.0)*255);
      greenVal=(int)((gsp/1080.0)*255);
      blueVal=(int)((bsp/1080.0)*255);


      if (blueVal==255) {
        blueVal=254;
      }
      CC=(int)(Math.pow(16, 4)*redVal+Math.pow(16, 2)*greenVal+blueVal);
      CC=CC-16777215;

      if (page.equals("colors")) {
        stroke(0);
        background(CC);
        fill(255);
        strokeWeight(10);
        rect(100, 150, 1080, 50);
        rect(100, 300, 1080, 50);
        rect(100, 450, 1080, 50);
        fill(255, 0, 0);
        rect(rsp+75, 125, 50, 100);
        fill(0, 255, 0);
        rect(gsp+75, 275, 50, 100);
        fill(0, 0, 255);
        rect(bsp+75, 425, 50, 100);
        fill(255);
        strokeWeight(0);
        rect(440, 550, 400, 150);
        fill(0);
        textSize(30);
        textAlign(CENTER, CENTER);
        text(redVal, 640, 100);
        text(greenVal, 640, 250);
        text(blueVal, 640, 400);
        JSONObject colo=colors.getJSONObject(selectedColor);
        fill((int)(colo.getInt("red")*Math.pow(16, 4)+colo.getInt("green")*Math.pow(16, 2)+colo.getInt("blue"))-16777215);
        rect(600, 600, 80, 80);
        fill(180);
        rect(500, 600, 50, 80);
        rect(730, 600, 50, 80);
        rect(600, 560, 80, 30);
        fill(0);
        triangle(510, 640, 540, 625, 540, 655);
        triangle(770, 640, 740, 625, 740, 655);
        fill(0);
        textSize(15);
        text("save color", 640, 570);
        if ((level!=null&&level.stages.size()>0&&currentStageIndex!=-1&&level.stages.get(currentStageIndex).type.equals("3Dstage")) || (workingBlueprint!=null && workingBlueprint.type.equals("3D blueprint"))) {

          fill(255);
          rect(100, 550, 200, 150);
          rect(950, 550, 200, 150);
          fill(0);
          textSize(25);
          text("starting depth", 200, 570);
          text("total depth", 1050, 570);
          text(startingDepth, 200, 650);
          text(totalDepth, 1050, 650);
        }
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();
        if (settingSkyColor)
          setSkyColor.draw();
      }//end of if page is colors
      if (page.equals("tools")) {
        background(255*0.5);
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();

        if (editingStage) {


          playPauseButton.draw();
          fill(0);
          stroke(0);
          strokeWeight(0);
          if (simulating) {
            rect(50, 50+100, 8, 30);
            rect(70, 50+100, 8, 30);
          } else {
            triangle(50, 50+100, 75, 65+100, 50, 80+100);
          }

          if (!e3DMode) {
            strokeWeight(0);
            if (ground) {
              groundButton.setColor(255, #F2F258);
            } else {
              groundButton.setColor(255, 203);
            }
            groundButton.draw();
            fill(-7254783);
            stroke(-7254783);
            rect(100, 70+100, 50, 20);
            fill(-16732415);
            stroke(-16732415);
            rect(100, 60+100, 50, 10);

            strokeWeight(0);
            if (check_point) {
              checkpointButton.setColor(255, #F2F258);
            } else {
              checkpointButton.setColor(255, 203);
            }
            checkpointButton.draw();
            fill(#B9B9B9);
            strokeWeight(0);
            rect(168, 45+100, 5, 40);
            fill(#EA0202);
            stroke(#EA0202);
            strokeWeight(0);
            triangle(170, 85-60+20+100, 170, 85-40+20+100, 170+30, 85-50+20+100);
            strokeWeight(0);

            if (!level.stages.get(currentStageIndex).type.equals("3Dstage")) {
              if (goal) {
                goalButton.setColor(255, #F2F258);
              } else {
                goalButton.setColor(255, 203);
              }
              goalButton.draw();
              fill(0);
              stroke(0);
              strokeWeight(0);
              rect(223, 43+100, 15, 15);
              rect(253, 43+100, 15, 15);
              rect(238, 58+100, 15, 15);
              rect(223, 73+100, 15, 15);
              rect(253, 73+100, 15, 15);
            }
            if (deleteing) {
              deleteButton.setColor(255, #F2F258);
            } else {
              deleteButton.setColor(255, 203);
            }
            deleteButton.draw();
            fill(203);
            stroke(203);
            strokeWeight(0);
            rect(285, 55+100, 40, 5);
            rect(300, 50+100, 10, 5);
            rect(290, 60+100, 5, 20);
            rect(290, 80+100, 30, 5);
            rect(315, 60+100, 5, 20);
            rect(298, 60+100, 5, 20);
            rect(307, 60+100, 5, 20);

            if (moving_player) {
              movePlayerButton.setColor(255, #F2F258);
            } else {
              movePlayerButton.setColor(255, 203);
            }
            movePlayerButton.draw();
            strokeWeight(0);
            draw_mann(365, 88+100, 1, 0.6, "red");

            if (grid_mode) {
              gridModeButton.setColor(255, #F2F258);
            } else {
              gridModeButton.setColor(255, 203);
            }
            gridModeButton.draw();
            textSize(20);
            fill(0);
            stroke(0);
            strokeWeight(1);
            line(410, 42+100, 410, 87+100);
            line(420, 42+100, 420, 87+100);
            line(430, 42+100, 430, 87+100);
            line(440, 42+100, 440, 87+100);
            line(402, 50+100, 448, 50+100);
            line(402, 60+100, 448, 60+100);
            line(402, 70+100, 448, 70+100);
            line(402, 80+100, 448, 80+100);
            text(grid_size, 410, 80+100);
            strokeWeight(0);
            if (holo_gram) {
              holoButton.setColor(255, #F2F258);
            } else {
              holoButton.setColor(255, 203);
            }
            holoButton.draw();
            exitStageEdit.draw();

            if (drawCoins) {
              draw_coin.setColor(255, #F2F258);
            } else {
              draw_coin.setColor(255, 203);
            }
            draw_coin.draw();
            drawCoin(605, 65+100, 4);
            if (drawingPortal) {
              draw_portal.setColor(255, #F2F258);
            } else {
              draw_portal.setColor(255, 203);
            }
            draw_portal.draw();
            drawPortal(665, 65+100, 0.45);

            if (!level.stages.get(currentStageIndex).type.equals("3Dstage")) {
              if (sloap) {
                draw_sloap.setColor(255, #F2F258);
              } else {
                draw_sloap.setColor(255, 203);
              }//draw_holoTriangle
              draw_sloap.draw();
              fill(-7254783);
              stroke(-7254783);
              strokeWeight(0);
              triangle(705, 85+100, 745, 85+100, 745, 45+100);
              if (holoTriangle) {
                draw_holoTriangle.setColor(255, #F2F258);
              } else {
                draw_holoTriangle.setColor(255, 203);
              }//draw_holoTriangle
              draw_holoTriangle.draw();
              fill(-4623063);
              stroke(-4623063);
              strokeWeight(0);
              triangle(765, 85+100, 805, 85+100, 805, 45+100);


              if (dethPlane) {
                draw_dethPlane.setColor(255, #F2F258);
              } else {
                draw_dethPlane.setColor(255, 203);
              }//draw_holoTriangle
              draw_dethPlane.draw();
              fill(-114431);
              stroke(-114431);
              rect(825, 65+100, 40, 20);

              if (selectingBlueprint) {
                placeBlueprint.setColor(#0F1AD3, #F2F258);
              } else {
                placeBlueprint.setColor(#0F1AD3, 203);
              }
              placeBlueprint.draw();

              if (placingSound) {
                playSound.setColor(255, #F2F258);
              } else {
                playSound.setColor(255, 203);
              }
              playSound.draw();
              drawSpeakericon(this, playSound.x+playSound.lengthX/2, playSound.y+playSound.lengthY/2, 0.5);
              
              //tmp
              if(placingGoon){
                goonEntity.setColor(255, #F2F258);
              } else {
                goonEntity.setColor(255, 203);
              }
              goonEntity.draw();
            }//end of level is not 3D

            if (drawingSign) {
              sign.setColor(255, #F2F258);
            } else {
              sign.setColor(255, 203);
            }
            sign.draw();
            drawSign(sign.x+sign.lengthX/2, sign.y+sign.lengthY, 0.6);

            if (selecting) {
              select.setColor(255, #F2F258);
            } else {
              select.setColor(255, 203);
            }
            select.draw();
            if (placingLogicButton) {
              logicButtonButton.setColor(255, #F2F258);
            } else {
              logicButtonButton.setColor(255, 203);
            }
            logicButtonButton.draw();
            drawLogicButton(this, logicButtonButton.x+logicButtonButton.lengthX/2, logicButtonButton.y+logicButtonButton.lengthY/2, 1, false);
          }//end of not in 3D mode

          saveLevel.draw();


          //button hover text
          textAlign(LEFT, BOTTOM);
          playPauseButton.drawHoverText();
          if (!e3DMode) {
            groundButton.drawHoverText();
            checkpointButton.drawHoverText();
            if (!level.stages.get(currentStageIndex).type.equals("3Dstage")) {
              goalButton.drawHoverText();
            }

            deleteButton.drawHoverText();
            movePlayerButton.drawHoverText();
            gridModeButton.drawHoverText();
            holoButton.drawHoverText();
            exitStageEdit.drawHoverText();
            draw_coin.drawHoverText();
            draw_portal.drawHoverText();
            if (!level.stages.get(currentStageIndex).type.equals("3Dstage")) {
              draw_sloap.drawHoverText();
              draw_holoTriangle.drawHoverText();
              draw_dethPlane.drawHoverText();
              placeBlueprint.drawHoverText();
              goonEntity.drawHoverText();
            }//end of level is not 3D
            playSound.drawHoverText();

            sign.drawHoverText();
            select.drawHoverText();
            logicButtonButton.drawHoverText();
            
          }//end of not 3d mode

          saveLevel.drawHoverText();


          if (level.stages.get(currentStageIndex).type.equals("3Dstage")) {

            if (!e3DMode) {
              toggle3DMode.setColor(255, 203);
              toggle3DMode.draw();

              playPauseButton.draw();
              fill(0);
              stroke(0);
              strokeWeight(0);
              if (simulating) {
                rect(50, 50+100, 8, 30);
                rect(70, 50+100, 8, 30);
              } else {
                triangle(50, 50+100, 75, 65+100, 50, 80+100);
              }

              strokeWeight(0);
              if (ground) {
                groundButton.setColor(255, #F2F258);
              } else {
                groundButton.setColor(255, 203);
              }
              groundButton.draw();
              fill(-7254783);
              stroke(-7254783);
              rect(100, 70+100, 50, 20);
              fill(-16732415);
              stroke(-16732415);
              rect(100, 60+100, 50, 10);
              exitStageEdit.draw();
              textAlign(LEFT, BOTTOM);

              if (grid_mode) {
                gridModeButton.setColor(255, #F2F258);
              } else {
                gridModeButton.setColor(255, 203);
              }
              gridModeButton.draw();
              textSize(20);
              fill(0);
              stroke(0);
              strokeWeight(1);
              line(410, 42+100, 410, 87+100);
              line(420, 42+100, 420, 87+100);
              line(430, 42+100, 430, 87+100);
              line(440, 42+100, 440, 87+100);
              line(402, 50+100, 448, 50+100);
              line(402, 60+100, 448, 60+100);
              line(402, 70+100, 448, 70+100);
              line(402, 80+100, 448, 80+100);
              text(grid_size, 410, 80+100);
              strokeWeight(0);
              if (deleteing) {
                deleteButton.setColor(255, #F2F258);
              } else {
                deleteButton.setColor(255, 203);
              }
              deleteButton.draw();
              fill(203);
              stroke(203);
              strokeWeight(0);
              rect(285, 55+100, 40, 5);
              rect(300, 50+100, 10, 5);
              rect(290, 60+100, 5, 20);
              rect(290, 80+100, 30, 5);
              rect(315, 60+100, 5, 20);
              rect(298, 60+100, 5, 20);
              rect(307, 60+100, 5, 20);

              if (moving_player) {
                movePlayerButton.setColor(255, #F2F258);
              } else {
                movePlayerButton.setColor(255, 203);
              }
              movePlayerButton.draw();
              strokeWeight(0);
              draw_mann(365, 88+100, 1, 0.6, "red");






              if (check_point) {
                checkpointButton.setColor(255, #F2F258);
              } else {
                checkpointButton.setColor(255, 203);
              }
              checkpointButton.draw();
              fill(#B9B9B9);
              strokeWeight(0);
              rect(168, 45+100, 5, 40);
              fill(#EA0202);
              stroke(#EA0202);
              strokeWeight(0);
              triangle(170, 85-60+20+100, 170, 85-40+20+100, 170+30, 85-50+20+100);



              if (holo_gram) {
                holoButton.setColor(255, #F2F258);
              } else {
                holoButton.setColor(255, 203);
              }
              holoButton.draw();

              if (draw3DSwitch1) {
                switch3D1.setColor(255, #F2F258);
              } else {
                switch3D1.setColor(255, 203);
              }
              switch3D1.draw();
              draw3DSwitch1(905, 80+100, 1);

              if (draw3DSwitch2) {
                switch3D2.setColor(255, #F2F258);
              } else {
                switch3D2.setColor(255, 203);
              }
              switch3D2.draw();
              draw3DSwitch2(965, 80+100, 1);

              if (drawingPortal) {
                draw_portal.setColor(255, #F2F258);
              } else {
                draw_portal.setColor(255, 203);
              }
              draw_portal.draw();
              drawPortal(665, 65+100, 0.45);

              if (drawCoins) {
                draw_coin.setColor(255, #F2F258);
              } else {
                draw_coin.setColor(255, 203);
              }
              draw_coin.draw();
              drawCoin(605, 65+100, 4);

              saveLevel.draw();
              
              if (selectingBlueprint) {
                placeBlueprint.setColor(#0F1AD3, #F2F258);
              } else {
                placeBlueprint.setColor(#0F1AD3, 203);
              }
              placeBlueprint.draw();
              
              
              textAlign(LEFT, BOTTOM);
              toggle3DMode.drawHoverText();
              switch3D1.drawHoverText();
              switch3D2.drawHoverText();
              checkpointButton.drawHoverText();
              draw_portal.drawHoverText();
              if (holoButton.isMouseOver()) {//this one has to stay
                stroke(0);
                fill(200);
                strokeWeight(2);
                rect(mouseX-4, mouseY-13, 165, 16);
                fill(0);
                textSize(15);
                text("hologram (solid in 3D)", mouseX, mouseY+5);
              }
              draw_coin.drawHoverText();
              saveLevel.drawHoverText();
              textAlign(LEFT, BOTTOM);
              playPauseButton.drawHoverText();
              groundButton.drawHoverText();
              exitStageEdit.drawHoverText();
              gridModeButton.drawHoverText();
              deleteButton.drawHoverText();
              placeBlueprint.drawHoverText();
            }//end of if not in 3D mode
            else {
              toggle3DMode.setColor(255, #F2F258);
              toggle3DMode.draw();
              if (grid_mode) {
                gridModeButton.setColor(255, #F2F258);
              } else {
                gridModeButton.setColor(255, 203);
              }
              gridModeButton.draw();
              textSize(20);
              fill(0);
              stroke(0);
              strokeWeight(1);
              line(410, 42+100, 410, 87+100);
              line(420, 42+100, 420, 87+100);
              line(430, 42+100, 430, 87+100);
              line(440, 42+100, 440, 87+100);
              line(402, 50+100, 448, 50+100);
              line(402, 60+100, 448, 60+100);
              line(402, 70+100, 448, 70+100);
              line(402, 80+100, 448, 80+100);
              text(grid_size, 410, 80+100);
              strokeWeight(0);

              if (current3DTransformMode==2&&selecting) {
                size3DButton.setColor(255, #F2F258);
              } else {
                size3DButton.setColor(255, 203);
              }
              size3DButton.draw();
              if (current3DTransformMode==1&&selecting) {
                move3DButton.setColor(255, #F2F258);
              } else {
                move3DButton.setColor(255, 203);
              }
              move3DButton.draw();
              strokeWeight(0);
              if (ground) {
                groundButton.setColor(255, #F2F258);
              } else {
                groundButton.setColor(255, 203);
              }
              groundButton.draw();
              fill(-7254783);
              stroke(-7254783);
              rect(100, 70+100, 50, 20);
              fill(-16732415);
              stroke(-16732415);
              rect(100, 60+100, 50, 10);
              if (holo_gram) {
                holoButton.setColor(255, #F2F258);
              } else {
                holoButton.setColor(255, 203);
              }
              holoButton.draw();
              if (check_point) {
                checkpointButton.setColor(255, #F2F258);
              } else {
                checkpointButton.setColor(255, 203);
              }
              checkpointButton.draw();
              fill(#B9B9B9);
              strokeWeight(0);
              rect(168, 45+100, 5, 40);
              fill(#EA0202);
              stroke(#EA0202);
              strokeWeight(0);
              triangle(170, 85-60+20+100, 170, 85-40+20+100, 170+30, 85-50+20+100);
              if (drawCoins) {
                draw_coin.setColor(255, #F2F258);
              } else {
                draw_coin.setColor(255, 203);
              }
              draw_coin.draw();
              drawCoin(605, 65+100, 4);
              if (draw3DSwitch1) {
                switch3D1.setColor(255, #F2F258);
              } else {
                switch3D1.setColor(255, 203);
              }
              switch3D1.draw();
              draw3DSwitch1(905, 80+100, 1);

              if (draw3DSwitch2) {
                switch3D2.setColor(255, #F2F258);
              } else {
                switch3D2.setColor(255, 203);
              }
              switch3D2.draw();
              draw3DSwitch2(965, 80+100, 1);
              if (drawingSign) {
                sign.setColor(255, #F2F258);
              } else {
                sign.setColor(255, 203);
              }
              sign.draw();
              drawSign(sign.x+sign.lengthX/2, sign.y+sign.lengthY, 0.6);
              if (placingLogicButton) {
                logicButtonButton.setColor(255, #F2F258);
              } else {
                logicButtonButton.setColor(255, 203);
              }
              logicButtonButton.draw();
              drawLogicButton(this, logicButtonButton.x+logicButtonButton.lengthX/2, logicButtonButton.y+logicButtonButton.lengthY/2, 1, false);
              if (deleteing) {
                deleteButton.setColor(255, #F2F258);
              } else {
                deleteButton.setColor(255, 203);
              }
              deleteButton.draw();
              fill(203);
              stroke(203);
              strokeWeight(0);
              rect(285, 55+100, 40, 5);
              rect(300, 50+100, 10, 5);
              rect(290, 60+100, 5, 20);
              rect(290, 80+100, 30, 5);
              rect(315, 60+100, 5, 20);
              rect(298, 60+100, 5, 20);
              rect(307, 60+100, 5, 20);
              
              if (selectingBlueprint) {
                placeBlueprint.setColor(#0F1AD3, #F2F258);
                if(blueprints.length!=0)
                  placeBlueprint3DButton.draw();
              } else {
                placeBlueprint.setColor(#0F1AD3, 203);
              }
              placeBlueprint.draw();
              

              move3DButton.drawHoverText();
              size3DButton.drawHoverText();
              gridModeButton.drawHoverText();
              toggle3DMode.drawHoverText();
              groundButton.drawHoverText();
              if (holoButton.isMouseOver()) {//this one has to stay
                stroke(0);
                fill(200);
                strokeWeight(2);
                rect(mouseX-4, mouseY-13, 165, 16);
                fill(0);
                textSize(15);
                textAlign(LEFT, BOTTOM);
                text("hologram (solid in 3D)", mouseX, mouseY+5);
              }
              checkpointButton.drawHoverText();
              draw_coin.drawHoverText();
              switch3D1.drawHoverText();
              switch3D2.drawHoverText();
              sign.drawHoverText();
              logicButtonButton.drawHoverText();
              deleteButton.drawHoverText();
              placeBlueprint.drawHoverText();
              if (selectingBlueprint && blueprints.length != 0) {
                placeBlueprint3DButton.drawHoverText();
              }
              
            }
          }//end of if stage is 3D

          if (selectingBlueprint) {
            textAlign(CENTER, CENTER);
            if (blueprints.length==0) {
              fill(0);
              textSize(25);
              text("you have no blueprints", width/2, height*0.7);
            } else {
              fill(0);
              textSize(25);
              text(blueprints[currentBluieprintIndex].name, width/2, height*0.7);
              if (currentBluieprintIndex>0)
                prevBlueprint.draw();
              if (currentBluieprintIndex<blueprints.length-1)
                nexBlueprint.draw();
            }
          }
          if (level.multyplayerMode==2) {
            fill(0);
            textSize(20);
            textAlign(LEFT, CENTER);
            text("current player:            "+currentPlayer, 200, 120);
            if (currentPlayer>0)
              prevousPlayerButton.draw();
            if (currentPlayer<level.maxPLayers-1)
              nextPlayerButton.draw();
          }
        }//end of if edditing
        else if (editingBlueprint) {
          if (workingBlueprint.type.equals("blueprint")) {
            strokeWeight(0);
            if (ground) {
              groundButton.setColor(255, #F2F258);
            } else {
              groundButton.setColor(255, 203);
            }
            groundButton.draw();
            fill(-7254783);
            stroke(-7254783);
            rect(100, 70+100, 50, 20);
            fill(-16732415);
            stroke(-16732415);
            rect(100, 60+100, 50, 10);

            strokeWeight(0);
            if (check_point) {
              checkpointButton.setColor(255, #F2F258);
            } else {
              checkpointButton.setColor(255, 203);
            }
            checkpointButton.draw();
            fill(#B9B9B9);
            strokeWeight(0);
            rect(168, 45+100, 5, 40);
            fill(#EA0202);
            stroke(#EA0202);
            strokeWeight(0);
            triangle(170, 85-60+20+100, 170, 85-40+20+100, 170+30, 85-50+20+100);
            strokeWeight(0);

            textAlign(LEFT, BOTTOM);

            if (grid_mode) {
              gridModeButton.setColor(255, #F2F258);
            } else {
              gridModeButton.setColor(255, 203);
            }
            gridModeButton.draw();
            textSize(20);
            fill(0);
            stroke(0);
            strokeWeight(1);
            line(410, 42+100, 410, 87+100);
            line(420, 42+100, 420, 87+100);
            line(430, 42+100, 430, 87+100);
            line(440, 42+100, 440, 87+100);
            line(402, 50+100, 448, 50+100);
            line(402, 60+100, 448, 60+100);
            line(402, 70+100, 448, 70+100);
            line(402, 80+100, 448, 80+100);
            text(grid_size, 410, 80+100);
            strokeWeight(0);
            if (deleteing) {
              deleteButton.setColor(255, #F2F258);
            } else {
              deleteButton.setColor(255, 203);
            }
            deleteButton.draw();
            fill(203);
            stroke(203);
            strokeWeight(0);
            rect(285, 55+100, 40, 5);
            rect(300, 50+100, 10, 5);
            rect(290, 60+100, 5, 20);
            rect(290, 80+100, 30, 5);
            rect(315, 60+100, 5, 20);
            rect(298, 60+100, 5, 20);
            rect(307, 60+100, 5, 20);

            if (drawCoins) {
              draw_coin.setColor(255, #F2F258);
            } else {
              draw_coin.setColor(255, 203);
            }
            draw_coin.draw();
            drawCoin(605, 65+100, 4);

            if (sloap) {
              draw_sloap.setColor(255, #F2F258);
            } else {
              draw_sloap.setColor(255, 203);
            }//draw_holoTriangle
            draw_sloap.draw();
            fill(-7254783);
            stroke(-7254783);
            strokeWeight(0);
            triangle(705, 85+100, 745, 85+100, 745, 45+100);
            if (holoTriangle) {
              draw_holoTriangle.setColor(255, #F2F258);
            } else {
              draw_holoTriangle.setColor(255, 203);
            }//draw_holoTriangle
            draw_holoTriangle.draw();
            fill(-4623063);
            stroke(-4623063);
            strokeWeight(0);
            triangle(765, 85+100, 805, 85+100, 805, 45+100);
            if (holo_gram) {
              holoButton.setColor(255, #F2F258);
            } else {
              holoButton.setColor(255, 203);
            }
            holoButton.draw();
            saveLevel.draw();
            exitStageEdit.draw();

            textAlign(LEFT, BOTTOM);
            groundButton.drawHoverText();
            gridModeButton.drawHoverText();
            deleteButton.drawHoverText();
            holoButton.drawHoverText();
            draw_coin.drawHoverText();
            saveLevel.drawHoverText();
            checkpointButton.drawHoverText();
            draw_sloap.drawHoverText();
            draw_holoTriangle.drawHoverText();
            exitStageEdit.drawHoverText();
          }//end of type is blueprint
          else if (workingBlueprint.type.equals("3D blueprint")) {
            strokeWeight(0);
            if (ground) {
              groundButton.setColor(255, #F2F258);
            } else {
              groundButton.setColor(255, 203);
            }
            groundButton.draw();
            fill(-7254783);
            stroke(-7254783);
            rect(100, 70+100, 50, 20);
            fill(-16732415);
            stroke(-16732415);
            rect(100, 60+100, 50, 10);

            strokeWeight(0);
            if (check_point) {
              checkpointButton.setColor(255, #F2F258);
            } else {
              checkpointButton.setColor(255, 203);
            }
            checkpointButton.draw();
            fill(#B9B9B9);
            strokeWeight(0);
            rect(168, 45+100, 5, 40);
            fill(#EA0202);
            stroke(#EA0202);
            strokeWeight(0);
            triangle(170, 85-60+20+100, 170, 85-40+20+100, 170+30, 85-50+20+100);
            strokeWeight(0);

            textAlign(LEFT, BOTTOM);

            if (grid_mode) {
              gridModeButton.setColor(255, #F2F258);
            } else {
              gridModeButton.setColor(255, 203);
            }
            gridModeButton.draw();
            textSize(20);
            fill(0);
            stroke(0);
            strokeWeight(1);
            line(410, 42+100, 410, 87+100);
            line(420, 42+100, 420, 87+100);
            line(430, 42+100, 430, 87+100);
            line(440, 42+100, 440, 87+100);
            line(402, 50+100, 448, 50+100);
            line(402, 60+100, 448, 60+100);
            line(402, 70+100, 448, 70+100);
            line(402, 80+100, 448, 80+100);
            text(grid_size, 410, 80+100);
            strokeWeight(0);
            if (deleteing) {
              deleteButton.setColor(255, #F2F258);
            } else {
              deleteButton.setColor(255, 203);
            }
            deleteButton.draw();
            fill(203);
            stroke(203);
            strokeWeight(0);
            rect(285, 55+100, 40, 5);
            rect(300, 50+100, 10, 5);
            rect(290, 60+100, 5, 20);
            rect(290, 80+100, 30, 5);
            rect(315, 60+100, 5, 20);
            rect(298, 60+100, 5, 20);
            rect(307, 60+100, 5, 20);

            if (drawCoins) {
              draw_coin.setColor(255, #F2F258);
            } else {
              draw_coin.setColor(255, 203);
            }
            draw_coin.draw();
            drawCoin(605, 65+100, 4);
            
            if (holo_gram) {
              holoButton.setColor(255, #F2F258);
            } else {
              holoButton.setColor(255, 203);
            }
            holoButton.draw();
            saveLevel.draw();
            
            
            if (!e3DMode) {
              toggle3DMode.setColor(255, 203);
              toggle3DMode.draw();
              exitStageEdit.draw();
              
              exitStageEdit.drawHoverText();
              //end of not in 3D mode
            }else{
              toggle3DMode.setColor(255, #F2F258);
              toggle3DMode.draw();
              if (current3DTransformMode==2&&selecting) {
                size3DButton.setColor(255, #F2F258);
              } else {
                size3DButton.setColor(255, 203);
              }
              size3DButton.draw();
              if (current3DTransformMode==1&&selecting) {
                move3DButton.setColor(255, #F2F258);
              } else {
                move3DButton.setColor(255, 203);
              }
              move3DButton.draw();
              
              move3DButton.drawHoverText();
              size3DButton.drawHoverText();
            }//end of 3D mode
            textAlign(LEFT, BOTTOM);
            toggle3DMode.drawHoverText();
            groundButton.drawHoverText();
            gridModeButton.drawHoverText();
            deleteButton.drawHoverText();
            holoButton.drawHoverText();
            draw_coin.drawHoverText();
            saveLevel.drawHoverText();
            checkpointButton.drawHoverText();
            
          }//end of type is 3D blueprint
        } else if (editinglogicBoard) {
          //draw buttons
          if (connectingLogic) {
            connectLogicButton.setColor(255, #F2F258);
          } else {
            connectLogicButton.setColor(255, 203);
          }
          connectLogicButton.draw();
          if (moveLogicComponents) {
            moveComponentsButton.setColor(255, #F2F258);
          } else {
            moveComponentsButton.setColor(255, 203);
          }
          moveComponentsButton.draw();
          if (deleteing) {
            deleteButton.setColor(255, #F2F258);
          } else {
            deleteButton.setColor(255, 203);
          }
          deleteButton.draw();
          fill(203);
          stroke(203);
          strokeWeight(0);
          rect(285, 55+100, 40, 5);
          rect(300, 50+100, 10, 5);
          rect(290, 60+100, 5, 20);
          rect(290, 80+100, 30, 5);
          rect(315, 60+100, 5, 20);
          rect(298, 60+100, 5, 20);
          rect(307, 60+100, 5, 20);
          if (placingAndGate) {
            andGateButton.setColor(255, #F2F258);
          } else {
            andGateButton.setColor(255, 203);
          }
          andGateButton.draw();
          if (placingOrGate) {
            orGateButton.setColor(255, #F2F258);
          } else {
            orGateButton.setColor(255, 203);
          }
          orGateButton.draw();
          if (placingXorGate) {
            xorGateButton.setColor(255, #F2F258);
          } else {
            xorGateButton.setColor(255, 203);
          }
          xorGateButton.draw();
          saveLevel.draw();
          exitStageEdit.draw();
          if (placingNandGate) {
            nandGateButton.setColor(255, #F2F258);
          } else {
            nandGateButton.setColor(255, 203);
          }
          nandGateButton.draw();
          if (placingNorGate) {
            norGateButton.setColor(255, #F2F258);
          } else {
            norGateButton.setColor(255, 203);
          }
          norGateButton.draw();
          if (placingXnorGate) {
            xnorGateButton.setColor(255, #F2F258);
          } else {
            xnorGateButton.setColor(255, 203);
          }
          xnorGateButton.draw();
          //if(placingTestLogic){///////////////////////////////////////////////////////////////////////
          //  testLogicPlaceButton.setColor(255, #F2F258);
          //}else{
          //  testLogicPlaceButton.setColor(255, 203);
          //}
          //testLogicPlaceButton.draw();
          if (placingOnSingal) {
            constantOnButton.setColor(255, #F2F258);
          } else {
            constantOnButton.setColor(255, 203);
          }
          constantOnButton.draw();
          if (placingReadVariable) {
            readVariableButton.setColor(255, #F2F258);
          } else {
            readVariableButton.setColor(255, 203);
          }
          readVariableButton.draw();
          if (placingSetVaravle) {
            setVariableButton.setColor(255, #F2F258);
          } else {
            setVariableButton.setColor(255, 203);
          }
          setVariableButton.draw();
          if (selecting) {
            select.setColor(255, #F2F258);
          } else {
            select.setColor(255, 203);
          }
          select.draw();
          if (placingSetVisibility) {
            setVisabilityButton.setColor(255, #F2F258);
          } else {
            setVisabilityButton.setColor(255, 203);
          }
          setVisabilityButton.draw();
          if (placingXOffset) {
            xOffsetButton.setColor(255, #F2F258);
          } else {
            xOffsetButton.setColor(255, 203);
          }
          xOffsetButton.draw();
          if (placingYOffset) {
            yOffsetButton.setColor(255, #F2F258);
          } else {
            yOffsetButton.setColor(255, 203);
          }
          yOffsetButton.draw();
          if (placingDelay) {
            delayButton.setColor(255, #F2F258);
          } else {
            delayButton.setColor(255, 203);
          }
          delayButton.draw();
          if (placingZOffset) {
            zOffsetButton.setColor(255, #F2F258);
          } else {
            zOffsetButton.setColor(255, 203);
          }
          zOffsetButton.draw();
          logicHelpButton.draw();
          if (placing3Dsetter) {
            set3DButton.setColor(255, #F2F258);
          } else {
            set3DButton.setColor(255, 203);
          }
          set3DButton.draw();
          if (placing3Dreader) {
            read3DButton.setColor(255, #F2F258);
          } else {
            read3DButton.setColor(255, 203);
          }
          read3DButton.draw();
          if (placingPlaySoundLogic) {
            playLogicSoundButton.setColor(255, #F2F258);
          } else {
            playLogicSoundButton.setColor(255, 203);
          }
          playLogicSoundButton.draw();
          drawSpeakericon(this, playLogicSoundButton.x+playLogicSoundButton.lengthX/2, playLogicSoundButton.y+playLogicSoundButton.lengthY/2, 0.5);

          if (placingPulse) {
            pulseButton.setColor(255, #F2F258);
          } else {
            pulseButton.setColor(255, 203);
          }
          pulseButton.draw();

          if (placingRandom) {
            randomButton.setColor(255, #F2F258);
          } else {
            randomButton.setColor(255, 203);
          }
          randomButton.draw();

          //draw hover text
          connectLogicButton.drawHoverText();
          moveComponentsButton.drawHoverText();
          deleteButton.drawHoverText();
          andGateButton.drawHoverText();
          orGateButton.drawHoverText();
          xorGateButton.drawHoverText();
          exitStageEdit.drawHoverText();
          saveLevel.drawHoverText();
          nandGateButton.drawHoverText();
          norGateButton.drawHoverText();
          xnorGateButton.drawHoverText();
          // testLogicPlaceButton.drawHoverText();
          constantOnButton.drawHoverText();
          readVariableButton.drawHoverText();
          setVariableButton.drawHoverText();
          setVisabilityButton.drawHoverText();
          xOffsetButton.drawHoverText();
          yOffsetButton.drawHoverText();
          delayButton.drawHoverText();
          zOffsetButton.drawHoverText();
          logicHelpButton.drawHoverText();
          read3DButton.drawHoverText();
          set3DButton.drawHoverText();
          playLogicSoundButton.drawHoverText();
          pulseButton.drawHoverText();
          randomButton.drawHoverText();
        } else {
          fill(0);
          textSize(20);
          text("you are not currently editing a stage", 300, 300);
        }
      }//end of if page is tools
      if (page.equals("selection")) {
        background(#790101);
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();

        if (selectedIndex==-1) {//if nothing is selected
          fill(0);
          textSize(20);
          textAlign(CENTER, CENTER);
          text("nothing is selected", width/2, height/2);
        } else {
          String type="";
          StageComponent thing= new GenericStageComponent();
          LogicComponent logicThing=new GenericLogicComponent(-10, -10, null);
          if (editingStage) {
            thing= level.stages.get(currentStageIndex).parts.get(selectedIndex);
            type=thing.type;
          }
          if (editinglogicBoard) {
            logicThing=level.logicBoards.get(logicBoardIndex).components.get(selectedIndex);
            type=logicThing.type;
          }
          if (type.equals("WritableSign")) {//if the current selected object is a sign
            fill(0);
            textSize(25);
            textAlign(CENTER, CENTER);
            text("sign contents", width/2, height*0.2);
            textAlign(CENTER, TOP);
            String contents=thing.getData();
            if (typingSign) {
              contents+=coursorr;
            }
            text(contents, width/2, height*0.25);
            rect(width*0.05, height*0.29, width*0.9, 2);
          } else if (type.equals("sound box")) {
            if (level.sounds.size()==0) {
              fill(0);
              textSize(20);
              textAlign(CENTER, CENTER);
              text("this level does not have any sounds currently", width/2, height/2);
            } else {
              int fileind=0;
              String[] keys=new String[0];
              keys=level.sounds.keySet().toArray(keys);
              String current=thing.getData();
              for (int i=0; i<keys.length; i++) {
                if (keys[i].equals(current)) {
                  fileind=i;
                  break;
                }
              }
              fill(0);
              textSize(25);
              text("current sound: "+keys[fileind], width/2, height*0.4);
              thing.setData(keys[fileind]);
              if (fileind>0)
                prevSound.draw();
              if (fileind<keys.length-1)
                nextSound.draw();
            }
          } else if (type.equals("read var")||type.equals("set var")) {
            int curvar=logicThing.getData();
            if (curvar>0)
              prevSound.draw();
            if (curvar<level.variables.size()-1)
              nextSound.draw();
            fill(0);
            textSize(25);
            text("b"+curvar, width/2, height*0.4);
            text("current variable", width/2, height*0.36);
          } else if (type.equals("set visable")) {
            int curgroop=logicThing.getData();
            if (curgroop>0)
              prevSound.draw();
            if (curgroop<level.groups.size()-1)
              nextSound.draw();
            fill(0);
            textSize(25);
            text(level.groupNames.get(curgroop), width/2, height*0.4);
            text("current group", width/2, height*0.36);
          } else if (type.equals("x-offset")) {
            int curgroop=logicThing.getData();
            if (curgroop>0)
              prevSound.draw();
            if (curgroop<level.groups.size()-1)
              nextSound.draw();
            fill(0);
            textSize(25);
            text(level.groupNames.get(curgroop), width/2, height*0.4);
            text("current group", width/2, height*0.36);
            text("offset", width/2, height*0.46);
            text(((SetXOffset)logicThing).getOffset(), width/2, height*0.53);
            increase.draw();
            increaseMore.draw();
            increaseAlot.draw();
            decrease.draw();
            decreaseMore.draw();
            decreaseAlot.draw();
          } else if (type.equals("y-offset")) {
            int curgroop=logicThing.getData();
            if (curgroop>0)
              prevSound.draw();
            if (curgroop<level.groups.size()-1)
              nextSound.draw();
            fill(0);
            textSize(25);
            text(level.groupNames.get(curgroop), width/2, height*0.4);
            text("current group", width/2, height*0.36);
            text("offset", width/2, height*0.46);
            text(((SetYOffset)logicThing).getOffset(), width/2, height*0.53);
            increase.draw();
            increaseMore.draw();
            increaseAlot.draw();
            decrease.draw();
            decreaseMore.draw();
            decreaseAlot.draw();
          } else if (type.equals("z-offset")) {
            int curgroop=logicThing.getData();
            if (curgroop>0)
              prevSound.draw();
            if (curgroop<level.groups.size()-1)
              nextSound.draw();
            fill(0);
            textSize(25);
            text(level.groupNames.get(curgroop), width/2, height*0.4);
            text("current group", width/2, height*0.36);
            text("offset", width/2, height*0.46);
            text(((SetZOffset)logicThing).getOffset(), width/2, height*0.53);
            increase.draw();
            increaseMore.draw();
            increaseAlot.draw();
            decrease.draw();
            decreaseMore.draw();
            decreaseAlot.draw();
          } else if (type.equals("logic button")) {
            int curvar=thing.getDataI();
            if (curvar>0)
              prevSound.draw();
            if (curvar<level.variables.size()-1)
              nextSound.draw();
            fill(0);
            textSize(25);
            if (curvar==-1) {
              text("none", width/2, height*0.4);
            } else {
              text("b"+curvar, width/2, height*0.4);
            }
            text("current variable", width/2, height*0.36);
          } else if (type.equals("delay")) {
            fill(0);
            textSize(25);
            text("delay in ticks (50tps)", width/2, height*0.46);
            text(logicThing.getData(), width/2, height*0.53);
            increase.draw();
            increaseMore.draw();
            increaseAlot.draw();
            if (logicThing.getData()>1)
              decrease.draw();
            if (logicThing.getData()>10)
              decreaseMore.draw();
            if (logicThing.getData()>100)
              decreaseAlot.draw();
          } else if (type.equals("play sound")) {
            if (level.sounds.size()==0) {
              fill(0);
              textSize(20);
              textAlign(CENTER, CENTER);
              text("this level does not have any sounds currently", width/2, height/2);
            } else {
              String[] keys=new String[0];
              keys=level.sounds.keySet().toArray(keys);
              int currenti=logicThing.getData();
              fill(0);
              textSize(25);
              if (currenti<0) {
                text("no sound selected", width/2, height*0.4);
              } else {
                text("current sound: "+keys[currenti], width/2, height*0.4);
              }
              if (currenti>0)
                prevSound.draw();
              if (currenti<keys.length-1)
                nextSound.draw();
            }
          } else {
            fill(0);
            textSize(20);
            textAlign(CENTER, CENTER);
            text("this object does not have any outher\nproperties that can be changed", width/2, height/2);
          }
          if (editingStage) {//component group selector
            fill(0);
            textSize(20);
            textAlign(CENTER, CENTER);
            text("set group:", width/2, height*0.86);
            if (thing.group==-1)
              text("none", width/2, height*0.9);
            else {
              text(level.groupNames.get(thing.group), width/2, height*0.9);
            }
            if (thing.group<level.groups.size()-1)
              nextGroup.draw();
            if (thing.group>-1)
              prevGroup.draw();
          }
        }//end of thing is selected
      }//end of selection page
      if (page.equals("stage settings")) {
        background(#92CED8);
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();
        if (editingStage) {
          fill(0);
          textSize(25);
          textAlign(LEFT, CENTER);
          text("stage name: "+level.stages.get(currentStageIndex).name, 50, 150);
          text("sky color: ", 50, 180);
          skyColorB1.setColor(level.stages.get(currentStageIndex).skyColor, 0);
          skyColorB1.draw();
          resetSkyColor.draw();
        } else {//end of editing stage
          fill(0);
          textSize(30);
          textAlign(CENTER, CENTER);
          text("you are not currently editing a stage", width/2, height/2);
        }//end of not editing stage
      }//end of stage settings page
      if (page.equals("variables and groups")) {
        background(#FCC740);
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();
        fill(0);
        textSize(25);
        textAlign(LEFT, CENTER);
        if (level!=null) {
          text("variables", 80, 200);
          text("groups", 560, 200);
          for (int i=0; i<10&&i+variableScroll<level.variables.size(); i++) {
            fill(0);
            text("b"+(i+variableScroll), 90, 230+i*21);
            if (level.variables.get(i+variableScroll)) {
              fill(#3FB700);
            } else {
              fill(#E30505);
            }
            rect(70, 225+i*21, 20, 20);
          }
          if (variableScroll>0)
            variablesUP.draw();
          if (variableScroll+10<level.variables.size())
            variablesDOWN.draw();
          textSize(25);
          textAlign(LEFT, CENTER);
          for (int i=0; i+groupScroll<level.groupNames.size()&&i<10; i++) {
            fill(0);
            text(level.groupNames.get(i+groupScroll), 565, 230+i*21);
          }
          if (groupScroll>0)
            groupsUP.draw();
          if (groupScroll+10<level.groupNames.size())
            groupsDOWN.draw();
          addVariable.draw();
          addGroup.draw();
          fill(0);
          //typeGroopName.draw();
          rect(680, 220, 400, 1);
          textSize(20);
          textAlign(LEFT, BOTTOM);
          if (typingGroopName)
            text(newGroopName+coursorr, 680, 218);
          else
            text(newGroopName, 680, 218);
          runLoad.draw();

          if (editinglogicBoard) {
            tickLogicButton.draw();
            tickLogicButton.drawHoverText();
          }
          runLoad.drawHoverText();
        }//end of editing level
      }//end of variables and groups
      if (page.equals("level settings")) {
        background(#BA90FF);
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();

        if (level==null||!(editingStage||levelOverview)) {
          textAlign(CENTER, CENTER);
          fill(0);
          textSize(25);
          text("no level loaded", width/2, height/2);
        } else {
          textSize(20);
          fill(0);
          textAlign(LEFT, CENTER);
          text("level name: "+level.name, 50, 150);
          text("multyplayer mode:", 50, 200);
          if (level.multyplayerMode==1) {
            multyplayerModeCoOpButton.setColor(255, 100);
            multyplayerModeSpeedrunButton.setColor(255, #F6FF03);
            currentNumberOfPlayers=1;
          }
          if (level.multyplayerMode==2) {
            multyplayerModeCoOpButton.setColor(255, #F6FF03);
            multyplayerModeSpeedrunButton.setColor(255, 100);
          }

          multyplayerModeCoOpButton.draw();
          multyplayerModeSpeedrunButton.draw();

          if (level.multyplayerMode==2) {
            textSize(20);
            fill(0);
            textAlign(LEFT, CENTER);
            text("min players:", 50, 250);
            text("max players:", 50, 300);
            text(level.minPlayers, 200, 250);
            text(level.maxPLayers, 200, 300);
            currentNumberOfPlayers=level.maxPLayers;
            if (level.minPlayers<level.maxPLayers)
              minplayersIncrease.draw();
            if (level.minPlayers>2)
              minPlayersDecrease.draw();
            if (level.maxPLayers<10)
              maxplayersIncrease.draw();
            if (level.maxPLayers>level.minPlayers)
              maxplayersDecrease.draw();
          }
          respawnEntitiesButton.draw();
        }
      }//end of page is level settings
    } else {
      background(200);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("Ignore this window!\nDue to API limitations it can not be closed.", width/2, height/2);
    }
  }//end of draw

  public void mouseClicked() {
    if (levelCreator) {
      if (page.equals("colors")) {
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 150 && mouseY <= 200) {
          rsp=mouseX-75;
        }
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 300 && mouseY <= 350) {
          gsp=mouseX-75;
        }
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 450 && mouseY <= 500) {
          bsp=mouseX-75;
        }
        if (mouseX >= 600 && mouseX <=680 && mouseY >= 600 && mouseY <=680) {
          JSONObject colo=colors.getJSONObject(selectedColor);
          rsp=(int)Math.ceil(colo.getInt("red")/255.0*1080);
          gsp=(int)Math.ceil(colo.getInt("green")/255.0*1080);
          bsp=(int)Math.ceil(colo.getInt("blue")/255.0*1080);
        }
        if (mouseX >= 500 && mouseX <= 550 && mouseY >= 600 && mouseY <=680&&selectedColor>0) {
          selectedColor--;
        }

        if (mouseX >= 730 && mouseX <= 780 && mouseY >= 600 && mouseY <=680&&selectedColor<colors.size()-1) {
          selectedColor++;
        }
        if (mouseX >= 600 && mouseX <=680  && mouseY >= 560 && mouseY <=590) {
          JSONObject colo=new JSONObject();
          colo.setInt("red", redVal);
          colo.setInt("green", greenVal);
          colo.setInt("blue", blueVal);
          colors.setJSONObject(colors.size(), colo);
          saveColors=true;
        }
        if (settingSkyColor) {
          if (setSkyColor.isMouseOver()) {
            settingSkyColor=false;
            page="stage settings";
            level.stages.get(currentStageIndex).skyColor=CC;
          }
        }
      }//end of if pages is colors

      if (colorPage.isMouseOver()) {
        page="colors";
      }
      if (toolsPage.isMouseOver()) {
        page="tools";
      }
      if (selectionPage.isMouseOver()) {
        page="selection";
      }
      if (stageSettings.isMouseOver()) {
        page="stage settings";
      }
      if (variablesAndGroups.isMouseOver()) {
        page="variables and groups";
      }
      if (levelSettingsPage.isMouseOver()) {
        page="level settings";
      }

      if (page.equals("tools")) {
        if (editingStage) {
          if (level.stages.get(currentStageIndex).type.equals("stage")) {
            if (draw_coin.isMouseOver()) {
              turnThingsOff();
              drawCoins=true;
            }
            if (draw_portal.isMouseOver()) {
              turnThingsOff();
              drawingPortal=true;
            }
            if (draw_sloap.isMouseOver()) {
              turnThingsOff();
              sloap=true;
            }
            if (draw_holoTriangle.isMouseOver()) {
              turnThingsOff();
              holoTriangle=true;
            }
            if (draw_dethPlane.isMouseOver()) {
              turnThingsOff();
              dethPlane=true;
            }

            if (playPauseButton.isMouseOver()) {
              simulating=!simulating;
            }


            if (groundButton.isMouseOver()) {
              turnThingsOff();
              ground=true;
            }
            if (checkpointButton.isMouseOver()) {
              turnThingsOff();
              check_point=true;
            }
            if (goalButton.isMouseOver()) {
              turnThingsOff();
              goal=true;
            }
            if (deleteButton.isMouseOver()) {
              turnThingsOff();
              deleteing=true;
            }
            if (movePlayerButton.isMouseOver()) {
              turnThingsOff();
              moving_player=true;
            }
            if (gridModeButton.isMouseOver()) {
              grid_mode=!grid_mode;
            }

            if (holoButton.isMouseOver()) {
              turnThingsOff();
              holo_gram=true;
            }

            if (exitStageEdit.isMouseOver()) {
              turnThingsOff();
              levelOverview=true;
              editingStage=false;
              level_complete=false;
              viewingItemContents=false;
            }
            if (sign.isMouseOver()) {
              turnThingsOff();
              drawingSign=true;
            }

            if (select.isMouseOver()) {
              turnThingsOff();
              selecting=true;
            }
            if (logicButtonButton.isMouseOver()) {
              turnThingsOff();
              placingLogicButton=true;
            }
            if (placeBlueprint.isMouseOver()) {
              turnThingsOff();

              String[] files=new File(appdata+"/CBi-games/skinny mann level creator/blueprints").list();
              int numofjsons=0;
              for (int i=0; i<files.length; i++) {
                if (files[i].contains(".json")) {
                  String bpType = loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]).getJSONObject(0).getString("type");
                  if(bpType.equals("blueprint"))
                    numofjsons++;
                }
              }
              blueprints=new Stage[numofjsons];
              int pointer=0;
              for (int i=0; i<files.length; i++) {
                if (files[i].contains(".json")) {
                  String bpType = loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]).getJSONObject(0).getString("type");
                  if(bpType.equals("blueprint")){
                    blueprints[pointer]=new Stage(loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]));
                    pointer++;
                  }
                }
              }
              System.out.println(blueprints.length);
              selectingBlueprint=true;
              currentBluieprintIndex=0;
            }
            if (selectingBlueprint) {
              if (currentBluieprintIndex>0&&prevBlueprint.isMouseOver())
                currentBluieprintIndex--;
              if (currentBluieprintIndex<blueprints.length-1&&nexBlueprint.isMouseOver())
                currentBluieprintIndex++;
            }
            if (playSound.isMouseOver()) {
              turnThingsOff();
              placingSound=true;
            }
            if(goonEntity.isMouseOver()){
              turnThingsOff();
              placingGoon=true;
            }
          }

          if (level.stages.get(currentStageIndex).type.equals("3Dstage")) {

            if (!e3DMode) {

              if (playPauseButton.isMouseOver()) {
                simulating=!simulating;
              }


              if (groundButton.isMouseOver()) {
                turnThingsOff();
                ground=true;
              }

              if (deleteButton.isMouseOver()) {
                turnThingsOff();
                deleteing=true;
              }

              if (gridModeButton.isMouseOver()) {
                grid_mode=!grid_mode;
              }

              if (movePlayerButton.isMouseOver()) {
                turnThingsOff();
                moving_player=true;
              }

              if (exitStageEdit.isMouseOver()) {
                turnThingsOff();
                levelOverview=true;
                editingStage=false;
                viewingItemContents=false;
              }



              if (checkpointButton.isMouseOver()) {
                turnThingsOff();
                check_point=true;
              }

              if (toggle3DMode.isMouseOver()) {
                e3DMode=true;
                turnThingsOff();
                selecting=true;
                return;
              }
              if (switch3D1.isMouseOver()) {
                turnThingsOff();
                draw3DSwitch1=true;
              }
              if (switch3D2.isMouseOver()) {
                turnThingsOff();
                draw3DSwitch2=true;
              }
              if (draw_portal.isMouseOver()) {
                turnThingsOff();
                drawingPortal=true;
              }
              if (holoButton.isMouseOver()) {
                turnThingsOff();
                holo_gram=true;
              }
              if (draw_coin.isMouseOver()) {
                turnThingsOff();
                drawCoins=true;
              }
              if (sign.isMouseOver()) {
                turnThingsOff();
                drawingSign=true;
              }
              if (select.isMouseOver()) {
                turnThingsOff();
                selecting=true;
              }
              if (logicButtonButton.isMouseOver()) {
                turnThingsOff();
                placingLogicButton=true;
              }
             
              if(goonEntity.isMouseOver()){
                turnThingsOff();
                placingGoon=true;
              }
            } else {
              if (toggle3DMode.isMouseOver()) {
                e3DMode=false;
                turnThingsOff();
              }

              if (playPauseButton.isMouseOver()) {
                simulating=!simulating;
              }

              if (sign.isMouseOver()) {
                turnThingsOff();
                drawingSign=true;
              }
              if (select.isMouseOver()) {
                turnThingsOff();
                selecting=true;
              }
              if (gridModeButton.isMouseOver()) {
                grid_mode=!grid_mode;
              }
              if (size3DButton.isMouseOver()) {
                current3DTransformMode=2;
                turnThingsOff();
                selecting=true;
              }
              if (move3DButton.isMouseOver()) {
                current3DTransformMode=1;
                turnThingsOff();
                selecting=true;
              }
              if (groundButton.isMouseOver()) {
                turnThingsOff();
                ground=true;
              }
              if (holoButton.isMouseOver()) {
                turnThingsOff();
                holo_gram=true;
              }
              if (checkpointButton.isMouseOver()) {
                turnThingsOff();
                check_point=true;
              }
              if (draw_coin.isMouseOver()) {
                turnThingsOff();
                drawCoins=true;
              }
              if (switch3D1.isMouseOver()) {
                turnThingsOff();
                draw3DSwitch1=true;
              }
              if (switch3D2.isMouseOver()) {
                turnThingsOff();
                draw3DSwitch2=true;
              }
              if (sign.isMouseOver()) {
                turnThingsOff();
                drawingSign=true;
              }
              if (logicButtonButton.isMouseOver()) {
                turnThingsOff();
                placingLogicButton=true;
              }
              if (deleteButton.isMouseOver()) {
                turnThingsOff();
                deleteing=true;
              }
              
              if (selectingBlueprint && blueprints.length != 0 && placeBlueprint3DButton.isMouseOver()) {
                StageComponent tmp;
                Stage current=level.stages.get(currentStageIndex);
                for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {//translate the objects from blueprint form into stage readdy form
                  tmp=blueprints[currentBluieprintIndex].parts.get(i);
                  //coins are special
                  if (tmp instanceof Coin) {
                    Coin g;
                    //make a copy of the coin for the apprirate dimention 
                    g=(Coin)tmp.copy(blueprintPlacemntX,blueprintPlacemntY,blueprintPlacemntZ);

                    //set the correct ID for the coin
                    g.coinId = level.numOfCoins;
                    //add the coin to the stage
                    current.parts.add(g);
                    coins.add(false);
                    level.numOfCoins++;
                    continue;
                  }
                  
                  
                  current.parts.add(tmp.copy(blueprintPlacemntX,blueprintPlacemntY,blueprintPlacemntZ));//preform a 3D copy on the curernt part and add it to the stage
                }
                  
              }
            }//end of 3D mode is on
            
            if (placeBlueprint.isMouseOver()) {
              turnThingsOff();

              String[] files=new File(appdata+"/CBi-games/skinny mann level creator/blueprints").list();
              int numofjsons=0;
              for (int i=0; i<files.length; i++) {
                if (files[i].contains(".json")) {
                  String bpType = loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]).getJSONObject(0).getString("type");
                  if(bpType.equals("3D blueprint"))
                    numofjsons++;
                }
              }
              blueprints=new Stage[numofjsons];
              int pointer=0;
              for (int i=0; i<files.length; i++) {
                if (files[i].contains(".json")) {
                  String bpType = loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]).getJSONObject(0).getString("type");
                  if(bpType.equals("3D blueprint")){
                    blueprints[pointer]=new Stage(loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]));
                    pointer++;
                  }
                }
              }
              System.out.println(blueprints.length);
              selectingBlueprint=true;
              currentBluieprintIndex=0;
              blueprintPlacemntX=cam3Dx;
              blueprintPlacemntY=cam3Dy;
              blueprintPlacemntZ=cam3Dz;
            }
          }

          if (saveLevel.isMouseOver()) {
            System.out.println("saving level");
            level.save();
            gmillis=millis()+400+millisOffset;
            System.out.println("save complete"+gmillis);
          }

          if (level.multyplayerMode==2) {
            if (currentPlayer>0&&prevousPlayerButton.isMouseOver()) {
              currentPlayer--;
              currentStageIndex=players[currentPlayer].stage;
              e3DMode=players[currentPlayer].in3D;
            }
            if (currentPlayer<level.maxPLayers-1&&nextPlayerButton.isMouseOver()) {
              currentPlayer++;
              currentStageIndex=players[currentPlayer].stage;
              e3DMode=players[currentPlayer].in3D;
            }
          }
        }//end of edditing stage
        else if (editingBlueprint) {
          if (workingBlueprint.type.equals("blueprint")) {
            if (groundButton.isMouseOver()) {
              turnThingsOff();
              ground=true;
            }

            if (deleteButton.isMouseOver()) {
              turnThingsOff();
              deleteing=true;
            }

            if (gridModeButton.isMouseOver()) {
              grid_mode=!grid_mode;
            }
            if (holoButton.isMouseOver()) {
              turnThingsOff();
              holo_gram=true;
            }
            if (draw_coin.isMouseOver()) {
              turnThingsOff();
              drawCoins=true;
            }
            if (checkpointButton.isMouseOver()) {
              turnThingsOff();
              check_point=true;
            }
            if (draw_sloap.isMouseOver()) {
              turnThingsOff();
              sloap=true;
            }
            if (draw_holoTriangle.isMouseOver()) {
              turnThingsOff();
              holoTriangle=true;
            }
            if (saveLevel.isMouseOver()) {
              System.out.println("saving blueprint");
              workingBlueprint.save();
              gmillis=millis()+400+millisOffset;
              System.out.println("save complete"+gmillis);
            }
            if (exitStageEdit.isMouseOver()) {
              levelCreator=false;
              editingBlueprint=false;
            }
          }//end of type is blueprint
          else if (workingBlueprint.type.equals("3D blueprint")) {
            if (groundButton.isMouseOver()) {
              turnThingsOff();
              ground=true;
            }

            if (deleteButton.isMouseOver()) {
              turnThingsOff();
              deleteing=true;
            }

            if (gridModeButton.isMouseOver()) {
              grid_mode=!grid_mode;
            }
            if (holoButton.isMouseOver()) {
              turnThingsOff();
              holo_gram=true;
            }
            if (draw_coin.isMouseOver()) {
              turnThingsOff();
              drawCoins=true;
            }
            if (checkpointButton.isMouseOver()) {
              turnThingsOff();
              check_point=true;
            }
            
            if (saveLevel.isMouseOver()) {
              System.out.println("saving blueprint");
              workingBlueprint.save();
              gmillis=millis()+400+millisOffset;
              System.out.println("save complete"+gmillis);
            }
            if (!e3DMode) {
              if (exitStageEdit.isMouseOver()) {
                levelCreator=false;
                editingBlueprint=false;
              }
              
              if (toggle3DMode.isMouseOver()) {
                e3DMode=true;
                turnThingsOff();
                selecting=true;
                return;
              }
              //end of 3D mode off
            }else{
              if (toggle3DMode.isMouseOver()) {
                e3DMode=false;
                turnThingsOff();
              }
              
              if (size3DButton.isMouseOver()) {
                current3DTransformMode=2;
                turnThingsOff();
                selecting=true;
              }
              if (move3DButton.isMouseOver()) {
                current3DTransformMode=1;
                turnThingsOff();
                selecting=true;
              }
            }//end of 3D mode on
          }
        }//end of editing blueprint
        else if (editinglogicBoard) {
          if (connectLogicButton.isMouseOver()) {
            turnThingsOff();
            connectingLogic=true;
          }
          if (moveComponentsButton.isMouseOver()) {
            turnThingsOff();
            moveLogicComponents=true;
          }
          if (andGateButton.isMouseOver()) {
            turnThingsOff();
            placingAndGate=true;
          }
          if (orGateButton.isMouseOver()) {
            turnThingsOff();
            placingOrGate=true;
          }
          if (deleteButton.isMouseOver()) {
            turnThingsOff();
            deleteing=true;
          }
          if (xorGateButton.isMouseOver()) {
            turnThingsOff();
            placingXorGate=true;
          }
          if (saveLevel.isMouseOver()) {
            System.out.println("saving level");
            level.save();
            gmillis=millis()+400+millisOffset;
            System.out.println("save complete"+gmillis);
          }
          if (exitStageEdit.isMouseOver()) {
            turnThingsOff();
            levelOverview=true;
            editinglogicBoard=false;
            camPos=0;
            camPosY=0;
          }
          if (nandGateButton.isMouseOver()) {
            turnThingsOff();
            placingNandGate=true;
          }
          if (norGateButton.isMouseOver()) {
            turnThingsOff();
            placingNorGate=true;
          }
          if (xnorGateButton.isMouseOver()) {
            turnThingsOff();
            placingXnorGate=true;
          }
          if (testLogicPlaceButton.isMouseOver()) {/////////////////////////////////
            turnThingsOff();
            placingTestLogic=true;
          }
          if (constantOnButton.isMouseOver()) {
            turnThingsOff();
            placingOnSingal=true;
          }
          if (readVariableButton.isMouseOver()) {
            turnThingsOff();
            placingReadVariable=true;
          }
          if (setVariableButton.isMouseOver()) {
            turnThingsOff();
            placingSetVaravle=true;
          }
          if (select.isMouseOver()) {
            turnThingsOff();
            selecting=true;
          }
          if (setVisabilityButton.isMouseOver()) {
            turnThingsOff();
            placingSetVisibility=true;
          }
          if (xOffsetButton.isMouseOver()) {
            turnThingsOff();
            placingXOffset=true;
          }
          if (yOffsetButton.isMouseOver()) {
            turnThingsOff();
            placingYOffset=true;
          }
          if (delayButton.isMouseOver()) {
            turnThingsOff();
            placingDelay=true;
          }
          if (zOffsetButton.isMouseOver()) {
            turnThingsOff();
            placingZOffset=true;
          }
          if (logicHelpButton.isMouseOver()) {
            link("https://youtu.be/3ac1G1qWK6g");
          }
          if (read3DButton.isMouseOver()) {
            turnThingsOff();
            placing3Dreader=true;
          }
          if (set3DButton.isMouseOver()) {
            turnThingsOff();
            placing3Dsetter=true;
          }
          if (playLogicSoundButton.isMouseOver()) {
            turnThingsOff();
            placingPlaySoundLogic=true;
          }
          if (pulseButton.isMouseOver()) {
            turnThingsOff();
            placingPulse=true;
          }
          if (randomButton.isMouseOver()) {
            turnThingsOff();
            placingRandom=true;
          }
        }//end of edditing logic board
      }//end of tools

      if (page.equals("selection")) {
        if (selectedIndex!=-1) {
          String type="";
          StageComponent thing= new GenericStageComponent();
          LogicComponent logicThing=new GenericLogicComponent(-10, -10, null);
          if (editingStage) {
            thing= level.stages.get(currentStageIndex).parts.get(selectedIndex);
            type=thing.type;
          }
          if (editinglogicBoard) {
            logicThing=level.logicBoards.get(logicBoardIndex).components.get(selectedIndex);
            type=logicThing.type;
          }
          if (type.equals("WritableSign")) {//if the current selected object is a sign
            if (mouseX>=width*0.05&&mouseX<=width*0.9&&mouseY>=height*0.21&&mouseY<=height*0.29) {//place to click to start typing
              typingSign=true;
            } else {
              typingSign=false;
            }
          } else if (type.equals("sound box")) {
            if (level.sounds.size()==0) {
            } else {
              int fileind=0;
              String[] keys=new String[0];
              keys=level.sounds.keySet().toArray(keys);
              String current=thing.getData();
              for (int i=0; i<keys.length; i++) {
                if (keys[i].equals(current)) {
                  fileind=i;
                  break;
                }
              }

              if (fileind>0&&prevSound.isMouseOver())
                thing.setData(keys[fileind-1]);
              if (fileind<keys.length-1&&nextSound.isMouseOver())
                thing.setData(keys[fileind+1]);
            }
          } else if (type.equals("read var")||type.equals("set var")) {
            int curvar=logicThing.getData();
            if (curvar>0&&prevSound.isMouseOver())
              logicThing.setData(curvar-1);
            if (curvar<level.variables.size()-1&&nextSound.isMouseOver())
              logicThing.setData(curvar+1);
          } else if (type.equals("set visable")) {
            int curvar=logicThing.getData();
            if (curvar>0&&prevSound.isMouseOver())
              logicThing.setData(curvar-1);
            if (curvar<level.groups.size()-1&&nextSound.isMouseOver())
              logicThing.setData(curvar+1);
          } else if (type.equals("x-offset")) {
            SetXOffset r=(SetXOffset)logicThing;
            if (increase.isMouseOver()) {
              r.setOffset(r.getOffset()+1);
            }
            if (increaseMore.isMouseOver()) {
              r.setOffset(r.getOffset()+10);
            }
            if (increaseAlot.isMouseOver()) {
              r.setOffset(r.getOffset()+100);
            }
            if (decrease.isMouseOver()) {
              r.setOffset(r.getOffset()-1);
            }
            if (decreaseMore.isMouseOver()) {
              r.setOffset(r.getOffset()-10);
            }
            if (decreaseAlot.isMouseOver()) {
              r.setOffset(r.getOffset()-100);
            }
            int curvar=logicThing.getData();
            if (curvar>0&&prevSound.isMouseOver())
              logicThing.setData(curvar-1);
            if (curvar<level.groups.size()-1&&nextSound.isMouseOver())
              logicThing.setData(curvar+1);
          } else if (type.equals("y-offset")) {
            SetYOffset r=(SetYOffset)logicThing;
            if (increase.isMouseOver()) {
              r.setOffset(r.getOffset()+1);
            }
            if (increaseMore.isMouseOver()) {
              r.setOffset(r.getOffset()+10);
            }
            if (increaseAlot.isMouseOver()) {
              r.setOffset(r.getOffset()+100);
            }
            if (decrease.isMouseOver()) {
              r.setOffset(r.getOffset()-1);
            }
            if (decreaseMore.isMouseOver()) {
              r.setOffset(r.getOffset()-10);
            }
            if (decreaseAlot.isMouseOver()) {
              r.setOffset(r.getOffset()-100);
            }
            int curvar=logicThing.getData();
            if (curvar>0&&prevSound.isMouseOver())
              logicThing.setData(curvar-1);
            if (curvar<level.groups.size()-1&&nextSound.isMouseOver())
              logicThing.setData(curvar+1);
          } else if (type.equals("z-offset")) {
            SetZOffset r=(SetZOffset)logicThing;
            if (increase.isMouseOver()) {
              r.setOffset(r.getOffset()+1);
            }
            if (increaseMore.isMouseOver()) {
              r.setOffset(r.getOffset()+10);
            }
            if (increaseAlot.isMouseOver()) {
              r.setOffset(r.getOffset()+100);
            }
            if (decrease.isMouseOver()) {
              r.setOffset(r.getOffset()-1);
            }
            if (decreaseMore.isMouseOver()) {
              r.setOffset(r.getOffset()-10);
            }
            if (decreaseAlot.isMouseOver()) {
              r.setOffset(r.getOffset()-100);
            }
            int curvar=logicThing.getData();
            if (curvar>0&&prevSound.isMouseOver())
              logicThing.setData(curvar-1);
            if (curvar<level.groups.size()-1&&nextSound.isMouseOver())
              logicThing.setData(curvar+1);
          } else if (type.equals("logic button")) {
            int curvar=thing.getDataI();
            if (curvar>0&&prevSound.isMouseOver())
              thing.setData(curvar-1);
            if (curvar<level.variables.size()-1&&nextSound.isMouseOver())
              thing.setData(curvar+1);
          } else if (type.equals("delay")) {
            int curval=logicThing.getData();
            if (increase.isMouseOver()) {
              logicThing.setData(logicThing.getData()+1);
            }
            if (increaseMore.isMouseOver()) {
              logicThing.setData(logicThing.getData()+10);
            }
            if (increaseAlot.isMouseOver()) {
              logicThing.setData(logicThing.getData()+100);
            }
            if (decrease.isMouseOver()&&curval>1) {
              logicThing.setData(logicThing.getData()-1);
            }
            if (decreaseMore.isMouseOver()&&curval>10) {
              logicThing.setData(logicThing.getData()-10);
            }
            if (decreaseAlot.isMouseOver()&&curval>100) {
              logicThing.setData(logicThing.getData()-100);
            }
          } else if (type.equals("play sound")) {
            if (level.sounds.size()==0) {
            } else {
              String[] keys=new String[0];
              keys=level.sounds.keySet().toArray(keys);
              int current=logicThing.getData();

              if (current>0&&prevSound.isMouseOver())
                logicThing.setData(current-1);
              if (current<keys.length-1&&nextSound.isMouseOver())
                logicThing.setData(current+1);
            }
          }
          if (editingStage) {
            if (thing.group<level.groups.size()-1&&nextGroup.isMouseOver()) {
              thing.group++;
            }
            if (thing.group>-1&&prevGroup.isMouseOver()) {
              thing.group--;
            }
          }
        }//if something is selected
      }//end of page is selection
      if (page.equals("stage settings")) {
        if (editingStage) {
          if (skyColorB1.isMouseOver()) {
            settingSkyColor=true;
            page="colors";
          }//end of clicked on skyColorB1
          if (resetSkyColor.isMouseOver()) {
            level.stages.get(currentStageIndex).skyColor=#74ABFF;
            println(#74ABFF);
          }//end of clicked on reset sky color
        }//end of editing stage
      }//end of page is stage settings
      if (page.equals("variables and groups")) {
        if (level!=null) {
          if (variablesUP.isMouseOver()&&variableScroll>0) {
            variableScroll--;
          }
          if (variablesDOWN.isMouseOver()&&variableScroll+10<level.variables.size()) {
            variableScroll++;
          }
          //rect(70,225+i*21,20,20);
          if (mouseX>=20&&mouseX<=90&&mouseY>=225&&mouseY<=435) {//if clicking on a variable state
            int varSel=((mouseY-225)/21)+variableScroll;
            if (varSel<level.variables.size()) {
              level.variables.set(varSel, !level.variables.get(varSel));
            }
          }
          if (groupsUP.isMouseOver()&&groupScroll>0) {
            groupScroll--;
          }
          if (groupsDOWN.isMouseOver()&&groupScroll+10<level.groupNames.size()) {
            groupScroll++;
          }
          if (typeGroopName.isMouseOver()) {
            typingGroopName=true;
          }
          if (addVariable.isMouseOver()) {
            level.variables.add(false);
          }
          if (addGroup.isMouseOver()&&!newGroopName.equals("")) {
            level.groupNames.add(newGroopName);
            level.groups.add(new Group());
            newGroopName="";
            typingGroopName=false;
          }
          if (runLoad.isMouseOver()) {
            level.logicBoards.get(level.loadBoard).superTick();
          }
          if (editinglogicBoard && tickLogicButton.isMouseOver()) {
            level.logicBoards.get(logicBoardIndex).tick();
          }
        }//end of editing a level
      }//end if page is varioables and groups
      if (page.equals("level settings")) {
        if(editingStage||levelOverview){
        if (multyplayerModeSpeedrunButton.isMouseOver()) {
          level.multyplayerMode=1;
        }
        if (multyplayerModeCoOpButton.isMouseOver()) {
          level.multyplayerMode=2;
        }
        if (level.multyplayerMode==2) {

          if (level.minPlayers<level.maxPLayers&&minplayersIncrease.isMouseOver()) {
            level.minPlayers++;
          }
          if (level.minPlayers>2&&minPlayersDecrease.isMouseOver()) {
            level.minPlayers--;
          }
          if (level.maxPLayers<10&&maxplayersIncrease.isMouseOver()) {
            level.maxPLayers++;
          }
          if (level.maxPLayers>level.minPlayers&&maxplayersDecrease.isMouseOver()) {
            level.maxPLayers--;
          }
        }
        if(respawnEntitiesButton.isMouseOver()){
          level.respawnEntities();
        }
        }
      }//end of page is level settings
    }
  }

  public void mouseDragged() {
    if (levelCreator) {
      if (page.equals("colors")) {
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 150 && mouseY <= 200) {
          rsp=mouseX-75;
        }
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 300 && mouseY <= 350) {
          gsp=mouseX-75;
        }
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 450 && mouseY <= 500) {
          bsp=mouseX-75;
        }
      }//end of if pages is colors
    }
  }

  void mouseWheel(MouseEvent event) {
    if (levelCreator) {
      if (page.equals("colors")) {
        float wheel_direction = event.getCount()*-1;

        if ((level!=null&&level.stages.size()>0&&currentStageIndex!=-1&&level.stages.get(currentStageIndex).type.equals("3Dstage")) || (workingBlueprint!=null && workingBlueprint.type.equals("3D blueprint"))) {
          if (mouseX>=100&&mouseX<=300&&mouseY>=550&&mouseY<=700) {
            startingDepth+=wheel_direction*5;
            if (startingDepth<0) {
              startingDepth=0;
            }
          }
          if (mouseX>=950&&mouseX<=1150&&mouseY>=550&&mouseY<=700) {
            totalDepth+=wheel_direction*5;
            if (totalDepth<5) {
              totalDepth=5;
            }
          }
        }
      }//end of if page is colors
      if (page.equals("tools")) {
        float wheel_direction = event.getCount()*-1;
        if (grid_mode) {//if grid mode is active
          if (grid_size==10&&wheel_direction<0) {
          } else {

            grid_size+=wheel_direction*10;//change the grid size
          }
          if (grid_size<10) {
            grid_size=10;
          }
        }
      }
    }
  }


  void keyPressed() {
    if (levelCreator) {
      if (page.equals("selection")) {
        if (selectedIndex!=-1&&editingStage) {
          StageComponent thing = level.stages.get(currentStageIndex).parts.get(selectedIndex);
          String type=thing.type;
          if (type.equals("WritableSign")) {//if the current selected object is a sign
            if (typingSign) {

              thing.setData(getInput(thing.getData(), 3, keyCode, key));
            }
          }
        }
      }//end of page is selection
      if (page.equals("variables and groups")) {
        if (level!=null) {
          if (typingGroopName) {
            newGroopName=getInput(newGroopName, 0, keyCode, key);
          }
        }
      }//end of page is variables and groops
    }
  }//end of keypressed


  void drawCoin(float x, float y, float Scale) {
    strokeWeight(0);
    fill(#FCC703);
    circle(x, y, 12*Scale);
    fill(255, 255, 0);
    circle(x, y, 10*Scale);
    fill(#FCC703);
    rect(x-2*Scale, y-3*Scale, 4*Scale, 6*Scale);
  }

  void drawPortal(float x, float y, float scale) {
    fill(0);
    strokeWeight(0);
    ellipse(x, y, 50*scale, 100*scale);
    fill(#AE00FA);
    ellipse(x, y, 35*scale, 80*scale);
    fill(0);
    ellipse(x, y, 20*scale, 60*scale);
    fill(#AE00FA);
    ellipse(x, y, 5*scale, 40*scale);
  }

  void draw3DSwitch1(float x, float y, float Scale) {
    fill(196);
    strokeWeight(0);
    rect((x-20)*Scale, (y-5)*Scale, 40*Scale, 5*Scale);
    fill(#FAB800);
    rect((x-10)*Scale, (y-10)*Scale, 20*Scale, 5*Scale);
  }

  void draw3DSwitch2(float x, float y, float Scale) {
    fill(196);
    strokeWeight(0);
    rect((x-20)*Scale, (y-5)*Scale, 40*Scale, 5*Scale);
  }

  void drawCheckPoint(float x, float y) {
    fill(#B9B9B9);
    strokeWeight(0);
    rect((x-3)*Scale, (y-60)*Scale, 5*Scale, 60*Scale);
    fill(#EA0202);
    stroke(#EA0202);
    strokeWeight(0);
    triangle(x*Scale, (y-60)*Scale, x*Scale, (y-40)*Scale, (x+30)*Scale, (y-50)*Scale);
  }

  void drawSign(float x, float y, float Scale) {
    fill(#A54A00);
    rect(x-5*Scale, y-30*Scale, 10*Scale, 30*Scale);
    rect(x-35*Scale, y-65*Scale, 70*Scale, 40*Scale);
    fill(#C4C4C4);
    rect(x-33*Scale, y-63*Scale, 66*Scale, 36*Scale);
    fill(#767675);
    rect(x-30*Scale, y-58*Scale, 60*Scale, 2*Scale);
    rect(x-30*Scale, y-52*Scale, 60*Scale, 2*Scale);
    rect(x-30*Scale, y-46*Scale, 60*Scale, 2*Scale);
    rect(x-30*Scale, y-40*Scale, 60*Scale, 2*Scale);
    rect(x-30*Scale, y-34*Scale, 60*Scale, 2*Scale);
  }

  void draw_mann(float x, float y, int pose, float scale, String shirt_color) {
    strokeWeight(0);
    if (shirt_color.equals("red")) {
      fill(255, 0, 0);
      stroke(255, 0, 0);
    }

    if (pose==1) {
      rect(x-10*scale, y-55*scale, scale*20, scale*25);
      fill(-17813);
      stroke(-17813);
      rect(x-15*scale, y-75*scale, scale*30, scale*20);
      fill(-16763137);
      stroke(-16763137);
      rect(x-10*scale, y-30*scale, scale*6, scale*10);
      rect(x+4*scale, y-30*scale, scale*6, scale*10);
      rect(x-10*scale, y-20*scale, scale*6, scale*10);
      rect(x+4*scale, y-20*scale, scale*6, scale*10);
      rect(x-10*scale, y-10*scale, scale*6, scale*10);
      rect(x+4*scale, y-10*scale, scale*6, scale*10);
    }
  }
}//end of ColorSelectorScreen class
