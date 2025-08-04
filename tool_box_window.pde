//start of tool_box_window.pde

/**Primarry object responcable for the level creator tool box window
*/
class ToolBox extends PApplet {
  
  /**Create a new tool box window,
  please only create one of theese 
  @param miliOffset The millis time of the main program when this window is created
  */
  public ToolBox(int miliOffset) {
    super();//setup the papplet
    //create the new window using this as the base for that window
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    millisOffset=miliOffset;
  }

  //oh fuck all the variables
  public int redVal=0, greenVal=0, blueVal=0, CC=0;
  int rsp=0, gsp=0, bsp=0, selectedColor=0, millisOffset, variableScroll=0, groupScroll=0;
  String page="colors", newGroopName="";
  Button colorPage, toolsPage,  toggle3DMode, saveLevel, exitStageEdit, select, selectionPage, stageSettings, skyColorB1, setSkyColor, resetSkyColor, placeBlueprint, nexBlueprint, prevBlueprint, nextSound, prevSound,  playPauseButton,  deleteButton, movePlayerButton, gridModeButton, connectLogicButton, moveComponentsButton, increase, increaseMore, increaseAlot, decrease, decreaseMore, decreaseAlot, nextGroup, prevGroup, variablesAndGroups, variablesUP, variablesDOWN, groupsUP, groupsDOWN, addVariable, addGroup, typeGroopName, runLoad, logicHelpButton, move3DButton, size3DButton, levelSettingsPage, multyplayerModeSpeedrunButton, multyplayerModeCoOpButton, minplayersIncrease, minPlayersDecrease, maxplayersIncrease, maxplayersDecrease, prevousPlayerButton, nextPlayerButton, tickLogicButton,placeBlueprint3DButton,respawnEntitiesButton, rotateButton;
  //thank goodness we do not need theese anymore
  //Button draw_coin, draw_portal, draw_sloap, draw_holoTriangle, draw_dethPlane, switch3D1, switch3D2, sign, checkpointButton, groundButton, goalButton, holoButton, logicButtonButton, playSound;
  //Button andGateButton, orGateButton, xorGateButton, nandGateButton, norGateButton, xnorGateButton, testLogicPlaceButton, constantOnButton, setVariableButton, readVariableButton, setVisabilityButton, xOffsetButton, yOffsetButton, delayButton, zOffsetButton, set3DButton, read3DButton, playLogicSoundButton, pulseButton, randomButton;
  Button[] stageComponetButtons, logicComponentButtons, entityButtons;
  StageComponentRegistry.ComponentButtonIconDraw componentIcons[];
  LogicComponentRegistry.ComponentButtonIconDraw logicComponentIcons[];
  EntityRegistry.EntityButtonIconDraw entityIcons[];
  Boolean[][] componentAllowedDimentions;
  boolean typingSign=false, settingSkyColor=false, typingGroopName=false;

