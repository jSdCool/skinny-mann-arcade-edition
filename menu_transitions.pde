void menuTransition() {
  if(settings.getDisableMenuTransitions()){
    transitionProgress=1;
    transitioningMenu=false;
    menue=true;
    return;
  }
  switch(currentTransition) {
  case LOGO_TO_MAIN:
    transition_logoToMain();
    break;

  case LOGO_TO_SETTINGS:
    transition_logoToSettings();
    break;

  case MAIN_TO_SETTINGS:
    transition_mainToSettings();
    break;

  case SETTINGS_TO_MAIN:
    transition_settingsToMain();
    break;

  case MAIN_TO_LEVEL_SELECT:
    transition_mainToLevelSelect();
    break;

  case LEVEL_SELECT_TO_MAIN:
    transition_levelSelectToMain();
    break;

  case LEVEL_SELECT_TO_UGC:
    transition_levelSelectToUGC();
    break;

  case UGC_TO_LEVEL_SELECT:
    transition_UGCToLevelSelect();
    break;
    
  case LEVEL_SELECT_TO_LEVEL_SELECT_2:
    transition_levelSelectToLevelSelect2();
    break;
    
  case LEVEL_SELECT_2_TO_LEVEL_SELECT:
    transition_levelSelect2ToLevelSelect();
    break;

  default:
    transitionProgress=1;
  }
  if (transitionProgress>=1) {
    transitioningMenu=false;
    menue=true;
  }
}

enum Transitions {
  LOGO_TO_MAIN,
    LOGO_TO_SETTINGS,
    MAIN_TO_SETTINGS,
    SETTINGS_TO_MAIN,
    MAIN_TO_LEVEL_SELECT,
    LEVEL_SELECT_TO_MAIN,
    LEVEL_SELECT_TO_UGC,
    UGC_TO_LEVEL_SELECT,
    LEVEL_SELECT_TO_LEVEL_SELECT_2,
    LEVEL_SELECT_2_TO_LEVEL_SELECT
};

Transitions currentTransition;
float transitionProgress;
int transitionStartMillis;

void initMenuTransition(Transitions transition) {
  currentTransition=transition;
  transitionProgress=0;
  transitionStartMillis=millis();
  println("starting transition: "+transition);
  transitioningMenu=true;
}

ArrayList<Star> startupStars = new ArrayList<Star>();

