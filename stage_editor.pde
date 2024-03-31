void stageEditGUI() {

  textAlign(LEFT, BOTTOM);


  int adj;//color adjustment stuff that may be useless
  if (RC == 0 && GC == 0 && BC > 0) {
    adj=256;
  } else {
    adj=0;
  }
  Color=(int)(RC*Math.pow(16, 4)+GC*Math.pow(16, 2)+BC+adj)-16777215;
  Color=scr2.CC;

  Stage current=null;//setup a varable that can be used for the current stage or blueprint
  if (editingStage) {
    current=level.stages.get(currentStageIndex);
  }
  if (editingBlueprint) {
    current=workingBlueprint;
  }

  if (current.type.equals("stage")||current.type.equals("blueprint")) {//if current is a steg or blueprint
  
  if (grid_mode) {//grid mode position box
    int X2=0, Y2=0, X1=0, Y1=0;
    X1=(int)(((floor((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale);
    X2=(int)(grid_size*Scale);//(int)(((int)(Math.ceil((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale)-X1;
    Y1=(int)(((floor((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale);
    Y2=(int)(grid_size*Scale);//(int)(((int)(Math.ceil((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale)-abs(Y1);\
    fill(#AAAA00,120);
    rect(X1,Y1,X2,Y2);

    
  }

    if (drawing) {//if drawing a dragable shape
      fill(Color);
      stroke(Color);
      if (dethPlane) {//overide coustome color if the current tool is deathplane
        fill(-114431);
        stroke(-114431);
      }

      if (grid_mode) {//if gridmode is on
        if (sloap||holoTriangle) {//if your currenly drawing a triangle type
          int X2=0, Y2=0, X1=0, Y1=0;//calcaute the location of the mouese press and unpress location
          if (mouseX>downX) {
            X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size-camPos;
            X2=(int)Math.floor(Math.ceil((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos;
          }
          if (mouseX<downX) {
            X1=(int)Math.floor((mouseX/Scale+camPos)/grid_size)*grid_size-camPos;
            X2=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-camPos;
          }
          if (mouseY>downY) {
            Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size+camPosY;
            Y2=(int)Math.floor(Math.ceil((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY;
          }
          if (mouseY<downY) {
            Y1=(int)Math.floor((mouseY/Scale-camPosY)/grid_size)*grid_size+camPosY;
            Y2=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)+camPosY;
          }
          if (triangleMode==0) {//display the triangle that will be created
            triangle(X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, X2*Scale, Y1*Scale);
          }
          if (triangleMode==1) {
            triangle(X1*Scale, Y1*Scale, X1*Scale, Y2*Scale, X2*Scale, Y1*Scale);
          }
          if (triangleMode==2) {
            triangle(X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, X1*Scale, Y2*Scale);
          }
          if (triangleMode==3) {
            triangle(X1*Scale, Y2*Scale, X2*Scale, Y2*Scale, X2*Scale, Y1*Scale);
          }
        } else {//if the type is not a triangle
          int XD=0, YD=0, X1=0, Y1=0;//calcaute the location of the mouese press and unpress location
          if (mouseX>downX) {
            X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size-camPos;
            XD=(int)Math.floor(Math.ceil((mouseX/Scale+camPos)/grid_size)*grid_size)-X1-camPos;
          }
          if (mouseX<downX) {
            X1=(int)Math.floor((mouseX/Scale+camPos)/grid_size)*grid_size-camPos;
            XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1-camPos;
          }
          if (mouseY>downY) {
            Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size+camPosY;
            YD=(int)Math.floor(Math.ceil((mouseY/Scale-camPosY)/grid_size)*grid_size)-Y1+camPosY;
          }
          //YD=(int)(Math.ceil(upY/grid_size)*grid_size)-Y1;
          if (mouseY<downY) {
            Y1=(int)Math.floor((mouseY/Scale-camPosY)/grid_size)*grid_size+camPosY;
            YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1+camPosY;
          }
          strokeWeight(0);

          rect(X1*Scale, Y1*Scale, XD*Scale, YD*Scale);//display the rectangle that is being drawn
        }
      } else {//if grid mode is off
        if (sloap||holoTriangle) {
          int X2=0, Y2=0, X1=0, Y1=0;//calcaute the location of the mouese press and unpress location
          if (mouseX>downX) {
            X1=(int)Math.floor((downX/Scale));
            X2=(int)Math.floor(Math.ceil((mouseX/Scale)));
          }
          if (mouseX<downX) {
            X1=(int)Math.floor((mouseX/Scale));
            X2=(int)Math.floor(Math.ceil((downX/Scale)));
          }
          if (mouseY>downY) {
            Y1=(int)Math.floor(downY/Scale);
            Y2=(int)Math.floor(Math.ceil(mouseY/Scale));
          }
          if (mouseY<downY) {
            Y1=(int)Math.floor(mouseY/Scale);
            Y2=(int)Math.floor(Math.ceil(downY/Scale));
          }
          if (triangleMode==0) {//display the triangle that will be created
            triangle(X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, X2*Scale, Y1*Scale);
          }
          if (triangleMode==1) {
            triangle(X1*Scale, Y1*Scale, X1*Scale, Y2*Scale, X2*Scale, Y1*Scale);
          }
          if (triangleMode==2) {
            triangle(X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, X1*Scale, Y2*Scale);
          }
          if (triangleMode==3) {
            triangle(X1*Scale, Y2*Scale, X2*Scale, Y2*Scale, X2*Scale, Y1*Scale);
          }
        } else {
          strokeWeight(0);
          float xdif=(int)((mouseX-downX)/Scale)*Scale, ydif=(int)((mouseY-downY)/Scale)*Scale;//calcaute the location of the mouese press and unpress location

          rect((int)(downX/Scale)*Scale, (int)(downY/Scale)*Scale, xdif, ydif);//display the rectangle that is being drawn
        }
      }
    }

    if (draw&&ground) {//add new ground element to the level

      float xdif=upX-downX, ydif=upY-downY;
      int X1=0, XD=0, Y1=0, YD=0;
      if (grid_mode) {//if grid mode is on


        if (upX>downX) {//calcualte corner position
          X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
          XD=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size)-X1;
        }
        if (upX<downX) {
          X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
          XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1;
        }
        if (upY>downY) {
          Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
          YD=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size)-Y1;
        }
        if (upY<downY) {
          Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
          YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1;
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      } else {//if grid mode is off


        if (upX>downX) {//calculate corder position
          X1 = (int)(downX/Scale)+camPos;
          XD = (int)abs(xdif/Scale);
        }
        if (upX<downX) {
          X1 = (int)(upX/Scale)+camPos;
          XD = (int)abs(downX/Scale-upX/Scale);
        }
        if (upY>downY) {
          Y1 = (int)(downY/Scale)-camPosY;
          YD =  (int)abs(ydif/Scale);
        }
        if (upY<downY) {
          Y1 = (int)(upY/Scale)-camPosY;
          YD = (int)abs(downY/Scale-upY/Scale);
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      }

      current.parts.add(new Ground(X1, Y1, XD, YD, Color));//add the new element to the stage
      draw=false;
    }//end of add ground

    if (draw&&holo_gram) {//add new holo element to the level
      float xdif=upX-downX, ydif=upY-downY;
      int X1=0, XD=0, Y1=0, YD=0;
      if (grid_mode) {


        if (upX>downX) {//calculate corder position
          X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
          XD=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size)-X1;
        }
        if (upX<downX) {
          X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
          XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1;
        }
        if (upY>downY) {
          Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
          YD=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size)-Y1;
        }
        if (upY<downY) {
          Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
          YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1;
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      } else {


        if (upX>downX) {//calculate corder position
          X1 = (int)(downX/Scale)+camPos;
          XD = (int)abs(xdif/Scale);
        }
        if (upX<downX) {
          X1 = (int)(upX/Scale)+camPos;
          XD = (int)abs(downX/Scale-upX/Scale);
        }
        if (upY>downY) {
          Y1 = (int)(downY/Scale)-camPosY;
          YD =  (int)abs(ydif/Scale);
        }
        if (upY<downY) {
          Y1 = (int)(upY/Scale)-camPosY;
          YD = (int)abs(downY/Scale-upY/Scale);
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      }
      current.parts.add(new Holo(X1, Y1, XD, YD, Color));//add the new element to the stage
      draw=false;
    }//end of add holo

    if (draw&&dethPlane) {//add new deathplane element to the level
      float xdif=upX-downX, ydif=upY-downY;
      int X1=0, XD=0, Y1=0, YD=0;
      if (grid_mode) {


        if (upX>downX) {//calculate corder position
          X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
          XD=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size)-X1;
        }
        if (upX<downX) {
          X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
          XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1;
        }
        if (upY>downY) {
          Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
          YD=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size)-Y1;
        }
        if (upY<downY) {
          Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
          YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1;
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      } else {


        if (upX>downX) {//calculate corder position
          X1 = (int)(downX/Scale)+camPos;
          XD = (int)(xdif/Scale);
        }
        if (upX<downX) {
          X1 = (int)(upX/Scale)+camPos;
          XD = (int)(downX/Scale-upX/Scale);
        }
        if (upY>downY) {
          Y1 = (int)(downY/Scale)-camPosY;
          YD =  (int)(ydif/Scale);
        }
        if (upY<downY) {
          Y1 = (int)(upY/Scale);
          YD = (int)(downY/Scale-upY/Scale-camPosY);
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      }
      current.parts.add(new DethPlane(X1, Y1, XD, YD));//add new death plane elemtn to the stage
      draw=false;
    }//end of new deathplane


    if (check_point&&draw) {//creating new checkpoint
      if (grid_mode) {//if grid mode is on
        current.parts.add(new CheckPoint(Math.round(((int)Math.floor(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)Math.floor(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size));//add new checkpoint to the stage
      } else {
        current.parts.add(new CheckPoint((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY));//add new checkpoint to the stage
      }
      draw=false;
    }//end of create new checkpoint
    if (goal&&draw) {//create new finishline
      if (grid_mode) {//if grid mode is on
        current.parts.add(new Goal(Math.round(((int)Math.floor(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)Math.floor(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size));//add new finishline to the stage
      } else {
        current.parts.add(new Goal((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY));//add new finishline to the stage
      }
      draw=false;
    }//end of new finishline

    if (deleteing&&delete) {//if attempting to delete something
      int index=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, current);//get the index of the elemtn the mouse is currently over
      if (index==-1) {//if the mouse was over nothing then do nothing
      } else {
        StageComponent removed = current.parts.remove(index);//remove the object the mosue was over
        if (current.interactables.contains(removed)) {
          current.interactables.remove(removed);
        }
      }
      delete=false;
    }//end of delete

    if (drawCoins) {//if adding coins
      if (grid_mode) {//if grid mode is on
        drawCoin((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, 3*Scale);//draw gid aligmed coin
      } else {
        drawCoin((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, 3*Scale);//draw coin
      }
    }

    if (drawingPortal) {//if adding portal part 1
      if (grid_mode) {//if gridmode is on
        drawPortal((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, 1*Scale);//draw a grid aligned portal
      } else {
        drawPortal((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, 1*Scale);//draw a portal
      }
    }

    if (drawingPortal3) {//if drawing portal part 3
      if (grid_mode) {//if gridmode is on
        drawPortal((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale);//draw a grid aligned portal
      } else {
        drawPortal((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, 1);//draw a portal
      }
    }

    if (sloap&&draw) {//if drawing a triangle
      int X1=0, X2=0, Y1=0, Y2=0;
      if (grid_mode) {//if gridmode is on


        if (upX>downX) {//calcualte corner positions
          X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
          X2=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size);
        }
        if (upX<downX) {
          X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
          X2=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size);
        }
        if (upY>downY) {
          Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
          Y2=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size);
        }
        if (upY<downY) {
          Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
          Y2=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size);
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      } else {//if gridmode is off

        if (upX>downX) {
          X1 = (int)(downX/Scale)+camPos;//calculate corder position
          X2 = (int)(upX/Scale)+camPos;
        }
        if (upX<downX) {
          X1 = (int)(upX/Scale)+camPos;
          X2 = (int)(downX/Scale+camPos);
        }
        if (upY>downY) {
          Y1 = (int)(downY/Scale)-camPosY;
          Y2 = (int)(upY/Scale)-camPosY;
        }
        if (upY<downY) {
          Y1 = (int)(upY/Scale)-camPosY;
          Y2 = (int)(downY/Scale)-camPosY;
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      }

      current.parts.add(new Sloap(X1, Y1, X2, Y2, triangleMode, Color));//add new sloap to the stage
      draw=false;
    }

    if (holoTriangle&&draw) {//if drawing a holo triangle
      int X1=0, X2=0, Y1=0, Y2=0;
      if (grid_mode) {//if gridmode is on


        if (upX>downX) {//calculate corder position
          X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
          X2=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size);
        }
        if (upX<downX) {
          X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
          X2=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size);
        }
        if (upY>downY) {
          Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
          Y2=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size);
        }
        if (upY<downY) {
          Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
          Y2=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size);
        }
        if (downX==upX) {
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      } else {//if grid mode is off


        if (upX>downX) {//calculate corder position
          X1 = (int)(downX/Scale)+camPos;
          X2 = (int)(upX/Scale)+camPos;
        }
        if (upX<downX) {
          X1 = (int)(upX/Scale)+camPos;
          X2 = (int)(downX/Scale+camPos);
        }
        if (upY>downY) {
          Y1 = (int)(downY/Scale)-camPosY;
          Y2 = (int)(upY/Scale)-camPosY;
        }
        if (upY<downY) {
          Y1 = (int)(upY/Scale)-camPosY;
          Y2 = (int)(downY/Scale)-camPosY;
        }
        if (downX==upX) {//if there was no change is mouse position then don't create a new segment
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      }
      current.parts.add(new HoloTriangle(X1, Y1, X2, Y2, triangleMode, Color));//add new holor triangle to the stage
      draw=false;
    }
    if (check_point) {//if  checkpoint
      if (grid_mode) {//draw checkoint
        drawCheckPoint((Math.round((mouseX/Scale+camPos)*1.0/grid_size)*grid_size-camPos), (Math.round((mouseY/Scale-camPosY)*1.0/grid_size)*grid_size+camPosY));
      } else {
        drawCheckPoint((int)(mouseX/Scale), (int)(mouseY/Scale));
      }
    }
    if (drawingSign) {//if sign
      if (grid_mode) {//draw a sign
        drawSign((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale);
      } else {
        drawSign((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale);
      }
    }
    if (placingSound) {//if placing soundboxes
      if (grid_mode) {//draw a sound box
        drawSoundBox((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale);
      } else {
        drawSoundBox((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale);
      }
    }
    if (placingLogicButton) {//if placing a logic button
      if (grid_mode) {//draw the switch
        drawLogicButton(primaryWindow, (Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale, false);
      } else {
        drawLogicButton(primaryWindow, (int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale, false);
      }
    }
    if (placingLogicButton&&draw) {//if attempting to add a logic button
      if (grid_mode) {//add the button to the stage
        current.parts.add(new LogicButton(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size));
      } else {
        current.parts.add(new LogicButton((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY));
      }
      current.interactables.add(current.parts.get(current.parts.size()-1));
      draw=false;
    }


    //the accual gut part
  }

  if (current.type.equals("3Dstage") || current.type.equals("3D blueprint")) {//if in a 3D stage

    if (!e3DMode) {//if 3D mode is off
      if (grid_mode) {//grid mode position box
        int X2=0, Y2=0, X1=0, Y1=0;
        X1=(int)(((floor((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale);
        X2=(int)(grid_size*Scale);//(int)(((int)(Math.ceil((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale)-X1;
        Y1=(int)(((floor((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale);
        Y2=(int)(grid_size*Scale);//(int)(((int)(Math.ceil((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale)-abs(Y1);\
        fill(#AAAA00,120);
        rect(X1,Y1,X2,Y2);
      }

      if (drawing) {//if drawing something
        fill(Color);
        stroke(Color);
        if (dethPlane) {
          fill(-114431);
          stroke(-114431);
        }

        if (grid_mode||holo_gram) {//if drawing something that is a rectangle
          int XD=0, YD=0, X1=0, Y1=0;//calc the corner positions
          if (mouseX>downX) {
            X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size-camPos;
            XD=(int)Math.floor(Math.ceil((mouseX/Scale+camPos)/grid_size)*grid_size)-X1-camPos;
          }
          if (mouseX<downX) {
            X1=(int)Math.floor((mouseX/Scale+camPos)/grid_size)*grid_size-camPos;
            XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1-camPos;
          }
          if (mouseY>downY) {
            Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size+camPosY;
            YD=(int)Math.floor(Math.ceil((mouseY/Scale-camPosY)/grid_size)*grid_size)-Y1+camPosY;
          }
          //YD=(int)(Math.ceil(upY/grid_size)*grid_size)-Y1;
          if (mouseY<downY) {
            Y1=(int)Math.floor((mouseY/Scale-camPosY)/grid_size)*grid_size+camPosY;
            YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1+camPosY;
          }
          strokeWeight(0);

          rect(X1*Scale, Y1*Scale, XD*Scale, YD*Scale);//draw the rectangle preview
        } else {//end of grid mode
          strokeWeight(0);
          float xdif=mouseX-downX, ydif=mouseY-downY;
          rect((int)(downX/Scale)*Scale, (int)(downY/Scale)*Scale, (int)(xdif/Scale)*Scale, (int)(ydif/Scale)*Scale);//draw the preview
        }
      }//end of drawing

      if (draw&&ground) {//if drawing ground
        float xdif=upX-downX, ydif=upY-downY;
        int X1=0, XD=0, Y1=0, YD=0;
        if (grid_mode) {//if gridmode is on


          if (upX>downX) {//cacl corner posirions
            X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
            XD=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size)-X1;
          }
          if (upX<downX) {
            X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
            XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1;
          }
          if (upY>downY) {
            Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
            YD=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size)-Y1;
          }
          if (upY<downY) {
            Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
            YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1;
          }
          if (downX==upX) {//if there was no change is mouse position then don't create a new segment
            draw=false;
            return ;
          }
          if (downY==upY) {
            draw=false;
            return;
          }
        } else {


          if (upX>downX) {//calc corner positions
            X1 = (int)(downX/Scale)+camPos;
            XD = (int)(xdif/Scale);
          }
          if (upX<downX) {
            X1 = (int)(upX/Scale)+camPos;
            XD = (int)(downX/Scale-upX/Scale);
          }
          if (upY>downY) {
            Y1 = (int)(downY/Scale)-camPosY;
            YD =  (int)(ydif/Scale);
          }
          if (upY<downY) {
            Y1 = (int)(upY/Scale);
            YD = (int)(downY/Scale-upY/Scale-camPosY);
          }
          if (downX==upX) {//if there was no change is mouse position then don't create a new segment
            draw=false;
            return ;
          }
          if (downY==upY) {
            draw=false;
            return;
          }
        }
        current.parts.add(new Ground(X1, Y1, startingDepth, XD, YD, totalDepth, Color));//add new ground to the stage
        draw=false;
      }
      if (draw&&holo_gram) {//if drawing holo
        float xdif=upX-downX, ydif=upY-downY;
        int X1=0, XD=0, Y1=0, YD=0;
        if (grid_mode) {//if grid mode is on


          if (upX>downX) {//calc corner position
            X1=(int)Math.floor((downX/Scale+camPos)/grid_size)*grid_size;
            XD=(int)Math.floor(Math.ceil((upX/Scale+camPos)/grid_size)*grid_size)-X1;
          }
          if (upX<downX) {
            X1=(int)Math.floor((upX/Scale+camPos)/grid_size)*grid_size;
            XD=(int)Math.floor(Math.ceil((downX/Scale+camPos)/grid_size)*grid_size)-X1;
          }
          if (upY>downY) {
            Y1=(int)Math.floor((downY/Scale-camPosY)/grid_size)*grid_size;
            YD=(int)Math.floor(Math.ceil((upY/Scale-camPosY)/grid_size)*grid_size)-Y1;
          }
          if (upY<downY) {
            Y1=(int)Math.floor((upY/Scale-camPosY)/grid_size)*grid_size;
            YD=(int)Math.floor(Math.ceil((downY/Scale-camPosY)/grid_size)*grid_size)-Y1;
          }
          if (downX==upX) {//if there was no change is mouse position then don't create a new segment
            draw=false;
            return ;
          }
          if (downY==upY) {
            draw=false;
            return;
          }
        } else {


          if (upX>downX) {//calc corner position
            X1 = (int)(downX/Scale)+camPos;
            XD = (int)(xdif/Scale);
          }
          if (upX<downX) {
            X1 = (int)(upX/Scale)+camPos;
            XD = (int)(downX/Scale-upX/Scale);
          }
          if (upY>downY) {
            Y1 = (int)(downY/Scale)-camPosY;
            YD =  (int)(ydif/Scale);
          }
          if (upY<downY) {
            Y1 = (int)upY;
            YD = (int)(downY/Scale-upY/Scale-camPosY);
          }
          if (downX==upX) {//if there was no change is mouse position then don't create a new segment
            draw=false;
            return ;
          }
          if (downY==upY) {
            draw=false;
            return;
          }
        }
        current.parts.add(new Holo(X1, Y1, startingDepth, XD, YD, totalDepth, Color));//add new holo to the stage
        draw=false;
      }

      if (deleteing&&delete) {//if deleting things
        int index=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, level.stages.get(currentStageIndex));//figure out what thing the mouse is over
        if (index==-1) {//if the mouse is over nothing then do nothing
        } else {
          StageComponent removed = current.parts.remove(index);//remove the object the mosue was over
          if (current.interactables.contains(removed)) {
            current.interactables.remove(removed);
          }
        }
        delete=false;
      }
      if (draw3DSwitch1) {//if drawing a 3d switch
        if (grid_mode) {//draw the switch
          draw3DSwitch1((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos), (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY), Scale);
        } else {
          draw3DSwitch1((int)(mouseX/Scale), (int)(mouseY/Scale), Scale);
        }
      }
      if (draw3DSwitch2) {//if drawing a 3d switch
        if (grid_mode) {//draw the switch
          draw3DSwitch2((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos), (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY), Scale);
        } else {
          draw3DSwitch2((int)(mouseX/Scale), (int)(mouseY/Scale), Scale);
        }
      }
      if (draw3DSwitch1&&draw) {//if attempting to add a 3D switch
        if (grid_mode) {//add the switch to the stage
          current.parts.add(new SWon3D(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth));
        } else {
          current.parts.add(new SWon3D((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth));
        }
        draw=false;
      }

      if (draw3DSwitch2&&draw) {//if attempting to add a 3D switch
        if (grid_mode) {//add the 3D switch to the stage
          current.parts.add(new SWoff3D(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth));
        } else {
          current.parts.add(new SWoff3D((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth));
        }
        draw=false;
      }

      if (check_point&&draw) {//if adding a checkpoint
        if (grid_mode) {//add a checkoint to the stage
          current.parts.add(new CheckPoint(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth));
        } else {
          current.parts.add(new CheckPoint((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth));
        }
        draw=false;
      }

      if (drawingPortal) {//if placing a portal
        if (grid_mode) {//diaply the portal
          drawPortal((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale);
        } else {
          drawPortal((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale);
        }
      }

      if (drawingPortal3) {//if placing a portal part 3
        if (grid_mode) {//display the portal
          drawPortal((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale);
        } else {
          drawPortal((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale);
        }
      }
      if (check_point) {//if adding checkoint
        if (grid_mode) {//display a checkoint
          drawCheckPoint((Math.round((mouseX/Scale+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round((mouseY/Scale-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale);
        } else {
          drawCheckPoint((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale);
        }
      }
      if (drawCoins) {//if adding coins
        if (grid_mode) {//display a coin
          drawCoin((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale*3);
        } else {
          drawCoin((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale*3);
        }
      }
      if (drawingSign) {//if adding coins
        if (grid_mode) {//display a coin
          drawSign((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale);
        } else {
          drawSign((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale);
        }
      }
      if (placingLogicButton) {//if placing a logic button
        if (grid_mode) {//draw the switch
          drawLogicButton(primaryWindow, (Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale, false);
        } else {
          drawLogicButton(primaryWindow, (int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale, false);
        }
      }
      if (placingLogicButton&&draw) {//if attempting to add a logic button
        if (grid_mode) {//add the button to the stage
          current.parts.add(new LogicButton(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth));
        } else {
          current.parts.add(new LogicButton((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth));
        }
        draw=false;
      }
    }//end of is 3d mode off if statment
    else {//if 3dmode is on
      if (selectedIndex!=-1) {
        //wether the red/green/blue arrows are currrntly being hoverd over
        boolean b1=false, b2=false, r1=false, r2=false, g1=false, g2=false;
        StageComponent ct=current.parts.get(selectedIndex);
        //check if the mouse is hovering over an arrow
        for (int i=0; i<5000; i++) {
          Point3D testPoint=genMousePoint(i);
          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= ct.z+ct.dz && testPoint.z <= ct.z+ct.dz+60) {
            b1=true;
            break;
          }

          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= ct.z-60 && testPoint.z <= ct.z) {
            b2=true;
            break;
          }

          if (testPoint.x >= ct.x-60 && testPoint.x <= ct.x && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            r1=true;
            break;
          }

          if (testPoint.x >= ct.x+ct.dx && testPoint.x <= ct.x+ct.dx+60 && testPoint.y >= (ct.y+ct.dy/2)-5 && testPoint.y <= (ct.y+ct.dy/2)+5 && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            r2=true;
            break;
          }

          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= ct.y-60 && testPoint.y <= ct.y && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            g1=true;
            break;
          }

          if (testPoint.x >= (ct.x+ct.dx/2)-5 && testPoint.x <= (ct.x+ct.dx/2)+5 && testPoint.y >= ct.y+ct.dy && testPoint.y <= ct.y+ct.dy+60 && testPoint.z >= (ct.z+ct.dz/2)-5 && testPoint.z <= (ct.z+ct.dz/2)+5) {
            g2=true;
            break;
          }
        }
        
        //render the arrow
        if (current3DTransformMode==1) {
          translate(ct.x+ct.dx/2, ct.y+ct.dy/2, ct.z+ct.dz);
          if (b1)
            shape(yellowArrow);
          else
            shape(blueArrow);

          translate(-(ct.x+ct.dx/2), -(ct.y+ct.dy/2), -(ct.z+ct.dz));

          translate(ct.x+ct.dx/2, ct.y+ct.dy/2, ct.z);
          rotateY(radians(180));
          if (b2)
            shape(yellowArrow);
          else
            shape(blueArrow);
          rotateY(-radians(180));
          translate(-(ct.x+ct.dx/2), -(ct.y+ct.dy/2), -(ct.z));

          translate(ct.x, ct.y+ct.dy/2, ct.z+ct.dz/2);
          rotateY(-radians(90));
          if (r1)
            shape(yellowArrow);
          else
            shape(redArrow);
          rotateY(radians(90));
          translate(-(ct.x), -(ct.y+ct.dy/2), -(ct.z+ct.dz/2));

          translate(ct.x+ct.dx, ct.y+ct.dy/2, ct.z+ct.dz/2);
          rotateY(radians(90));
          if (r2)
            shape(yellowArrow);
          else
            shape(redArrow);
          rotateY(-radians(90));
          translate(-(ct.x+ct.dx), -(ct.y+ct.dy/2), -(ct.z+ct.dz/2));

          translate(ct.x+ct.dx/2, ct.y, ct.z+ct.dz/2);
          rotateX(radians(90));
          if (g1)
            shape(yellowArrow);
          else
            shape(greenArrow);
          rotateX(-radians(90));
          translate(-(ct.x+ct.dx/2), -(ct.y), -(ct.z+ct.dz/2));

          translate(ct.x+ct.dx/2, ct.y+ct.dy, ct.z+ct.dz/2);
          rotateX(-radians(90));
          if (g2)
            shape(yellowArrow);
          else
            shape(greenArrow);
          rotateX(radians(90));
          translate(-(ct.x+ct.dx/2), -(ct.y+ct.dy), -(ct.z+ct.dz/2));

          //translte objects in 3D
          if (grid_mode) {//Math.round(((int)mouseX+camPos)*1.0/grid_size)*grid_size
            if (translateZaxis) {
              ct.z=(int)Math.round((initalObjectPos.z-initalMousePoint.z+mousePoint.z)*1.0/grid_size)*grid_size;
            }
            if (translateXaxis) {
              ct.x=(int)Math.round((initalObjectPos.x-initalMousePoint.x+mousePoint.x)*1.0/grid_size)*grid_size;
              ;
            }
            if (translateYaxis) {
              ct.y=(int)Math.round((initalObjectPos.y-initalMousePoint.y+mousePoint.y)*1.0/grid_size)*grid_size;
              ;
            }
          } else {//if not in grid mdoe
            if (translateZaxis) {
              ct.z=(int)initalObjectPos.z-(initalMousePoint.z-mousePoint.z);
            }
            if (translateXaxis) {
              ct.x=(int)initalObjectPos.x-(initalMousePoint.x-mousePoint.x);
            }
            if (translateYaxis) {
              ct.y=(int)initalObjectPos.y-(initalMousePoint.y-mousePoint.y);
            }
          }
        }//end of 3d transform mode is move

        if (current3DTransformMode==2&&(ct instanceof Ground || ct instanceof Holo)) {
          translate(ct.x+ct.dx/2, ct.y+ct.dy/2, ct.z+ct.dz);
          if (b1)
            shape(yellowScaler);
          else
            shape(blueScaler);

          translate(-(ct.x+ct.dx/2), -(ct.y+ct.dy/2), -(ct.z+ct.dz));

          translate(ct.x+ct.dx/2, ct.y+ct.dy/2, ct.z);
          rotateY(radians(180));
          if (b2)
            shape(yellowScaler);
          else
            shape(blueScaler);
          rotateY(-radians(180));
          translate(-(ct.x+ct.dx/2), -(ct.y+ct.dy/2), -(ct.z));

          translate(ct.x, ct.y+ct.dy/2, ct.z+ct.dz/2);
          rotateY(-radians(90));
          if (r1)
            shape(yellowScaler);
          else
            shape(redScaler);
          rotateY(radians(90));
          translate(-(ct.x), -(ct.y+ct.dy/2), -(ct.z+ct.dz/2));

          translate(ct.x+ct.dx, ct.y+ct.dy/2, ct.z+ct.dz/2);
          rotateY(radians(90));
          if (r2)
            shape(yellowScaler);
          else
            shape(redScaler);
          rotateY(-radians(90));
          translate(-(ct.x+ct.dx), -(ct.y+ct.dy/2), -(ct.z+ct.dz/2));

          translate(ct.x+ct.dx/2, ct.y, ct.z+ct.dz/2);
          rotateX(radians(90));
          if (g1)
            shape(yellowScaler);
          else
            shape(greenScaler);
          rotateX(-radians(90));
          translate(-(ct.x+ct.dx/2), -(ct.y), -(ct.z+ct.dz/2));

          translate(ct.x+ct.dx/2, ct.y+ct.dy, ct.z+ct.dz/2);
          rotateX(-radians(90));
          if (g2)
            shape(yellowScaler);
          else
            shape(greenScaler);
          rotateX(radians(90));
          translate(-(ct.x+ct.dx/2), -(ct.y+ct.dy), -(ct.z+ct.dz/2));

          //scaling of objects in 3D
          if (grid_mode) {
            if (transformComponentNumber==1) {
              if (translateZaxis) {
                if (initialObjectDim.z-Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size > 0)
                  ct.dz=initialObjectDim.z-Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size;
              }
              if (translateXaxis) {
                if (initialObjectDim.x-Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size > 0)
                  ct.dx=initialObjectDim.x-Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size;
              }
              if (translateYaxis) {
                if (initialObjectDim.y-Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size > 0)
                  ct.dy=initialObjectDim.y-Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size;
              }
            }
            if (transformComponentNumber==2) {
              if (translateZaxis) {
                if (initialObjectDim.z+Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size > 0) {
                  ct.dz=initialObjectDim.z+Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size;
                  ct.z=(initalObjectPos.z-Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size);
                }
              }
              if (translateXaxis) {
                if (initialObjectDim.x+Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size > 0) {
                  ct.dx=initialObjectDim.x+Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size;
                  ct.x=(initalObjectPos.x-Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size);
                }
              }
              if (translateYaxis) {
                if (initialObjectDim.y+Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size > 0) {
                  ct.dy=initialObjectDim.y+Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size;
                  ct.y=(initalObjectPos.y-Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size);
                }
              }
            }
          } else {//if not in grid mode
            if (transformComponentNumber==1) {
              if (translateZaxis) {
                if (initialObjectDim.z-(initalMousePoint.z-mousePoint.z) > 0)
                  ct.dz=initialObjectDim.z-(initalMousePoint.z-mousePoint.z);
              }
              if (translateXaxis) {
                if (initialObjectDim.x-(initalMousePoint.x-mousePoint.x) > 0)
                  ct.dx=initialObjectDim.x-(initalMousePoint.x-mousePoint.x);
              }
              if (translateYaxis) {
                if (initialObjectDim.y-(initalMousePoint.y-mousePoint.y) > 0);
                ct.dy=initialObjectDim.y-(initalMousePoint.y-mousePoint.y);
              }
            }
            if (transformComponentNumber==2) {
              if (translateZaxis) {
                if (initialObjectDim.z+(initalMousePoint.z-mousePoint.z) > 0) {
                  ct.dz=initialObjectDim.z+(initalMousePoint.z-mousePoint.z);
                  ct.z=initalObjectPos.z-(initalMousePoint.z-mousePoint.z);
                }
              }
              if (translateXaxis) {
                if (initialObjectDim.x+(initalMousePoint.x-mousePoint.x) > 0) {
                  ct.dx=initialObjectDim.x+(initalMousePoint.x-mousePoint.x);
                  ct.x=initalObjectPos.x-(initalMousePoint.x-mousePoint.x);
                }
              }
              if (translateYaxis) {
                if (initialObjectDim.y+(initalMousePoint.y-mousePoint.y) > 0) {
                  ct.dy=initialObjectDim.y+(initalMousePoint.y-mousePoint.y);
                  ct.y=initalObjectPos.y-(initalMousePoint.y-mousePoint.y);
                }
              }
            }
          }
        }//end of 3d transform mode is scale
      }//end of 3d tranform is move mode
      
      if (e3DMode && selectingBlueprint && blueprints.length!=0){

        if (grid_mode) {//Math.round(((int)mouseX+camPos)*1.0/grid_size)*grid_size
            if (translateZaxis) {
              blueprintPlacemntZ=(int)Math.round((initalObjectPos.z-initalMousePoint.z+mousePoint.z)*1.0/grid_size)*grid_size;
            }
            if (translateXaxis) {
              blueprintPlacemntX=(int)Math.round((initalObjectPos.x-initalMousePoint.x+mousePoint.x)*1.0/grid_size)*grid_size;
            }
            if (translateYaxis) {
              blueprintPlacemntY=(int)Math.round((initalObjectPos.y-initalMousePoint.y+mousePoint.y)*1.0/grid_size)*grid_size;
            }
          } else {//if not in grid mdoe
            if (translateZaxis) {
              blueprintPlacemntZ=(int)initalObjectPos.z-(initalMousePoint.z-mousePoint.z);
            }
            if (translateXaxis) {
              blueprintPlacemntX=(int)initalObjectPos.x-(initalMousePoint.x-mousePoint.x);
            }
            if (translateYaxis) {
              blueprintPlacemntY=(int)initalObjectPos.y-(initalMousePoint.y-mousePoint.y);
            }
          }
      }//end of moving blueprint in 3D
      
      engageHUDPosition();//move the draw position to align with the camera


      disEngageHUDPosition();//move the draw position back to 0 0 0
    }//end of 3d mode on
  }
}

void GUImouseClicked() {
  if (editingStage||editingBlueprint) {//if edditing a stage or blueprint



    Stage current=null;//figure out what your edditing
    if (editingStage) {
      current=level.stages.get(currentStageIndex);
    }
    if (editingBlueprint) {
      current=workingBlueprint;
    }


    if (check_point) {//if checkoint
      draw=true;
    }
    if (goal) {//if placing finishline
      draw=true;
    }
    if (placingLogicButton) {//if placing logic button
      draw=true;
    }
    if (deleteing) {//if deleteing
      delete=true;
    }
    if (moving_player) {//if moving the player
      //set the players new position
      players[currentPlayer].setX(mouseX/Scale+camPos);
      players[currentPlayer].setY(mouseY/Scale-camPosY);
      if (level.stages.get(currentStageIndex).type.equals("3Dstage")) {
        players[currentPlayer].z=startingDepth;
      }
      tpCords[0]=mouseX/Scale+camPos;
      tpCords[1]=mouseY/Scale-camPosY;
      tpCords[2]=startingDepth;

      setPlayerPosTo=true;
    }
    if (drawCoins) {//if drawing coin
      String tpe = current.type;
      if (grid_mode) {//add coins with data accorinding to how it needs to be integrated
        if (tpe.equals("stage")) {
          current.parts.add(new Coin(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, level.numOfCoins));
        }
        if (tpe.equals("3Dstage")) {
          current.parts.add(new Coin(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth, level.numOfCoins));
        }
        if (tpe.equals("blueprint")) {
          current.parts.add(new Coin(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, 0));
        }
        if (tpe.equals("3D blueprint")) {
          current.parts.add(new Coin(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth, 0));
        }
      } else {
        if (tpe.equals("stage")) {
          current.parts.add(new Coin((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, level.numOfCoins));
        }
        if (tpe.equals("3Dstage")) {
          current.parts.add(new Coin((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth, level.numOfCoins));
        }
        if (tpe.equals("blueprint")) {
          current.parts.add(new Coin((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, 0));
        }
        if (tpe.equals("3D blueprint")) {
          current.parts.add(new Coin((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth, 0));
        }
      }
      if (editingStage) {//if edditng stage the increwase the coin counter
        level.numOfCoins++;
        level.reloadCoins();
      }
    }
    if (drawingPortal) {//if drawing portal part 1

      portalStage1=new JSONObject();//create and store data needed for the proper function of the portals
      portalStage2=new JSONObject();
      portalStage1.setString("type", "interdimentional Portal");
      portalStage2.setString("type", "interdimentional Portal");
      if (grid_mode) {
        portalStage1.setInt("x", Math.round(((int)(mouseX)/Scale+camPos)*1.0/grid_size)*grid_size);
        portalStage1.setInt("y", Math.round(((int)(mouseY)/Scale-camPosY)*1.0/grid_size)*grid_size);
        portalStage2.setInt("linkX", Math.round(((int)(mouseX)/Scale+camPos)*1.0/grid_size)*grid_size);
        portalStage2.setInt("linkY", Math.round(((int)(mouseY)/Scale-camPosY)*1.0/grid_size)*grid_size);
      } else {
        portalStage1.setInt("x", (int)(mouseX/Scale)+camPos);
        portalStage1.setInt("y", (int)(mouseY/Scale)-camPosY);
        portalStage2.setInt("linkX", (int)(mouseX/Scale)+camPos);
        portalStage2.setInt("linkY", (int)(mouseY/Scale)-camPosY);
      }
      if (level.stages.get(currentStageIndex).is3D) {
        portalStage1.setInt("z", startingDepth);
        portalStage2.setInt("linkZ", startingDepth);
      }
      portalStage2.setInt("link Index", currentStageIndex+1);
      drawingPortal=false;
      drawingPortal2=true;
      editingStage=false;
      preSI=currentStageIndex;
    }
    if (drawingPortal3) {//if drawing portal part 3

      if (grid_mode) {//gathe the remaining data required and then add the portal to the correct stages
        portalStage2.setInt("x", Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size);
        portalStage2.setInt("y", Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size);
        portalStage1.setInt("linkX", Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size);
        portalStage1.setInt("linkY", Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size);
      } else {
        portalStage2.setInt("x", (int)(mouseX/Scale)+camPos);
        portalStage2.setInt("y", (int)(mouseY/Scale)-camPosY);
        portalStage1.setInt("linkX", (int)(mouseX/Scale)+camPos);
        portalStage1.setInt("linkY", (int)(mouseY/Scale)-camPosY);
      }
      portalStage1.setInt("link Index", currentStageIndex+1);
      if (level.stages.get(currentStageIndex).is3D) {
        portalStage2.setInt("z", startingDepth);
        portalStage1.setInt("linkZ", startingDepth);
      }
      level.stages.get(currentStageIndex).parts.add(new Interdimentional_Portal(portalStage2, level.stages.get(currentStageIndex).is3D));
      level.stages.get(preSI).parts.add(new Interdimentional_Portal(portalStage1, level.stages.get(preSI).is3D));
      portalStage2=null;
      portalStage1=null;
      drawingPortal3=false;
    }
    //add switches
    if (draw3DSwitch1) {
      draw=true;
    }
    if (draw3DSwitch2) {
      draw=true;
    }
    if (drawingSign&&!e3DMode) {//if drawing sign then add the sign to the stage
      String tpe = level.stages.get(currentStageIndex).type;
      if (tpe.equals("stage")) {
        if (grid_mode) {
          current.parts.add(new WritableSign(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size));
        } else {
          current.parts.add(new WritableSign((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY));
        }
      }
      if (tpe.equals("3Dstage")) {
        if (grid_mode) {
          current.parts.add(new WritableSign(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, startingDepth));
        } else {
          current.parts.add(new WritableSign((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, startingDepth));
        }
      }
    }

    if (selecting) {//if selecting figureout what is being selected
      selectedIndex=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, current);
    }
    if (selectingBlueprint&&blueprints.length!=0) {//place selectedb bluepring and paste it into the stage
      boolean type3d = blueprints[currentBluieprintIndex].type.equals("3D blueprint");
      StageComponent tmp;
      int ix, iy, iz = startingDepth;
      if (grid_mode) {
        ix=Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size;
        iy=Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size;
      } else {
        ix=(int)(mouseX/Scale)+camPos;
        iy=(int)(mouseY/Scale)-camPosY;
      }
      for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {//translate the objects from blueprint form into stage readdy form
        tmp=blueprints[currentBluieprintIndex].parts.get(i);
        //coins are special
        if (tmp instanceof Coin) {
          Coin g;
          //make a copy of the coin for the apprirate dimention 
          if(type3d){
            g=(Coin)tmp.copy(ix,iy,iz);
          }else{
            g=(Coin)tmp.copy(ix,iy);
          }
          //set the correct ID for the coin
          g.coinId = level.numOfCoins;
          //add the coin to the stage
          current.parts.add(g);
          coins.add(false);
          level.numOfCoins++;
          continue;
        }
        
        if(type3d){//if the bluepint is 3D
          current.parts.add(tmp.copy(ix,iy,iz));//preform a 3D copy on the curernt part and add it to the stage
        }else{
          current.parts.add(tmp.copy(ix,iy));//preform a 2D copy on a part and add it to the stage
        }
        
      }
    }
    if (placingSound) {
      if (grid_mode) {
        current.parts.add(new SoundBox(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size));
      } else {
        current.parts.add(new SoundBox((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY));
      }
    }
  }//end of eddit stage
}

void GUImousePressed() {
  if (mouseButton==LEFT) {
    if (ground||holo_gram||sloap||holoTriangle||dethPlane) {

      downX=mouseX;
      downY=mouseY;
      drawing=true;
    }
  }
}

void GUImouseReleased() {
  if (mouseButton==LEFT) {
    if ((ground||holo_gram||sloap||holoTriangle||dethPlane)&&drawing) {

      upX=mouseX;
      upY=mouseY;
      drawing=false;
      draw=true;
    }
  }
}

void renderTranslationArrows(float x,float y,float z,float dx, float dy,float dz){
  //wether the red/green/blue arrows are currrntly being hoverd over
  boolean b1=false, b2=false, r1=false, r2=false, g1=false, g2=false;
  //check if the mouse is hovering over an arrow
  for (int i=0; i<5000; i++) {
    Point3D testPoint=genMousePoint(i);
    if (testPoint.x >= (x+dx/2)-5 && testPoint.x <= (x+dx/2)+5 && testPoint.y >= (y+dy/2)-5 && testPoint.y <= (y+dy/2)+5 && testPoint.z >= z+dz && testPoint.z <= z+dz+60) {
      b1=true;
      break;
    }

    if (testPoint.x >= (x+dx/2)-5 && testPoint.x <= (x+dx/2)+5 && testPoint.y >= (y+dy/2)-5 && testPoint.y <= (y+dy/2)+5 && testPoint.z >= z-60 && testPoint.z <= z) {
      b2=true;
      break;
    }

    if (testPoint.x >= x-60 && testPoint.x <= x && testPoint.y >= (y+dy/2)-5 && testPoint.y <= (y+dy/2)+5 && testPoint.z >= (z+dz/2)-5 && testPoint.z <= (z+dz/2)+5) {
      r1=true;
      break;
    }

    if (testPoint.x >= x+dx && testPoint.x <= x+dx+60 && testPoint.y >= (y+dy/2)-5 && testPoint.y <= (y+dy/2)+5 && testPoint.z >= (z+dz/2)-5 && testPoint.z <= (z+dz/2)+5) {
      r2=true;
      break;
    }

    if (testPoint.x >= (x+dx/2)-5 && testPoint.x <= (x+dx/2)+5 && testPoint.y >= y-60 && testPoint.y <= y && testPoint.z >= (z+dz/2)-5 && testPoint.z <= (z+dz/2)+5) {
      g1=true;
      break;
    }

    if (testPoint.x >= (x+dx/2)-5 && testPoint.x <= (x+dx/2)+5 && testPoint.y >= y+dy && testPoint.y <= y+dy+60 && testPoint.z >= (z+dz/2)-5 && testPoint.z <= (z+dz/2)+5) {
      g2=true;
      break;
    }
  }
  
  //render the arrows
  if (current3DTransformMode==1) {
    translate(x+dx/2, y+dy/2, z+dz);
    if (b1)
      shape(yellowArrow);
    else
      shape(blueArrow);

    translate(-(x+dx/2), -(y+dy/2), -(z+dz));

    translate(x+dx/2, y+dy/2, z);
    rotateY(radians(180));
    if (b2)
      shape(yellowArrow);
    else
      shape(blueArrow);
    rotateY(-radians(180));
    translate(-(x+dx/2), -(y+dy/2), -(z));

    translate(x, y+dy/2, z+dz/2);
    rotateY(-radians(90));
    if (r1)
      shape(yellowArrow);
    else
      shape(redArrow);
    rotateY(radians(90));
    translate(-(x), -(y+dy/2), -(z+dz/2));

    translate(x+dx, y+dy/2, z+dz/2);
    rotateY(radians(90));
    if (r2)
      shape(yellowArrow);
    else
      shape(redArrow);
    rotateY(-radians(90));
    translate(-(x+dx), -(y+dy/2), -(z+dz/2));

    translate(x+dx/2, y, z+dz/2);
    rotateX(radians(90));
    if (g1)
      shape(yellowArrow);
    else
      shape(greenArrow);
    rotateX(-radians(90));
    translate(-(x+dx/2), -(y), -(z+dz/2));

    translate(x+dx/2, y+dy, z+dz/2);
    rotateX(-radians(90));
    if (g2)
      shape(yellowArrow);
    else
      shape(greenArrow);
    rotateX(radians(90));
    translate(-(x+dx/2), -(y+dy), -(z+dz/2));
  }
}


void mouseClicked3D() {
  Stage current=null;//figure out what your edditing
    if (editingStage) {
      current=level.stages.get(currentStageIndex);
    }
    if (editingBlueprint) {
      current=workingBlueprint;
    }
  if (selecting)
    for (int i=0; i<5000; i++) {
      Point3D testPoint = genMousePoint(i);
      selectedIndex=colid_index(testPoint.x, testPoint.y, testPoint.z, current);
      if (selectedIndex!=-1)
        break;
    }
  if (ground) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new Ground((int)(testPoint.x-5+5*direction), (int)(testPoint.y-5), (int)(testPoint.z-5), 10, 10, 10, Color));//create the new object
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        current.parts.add(new Ground((int)(testPoint.x-5), (int)(testPoint.y-5+5*direction), (int)(testPoint.z-5), 10, 10, 10, Color));//create the new object
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new Ground((int)(testPoint.x-5), (int)(testPoint.y-5), (int)(testPoint.z-5+5*direction), 10, 10, 10, Color));//create the new object
        break;
      }
    }
  }
  if (holo_gram) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane    used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);
        if (Float.isNaN(direction)) {
          direction=cos(rx_z)/abs(cos(rx_z));
        }
        current.parts.add(new Holo((int)(testPoint.x-5+5*direction), (int)(testPoint.y-5), (int)(testPoint.z-5), 10, 10, 10, Color));
        break;
      }
      omp.y=testPoint.y;
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);
        if (Float.isNaN(direction)) {
          direction=sin(ry_xz)/abs(sin(ry_xz));
        }
        current.parts.add(new Holo((int)(testPoint.x-5), (int)(testPoint.y-5+5*direction), (int)(testPoint.z-5), 10, 10, 10, Color));
        break;
      }
      omp.z=testPoint.z;
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);
        if (Float.isNaN(direction)) {
          direction=sin(rx_z)/abs(sin(rx_z));
        }
        current.parts.add(new Holo((int)(testPoint.x-5), (int)(testPoint.y-5), (int)(testPoint.z-5+5*direction), 10, 10, 10, Color));
        break;
      }
    }
  }
  if (check_point) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new CheckPoint((int)(testPoint.x+5*direction), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        current.parts.add(new CheckPoint((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new CheckPoint((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+5*direction)));//create the new object
        break;
      }
    }
  }
  if (drawCoins) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        if(editingBlueprint){
          current.parts.add(new Coin((int)(testPoint.x+30*direction), (int)(testPoint.y), (int)(testPoint.z), 0));//create the new object
        }else{
          current.parts.add(new Coin((int)(testPoint.x+30*direction), (int)(testPoint.y), (int)(testPoint.z), level.numOfCoins));//create the new object
          coins.add(false);
          level.numOfCoins++;
        }
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        if(editingBlueprint){
          current.parts.add(new Coin((int)(testPoint.x), (int)(testPoint.y+30*direction), (int)(testPoint.z), 0));//create the new object
        }else{
          current.parts.add(new Coin((int)(testPoint.x), (int)(testPoint.y+30*direction), (int)(testPoint.z), level.numOfCoins));//create the new object
          coins.add(false);
          level.numOfCoins++;
        }
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        if(editingBlueprint){
          current.parts.add(new Coin((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+30*direction), 0));//create the new object
        }else{
          current.parts.add(new Coin((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+30*direction), level.numOfCoins));//create the new object
          coins.add(false);
          level.numOfCoins++;
        }
        break;
      }
    }
  }
  if (draw3DSwitch1) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new SWon3D((int)(testPoint.x+20*direction), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        current.parts.add(new SWon3D((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new SWon3D((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+20*direction)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
    }
  }
  if (draw3DSwitch2) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new SWoff3D((int)(testPoint.x+20*direction), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        current.parts.add(new SWoff3D((int)testPoint.x, (int)testPoint.y, (int)testPoint.z));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new SWoff3D((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+20*direction)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
    }
  }
  if (drawingSign) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new WritableSign((int)(testPoint.x+35*direction), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        current.parts.add(new WritableSign((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new WritableSign((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+5*direction)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
    }
  }
  if (placingLogicButton) {
    calcMousePoint();
    Point3D omp=genMousePoint(0);
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new LogicButton((int)(testPoint.x+20*direction), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        current.parts.add(new LogicButton((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        current.parts.add(new LogicButton((int)(testPoint.x), (int)(testPoint.y), (int)(testPoint.z+20*direction)));//create the new object
        coins.add(false);
        level.numOfCoins++;
        break;
      }
    }
  }
  if (deleteing) {
    for (int i=0; i<5000; i++) {
      Point3D testPoint = genMousePoint(i);
      int deleteIndex=colid_index(testPoint.x, testPoint.y, testPoint.z, current);
      if (deleteIndex!=-1) {
        StageComponent removed = current.parts.remove(deleteIndex);
        if (current.interactables.contains(removed)) {
          current.interactables.remove(removed);
        }
        break;
      }
    }
  }
}




/**coppy the blueprint so it can be correctly positoned on top of the stage for viewing
 
 */
void generateDisplayBlueprint() {
  String type = blueprints[currentBluieprintIndex].type;
  boolean type3d = type.equals("3D blueprint");
  displayBlueprint=new Stage("tmp", type);
  int ix, iy, iz =startingDepth;
  if (grid_mode) {
    ix=Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size;
    iy=Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size;
  } else {
    ix=(int)(mouseX/Scale)+camPos;
    iy=(int)(mouseY/Scale)-camPosY;
  }


  for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {
    displayBlueprint.parts.add(blueprints[currentBluieprintIndex].parts.get(i).copy());
    if (displayBlueprint.parts.get(i).type.equals("sloap")||displayBlueprint.parts.get(i).type.equals("holoTriangle")) {
      displayBlueprint.parts.get(i).dx+=ix;
      displayBlueprint.parts.get(i).dy+=iy;
      if(type3d){
        displayBlueprint.parts.get(i).dz+=iz;
      }
    }
    displayBlueprint.parts.get(i).x+=ix;
    displayBlueprint.parts.get(i).y+=iy;
    if(type3d){
      displayBlueprint.parts.get(i).z+=iz;
    }
    //System.out.println(displayBlueprint.parts.get(i).x);
  }
}

void generateDisplayBlueprint3D() {
  String type = blueprints[currentBluieprintIndex].type;
  displayBlueprint=new Stage("tmp", type);
  float ix = blueprintPlacemntX, iy = blueprintPlacemntY, iz = blueprintPlacemntZ;
  blueprintMax=new float[]{-66666666,-66666666,-66666666};
  blueprintMin=new float[]{66666666,66666666,66666666};
  for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {
    StageComponent part = blueprints[currentBluieprintIndex].parts.get(i).copy(ix,iy,iz);
    displayBlueprint.parts.add(part);
    //NOTE this will have to be reworked when sloaps are added to 3D
    blueprintMax[0]=max(blueprintMax[0],part.x+part.dx);
    blueprintMax[1]=max(blueprintMax[1],part.y+part.dy);
    blueprintMax[2]=max(blueprintMax[2],part.z+part.dz);
    blueprintMin[0]=min(blueprintMin[0],part.x);
    blueprintMin[1]=min(blueprintMin[1],part.y);
    blueprintMin[2]=min(blueprintMin[2],part.z);
  }
}

void renderBlueprint() {//render the blueprint on top of the stage
  for (int i=0; i<displayBlueprint.parts.size(); i++) {
    displayBlueprint.parts.get(i).draw();
  }
}

void renderBlueprint3D() {//render the blueprint on top of the stage
  for (int i=0; i<displayBlueprint.parts.size(); i++) {
    displayBlueprint.parts.get(i).draw3D();
  }
}

//dfa=default aspect ratio car=current aspect ratio
float dfa=1280.0/720, car=1.0*width/height;
Point3D mousePoint=new Point3D(0, 0, 0);
void calcMousePoint() {//get a 3d point that is at the same postition as the mouse curser

  car=1.0*width/height;
  float planeDist=622/*700*/;
  float camCentercCalcX, camCentercCalcY, camCentercCalcZ;//get a point that is a certain distance from where the camera eyes are in the center if the screen
  camCentercCalcY=sin(radians(yangle))*planeDist+cam3Dy-DY;//calculate the center point of the camera on the plane that is a distacne from the eye point of the camera
  float hd2=cos(radians(yangle))*-planeDist;//calcualte a new hypotenuse for the x/z axis where the result from the calculation of the Y coord is taken into account
  camCentercCalcX=sin(radians(xangle))*hd2+cam3Dx+DX;//use the new hypotenuse to calculate the x and z points
  camCentercCalcZ=cos(radians(xangle))*-hd2+cam3Dz-DZ;


  float midDistX=-1*(mouseX-width/2)/((width/1280.0)/(car/dfa)), midDistY=(mouseY-height/2)/(height/720.0);//calculate the mouse's distance from the center of the window adjusted to the plane that is a distacne from the camera
  float nz=sin(radians(-xangle))*midDistX, nx=cos(radians(-xangle))*midDistX;//calcuate the new distacne from the cenetr of trhe plane the points are at
  float ny=cos(radians(yangle))*midDistY, nd=sin(radians(yangle))*midDistY;
  nz+=cos(radians(xangle))*nd;//adjust those points for the rotation of the plane
  nx+=sin(radians(xangle))*nd;
  //calculate the final coorinates of the point that is at the cameras pos
  mousePoint=new Point3D(camCentercCalcX+nx, camCentercCalcY+ny, camCentercCalcZ-nz);
}

Point3D genMousePoint(float hyp) {//calcualte the coords of a new point that is in line through the mouse pointer at a set distance from the camera
  calcMousePoint();//make shure the mouse position is up to date
  float x, y, z, ry_xz, rx_z, xzh;//define variables that will be used
  hyp*=-1;//invert the inputed distance
  xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane
  ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
  rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
  y=(sin(ry_xz)*hyp)+cam3Dy-DY;//calculate the y component of the new line
  float nh = cos(ry_xz)*hyp;//calculate the total length of the x-z component of the new linw
  z=(sin(rx_z)*nh)+cam3Dz-DZ;//calculate the z component of the new line
  x=(cos(rx_z)*nh)+cam3Dx+DX;//calculate the x component of the new line`

  return new Point3D(x, y, z);
}
class Point3D {
  float x, y, z;
  Point3D(float x, float y, float z) {
    this.x=x;
    this.y=y;
    this.z=z;
  }

  public String toString() {
    return x+" "+y+" "+z;
  }
}