  /**Processing's settings method.
  sets the size of the new window
  */
  public void settings() {
    //not resizable for now, or perhaps ever
    size(1280, 720, P2D);//mac os requires a render to be specified, because for some reason JAVA2D does not work on mac
    smooth();
  }
  /**Processing's setup function
  */
  void setup() {
    textSize(50);//set the inital text size
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
    int buttonPosIndex = 0;
    int[] buttonPos = calcButtonPos(buttonPosIndex++);
    //NOTE: save, back to overiew, delete and select are common between level and logic tools
    saveLevel=new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText("save level");
    buttonPos = calcButtonPos(buttonPosIndex++);
    exitStageEdit= new Button(this, buttonPos[0], buttonPos[1], 50, 50, " < ", 255, 203).setStrokeWeight(5).setHoverText("exit to overview");
    buttonPos = calcButtonPos(buttonPosIndex++);
    select=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "select", 255, 203).setStrokeWeight(5).setHoverText("select");
    buttonPos = calcButtonPos(buttonPosIndex++);
    deleteButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText("delete");
    //end of common tool buttons    
    buttonPos = calcButtonPos(buttonPosIndex++);
    playPauseButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText("play/pause the simulation");
    buttonPos = calcButtonPos(buttonPosIndex++);
    gridModeButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText("grid mode");
    buttonPos = calcButtonPos(buttonPosIndex++);
    movePlayerButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText("move player");
    buttonPos = calcButtonPos(buttonPosIndex++);
    toggle3DMode=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "  3D  ", 255, 203).setStrokeWeight(5).setHoverText("toggle 3D mode");
    buttonPos = calcButtonPos(buttonPosIndex++);
    move3DButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "move", 255, 203).setStrokeWeight(5).setHoverText("move things in 3D");
    buttonPos = calcButtonPos(buttonPosIndex++);
    size3DButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "size", 255, 203).setStrokeWeight(5).setHoverText("resize things in 3D");
    buttonPos = calcButtonPos(buttonPosIndex++);
    rotateButton = new Button(this, buttonPos[0], buttonPos[1], 50, 50, "Rotate", 255, 203).setStrokeWeight(5).setHoverText("rotate thigns");
    buttonPos = calcButtonPos(buttonPosIndex++);
    placeBlueprint=new Button(this, buttonPos[0], buttonPos[1], 50, 50, #0F1AD3, 203).setStrokeWeight(5).setHoverText("place blurprint");
    
    
    stageComponetButtons = new Button[StageComponentRegistry.size()];
    componentIcons = new StageComponentRegistry.ComponentButtonIconDraw[stageComponetButtons.length];
    componentAllowedDimentions = new Boolean[stageComponetButtons.length][];
    //generate all the component tool buttons from what is registerd in the registries
    for(int i=0;i<stageComponetButtons.length;i++){
      Identifier component = StageComponentRegistry.get(i);
      buttonPos = calcButtonPos(buttonPosIndex++);//calculate the locaion of this button
      stageComponetButtons[i] = new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText(StageComponentRegistry.getDescription(component));//create the button
      componentIcons[i] = StageComponentRegistry.getIcon(component);
      componentAllowedDimentions[i] = StageComponentRegistry.getAllowedDimentions(component);
    }
    
    entityButtons = new Button[EntityRegistry.size()];
    entityIcons = new EntityRegistry.EntityButtonIconDraw[entityButtons.length];
    //generate entitie buttons
    for(int i=0;i<entityButtons.length;i++){
      Identifier component = EntityRegistry.get(i);
      buttonPos = calcButtonPos(buttonPosIndex++);
      entityButtons[i] = new Button(this,buttonPos[0], buttonPos[1],50,50,255,203).setStrokeWeight(5).setHoverText(EntityRegistry.getDescription(component));
      entityIcons[i] = EntityRegistry.getIcon(component);
    }
    
    //blueprint and sound things
    nexBlueprint=new Button(this, width/2+200, height*0.7-25, 50, 50, ">", 255, 203).setStrokeWeight(5);
    prevBlueprint=new Button(this, width/2-200, height*0.7-25, 50, 50, "<", 255, 203).setStrokeWeight(5);
    nextSound=new Button(this, width/2+300, height*0.4-25, 50, 50, ">", 255, 203).setStrokeWeight(5);
    prevSound=new Button(this, width/2-300, height*0.4-25, 50, 50, "<", 255, 203).setStrokeWeight(5);

    //logic editor tools
    buttonPosIndex = 4;
    buttonPos = calcButtonPos(buttonPosIndex++);
    connectLogicButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "connect", 255, 203).setStrokeWeight(5).setHoverText("connect logic nodes");
    buttonPos = calcButtonPos(buttonPosIndex++);
    moveComponentsButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "move", 255, 203).setStrokeWeight(5).setHoverText("move components arround");
    buttonPos = calcButtonPos(buttonPosIndex++);
    logicHelpButton=new Button(this, buttonPos[0], buttonPos[1], 50, 50, "?", 255, 203).setStrokeWeight(5).setHoverText("help");
    
    logicComponentButtons = new Button[LogicComponentRegistry.size()];
    logicComponentIcons = new LogicComponentRegistry.ComponentButtonIconDraw[logicComponentButtons.length];
    //generate the logic component tools
    for(int i=0;i<logicComponentButtons.length;i++){
      Identifier compId = LogicComponentRegistry.get(i);
      buttonPos = calcButtonPos(buttonPosIndex++);
      logicComponentButtons[i] = new Button(this, buttonPos[0], buttonPos[1], 50, 50, 255, 203).setStrokeWeight(5).setHoverText(LogicComponentRegistry.getDescription(compId));
      logicComponentIcons[i] = LogicComponentRegistry.getIcon(compId);
    }
    
    
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
    skyColorB1=new Button(this, 150, 165, 40, 40, 255, 203).setStrokeWeight(0);
    setSkyColor=new Button(this, 300, 580, 100, 30, "set sky color").setStrokeWeight(2);
    resetSkyColor=new Button(this, 200, 165, 40, 40, "reset", 255, 203).setStrokeWeight(0);
  }

  /**Calculate the XY positions of a given tool button
  @param index The index of the button.
  @return An array of 2 elements that represent the x and y positions of the button
  */
  private int[] calcButtonPos(int index){
    final int numPerRow= 20;
    int x = 40+60*(index%numPerRow);
    int y = 140+ 60*(index/numPerRow);
    return new int[]{x,y};
  }

  /**The main render loop for the toolbox
  */
  public void draw() {
    if (levelCreator) {//if in the level creator
      //calculate the color selector RGB values
      //This may be unused now
      redVal=(int)((rsp/1080.0)*255);
      greenVal=(int)((gsp/1080.0)*255);
      blueVal=(int)((bsp/1080.0)*255);


      if (blueVal==255) {//limit the blue val becasuse if it is 255 it does not work for some reason
        blueVal=254;
      }
      //calculate the final color
      CC=(int)(Math.pow(16, 4)*redVal+Math.pow(16, 2)*greenVal+blueVal);
      CC=CC-16777215;

      if (page.equals("colors")) {//if on the colors page
        stroke(0);
        background(CC);
        //render the color selector
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
        fill((int)(colo.getInt("red")*Math.pow(16, 4)+colo.getInt("green")*Math.pow(16, 2)+colo.getInt("blue"))-16777215);//calculate the fill color for the given saved color
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
        //if in 3D mode
        if ((level != null && level.stages.size() > 0 && currentStageIndex != -1 && level.stages.get(currentStageIndex).type.equals("3Dstage")) || (workingBlueprint!=null && workingBlueprint.type.equals("3D blueprint"))) {
          //draw the depth stuff
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
        //draw the page buttons
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();
        if (settingSkyColor) {//if setting the sky color, show the set sky color button
          setSkyColor.draw();
        }
      }//end of if page is colors
      
      if (page.equals("tools")) {//if the page is the tools page
        background(255*0.5);
        //draw the page buttons
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();

        if (editingStage) {//if editing a stage
          boolean stageIs3D = level.stages.get(currentStageIndex).type.equals("3Dstage");//get if this stage is 3D

          //Tools
          //play pause button
          playPauseButton.draw();
          fill(0);
          stroke(0);
          strokeWeight(0);
          if (simulating) {
            rect(playPauseButton.x+10, playPauseButton.y+10, 8, 30);
            rect(playPauseButton.x+30, playPauseButton.y+10, 8, 30);
          } else {
            triangle(playPauseButton.x+10, playPauseButton.y+10, playPauseButton.x+35, playPauseButton.y+25, playPauseButton.x+10, playPauseButton.y+40);
          }
          //delete button
          if (deleteing) {
            deleteButton.setColor(255, #F2F258);
          } else {
            deleteButton.setColor(255, 203);
          }
          deleteButton.draw();
          fill(203);
          stroke(203);
          strokeWeight(0);
          //trash can
          rect(deleteButton.x+5, deleteButton.y+15, 40, 5);
          rect(deleteButton.x+20, deleteButton.y+10, 10, 5);
          rect(deleteButton.x+10, deleteButton.y+20, 5, 20);
          rect(deleteButton.x+10, deleteButton.y+40, 30, 5);
          rect(deleteButton.x+35, deleteButton.y+20, 5, 20);
          rect(deleteButton.x+18, deleteButton.y+20, 5, 20);
          rect(deleteButton.x+27, deleteButton.y+20, 5, 20);

          //move player button
          if(!e3DMode){//only render when not in 3D
            if (moving_player) {
              movePlayerButton.setColor(255, #F2F258);
            } else {
              movePlayerButton.setColor(255, 203);
            }
            movePlayerButton.draw();
            strokeWeight(0);
            draw_mann(movePlayerButton.x+25, movePlayerButton.y+48, 1, 0.6, 0,g);
          }
          //grid mode button
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
          line(gridModeButton.x+10, gridModeButton.y+2, gridModeButton.x+10, gridModeButton.y+47);
          line(gridModeButton.x+20, gridModeButton.y+2, gridModeButton.x+20, gridModeButton.y+47);
          line(gridModeButton.x+30, gridModeButton.y+2, gridModeButton.x+30, gridModeButton.y+47);
          line(gridModeButton.x+40, gridModeButton.y+2, gridModeButton.x+40, gridModeButton.y+47);
          line(gridModeButton.x+2, gridModeButton.y+10, gridModeButton.x+48, gridModeButton.y+10);
          line(gridModeButton.x+2, gridModeButton.y+20, gridModeButton.x+48, gridModeButton.y+20);
          line(gridModeButton.x+2, gridModeButton.y+30, gridModeButton.x+48, gridModeButton.y+30);
          line(gridModeButton.x+2, gridModeButton.y+40, gridModeButton.x+48, gridModeButton.y+40);
          text(grid_size, gridModeButton.x+10, gridModeButton.y+40);
          strokeWeight(0);
          //blueprint button
          if (selectingBlueprint) {
            placeBlueprint.setColor(#0F1AD3, #F2F258);
          } else {
            placeBlueprint.setColor(#0F1AD3, 203);
          }
          placeBlueprint.draw();
          //select button and 3D move/size button
          if(!e3DMode){//only render when not in 3D
            if (selecting) {
              select.setColor(255, #F2F258);
            } else {
              select.setColor(255, 203);
            }
            select.draw();
          }else{
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
          }
          //save button
          saveLevel.draw();
          saveIcon(saveLevel.x+saveLevel.lengthX/2,saveLevel.y+saveLevel.lengthY/2,1,g);
          //toggle 3D button
          if(stageIs3D){
            if (e3DMode) {
              toggle3DMode.setColor(255, #F2F258);
            } else {
              toggle3DMode.setColor(255, 203);
            }
            toggle3DMode.draw();
          }
          //exit stage button
          if(!e3DMode){//only render when not in 3D
            exitStageEdit.draw();
          }
          //rotate button
          if(rotating){
            rotateButton.setColor(255, #F2F258);
          } else {
            rotateButton.setColor(255, 203);
          }
          rotateButton.draw();
          
          
          //Components
          for(int i=0;i<stageComponetButtons.length;i++){
            //check allowed dimentions
            //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
            if(/*can beplaced in 2D and stage is 2D*/(componentAllowedDimentions[i][0] && !stageIs3D) || /*can be palced in a 3D stage an is a 3D stage*/(componentAllowedDimentions[i][1] && stageIs3D)){
              //check can be placed in 3D mdoe
              if(!stageIs3D || !e3DMode || componentAllowedDimentions[i].length < 3 || (componentAllowedDimentions[i].length >=3 && componentAllowedDimentions[i][2])){
                //check if currently active to change the color
                if(StageComponentRegistry.get(i).equals(currentlyPlaceing) || (Interdimentional_Portal.ID.equals(StageComponentRegistry.get(i)) && drawingPortal)){
                   stageComponetButtons[i].setColor(255, #F2F258);
                }else{
                   stageComponetButtons[i].setColor(255, 203);
                }
                stageComponetButtons[i].draw();
                componentIcons[i].draw(g, stageComponetButtons[i].x, stageComponetButtons[i].y);
              
              }
            }
          }
          
          if(!stageIs3D){
            //Entities
            for(int i=0;i<entityButtons.length;i++){
              Identifier component = EntityRegistry.get(i);
              if(EntityRegistry.get(i).equals(currentlyPlaceing)){
                 entityButtons[i].setColor(255, #F2F258);
              }else{
                 entityButtons[i].setColor(255, 203);
              }
              entityButtons[i].draw();
              entityIcons[i].draw(g, entityButtons[i].x,entityButtons[i].y);
            }
          }
          
          //Hover Text
          deleteButton.drawHoverText();
          if(!e3DMode){
            movePlayerButton.drawHoverText();
          }
          gridModeButton.drawHoverText();
          if(!e3DMode){
            exitStageEdit.drawHoverText();
          }
          playPauseButton.drawHoverText();
          placeBlueprint.drawHoverText();
          if(!stageIs3D){
            for(int i=0;i<entityButtons.length;i++){
              entityButtons[i].drawHoverText();
            }
          }
          if(!e3DMode){
            select.drawHoverText();
          }else{
            move3DButton.drawHoverText();
          size3DButton.drawHoverText();
          }
          saveLevel.drawHoverText();
          if(stageIs3D){
            toggle3DMode.drawHoverText();
          }
          rotateButton.drawHoverText();
          //component hover text
          for(int i=0;i<stageComponetButtons.length;i++){
            //check allowed dimentions
            //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
            if(/*can beplaced in 2D and stage is 2D*/(componentAllowedDimentions[i][0] && !stageIs3D) || /*can be palced in a 3D stage an is a 3D stage*/(componentAllowedDimentions[i][1] && stageIs3D)){
              //check can be placed in 3D mdoe
              if(!stageIs3D || !e3DMode || componentAllowedDimentions[i].length < 3 || (componentAllowedDimentions[i].length >=3 && componentAllowedDimentions[i][2])){
                stageComponetButtons[i].drawHoverText();
              }
            }
          }
          
          //blueprint selection stuff
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
              if (currentBluieprintIndex>0) {
                prevBlueprint.draw();
              }
              if (currentBluieprintIndex<blueprints.length-1) {
                nexBlueprint.draw();
              }
              
              //TODO: place blueprint button for 3D
            }
          }
          //co op mode player switcher
          if (level.multyplayerMode==2) {
            fill(0);
            textSize(20);
            textAlign(LEFT, CENTER);
            text("current player:            "+currentPlayer, 200, 120);
            if (currentPlayer > 0) {
              prevousPlayerButton.draw();
            }
            if (currentPlayer<level.maxPLayers-1) {
              nextPlayerButton.draw();
            }
          }
        }//end of if edditing
        else if (editingBlueprint) {//if editing a Blueprint
          if (workingBlueprint.type.equals("blueprint")) {//if its a 2D blueprint
            
            //deleteing button
            if (deleteing) {
              deleteButton.setColor(255, #F2F258);
            } else {
              deleteButton.setColor(255, 203);
            }
            deleteButton.draw();
            fill(203);
            stroke(203);
            strokeWeight(0);
            rect(deleteButton.x+5, deleteButton.y+15, 40, 5);
            rect(deleteButton.x+20, deleteButton.y+10, 10, 5);
            rect(deleteButton.x+10, deleteButton.y+20, 5, 20);
            rect(deleteButton.x+10, deleteButton.y+40, 30, 5);
            rect(deleteButton.x+35, deleteButton.y+20, 5, 20);
            rect(deleteButton.x+18, deleteButton.y+20, 5, 20);
            rect(deleteButton.x+27, deleteButton.y+20, 5, 20);
            //gid mode button
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
            line(gridModeButton.x+10, gridModeButton.y+2, gridModeButton.x+10, gridModeButton.y+47);
            line(gridModeButton.x+20, gridModeButton.y+2, gridModeButton.x+20, gridModeButton.y+47);
            line(gridModeButton.x+30, gridModeButton.y+2, gridModeButton.x+30, gridModeButton.y+47);
            line(gridModeButton.x+40, gridModeButton.y+2, gridModeButton.x+40, gridModeButton.y+47);
            line(gridModeButton.x+2, gridModeButton.y+10, gridModeButton.x+48, gridModeButton.y+10);
            line(gridModeButton.x+2, gridModeButton.y+20, gridModeButton.x+48, gridModeButton.y+20);
            line(gridModeButton.x+2, gridModeButton.y+30, gridModeButton.x+48, gridModeButton.y+30);
            line(gridModeButton.x+2, gridModeButton.y+40, gridModeButton.x+48, gridModeButton.y+40);
            text(grid_size, gridModeButton.x+10, gridModeButton.y+40);
            strokeWeight(0);
            //save button
            saveLevel.draw();
            saveIcon(saveLevel.x+saveLevel.lengthX/2,saveLevel.y+saveLevel.lengthY/2,1,g);
            exitStageEdit.draw();
            
            //Components
            for(int i=0;i<stageComponetButtons.length;i++){
              //check allowed dimentions
              //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
              if(/*can beplaced in 2D and stage is 2D*/(componentAllowedDimentions[i][0])){
                //check can be placed in 3D mdoe
                if(componentAllowedDimentions[i].length < 4 || componentAllowedDimentions[i][3]){
                  //check if currently active to change the color
                  if(StageComponentRegistry.get(i).equals(currentlyPlaceing)){
                     stageComponetButtons[i].setColor(255, #F2F258);
                  }else{
                     stageComponetButtons[i].setColor(255, 203);
                  }
                  stageComponetButtons[i].draw();
                  componentIcons[i].draw(g, stageComponetButtons[i].x, stageComponetButtons[i].y);
                
                }
              }
            }
            
            //hover text
            deleteButton.drawHoverText();
            gridModeButton.drawHoverText();
            saveLevel.drawHoverText();
            exitStageEdit.drawHoverText();
            for(int i=0;i<stageComponetButtons.length;i++){
              //check allowed dimentions
              //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
              if(/*can beplaced in 2D and stage is 2D*/(componentAllowedDimentions[i][0])){
                //check can be placed in 3D mdoe
                if(componentAllowedDimentions[i].length < 4 || componentAllowedDimentions[i][3]){
                  stageComponetButtons[i].drawHoverText();
                
                }
              }
            }
            
          }//end of type is 2D blueprint
          else if (workingBlueprint.type.equals("3D blueprint")) {//if its a 3D blueprint
            //delete button
            if (deleteing) {
              deleteButton.setColor(255, #F2F258);
            } else {
              deleteButton.setColor(255, 203);
            }
            deleteButton.draw();
            fill(203);
            stroke(203);
            strokeWeight(0);
            rect(deleteButton.x+5, deleteButton.y+15, 40, 5);
            rect(deleteButton.x+20, deleteButton.y+10, 10, 5);
            rect(deleteButton.x+10, deleteButton.y+20, 5, 20);
            rect(deleteButton.x+10, deleteButton.y+40, 30, 5);
            rect(deleteButton.x+35, deleteButton.y+20, 5, 20);
            rect(deleteButton.x+18, deleteButton.y+20, 5, 20);
            rect(deleteButton.x+27, deleteButton.y+20, 5, 20);
            //gridmode button
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
            line(gridModeButton.x+10, gridModeButton.y+2, gridModeButton.x+10, gridModeButton.y+47);
            line(gridModeButton.x+20, gridModeButton.y+2, gridModeButton.x+20, gridModeButton.y+47);
            line(gridModeButton.x+30, gridModeButton.y+2, gridModeButton.x+30, gridModeButton.y+47);
            line(gridModeButton.x+40, gridModeButton.y+2, gridModeButton.x+40, gridModeButton.y+47);
            line(gridModeButton.x+2, gridModeButton.y+10, gridModeButton.x+48, gridModeButton.y+10);
            line(gridModeButton.x+2, gridModeButton.y+20, gridModeButton.x+48, gridModeButton.y+20);
            line(gridModeButton.x+2, gridModeButton.y+30, gridModeButton.x+48, gridModeButton.y+30);
            line(gridModeButton.x+2, gridModeButton.y+40, gridModeButton.x+48, gridModeButton.y+40);
            text(grid_size, gridModeButton.x+10, gridModeButton.y+40);
            strokeWeight(0);
            //save button
            saveLevel.draw();
            saveIcon(saveLevel.x+saveLevel.lengthX/2,saveLevel.y+saveLevel.lengthY/2,1,g);
            if(!e3DMode){
              exitStageEdit.draw();
            }
            //move and size buttons
            if(e3DMode){//only render when not in 3D
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
            }
            //3D button
            if (e3DMode) {
              toggle3DMode.setColor(255, #F2F258);
            } else {
              toggle3DMode.setColor(255, 203);
            }
            toggle3DMode.draw();
            
            //Components
            for(int i=0;i<stageComponetButtons.length;i++){
              //check allowed dimentions
              //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
              if(/*can beplaced in 3D and stage is 3D*/(componentAllowedDimentions[i][1])){
                //check can be placed in 3D mdoe
                if((componentAllowedDimentions[i].length < 4 || componentAllowedDimentions[i][3]) && (!e3DMode || componentAllowedDimentions[i].length < 3 || componentAllowedDimentions[i][2])){
                  //check if currently active to change the color
                  if(StageComponentRegistry.get(i).equals(currentlyPlaceing)){
                     stageComponetButtons[i].setColor(255, #F2F258);
                  }else{
                     stageComponetButtons[i].setColor(255, 203);
                  }
                  stageComponetButtons[i].draw();
                  componentIcons[i].draw(g, stageComponetButtons[i].x, stageComponetButtons[i].y);
                
                }
              }
            }
            
            //hover text
            deleteButton.drawHoverText();
            gridModeButton.drawHoverText();
            saveLevel.drawHoverText();
            if(!e3DMode){
              exitStageEdit.drawHoverText();
            }else{
              move3DButton.drawHoverText();
              size3DButton.drawHoverText();
            }
            toggle3DMode.drawHoverText();
            for(int i=0;i<stageComponetButtons.length;i++){
              //check allowed dimentions
              //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
              if(/*can beplaced in 3D and stage is 3D*/(componentAllowedDimentions[i][1])){
                //check can be placed in 3D mdoe
                if((componentAllowedDimentions[i].length < 4 || componentAllowedDimentions[i][3]) && (!e3DMode || componentAllowedDimentions[i].length < 3 || componentAllowedDimentions[i][2])){
                  stageComponetButtons[i].drawHoverText();
                
                }
              }
            }
          }//end of type is 3D blueprint
        } else if (editinglogicBoard) {//if editing a logic board
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
          rect(deleteButton.x+5, deleteButton.y+15, 40, 5);
          rect(deleteButton.x+20, deleteButton.y+10, 10, 5);
          rect(deleteButton.x+10, deleteButton.y+20, 5, 20);
          rect(deleteButton.x+10, deleteButton.y+40, 30, 5);
          rect(deleteButton.x+35, deleteButton.y+20, 5, 20);
          rect(deleteButton.x+18, deleteButton.y+20, 5, 20);
          rect(deleteButton.x+27, deleteButton.y+20, 5, 20);
          
          saveLevel.draw();
          saveIcon(saveLevel.x+saveLevel.lengthX/2,saveLevel.y+saveLevel.lengthY/2,1,g);
          exitStageEdit.draw();
          
          if (selecting) {
            select.setColor(255, #F2F258);
          } else {
            select.setColor(255, 203);
          }
          select.draw();
          
          logicHelpButton.draw();
          
          for(int i=0;i<logicComponentButtons.length;i++){
            if(LogicComponentRegistry.get(i).equals(currentlyPlaceing)){
              logicComponentButtons[i].setColor(255, #F2F258);
            }else{
              logicComponentButtons[i].setColor(255, 203);
            }
            logicComponentButtons[i].draw();
            logicComponentIcons[i].draw(g, logicComponentButtons[i].x,logicComponentButtons[i].y);
          }

          //draw hover text
          connectLogicButton.drawHoverText();
          moveComponentsButton.drawHoverText();
          deleteButton.drawHoverText();
          exitStageEdit.drawHoverText();
          saveLevel.drawHoverText();
          logicHelpButton.drawHoverText();
          for(int i=0;i<logicComponentButtons.length;i++){
            logicComponentButtons[i].drawHoverText();
          }
        } else {
          fill(0);
          textSize(20);
          text("you are not currently editing a stage", 300, 300);
        }
      }//end of if page is tools
      
      if (page.equals("selection")) {//if the page is a selection page
        background(#790101);
        //page buttons
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
          //TODO replace this with a completely modular system
          //due to this i can not be fucked to document this further
          String type="";
          //theese are assigned to things so that I do not get pesterd about them having the potential to be null
          //this stuf has to so with thigns being selected
          StageComponent thing= new GenericStageComponent();
          LogicComponent logicThing=new GenericLogicComponent(new LogicCompoentnPlacementContext(-10000,-10000,null));
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
      
      
      if (page.equals("stage settings")) {//if the page is stage settings
        background(#92CED8);
        //page buttons
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();
        
        if (editingStage) {//if editing a stage
          fill(0);
          textSize(25);
          textAlign(LEFT, CENTER);
          //display the name and sky color button
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
      
      
      if (page.equals("variables and groups")) {//if the page is variables and groups
        background(#FCC740);
        //page buttons
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();
        fill(0);
        textSize(25);
        textAlign(LEFT, CENTER);
        //if there is a level
        if (level!=null) {
          text("variables", 80, 200);
          text("groups", 560, 200);
          //show the state of each variable
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
          if (variableScroll>0) {
            variablesUP.draw();
          }
          if (variableScroll+10<level.variables.size()) {
            variablesDOWN.draw();
          }
          textSize(25);
          textAlign(LEFT, CENTER);
          //display the name of each group
          for (int i=0; i+groupScroll<level.groupNames.size()&&i<10; i++) {
            fill(0);
            text(level.groupNames.get(i+groupScroll), 565, 230+i*21);
          }
          if (groupScroll>0) {
            groupsUP.draw();
          }
          if (groupScroll+10<level.groupNames.size()) {
            groupsDOWN.draw();
          }
          addVariable.draw();
          addGroup.draw();
          fill(0);
          //typeGroopName.draw();
          rect(680, 220, 400, 1);
          textSize(20);
          textAlign(LEFT, BOTTOM);
          if (typingGroopName) {
            text(newGroopName+coursorr, 680, 218);
          } else {
            text(newGroopName, 680, 218);
          }
          runLoad.draw();

          if (editinglogicBoard) {//if on a logic board show the tick button
            tickLogicButton.draw();
            tickLogicButton.drawHoverText();
          }
          runLoad.drawHoverText();
        }//end of editing level
      }//end of variables and groups
      
      if (page.equals("level settings")) {//if the page is level settings
        background(#BA90FF);
        //page buttons
        colorPage.draw();
        toolsPage.draw();
        selectionPage.draw();
        stageSettings.draw();
        variablesAndGroups.draw();
        levelSettingsPage.draw();

        if (level==null || !(editingStage || levelOverview)) {//if there is no level or your not editing a level
          //display an error
          textAlign(CENTER, CENTER);
          fill(0);
          textSize(25);
          text("no level loaded", width/2, height/2);
        } else {//if you are editing a level
          textSize(20);
          fill(0);
          textAlign(LEFT, CENTER);
          text("level name: "+level.name, 50, 150);
          text("multyplayer mode:", 50, 200);
          //multyplayer mode buttons
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

          if (level.multyplayerMode==2) {//if level is set to co op mode
            //show the number of players selector
            textSize(20);
            fill(0);
            textAlign(LEFT, CENTER);
            text("min players:", 50, 250);
            text("max players:", 50, 300);
            text(level.minPlayers, 200, 250);
            text(level.maxPLayers, 200, 300);
            currentNumberOfPlayers=level.maxPLayers;
            if (level.minPlayers<level.maxPLayers) {
              minplayersIncrease.draw();
            }
            if (level.minPlayers > 2) {
              minPlayersDecrease.draw();
            }
            if (level.maxPLayers < 10) {
              maxplayersIncrease.draw();
            }
            if (level.maxPLayers > level.minPlayers) {
              maxplayersDecrease.draw();
            }
          }
          respawnEntitiesButton.draw();
        }
      }//end of page is level settings
      
    } else {//if not in the level creator
      //show the API limitation screen
      background(200);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("Ignore this window!\nDue to API limitations it can not be closed.", width/2, height/2);
    }
  }//end of draw

  /**Processings mouse clicked function
  */
  public void mouseClicked() {
    if (levelCreator) {//if in the level creator
      if (page.equals("colors")) {
        //if the mouse is in the range for one of the sliders
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 150 && mouseY <= 200) {
          rsp=mouseX-75;
        }
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 300 && mouseY <= 350) {
          gsp=mouseX-75;
        }
        if (mouseX >= 100-25 && mouseX <= 1180-25 && mouseY >= 450 && mouseY <= 500) {
          bsp=mouseX-75;
        }
        //load a saved color button
        if (mouseX >= 600 && mouseX <=680 && mouseY >= 600 && mouseY <=680) {
          JSONObject colo=colors.getJSONObject(selectedColor);
          rsp=(int)Math.ceil(colo.getInt("red")/255.0*1080);
          gsp=(int)Math.ceil(colo.getInt("green")/255.0*1080);
          bsp=(int)Math.ceil(colo.getInt("blue")/255.0*1080);
        }
        //change selected saved color button
        if (mouseX >= 500 && mouseX <= 550 && mouseY >= 600 && mouseY <=680&&selectedColor>0) {
          selectedColor--;
        }
        //chnage selected saved color button
        if (mouseX >= 730 && mouseX <= 780 && mouseY >= 600 && mouseY <=680&&selectedColor<colors.size()-1) {
          selectedColor++;
        }
        //save the current color button
        if (mouseX >= 600 && mouseX <=680  && mouseY >= 560 && mouseY <=590) {
          JSONObject colo=new JSONObject();
          colo.setInt("red", redVal);
          colo.setInt("green", greenVal);
          colo.setInt("blue", blueVal);
          colors.setJSONObject(colors.size(), colo);
          saveColors=true;
        }
        //if setting sky color
        if (settingSkyColor) {
          if (setSkyColor.isMouseOver()) {//if the setting sky color button has been clicked on
            settingSkyColor=false;
            page="stage settings";
            level.stages.get(currentStageIndex).skyColor=CC;
            //set this stage's sky color to the current color
          }
        }
      }//end of if pages is colors

      //page buttons 
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

      //if on the tools page
      if (page.equals("tools")) {
        if (editingStage) {//and editing a stage
          boolean stageIs3D = level.stages.get(currentStageIndex).type.equals("3Dstage");
          
          //mouse clicked processing for stage compoentns
          for(int i=0;i<stageComponetButtons.length;i++){
            //check allowed dimentions
            //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
            if(/*can beplaced in 2D and stage is 2D*/(componentAllowedDimentions[i][0] && !stageIs3D) || /*can be palced in a 3D stage an is a 3D stage*/(componentAllowedDimentions[i][1] && stageIs3D)){
              //check can be placed in 3D mdoe
              if(!stageIs3D || !e3DMode || componentAllowedDimentions[i].length < 3 || (componentAllowedDimentions[i].length >=3 && componentAllowedDimentions[i][2])){
                
                if(stageComponetButtons[i].isMouseOver()){
                  turnThingsOff();
                  Identifier compoenntId = StageComponentRegistry.get(i);
                  //special case for portals
                  if(compoenntId.equals(Interdimentional_Portal.ID)){
                    drawingPortal = true;
                  }else{
                    currentlyPlaceing = compoenntId;
                  }
                }
              }
            }
          }
          //everything else that is hard coded
          //dont feel like going into specifics
          if (playPauseButton.isMouseOver()) {
            simulating=!simulating;
          }
          if (deleteButton.isMouseOver()) {
            turnThingsOff();
            deleteing=true;
          }
          if(!e3DMode){
            if (movePlayerButton.isMouseOver()) {
              turnThingsOff();
              moving_player=true;
            }
          }
          if (gridModeButton.isMouseOver()) {
            grid_mode=!grid_mode;
          }
          if(!e3DMode){
            if (exitStageEdit.isMouseOver()) {
              turnThingsOff();
              levelOverview=true;
              editingStage=false;
              level_complete=false;
              viewingItemContents=false;
            }
            if (select.isMouseOver()) {
              turnThingsOff();
              selecting=true;
            }
          }

          if (placeBlueprint.isMouseOver()) {
            turnThingsOff();
            //blueprint things are complicated
            String blueprintType = stageIs3D ? "3D blueprint" : "blueprint";
            //start by finding all valid blueprints
            String[] files=new File(appdata+"/CBi-games/skinny mann level creator/blueprints").list();
            int numofjsons=0;
            //count the number of valid blueprints
            for (int i=0; i<files.length; i++) {
              if (files[i].contains(".json")) {
                String bpType = loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]).getJSONObject(0).getString("type");
                if(bpType.equals(blueprintType))
                  numofjsons++;
              }
            }
            blueprints=new Stage[numofjsons];
            int pointer=0;
            //load the valid blueprints
            for (int i=0; i<files.length; i++) {
              if (files[i].contains(".json")) {
                String bpType = loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]).getJSONObject(0).getString("type");
                if(bpType.equals(blueprintType)){
                  blueprints[pointer]=new Stage(loadJSONArray(appdata+"/CBi-games/skinny mann level creator/blueprints/"+files[i]));
                  pointer++;
                }
              }
            }
            System.out.println("loaded "+blueprints.length+" blueprints");
            selectingBlueprint=true;
            currentBluieprintIndex=0;
            //setup the placement
            blueprintPlacemntX=cam3Dx;
            blueprintPlacemntY=cam3Dy;
            blueprintPlacemntZ=cam3Dz;
          }
          
          if (selectingBlueprint) { //if the blurprint is being selected
            //blueprint selection things
            if (currentBluieprintIndex > 0 && prevBlueprint.isMouseOver()) {
              currentBluieprintIndex--;
            }
            if (currentBluieprintIndex < blueprints.length - 1 && nexBlueprint.isMouseOver()) {
              currentBluieprintIndex++;
            }
          }
          
          //entity buttons
          if(!stageIs3D){
            for(int i=0;i<entityButtons.length;i++){
              Identifier component = EntityRegistry.get(i);
              if(entityButtons[i].isMouseOver()){
                turnThingsOff();
                currentlyPlaceing = component;
              }
            }
          }
          
          //3D buttons
          if(stageIs3D){
            if (toggle3DMode.isMouseOver()) {
              e3DMode =! e3DMode;
              turnThingsOff();
              if(e3DMode){
                selecting=true;
              }
              return;
            }
          }
          
          if(rotateButton.isMouseOver()){
            current3DTransformMode=3;
            turnThingsOff();
            rotating = true;
            selecting=true;
          }
          
          if(e3DMode){
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
          
            //place a blueprint when in 3D mode
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
          }

          //save button
          if (saveLevel.isMouseOver()) {
            System.out.println("saving level");
            level.save(true);
            gmillis=millis()+400+millisOffset;
            System.out.println("save complete"+gmillis);
          }

          //player swithing buttons
          if (level.multyplayerMode == 2) {
            if (currentPlayer > 0 && prevousPlayerButton.isMouseOver()) {
              currentPlayer--;
              currentStageIndex=players[currentPlayer].stage;
              e3DMode=players[currentPlayer].in3D;
            }
            if (currentPlayer < level.maxPLayers - 1 && nextPlayerButton.isMouseOver()) {
              currentPlayer++;
              currentStageIndex=players[currentPlayer].stage;
              e3DMode=players[currentPlayer].in3D;
            }
          }
        }//end of edditing stage
        else if (editingBlueprint) {//if editing blueprint
          if (workingBlueprint.type.equals("blueprint")) {
            
            //bla bla bla very similar things
            if (deleteButton.isMouseOver()) {
              turnThingsOff();
              deleteing=true;
            }

            if (gridModeButton.isMouseOver()) {
              grid_mode=!grid_mode;
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
            //component buttons
            for(int i=0;i<stageComponetButtons.length;i++){
              //check allowed dimentions
              //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
              if(/*can beplaced in 2D and stage is 2D*/componentAllowedDimentions[i][0]){
                //check can be placed in 3D mdoe
                if(componentAllowedDimentions[i].length < 4 || componentAllowedDimentions[i][3]){
                  
                  if(stageComponetButtons[i].isMouseOver()){
                    turnThingsOff();
                    Identifier compoenntId = StageComponentRegistry.get(i);
                    //special case for portals
                    currentlyPlaceing = compoenntId;
                  }
                }
              }
            }
          }//end of type is blueprint
          else if (workingBlueprint.type.equals("3D blueprint")) {
            
            if (deleteButton.isMouseOver()) {
              turnThingsOff();
              deleteing=true;
            }

            if (gridModeButton.isMouseOver()) {
              grid_mode=!grid_mode;
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
            
            //component buttons
            
            for(int i=0;i<stageComponetButtons.length;i++){
              //check allowed dimentions
              //[0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
              if(/*can beplaced in 3D and stage is 3D*/componentAllowedDimentions[i][1]){
                //check can be placed in 3D mdoe
                if((componentAllowedDimentions[i].length < 4 || componentAllowedDimentions[i][3]) && (!e3DMode || componentAllowedDimentions[i].length < 3 || componentAllowedDimentions[i][2])){
                  
                  if(stageComponetButtons[i].isMouseOver()){
                    turnThingsOff();
                    Identifier compoenntId = StageComponentRegistry.get(i);
                    //special case for portals
                    currentlyPlaceing = compoenntId;
                  }
                }
              }
            }
          }
        }//end of editing blueprint
        else if (editinglogicBoard) {
          //hard coded logic board buttons
          if (connectLogicButton.isMouseOver()) {
            turnThingsOff();
            connectingLogic=true;
          }
          if (moveComponentsButton.isMouseOver()) {
            turnThingsOff();
            moveLogicComponents=true;
          }
          if (deleteButton.isMouseOver()) {
            turnThingsOff();
            deleteing=true;
          }
          if (saveLevel.isMouseOver()) {
            System.out.println("saving level");
            level.save(true);
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
          if (select.isMouseOver()) {
            turnThingsOff();
            selecting=true;
          }
          //help link
          if (logicHelpButton.isMouseOver()) {
            link("https://youtu.be/RIgViL-a3zs");//logic tutorial video
          }
          //component buttons
          for(int i=0;i<logicComponentButtons.length;i++){             
            if(logicComponentButtons[i].isMouseOver()){
              turnThingsOff();
              Identifier compoenntId = LogicComponentRegistry.get(i);
              //special case for portals
              currentlyPlaceing = compoenntId;
            }
          }
        }//end of edditing logic board
      }//end of tools

      if (page.equals("selection")) {//if the page is the selection page
        if (selectedIndex!=-1) {//if something is elected
          String type="";
          StageComponent thing= new GenericStageComponent();
          LogicComponent logicThing=new GenericLogicComponent(new LogicCompoentnPlacementContext(-10000,-10000,null));
          //get the thing that is being editied
          if (editingStage) {
            thing= level.stages.get(currentStageIndex).parts.get(selectedIndex);
            type=thing.type;
          }
          if (editinglogicBoard) {
            logicThing=level.logicBoards.get(logicBoardIndex).components.get(selectedIndex);
            type=logicThing.type;
          }
          //component specific hard coded actions
          //not going to document this shit as this will be replaced with a better system in the near future
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
      
      if (page.equals("stage settings")) {//if page is stage settings
        if (editingStage) {
          //sky color button
          if (skyColorB1.isMouseOver()) {
            settingSkyColor=true;
            page="colors";
          }//end of clicked on skyColorB1
          //reset sky color button
          if (resetSkyColor.isMouseOver()) {
            level.stages.get(currentStageIndex).skyColor=#74ABFF;
            println(#74ABFF);
          }//end of clicked on reset sky color
        }//end of editing stage
      }//end of page is stage settings
      
      if (page.equals("variables and groups")) {//varaibles and groups page
        if (level != null) {//if in a level
          //variable scrolling buttons
          if (variablesUP.isMouseOver() && variableScroll > 0) {
            variableScroll--;
          }
          if (variablesDOWN.isMouseOver() && variableScroll + 10 < level.variables.size()) {
            variableScroll++;
          }
          //change varaible state buttons
          if (mouseX>=20&&mouseX<=90&&mouseY>=225&&mouseY<=435) {//if clicking on a variable state
            int varSel = ((mouseY-225)/21)+variableScroll;//figure out what var is being clicked on
            if (varSel < level.variables.size()) {
              level.variables.set(varSel, !level.variables.get(varSel));//flip the state of the varaible
            }
          }
          //group scrolling
          if (groupsUP.isMouseOver()&&groupScroll>0) {
            groupScroll--;
          }
          if (groupsDOWN.isMouseOver()&&groupScroll+10<level.groupNames.size()) {
            groupScroll++;
          }
          //new group name typing stuff
          if (typeGroopName.isMouseOver()) {
            typingGroopName=true;
          }
          if (addVariable.isMouseOver()) {
            level.variables.add(false);
          }
          //add new group button
          if (addGroup.isMouseOver() && !newGroopName.equals("")) {
            level.groupNames.add(newGroopName);
            level.groups.add(new Group());
            newGroopName="";
            typingGroopName=false;
          }
          //run the load board button
          if (runLoad.isMouseOver()) {
            level.logicBoards.get(level.loadBoard).superTick();
          }
          //tick current board by 1 button
          if (editinglogicBoard && tickLogicButton.isMouseOver()) {
            level.logicBoards.get(logicBoardIndex).tick();
          }
        }//end of editing a level
      }//end if page is varioables and groups
      
      if (page.equals("level settings")) {//if the page is level settings
        if(editingStage||levelOverview){
          //the things for level settings very basic and eazy to under stand
          if (multyplayerModeSpeedrunButton.isMouseOver()) {
            level.multyplayerMode=1;
          }
          if (multyplayerModeCoOpButton.isMouseOver()) {
            level.multyplayerMode=2;
          }
          if (level.multyplayerMode==2) {
  
            if (level.minPlayers < level.maxPLayers && minplayersIncrease.isMouseOver()) {
              level.minPlayers++;
            }
            if (level.minPlayers > 2 && minPlayersDecrease.isMouseOver()) {
              level.minPlayers--;
            }
            if (level.maxPLayers < 10 && maxplayersIncrease.isMouseOver()) {
              level.maxPLayers++;
            }
            if (level.maxPLayers > level.minPlayers && maxplayersDecrease.isMouseOver()) {
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

  /**Processings mouse dragged button
  */
  public void mouseDragged() {
    if (levelCreator) {
      if (page.equals("colors")) {
        //color selector sliders
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

  /**Processings mouse wheel function
  @param event Mouse event information
  */
  void mouseWheel(MouseEvent event) {
    if (levelCreator) {
      if (page.equals("colors")) {
        float wheel_direction = event.getCount()*-1;
        //if in a level and there are stages and there is a current stage and this stage is a 3D stage or blueprint
        if ((level != null && level.stages.size() > 0 && currentStageIndex != -1 && level.stages.get(currentStageIndex).type.equals("3Dstage")) || (workingBlueprint!=null && workingBlueprint.type.equals("3D blueprint"))) {
          //if scrolling in the starting depth box
          if (mouseX>=100&&mouseX<=300&&mouseY>=550&&mouseY<=700) {
            startingDepth+=wheel_direction*5;
            if (startingDepth<0) {//limit min to 0
              startingDepth=0;
            }
          }
          //if scrolling in the total depth box
          if (mouseX>=950&&mouseX<=1150&&mouseY>=550&&mouseY<=700) {
            totalDepth+=wheel_direction*5;
            if (totalDepth<5) {//limit min to 5
              totalDepth=5;
            }
          }
        }
      }//end of if page is colors
      
      if (page.equals("tools")) {//if on the tools page
        float wheel_direction = event.getCount()*-1;
        //addjust the grid size value if grid mode is on
        if (grid_mode) {//if grid mode is active
          if (grid_size==10 && wheel_direction < 0) {//id the grid size is 10 and the wheel whent in the down direction
            //uhhhhhhhhhh do nothing
          } else {
            //otherize
            grid_size+=wheel_direction*10;//change the grid size
          }
          
          if (grid_size<10) {//enforce a minimum of 10
            grid_size=10;
          }
        }
      }
    }
  }

  /**Processing's key pressed function
  */
  void keyPressed() {
    if (levelCreator) {
      if (page.equals("selection")) {
        //sign selection text entering
        //this will be modularized in the near future
        if (selectedIndex!=-1&&editingStage) {
          StageComponent thing = level.stages.get(currentStageIndex).parts.get(selectedIndex);//get the component
          String type=thing.type;
          if (type.equals("WritableSign")) {//if the current selected object is a sign
            if (typingSign) {
              thing.setData(getInput(thing.getData(), 3, keyCode, key));
            }
          }
        }
      }//end of page is selection
      
      if (page.equals("variables and groups")) {
        //new group name typing
        if (level!=null) {
          if (typingGroopName) {
            newGroopName=getInput(newGroopName, 0, keyCode, key);
          }
        }
      }//end of page is variables and groops
    }
  }//end of keypressed
}//end of ToolBox class

//end of tool_box_window.pde