void transition_logoToMain() {

  if (transitionProgress<0.4) {
    background(0);
    if (startupStars.size()<500) {
      addStars();
    }
    for (int i=0; i<startupStars.size(); i++) {
      startupStars.get(i).draw();
    }
    drawlogo(true, false);
  } else if (transitionProgress<0.6) {
    background(0);
    float senctionProgress = (transitionProgress-0.4)/0.2;
    float camYpos  = 1300*senctionProgress+height/2;
    camera(width/2, camYpos, 623.5382907, width/2, camYpos, 0, 0, 1, 0);
    if (startupStars.size()<500) {
      addStars();
    }
    for (int i=0; i<startupStars.size(); i++) {
      startupStars.get(i).draw();
    }
    drawlogo(false, false);
  } else if (transitionProgress<0.8) {
    float senctionProgress = (transitionProgress-0.6)/0.2;
    float camYpos  = 1300*senctionProgress+height/2+1300;
    background(lerpColor(0, #74ABFF, senctionProgress));

    camera(width/2, camYpos, 623.5382907, width/2, camYpos, 0, 0, 1, 0);
    if (startupStars.size()<500) {
      addStars();
    }
    for (int i=0; i<startupStars.size(); i++) {
      startupStars.get(i).draw();
    }
  } else {
    float senctionProgress = (transitionProgress-0.8)/0.2;
    float camYpos = 1300*senctionProgress+height/2-1300;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawMainMenu(true);
  }


  transitionProgress=(float)(millis()-transitionStartMillis)/5000.0;
}


void transition_logoToSettings() {

  if (transitionProgress<0.4) {
    background(0);
    if (startupStars.size()<500) {
      addStars();
    }
    for (int i=0; i<startupStars.size(); i++) {
      startupStars.get(i).draw();
    }
    drawlogo(true, false);
  } else if (transitionProgress<0.6) {
    background(0);
    float senctionProgress = (transitionProgress-0.4)/0.2;
    float camYpos  = 1300*senctionProgress+height/2;
    camera(width/2, camYpos, 623.5382907, width/2, camYpos, 0, 0, 1, 0);
    if (startupStars.size()<500) {
      addStars();
    }
    for (int i=0; i<startupStars.size(); i++) {
      startupStars.get(i).draw();
    }
    drawlogo(false, false);
  } else if (transitionProgress<0.8) {
    float senctionProgress = (transitionProgress-0.6)/0.2;
    float camYpos  = 1300*senctionProgress+height/2+1300;
    background(lerpColor(0, #74ABFF, senctionProgress));

    camera(width/2, camYpos, 623.5382907, width/2, camYpos, 0, 0, 1, 0);
    if (startupStars.size()<500) {
      addStars();
    }
    for (int i=0; i<startupStars.size(); i++) {
      startupStars.get(i).draw();
    }
  } else {
    float senctionProgress = (transitionProgress-0.8)/0.2;
    float camYpos = 1300*senctionProgress+height/2-1300;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawSettings();
  }


  transitionProgress=(float)(millis()-transitionStartMillis)/5000.0;
}

void transition_mainToSettings() {
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camYpos = -height*senctionProgress+height/2;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawMainMenu(true);
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camYpos = -height*senctionProgress+height/2+height;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawSettings();
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_settingsToMain() {
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camYpos = height*senctionProgress+height/2;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawSettings();
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camYpos = height*senctionProgress+height/2-height;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawMainMenu(true);
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_mainToLevelSelect() {
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camZpos = (height/2)/tan(radians(60)/2);
    float camXpos = width*senctionProgress+width/2;
    camera(camXpos, height/2, camZpos, camXpos, height/2, 0, 0, 1, 0);
    background(#74ABFF);
    fill(-16732415);
    rect(0, height/2, width*8, height/2);
    drawMainMenu(false);
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camZpos = (height/2)/tan(radians(60)/2);
    float camXpos = width*senctionProgress+width/2-width;
    camera(camXpos, height/2, camZpos, camXpos, height/2, 0, 0, 1, 0);
    background(#74ABFF);
    fill(-16732415);
    rect(-width*7, height/2, width*8, height/2);
    drawLevelSelect(false,-16732415);
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_levelSelectToMain() {
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camZpos = (height/2)/tan(radians(60)/2);
    float camXpos = -width*senctionProgress+width/2;
    camera(camXpos, height/2, camZpos, camXpos, height/2, 0, 0, 1, 0);
    background(#74ABFF);
    fill(-16732415);
    rect(-width*7, height/2, width*8, height/2);
    drawLevelSelect(false,-16732415);
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camZpos = (height/2)/tan(radians(60)/2);
    float camXpos = -width*senctionProgress+width/2+width;
    camera(camXpos, height/2, camZpos, camXpos, height/2, 0, 0, 1, 0);
    background(#74ABFF);
    fill(-16732415);
    rect(0, height/2, width*8, height/2);
    drawMainMenu(false);
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_levelSelectToUGC() {
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camYpos = -height*senctionProgress+height/2;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelect(true,-16732415);
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camYpos = -height*senctionProgress+height/2+height;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelectUGC();
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_UGCToLevelSelect() {
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camYpos = height*senctionProgress+height/2;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelectUGC();
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camYpos = height*senctionProgress+height/2-height;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelect(true,-16732415);
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_levelSelect2ToLevelSelect() {
  int groundCOlor = -16732415;
  if(transitionProgress<0.75){
    background(lerpColor(#66696F,-16732415,transitionProgress/0.75));
    groundCOlor = lerpColor(#66696F,-16732415,transitionProgress/0.75);
  }else{
    background(7646207);
  }
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camYpos = -height*senctionProgress+height/2;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelect2(false);
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camYpos = -height*senctionProgress+height/2+height;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelect(false,groundCOlor);
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}

void transition_levelSelectToLevelSelect2() {
  int groundCOlor = -16732415;
  if(transitionProgress>0.25){
    background(lerpColor(-16732415,#66696F,(transitionProgress-0.25)/0.75));
    groundCOlor = lerpColor(-16732415,#66696F,(transitionProgress-0.25)/0.75);
  }else{
    background(7646207);
  }
  if (transitionProgress<0.5) {
    float senctionProgress = (transitionProgress)/0.5;
    float camYpos = height*senctionProgress+height/2;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelect(false,groundCOlor);
  } else {
    float senctionProgress = (transitionProgress-0.5)/0.5;
    float camYpos = height*senctionProgress+height/2-height;
    float camZpos = (height/2)/tan(radians(60)/2);
    camera(width/2, camYpos, camZpos, width/2, camYpos, 0, 0, 1, 0);
    drawLevelSelect2(false);
  }

  transitionProgress=(float)(millis()-transitionStartMillis)/2000.0;
}



//camera() = camera(defCameraX, defCameraY, defCameraZ,    defCameraX, defCameraY, 0,    0, 1, 0);
//defCameraX = width/2;
//defCameraY = height/2;
//defCameraFOV = 60 * DEG_TO_RAD;
//defCameraZ = defCameraY / ((float) Math.tan(defCameraFOV / 2.0f));

class Star {
  int x, y;
  Star() {
    x=(int)random(0, width);
    y=(int)random(0, 2880);
  }

  void draw() {
    fill(255);
    circle(x, y, 2);
  }
}

void addStars() {
  for (int i=0; i<10; i++) {
    startupStars.add(new Star());
  }
}
