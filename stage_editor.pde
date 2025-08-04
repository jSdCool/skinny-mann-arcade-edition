//start of stage_editor.pde
/**Render the GUI for the stage editor. Note: this is also generaly responcable for component placement
*/
void stageEditGUI() {

  textAlign(LEFT, BOTTOM);


  int adj;//color adjustment stuff that may be useless
  if (RC == 0 && GC == 0 && BC > 0) {
    adj=256;
  } else {
    adj=0;
  }
  Color=(int)(RC*Math.pow(16, 4)+GC*Math.pow(16, 2)+BC+adj)-16777215;//calculate the color from the level creator, this may be useless
  Color=scr2.CC;

  Stage current=null;//setup a varable that can be used for the current stage or blueprint
  if (editingStage) {//if editing a stage
    current=level.stages.get(currentStageIndex);
  }
  if (editingBlueprint) {//if editing a blueprint
    current=workingBlueprint;
  }

  if (current.type.equals("stage")||current.type.equals("blueprint")) {//if current is a 2D stage or blueprint
  
    if (grid_mode) {//grid mode position box
      int X2=0, Y2=0, X1=0, Y1=0;
      X1=(int)(((floor((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale);
      X2=(int)(grid_size*Scale);//(int)(((int)(Math.ceil((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale)-X1;
      Y1=(int)(((floor((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale);
      Y2=(int)(grid_size*Scale);//(int)(((int)(Math.ceil((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale)-abs(Y1);\
      fill(#AAAA00,120);
      rect(X1,Y1,X2,Y2);
    }

    if (drawing && currentlyPlaceing != null && StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if drawing a dragable shape
      StageComponentRegistry.DraggablePlacementPreview preview = StageComponentRegistry.getDragPreview(currentlyPlaceing);
      boolean isSloap = currentlyPlaceing.equals(Sloap.ID) || currentlyPlaceing.equals(HoloTriangle.ID);//figure out if the thing currently being placed is a slope type
      //becasue slopes are special and palce alightly diffrently
      if (grid_mode) {//if gridmode is on
        if (isSloap) {//if your currenly drawing a triangle type
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
          
          preview.draw(g, X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, Color, triangleMode, Scale);
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

          preview.draw(g, X1*Scale, Y1*Scale, XD*Scale, YD*Scale, Color, triangleMode, Scale);//display the rectangle that is being drawn
        }
      } else {//if grid mode is off
        if (isSloap) {
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
          
            
          preview.draw(g, X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, Color, triangleMode, Scale);//draw the preview of that os being placed
              
        } else {
          strokeWeight(0);
          float xdif=(int)((mouseX-downX)/Scale)*Scale, ydif=(int)((mouseY-downY)/Scale)*Scale;//calcaute the location of the mouese press and unpress location
           preview.draw(g, (int)(downX/Scale)*Scale, (int)(downY/Scale)*Scale, xdif, ydif, Color, triangleMode, Scale);//display the rectangle that is being drawn
        }
      }
    }

    //if placing a draggable and it is time to add it to the level
    if (draw && StageComponentRegistry.isDraggable(currentlyPlaceing)) {

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
        if (downX==upX) {//if there was no change is mouse position then don't create a new component
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
        if (downX==upX) {//if there was no change is mouse position then don't create a new component
          draw=false;
          return ;
        }
        if (downY==upY) {
          draw=false;
          return;
        }
      }
      //get the drag constructor of the component
      Function<StageComponentDragPlacementContext, StageComponent> constructor = StageComponentRegistry.getDragConstructor(currentlyPlaceing);
      if(constructor == null){
        throw new RuntimeException("Constructor not found for dragagble: "+currentlyPlaceing);
      }
      StageComponentDragPlacementContext placementContext = new StageComponentDragPlacementContext(X1, Y1, XD, YD, Color, triangleMode);
      //create the new component
      current.add(constructor.apply(placementContext));//add the new element to the stage
      draw=false;
    }//end of add draggable to stage

    if (deleteing&&delete) {//if attempting to delete something
      int index=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, current);//get the index of the element the mouse is currently over
      if (index==-1) {//if the mouse was over nothing then do nothing
        Collider2D c2D = Collider2D.createRectHitbox(mouseX/Scale+camPos-0.5f,mouseY/Scale-camPosY-0.5f,1,1);
        //check for collision with entities
        for(int i=0;i<current.entities.size();i++){
          if(CollisionDetection.collide2D(current.entities.get(i).getHitBox2D(0,0),c2D)){//if clicking on a entity
            current.entities.remove(i);//remove that entity
            break;
          }
        }
      } else {//if a stage component was clicked
        StageComponent removed = current.parts.remove(index);//remove the object the mosue was over
        if (current.interactables.contains(removed)) {
          current.interactables.remove(removed);
        }
      }
      delete=false;//stop deleteing
    }//end of delete
    
    //draw placeable preview
    if(currentlyPlaceing != null && !StageComponentRegistry.isDraggable(currentlyPlaceing)){//if currently placing something, that is not a draggable
      StageComponentRegistry.PlacementPreview preview = StageComponentRegistry.getPreview(currentlyPlaceing);//get the preview renderer for this component
      if(preview != null){//if it has a preview
        if (grid_mode) {//display the preview with the appropriate respect to grid mode
          preview.draw(g, (Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos), (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY), Scale);
        } else {
          preview.draw(g, (int)(mouseX/Scale), (int)(mouseY/Scale), Scale);
        }
      }
    }
    //portals are special
    if (drawingPortal || drawingPortal3) {//if adding portal part 1 reder a portal
      if (grid_mode) {//if gridmode is on
        drawPortal((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, 1*Scale,g);//draw a grid aligned portal
      } else {
        drawPortal((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, 1*Scale,g);//draw a portal
      }
    }
    
    //2D Component Transformations
    if (selectedIndex!=-1) {//if something is selected
      StageComponent ct=current.parts.get(selectedIndex);//get the selected componenet
      //2D Rotation
      if(current3DTransformMode==3 && ct instanceof Rotatable){//if rotating
        //prepair the visual center pos
        PVector center = ct.getCenter();
        center.z=0;
        center.mult(Scale);
        center.x -= drawCamPosX*Scale;
        center.y += drawCamPosY*Scale;
        float sze = sqrt(pow(ct.getWidth()/2,2)+pow(ct.getHeight()/2,2))*2.5;//calculate the circle size
        
        //draw the circle
        fill(0,0);
        if(dist(mouseX,mouseY,center.x,center.y) <= sze/2*Scale){
          stroke(255,255,0);
        }else{
          stroke(0,0,255);
        }
        strokeWeight(4);
        circle(center.x,center.y,sze*Scale);
        noStroke();
        
        //rotation functionality
        if(translateZaxis){
          //basically just get the angle between where the mouse is now and where it was when the rotation started
          Rotatable rotb = (Rotatable)ct;
          PVector AB = PVector.sub(initalMousePoint.toPVector(),center,null);
          PVector BC = PVector.sub(center, new PVector(mouseX,mouseY),null);
          AB.normalize();
          BC.normalize();
          BC.mult(-1);//make both face the smae direction if the start and current points are the same place
          float angleDiff = acos(AB.dot(BC));
          //this is some math shit I do not completely
          if(PVector.cross(AB,BC,null).dot(rotb.getZRotationAxis()) <= 0){
            angleDiff*=-1;
          }
          //then apply it to the correct axis
          if(grid_mode){
            rotb.rotateZ(radians(Math.round(degrees(currentComponentRotation.z+angleDiff)/grid_size)*grid_size));
          }else{
            rotb.rotateZ(currentComponentRotation.z+angleDiff);
          }
          
        }
      }//end of rotating
      
    }//end of transformations
  }//end of 2D stage edit gui

  if (current.type.equals("3Dstage") || current.type.equals("3D blueprint")) {//if in a 3D stage

    if (!e3DMode) {//if 3D mode is off
      if (grid_mode) {//grid mode position box for 2D
        int X2=0, Y2=0, X1=0, Y1=0;
        X1=(int)(((floor((mouseX/Scale+camPos)/grid_size)*grid_size)-camPos)*Scale);
        X2=(int)(grid_size*Scale);
        Y1=(int)(((floor((mouseY/Scale-camPosY)/grid_size)*grid_size)+camPosY)*Scale);
        Y2=(int)(grid_size*Scale);
        fill(#AAAA00,120);
        rect(X1,Y1,X2,Y2);
      }

      if (drawing && currentlyPlaceing != null && StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if drawing a dragable shape
      StageComponentRegistry.DraggablePlacementPreview preview = StageComponentRegistry.getDragPreview(currentlyPlaceing);//get the preview for that shape
      boolean isSloap = currentlyPlaceing.equals(Sloap.ID) || currentlyPlaceing.equals(HoloTriangle.ID);//hard coded shit for sloapes (lol no idea why I still need this)
      if (grid_mode) {//if gridmode is on
        if (isSloap) {//if your currenly drawing a triangle type
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
          
          preview.draw(g, X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, Color, triangleMode, Scale);//render its preview
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

          preview.draw(g, X1*Scale, Y1*Scale, XD*Scale, YD*Scale, Color, triangleMode, Scale);//display the shape that is being drawn
        }
      } else {//if grid mode is off
        if (isSloap) {
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
          
            
          preview.draw(g, X1*Scale, Y1*Scale, X2*Scale, Y2*Scale, Color, triangleMode, Scale);//preview the triangle
              
        } else {
          strokeWeight(0);
          float xdif=(int)((mouseX-downX)/Scale)*Scale, ydif=(int)((mouseY-downY)/Scale)*Scale;//calcaute the location of the mouese press and unpress location
           preview.draw(g, (int)(downX/Scale)*Scale, (int)(downY/Scale)*Scale, xdif, ydif, Color, triangleMode, Scale);//display the shape that is being drawn
        }
      }
    }

      if (draw && StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if placeing a draggable 
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
          if (downX==upX) {//if there was no change is mouse position then don't create a new componenet
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
          if (downX==upX) {//if there was no change is mouse position then don't create a new component
            draw=false;
            return ;
          }
          if (downY==upY) {
            draw=false;
            return;
          }
        }
        
        Function<StageComponentDragPlacementContext, StageComponent> constructor = StageComponentRegistry.getDragConstructor(currentlyPlaceing);//get the constructor for this component
        if(constructor == null){
          throw new RuntimeException("Constructor not found for dragagble: "+currentlyPlaceing);
        }
        StageComponentDragPlacementContext placementContext = new StageComponentDragPlacementContext(X1, Y1, startingDepth, XD, YD, totalDepth, Color, triangleMode);
        //create the new component
        current.add(constructor.apply(placementContext));//add the new element to the stage
        draw=false;
      }//end of placeing draggable

      if (deleteing&&delete) {//if deleting things
        int index=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, level.stages.get(currentStageIndex));//figure out what thing the mouse is over
        if (index==-1) {//if the mouse is over nothing then do nothing
          Collider2D c2D = Collider2D.createRectHitbox(mouseX/Scale+camPos-0.5f,mouseY/Scale-camPosY-0.5f,1,1);
          //check for collision with entities
          for(int i=0;i<current.entities.size();i++){
            if(CollisionDetection.collide2D(current.entities.get(i).getHitBox2D(0,0),c2D)){//if over an entity
              current.entities.remove(i);//delete the entity
              break;
            }
          }
        } else {//if over a component
          StageComponent removed = current.parts.remove(index);//remove the object the mosue was over
          if (current.interactables.contains(removed)) {
            current.interactables.remove(removed);
          }
        }
        delete=false;
      }
      
      //draw placeable preview
      if(currentlyPlaceing != null && !StageComponentRegistry.isDraggable(currentlyPlaceing)){//if currently placing a placeable
        StageComponentRegistry.PlacementPreview preview = StageComponentRegistry.getPreview(currentlyPlaceing);//get the preview renderer for this component
        if (grid_mode) {//render it appropriatly 
            preview.draw(g, (Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos), (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY), Scale);
          } else {
            preview.draw(g, (int)(mouseX/Scale), (int)(mouseY/Scale), Scale);
          }
      }
     
      if (drawingPortal || drawingPortal3) {//if placing a portal
        if (grid_mode) {//diaply the portal
          drawPortal((Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size-camPos)*Scale, (Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size+camPosY)*Scale, Scale,g);
        } else {
          drawPortal((int)(mouseX/Scale)*Scale, (int)(mouseY/Scale)*Scale, Scale,g);
        }
      }
      
      //2D 3D Component transformations
      if (selectedIndex!=-1) {//if selecting somethings
        StageComponent ct = current.parts.get(selectedIndex);
        //2D Rotation
        if(current3DTransformMode==3 && ct instanceof Rotatable){//if rotating
          //prepair the visual center pos
          PVector center = ct.getCenter();
          center.z=0;
          center.mult(Scale);
          center.x -= drawCamPosX*Scale;
          center.y += drawCamPosY*Scale;
          float sze = sqrt(pow(ct.getWidth()/2,2)+pow(ct.getHeight()/2,2))*2.5;//calulcate the size of the circle
          
          //draw the circle
          fill(0,0);
          if(dist(mouseX,mouseY,center.x,center.y) <= sze/2*Scale){
            stroke(255,255,0);
          }else{
            stroke(0,0,255);
          }
          strokeWeight(4);
          circle(center.x,center.y,sze*Scale);
          noStroke();
          
          //rotation functionality
          if(translateZaxis){
            Rotatable rotb = (Rotatable)ct;
            //calculate the angle between the mouse and the origional mouse pos
            PVector AB = PVector.sub(initalMousePoint.toPVector(),center,null);
            PVector BC = PVector.sub(center, new PVector(mouseX,mouseY),null);
            AB.normalize();
            BC.normalize();
            BC.mult(-1);//make both face the smae direction if the start and current points are the same place
            float angleDiff = acos(AB.dot(BC));
            //println(angleDiff+" "+initalMousePoint+" "+objectCenter+" "+inPlane);
            if(PVector.cross(AB,BC,null).dot(rotb.getZRotationAxis()) <= 0){
              angleDiff*=-1;
            }
            //then apply it to the correct axis
            if(grid_mode){
              rotb.rotateZ(radians(Math.round(degrees(currentComponentRotation.z+angleDiff)/grid_size)*grid_size));
            }else{
              rotb.rotateZ(currentComponentRotation.z+angleDiff);
            }
            
          }
        }
        
      }
      
      
    }//end of is 3d mode off if statment
    else {//if 3dmode is on
    
      //3D Component transformations
      if (selectedIndex!=-1) {//if something is selected
        //wether the red/green/blue arrows are currrntly being hoverd over
        boolean b1=false, b2=false, r1=false, r2=false, g1=false, g2=false, rix=false,riy=false,riz=false;
        StageComponent ct=current.parts.get(selectedIndex);
        //check if the mouse is hovering over an arrow
        for (int i=0; i<5000; i++) {//ray cast
          Point3D testPoint=genMousePoint(i);//get the point that is i units from the camera where the mouse is
          if(!(current3DTransformMode==3 && ct instanceof Rotatable)){//if not rotating
            //check if the current mouse point is inside of one of the translation arrows / scaling stocks
            if (testPoint.x >= (ct.getX()+ct.getWidth()/2)-5 && testPoint.x <= (ct.getX()+ct.getWidth()/2)+5 && testPoint.y >= (ct.getY()+ct.getHeight()/2)-5 && testPoint.y <= (ct.getY()+ct.getHeight()/2)+5 && testPoint.z >= ct.getZ()+ct.getDepth() && testPoint.z <= ct.getZ()+ct.getDepth()+60) {
              b1=true;
              break;
            }
  
            if (testPoint.x >= (ct.getX()+ct.getWidth()/2)-5 && testPoint.x <= (ct.getX()+ct.getWidth()/2)+5 && testPoint.y >= (ct.getY()+ct.getHeight()/2)-5 && testPoint.y <= (ct.getY()+ct.getHeight()/2)+5 && testPoint.z >= ct.getZ()-60 && testPoint.z <= ct.getZ()) {
              b2=true;
              break;
            }
  
            if (testPoint.x >= ct.getX()-60 && testPoint.x <= ct.getX() && testPoint.y >= (ct.getY()+ct.getHeight()/2)-5 && testPoint.y <= (ct.getY()+ct.getHeight()/2)+5 && testPoint.z >= (ct.getZ()+ct.getDepth()/2)-5 && testPoint.z <= (ct.getZ()+ct.getDepth()/2)+5) {
              r1=true;
              break;
            }
  
            if (testPoint.x >= ct.getX()+ct.getWidth() && testPoint.x <= ct.getX()+ct.getWidth()+60 && testPoint.y >= (ct.getY()+ct.getHeight()/2)-5 && testPoint.y <= (ct.getY()+ct.getHeight()/2)+5 && testPoint.z >= (ct.getZ()+ct.getDepth()/2)-5 && testPoint.z <= (ct.getZ()+ct.getDepth()/2)+5) {
              r2=true;
              break;
            }
  
            if (testPoint.x >= (ct.getX()+ct.getWidth()/2)-5 && testPoint.x <= (ct.getX()+ct.getWidth()/2)+5 && testPoint.y >= ct.getY()-60 && testPoint.y <= ct.getY() && testPoint.z >= (ct.getZ()+ct.getDepth()/2)-5 && testPoint.z <= (ct.getZ()+ct.getDepth()/2)+5) {
              g1=true;
              break;
            }
  
            if (testPoint.x >= (ct.getX()+ct.getWidth()/2)-5 && testPoint.x <= (ct.getX()+ct.getWidth()/2)+5 && testPoint.y >= ct.getY()+ct.getHeight() && testPoint.y <= ct.getY()+ct.getHeight()+60 && testPoint.z >= (ct.getZ()+ct.getDepth()/2)-5 && testPoint.z <= (ct.getZ()+ct.getDepth()/2)+5) {
              g2=true;
              break;
            }
          }
        }
        
        if(current3DTransformMode==3 && ct instanceof Rotatable){//if rotating
          //figure out what circle to hilight
          if(!(translateXaxis || translateYaxis || translateZaxis)){
            PVector center = ct.getCenter();
            float sze = sqrt(pow(ct.getWidth()/2,2)+pow(ct.getHeight()/2,2)+pow(ct.getDepth()/2,2))/28;
            sze*=31;//scale factor to make the cyleners the right size
            Rotatable rota = (Rotatable)ct;
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
              rix=true;
            }
            if(distToCenterY.mag() <= sze){
              riy=true;
            }
            if(distToCenterZ.mag() <= sze){
              riz=true;
            }
            
            
            //if multiple are selcted then only select the one that is closested to the camera
            if(rix && riy){
              if(distToCamX.mag() < distToCamY.mag()){
                riy = false;
              }else{
                rix = false;
              }
            }
            if(rix && riz){
              if(distToCamX.mag() < distToCamZ.mag()){
                riz = false;
              }else{
                rix = false;
              }
            }
            if(riy && riz){
              if(distToCamY.mag() < distToCamZ.mag()){
                riz = false;
              }else{
                riy = false;
              }
            }
          }else{
            //if actively rotatin then hilight that specific cirlce
            rix = translateXaxis;
            riy = translateYaxis;
            riz = translateZaxis;
          }
        }
        
        //render the arrow for translation
        if (current3DTransformMode==1) {
          translate(ct.getX()+ct.getWidth()/2, ct.getY()+ct.getHeight()/2, ct.getZ()+ct.getDepth());
          if (b1) {
            shape(yellowArrow);
          } else {
            shape(blueArrow);
          }

          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()+ct.getDepth()));

          translate(ct.getX()+ct.getWidth()/2, ct.getY()+ct.getHeight()/2, ct.getZ());
          rotateY(radians(180));
          if (b2) {
            shape(yellowArrow);
          } else {
            shape(blueArrow);
          }
          rotateY(-radians(180));
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()));

          translate(ct.getX(), ct.getY()+ct.getHeight()/2, ct.getZ()+ct.getDepth()/2);
          rotateY(-radians(90));
          if (r1) {
            shape(yellowArrow);
          } else {
            shape(redArrow);
          }
          rotateY(radians(90));
          translate(-(ct.getX()), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()+ct.getDepth()/2));

          translate(ct.getX()+ct.getWidth(), ct.getY()+ct.getHeight()/2, ct.getZ()+ct.getDepth()/2);
          rotateY(radians(90));
          if (r2) {
            shape(yellowArrow);
          } else {
            shape(redArrow);
          }
          rotateY(-radians(90));
          translate(-(ct.getX()+ct.getWidth()), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()+ct.getDepth()/2));

          translate(ct.getX()+ct.getWidth()/2, ct.getY(), ct.getZ()+ct.getDepth()/2);
          rotateX(radians(90));
          if (g1) {
            shape(yellowArrow);
          } else {
            shape(greenArrow);
          }
          rotateX(-radians(90));
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()), -(ct.getZ()+ct.getDepth()/2));

          translate(ct.getX()+ct.getWidth()/2, ct.getY()+ct.getHeight(), ct.getZ()+ct.getDepth()/2);
          rotateX(-radians(90));
          if (g2) {
            shape(yellowArrow);
          } else {
            shape(greenArrow);
          }
          rotateX(radians(90));
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()+ct.getHeight()), -(ct.getZ()+ct.getDepth()/2));
          //end of rendering arrows

          //translte objects in 3D functionality
          //calculate how far the thing has been moved in the axis of translation and set its new position acordingly
          if (grid_mode) {//if in grid mode
            if (translateZaxis) {
              ct.setZ((int)Math.round((initalObjectPos.z-initalMousePoint.z+mousePoint.z)*1.0/grid_size)*grid_size);
            }
            if (translateXaxis) {
              ct.setX((int)Math.round((initalObjectPos.x-initalMousePoint.x+mousePoint.x)*1.0/grid_size)*grid_size);
            }
            if (translateYaxis) {
              ct.setY((int)Math.round((initalObjectPos.y-initalMousePoint.y+mousePoint.y)*1.0/grid_size)*grid_size);
            }
          } else {//if not in grid mdoe
            if (translateZaxis) {
              ct.setZ((int)initalObjectPos.z-(initalMousePoint.z-mousePoint.z));
            }
            if (translateXaxis) {
              ct.setX((int)initalObjectPos.x-(initalMousePoint.x-mousePoint.x));
            }
            if (translateYaxis) {
              ct.setY((int)initalObjectPos.y-(initalMousePoint.y-mousePoint.y));
            }
          }
        }//end of 3d transform mode is move

        if (current3DTransformMode == 2 && ct instanceof Resizeable) {//if resizing a component
        //render the scaling stocks
          translate(ct.getX()+ct.getWidth()/2, ct.getY()+ct.getHeight()/2, ct.getZ()+ct.getDepth());
          if (b1) {
            shape(yellowScaler);
          } else {
            shape(blueScaler);
          }
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()+ct.getDepth()));

          translate(ct.getX()+ct.getWidth()/2, ct.getY()+ct.getHeight()/2, ct.getZ());
          rotateY(radians(180));
          if (b2) {
            shape(yellowScaler);
          } else {
            shape(blueScaler);
          }
          rotateY(-radians(180));
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()));

          translate(ct.getX(), ct.getY()+ct.getHeight()/2, ct.getZ()+ct.getDepth()/2);
          rotateY(-radians(90));
          if (r1) {
            shape(yellowScaler);
          } else {
            shape(redScaler);
          }
          rotateY(radians(90));
          translate(-(ct.getX()), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()+ct.getDepth()/2));

          translate(ct.getX()+ct.getWidth(), ct.getY()+ct.getHeight()/2, ct.getZ()+ct.getDepth()/2);
          rotateY(radians(90));
          if (r2) {
            shape(yellowScaler);
          } else {
            shape(redScaler);
          }
          rotateY(-radians(90));
          translate(-(ct.getX()+ct.getWidth()), -(ct.getY()+ct.getHeight()/2), -(ct.getZ()+ct.getDepth()/2));

          translate(ct.getX()+ct.getWidth()/2, ct.getY(), ct.getZ()+ct.getDepth()/2);
          rotateX(radians(90));
          if (g1) {
            shape(yellowScaler);
          } else {
            shape(greenScaler);
          }
          rotateX(-radians(90));
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()), -(ct.getZ()+ct.getDepth()/2));

          translate(ct.getX()+ct.getWidth()/2, ct.getY()+ct.getHeight(), ct.getZ()+ct.getDepth()/2);
          rotateX(-radians(90));
          if (g2) {
            shape(yellowScaler);
          } else {
            shape(greenScaler);
          }
          rotateX(radians(90));
          translate(-(ct.getX()+ct.getWidth()/2), -(ct.getY()+ct.getHeight()), -(ct.getZ()+ct.getDepth()/2));

          //scaling of objects in 3D functionality
          if (grid_mode) {
            if (transformComponentNumber==1) {//if the first set of stocker was clicked
              //resize the approtiate axis within the allowed limits
              if (translateZaxis) {
                if (initialObjectDim.z-Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size > 0){
                  ct.setDepth(initialObjectDim.z-Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size);
                }
              }
              if (translateXaxis) {
                if (initialObjectDim.x-Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size > 0){
                  ct.setWidth(initialObjectDim.x-Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size);
                }
              }
              if (translateYaxis) {
                if (initialObjectDim.y-Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size > 0){
                  ct.setHeight(initialObjectDim.y-Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size);
                }
              }
            }
            
            if (transformComponentNumber==2) {//if the second set of stocks was clicked
              //resize the approtiate axis within the allowed limits
              if (translateZaxis) {
                if (initialObjectDim.z+Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size > 0) {
                  ct.setDepth(initialObjectDim.z+Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size);
                  ct.setZ((initalObjectPos.z-Math.round((initalMousePoint.z-mousePoint.z)*1.0/grid_size)*grid_size));
                }
              }
              if (translateXaxis) {
                if (initialObjectDim.x+Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size > 0) {
                  ct.setWidth(initialObjectDim.x+Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size);
                  ct.setX((initalObjectPos.x-Math.round((initalMousePoint.x-mousePoint.x)*1.0/grid_size)*grid_size));
                }
              }
              if (translateYaxis) {
                if (initialObjectDim.y+Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size > 0) {
                  ct.setHeight(initialObjectDim.y+Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size);
                  ct.setY((initalObjectPos.y-Math.round((initalMousePoint.y-mousePoint.y)*1.0/grid_size)*grid_size));
                }
              }
            }
          } else {//if not in grid mode
            if (transformComponentNumber==1) { //if the first set of stocker was clicked
              //resize the approtiate axis within the allowed limits
              if (translateZaxis) {
                if (initialObjectDim.z-(initalMousePoint.z-mousePoint.z) > 0){
                  ct.setDepth(initialObjectDim.z-(initalMousePoint.z-mousePoint.z));
                }
              }
              if (translateXaxis) {
                if (initialObjectDim.x-(initalMousePoint.x-mousePoint.x) > 0){
                  ct.setWidth(initialObjectDim.x-(initalMousePoint.x-mousePoint.x));
                }
              }
              if (translateYaxis) {
                if (initialObjectDim.y-(initalMousePoint.y-mousePoint.y) > 0){
                  ct.setHeight(initialObjectDim.y-(initalMousePoint.y-mousePoint.y));
                }
              }
            }
            if (transformComponentNumber==2) {//if the second set of stocks was clicked
              //resize the approtiate axis within the allowed limits
              if (translateZaxis) {
                if (initialObjectDim.z+(initalMousePoint.z-mousePoint.z) > 0) {
                  ct.setDepth(initialObjectDim.z+(initalMousePoint.z-mousePoint.z));
                  ct.setZ(initalObjectPos.z-(initalMousePoint.z-mousePoint.z));
                }
              }
              if (translateXaxis) {
                if (initialObjectDim.x+(initalMousePoint.x-mousePoint.x) > 0) {
                  ct.setWidth(initialObjectDim.x+(initalMousePoint.x-mousePoint.x));
                  ct.setX(initalObjectPos.x-(initalMousePoint.x-mousePoint.x));
                }
              }
              if (translateYaxis) {
                if (initialObjectDim.y+(initalMousePoint.y-mousePoint.y) > 0) {
                  ct.setHeight(initialObjectDim.y+(initalMousePoint.y-mousePoint.y));
                  ct.setY(initalObjectPos.y-(initalMousePoint.y-mousePoint.y));
                }
              }
            }
          }
        }//end of 3d transform mode is scale
        
        if(current3DTransformMode==3 && ct instanceof Rotatable){//if rotating something
          Rotatable rotb = (Rotatable)ct;
          PVector center = ct.getCenter();
          PVector cameraVec = new PVector(cam3Dx+DX,cam3Dy-DY,cam3Dz-DZ), mousePointVec = new PVector(mousePoint.x,mousePoint.y,mousePoint.z);
          //calculate the position on the rotation plane that intersects with the mouse
          PVector inPlaneX = Util.intersectPlaneAndLine(cameraVec,mousePointVec,center,rotb.getXRotationAxis());
          PVector inPlaneY = Util.intersectPlaneAndLine(cameraVec,mousePointVec,center,rotb.getYRotationAxis());
          PVector inPlaneZ = Util.intersectPlaneAndLine(cameraVec,mousePointVec,center,rotb.getZRotationAxis());
          
          float sze = sqrt(pow(ct.getWidth()/2,2)+pow(ct.getHeight()/2,2)+pow(ct.getDepth()/2,2))/28;//calculate the scale factor for the rotation rings
          rotateCircleX.scale(sze);
          rotateCircleY.scale(sze);
          rotateCircleZ.scale(sze);
          rotateCircleHilight.scale(sze);
          translate(center.x, center.y, center.z);
          
          //render each ring with the correct color and rotation
          rotateZ(rotb.getRotateZ());
          rotateY(rotb.getRotateY());
          rotateX(rotb.getRotateX());
          
          //x - ring
          rotateY(HALF_PI);

          if (rix) {
            shape(rotateCircleHilight);
          }else{
             shape(rotateCircleX); 
          }
          rotateY(-HALF_PI);
          rotateX(-rotb.getRotateX());
          // y- ring
          rotateX(HALF_PI);
          
          if (riy) {
            shape(rotateCircleHilight);
          }else{
            shape(rotateCircleY);   
          }
          
          rotateX(-HALF_PI);
          rotateY(-rotb.getRotateY());
          // z-ring
          
          if (riz) {
            shape(rotateCircleHilight);
          }else{
             shape(rotateCircleZ); 
          }
          
          
          
          rotateZ(-rotb.getRotateZ());
          //un translate and rescale everying
          translate(-center.x, -center.y, -center.z);
          rotateCircleX.scale(1/sze);
          rotateCircleY.scale(1/sze);
          rotateCircleZ.scale(1/sze);
          rotateCircleHilight.scale(1/sze);
          
          //now for the funtional part of rotating
          if(translateXaxis||translateYaxis||translateZaxis){//if rotating in an axis
            PVector inPlane;
            PVector aNoraml;
            //calculate the plane the roation is happning in and the location of the mouse pointer in that plane
            if(translateXaxis){
              inPlane = inPlaneX;
              aNoraml = rotb.getXRotationAxis();
            }else if(translateYaxis){
              inPlane = inPlaneY;
              aNoraml = rotb.getYRotationAxis();
            }else if(translateZaxis){
              inPlane = inPlaneZ;
              aNoraml = rotb.getZRotationAxis();
            }else{
              throw new RuntimeException("Attepmpted to compute rotation when no rotation axsi was selected");
            }
            
            if(!Float.isNaN(inPlane.x)){//only do the next part if the mouse if not parellel to the plane in question
              //start by finding the ange of rotation:
              PVector objectCenter = ct.getCenter();
              PVector AB = PVector.sub(initalMousePoint.toPVector(),objectCenter,null);
              PVector BC = PVector.sub(objectCenter, inPlane,null);
              AB.normalize();
              BC.normalize();
              BC.mult(-1);//make both face the smae direction if the start and current points are the same place
              float angleDiff = acos(AB.dot(BC));
              //correct the sign of the rotation if nessarry
              if(PVector.cross(AB,BC,null).dot(aNoraml) <= 0){
                angleDiff*=-1;
              }
              //then apply it to the correct axis of rotation
              if(translateXaxis){
                if(grid_mode){
                  rotb.rotateX(radians(Math.round(degrees(currentComponentRotation.x+angleDiff)/grid_size)*grid_size));
                }else{
                  rotb.rotateX(currentComponentRotation.x+angleDiff);
                }
              }
              if(translateYaxis){
                if(grid_mode){
                  rotb.rotateY(radians(Math.round(degrees(currentComponentRotation.y+angleDiff)/grid_size)*grid_size));
                }else{
                  rotb.rotateY(currentComponentRotation.y+angleDiff);
                }
              }
              if(translateZaxis){
                if(grid_mode){
                  rotb.rotateZ(radians(Math.round(degrees(currentComponentRotation.z+angleDiff)/grid_size)*grid_size));
                }else{
                  rotb.rotateZ(currentComponentRotation.z+angleDiff);
                }
              }
            }
          }
        }
      }//end of something is selected
      
      if (e3DMode && selectingBlueprint && blueprints.length!=0){//if placing a blueprint
        //the movement arrows for the 3D blueprint placement
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
      
      //engageHUDPosition();//move the draw position to align with the camera

      ////hmm apperenrly we are not drawing anything here

      //disEngageHUDPosition();//move the draw position back to 0 0 0
    }//end of 3d mode on
  }
}

/**Processes mouse clicks for the stage edit GUI
*/
void GUImouseClicked() {
  if (editingStage||editingBlueprint) {//if edditing a stage or blueprint

    Stage current=null;//figure out what your edditing
    if (editingStage) {
      current=level.stages.get(currentStageIndex);
    }
    if (editingBlueprint) {
      current=workingBlueprint;
    }
    
    if (deleteing) {//if the delete tool is selected
      delete=true;//set tring to delet the current thing to true
      //no idea why the processing for this is not here
    }

    if(currentlyPlaceing !=null && (current.type.equals("stage") || current.type.equals("blueprint")) && !currentlyPlaceing.equals(Interdimentional_Portal.ID)){//if currently placing something that is not a portal and the stage type is 2D
      if (!StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if the currenly palceing thing is not draggable
        //get the constructor for this component
        Function<StageComponentPlacementContext, StageComponent> constructor = StageComponentRegistry.getPlacementConstructor(currentlyPlaceing);
        if(constructor == null){//if for some reason it does not have one
          //it must be an entity, so get the entity constructor
          Function<StageEntityPlacementContext, StageEntity> entityConstructor = EntityRegistry.getPlacementConstructor(currentlyPlaceing);
          if(entityConstructor == null){//if that does not have one,
            throw new RuntimeException("Constrructor not found for plaeable: "+currentlyPlaceing);//PANIC!!!!!!
          }
          //create the placement context
          StageEntityPlacementContext placementContext;
          if (grid_mode) {//if grid mode is on
            placementContext = new StageEntityPlacementContext(Math.round(((int)Math.floor(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)Math.floor(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size,0);
          } else {
            placementContext = new StageEntityPlacementContext((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY,0);//add new checkpoint to the stage
          }
          //create the entity
          current.entities.add(entityConstructor.apply(placementContext));
        } else {//if we have the constructor for the component
          //check special case here, mostly just things for the coins
          boolean isCoin = currentlyPlaceing.equals(Coin.ID);
          int numCoins = 0;
          if(current.type.equals("stage")){//if not in a blueprint
            numCoins = level.numOfCoins;//update the number of coins in the level
          }
          
          //create the placement context
          StageComponentPlacementContext placementContext;
          if (grid_mode) {//if grid mode is on
            placementContext = new StageComponentPlacementContext(Math.round(((int)Math.floor(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)Math.floor(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size);
          } else {
            placementContext = new StageComponentPlacementContext((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY);//add new checkpoint to the stage
          }
          if(isCoin){//overide that for a coin
            if (grid_mode) {//if grid mode is on
              placementContext = new StageComponentPlacementContext(Math.round(((int)Math.floor(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)Math.floor(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size,numCoins);
            } else {
              placementContext = new StageComponentPlacementContext((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY,numCoins);//add new checkpoint to the stage
            }
            if (editingStage) {//if edditng stage the increase the coin counter
              level.numOfCoins++;
              level.reloadCoins();
            }
          }
          //create the new component and add it to the stage
          current.add(constructor.apply(placementContext));
        }//end of constructor not being null
        draw=false;
      }//end of add placeable to stage
    }else if(currentlyPlaceing !=null && (current.type.equals("3Dstage") || current.type.equals("3D blueprint")) && !currentlyPlaceing.equals(Interdimentional_Portal.ID)){//if curretnly placing something that is not a portal and the stage is a 3D type
      if (!StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if the component is not a draggable
        Function<StageComponentPlacementContext, StageComponent> constructor = StageComponentRegistry.getPlacementConstructor(currentlyPlaceing);//get the constructor for this component
        if(constructor == null){//if no consctor was found
          throw new RuntimeException("Constrructor not found for plaeable: "+currentlyPlaceing);//PANIC!!!!
        }
        
        //check special case here, the coin case
        boolean isCoin = currentlyPlaceing.equals(Coin.ID);
        int numCoins = 0;
        if(current.type.equals("3Dstage")){
          numCoins = level.numOfCoins;
        }
        
        //create the placement contextr
        StageComponentPlacementContext placementContext;
        if (grid_mode) {//if grid mode is on
          placementContext = new StageComponentPlacementContext(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, (float)startingDepth);
        } else {
          placementContext = new StageComponentPlacementContext((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, (float)startingDepth);//add new checkpoint to the stage
        }
        if(isCoin){//coins fuck everything up
          if (grid_mode) {//if grid mode is on
            placementContext = new StageComponentPlacementContext(Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size, Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size, (float)startingDepth, numCoins);
          } else {
            placementContext = new StageComponentPlacementContext((int)(mouseX/Scale)+camPos, (int)(mouseY/Scale)-camPosY, (float)startingDepth, numCoins);//add new checkpoint to the stage
          }
          if (editingStage) {//if edditng stage the increase the coin counter
            level.numOfCoins++;
            level.reloadCoins();
          }
        }
        //create the new component and add it to the stage
        current.add(constructor.apply(placementContext));
        
        draw=false;
      }//end of add placeable to stage
    }//end of 3D
    
    if (moving_player) {//if moving the player
      //set the players new position
      players[currentPlayer].setX(mouseX/Scale+camPos);
      players[currentPlayer].setY(mouseY/Scale-camPosY);
      if (level.stages.get(currentStageIndex).type.equals("3Dstage")) {//and the z pos if in 3D
        players[currentPlayer].z=startingDepth;
      }
      tpCords[0]=mouseX/Scale+camPos;//other more diffrent place position setting
      tpCords[1]=mouseY/Scale-camPosY;
      tpCords[2]=startingDepth;

      setPlayerPosTo=true;
    }

    if (drawingPortal) {//if drawing portal part 1

      portalStage1=new JSONObject();//create and store data needed for the proper function of both portals
      portalStage2=new JSONObject();
      portalStage1.setString("type", "interdimentional Portal");
      portalStage2.setString("type", "interdimentional Portal");
      //set the data we currently know about this half of the portals
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

      if (grid_mode) {//gather the remaining data required and then add the portal to the correct stages
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
      portalStage2.setBoolean("s3d", level.stages.get(currentStageIndex).is3D);
      portalStage1.setBoolean("s3d", level.stages.get(preSI).is3D);
      //done collecting data
      //create both of the portals and add them to the corresponding stage
      level.stages.get(currentStageIndex).add(new Interdimentional_Portal(portalStage2));
      level.stages.get(preSI).add(new Interdimentional_Portal(portalStage1));
      portalStage2=null;
      portalStage1=null;
      drawingPortal3=false;
    }

    if (selecting) {//if selecting figureout what is being selected
      selectedIndex=colid_index(mouseX/Scale+camPos, mouseY/Scale-camPosY, current);
    }
    if (selectingBlueprint && blueprints.length != 0) {//place selected bluepring and paste it into the stage
      boolean type3d = blueprints[currentBluieprintIndex].type.equals("3D blueprint");
      StageComponent tmp;
      int ix, iy, iz = startingDepth;
      //calculate the base position
      if (grid_mode) {
        ix=Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size;
        iy=Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size;
      } else {
        ix=(int)(mouseX/Scale)+camPos;
        iy=(int)(mouseY/Scale)-camPosY;
      }
      for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {//translate the objects from blueprint form into stage readdy form
        tmp = blueprints[currentBluieprintIndex].parts.get(i);//get the current component  of this blueprint
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
        
        //create an offset copy of the component and put it in the stage,
        //TODO: repalce this terrible copy shit with use of the serial constructor
        if(type3d){//if the bluepint is 3D
          current.add(tmp.copy(ix,iy,iz));//preform a 3D copy on the curernt part and add it to the stage
        }else{
          current.add(tmp.copy(ix,iy));//preform a 2D copy on a part and add it to the stage
        }
        
      }
    }
  }//end of eddit stage
}//end of mouse clicked stage edit gui

/**Process mouse pressed down event for the stage edit gui
*/
void GUImousePressed() {
  if (mouseButton==LEFT) {//if the button was the left button
    if (StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if currently placeing a draggable

      downX=mouseX;//record that posstion
      downY=mouseY;
      drawing=true;
    }
  }
}
/**Process mouse released event for the stage edit gui
*/
void GUImouseReleased() {
  if (mouseButton==LEFT) {//if the button was the left button
    if ((StageComponentRegistry.isDraggable(currentlyPlaceing)) && drawing) {//if currently placing a draggable and allreaddy pressed the mouse button

      upX=mouseX;//record the up position
      upY=mouseY;
      drawing=false;
      draw=true;//trigger the component to be placed in the next frame
    }
  }
}

/**Render the 3D arrows for translating a 3D object.
Note: ckecks the current mouse position to determine if the arrows should be renderd yellow
@param x The lower x coordinate of the component bounding box
@param y The lower y coordinate of the component bounding box
@param z The lower z coordinate of the component bounding box
@param dx The width of the component bounding box
@param dy The height of the component bounding box
@param dz The depth of the component bounding box
*/
void renderTranslationArrows(float x,float y,float z,float dx, float dy,float dz){
  //wether the red/green/blue arrows are currrntly being hoverd over
  boolean b1=false, b2=false, r1=false, r2=false, g1=false, g2=false;
  //check if the mouse is hovering over an arrow
  for (int i=0; i<5000; i++) {//ray cast
    Point3D testPoint=genMousePoint(i);
    //see what arrows (if any) the mouse is over
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
    if (b1){
      shape(yellowArrow);
    } else {
      shape(blueArrow);
    }

    translate(-(x+dx/2), -(y+dy/2), -(z+dz));

    translate(x+dx/2, y+dy/2, z);
    rotateY(radians(180));
    if (b2) {
      shape(yellowArrow);
    } else {
      shape(blueArrow);
    }
    rotateY(-radians(180));
    translate(-(x+dx/2), -(y+dy/2), -(z));

    translate(x, y+dy/2, z+dz/2);
    rotateY(-radians(90));
    if (r1) {
      shape(yellowArrow);
    } else {
      shape(redArrow);
    }
    rotateY(radians(90));
    translate(-(x), -(y+dy/2), -(z+dz/2));

    translate(x+dx, y+dy/2, z+dz/2);
    rotateY(radians(90));
    if (r2) {
      shape(yellowArrow);
    } else {
      shape(redArrow);
    }
    rotateY(-radians(90));
    translate(-(x+dx), -(y+dy/2), -(z+dz/2));

    translate(x+dx/2, y, z+dz/2);
    rotateX(radians(90));
    if (g1) {
      shape(yellowArrow);
    } else {
      shape(greenArrow);
    }
    rotateX(-radians(90));
    translate(-(x+dx/2), -(y), -(z+dz/2));

    translate(x+dx/2, y+dy, z+dz/2);
    rotateX(-radians(90));
    if (g2) {
      shape(yellowArrow);
    } else {
      shape(greenArrow);
    }
    rotateX(radians(90));
    translate(-(x+dx/2), -(y+dy), -(z+dz/2));
  }
}

/**Process stage editor 3D mode mouse clicks
*/
void mouseClicked3D() {
  Stage current=null;//figure out what your edditing
  if (editingStage) {
    current=level.stages.get(currentStageIndex);
  }
  if (editingBlueprint) {
    current=workingBlueprint;
  }
    
  if (selecting) {//if the selecting tool(and translations) is selected
    for (int i=0; i<5000; i++) {//ray cast to find what is being clicked on
      Point3D testPoint = genMousePoint(i);
      selectedIndex=colid_index(testPoint.x, testPoint.y, testPoint.z, current);
      if (selectedIndex != -1){//if you found something
        break;//stop looking
      }
    }
  }
   
  //place draggable
  if (currentlyPlaceing != null && StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if currenly placing something and that thing is a draggable
    
    calcMousePoint();//calculate a fresh mouse location
    Point3D omp=genMousePoint(0);//get the point that is 0 distance from the camera, wait 0 distance? is that not just the fucking camera eye position?   why are we even calculaing this?
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
    
    Function<StageComponentDragPlacementContext, StageComponent> constructor = StageComponentRegistry.getDragConstructor(currentlyPlaceing);//get the constructor of this components
    if(constructor == null){
      throw new RuntimeException("Constructor not found for dragagble: "+currentlyPlaceing);
    }
    //calculate a point in 3D space in line with the mouse pointer that is on a solid object
    for (int i=0; i<5000; i++) {//ray cast
      Point3D testPoint = genMousePoint(i);
      
      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        StageComponentDragPlacementContext placementContext = new StageComponentDragPlacementContext((int)(testPoint.x-5+5*direction), (int)(testPoint.y-5), (int)(testPoint.z-5), 10, 10, 10, Color);
        current.add(constructor.apply(placementContext));//create the new object
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
        StageComponentDragPlacementContext placementContext = new StageComponentDragPlacementContext((int)(testPoint.x-5), (int)(testPoint.y-5+5*direction), (int)(testPoint.z-5), 10, 10, 10, Color);
        current.add(constructor.apply(placementContext));//create the new object
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        StageComponentDragPlacementContext placementContext = new StageComponentDragPlacementContext((int)(testPoint.x-5), (int)(testPoint.y-5), (int)(testPoint.z-5+5*direction), 10, 10, 10, Color);
        current.add(constructor.apply(placementContext));//create the new object
        break;
      }
    }
  }
  
  if (currentlyPlaceing != null && !StageComponentRegistry.isDraggable(currentlyPlaceing)) {//if currently placeing something and that things is a placeable
    calcMousePoint();//calculate a fresh mouse location
    Point3D omp=genMousePoint(0);//get the point that is 0 distance from the camera, wait 0 distance? is that not just the fucking camera eye position?   why are we even calculaing this?
    float xzh=dist(cam3Dx+DX, cam3Dz-DZ, mousePoint.x, mousePoint.z);//calcuate the original displacment distance on the x-z plane   used in case the direction calculation return NAN
    float ry_xz=atan2((cam3Dy-DY)-mousePoint.y, xzh);//find the rotation of the orignal line to the x-z plane
    float rx_z=atan2((cam3Dz-DZ)-mousePoint.z, (cam3Dx+DX)-mousePoint.x);//find the rotation of the x-z component of the prevous line
   
    Function<StageComponentPlacementContext, StageComponent> constructor = StageComponentRegistry.getPlacementConstructor(currentlyPlaceing);//get the constructor of this components
    //coins are special so do special things
    int numCoins = 0;
    boolean isCoin = currentlyPlaceing.equals(Coin.ID);
    if(isCoin){
      if(!editingBlueprint){
        numCoins = level.numOfCoins;
      }
    }
    
    for (int i=0; i<5000; i++) {//ray cast
    //search for a surface to place the component on
      Point3D testPoint = genMousePoint(i);

      omp.x=testPoint.x;//change the current testing x avlue
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new xpoint colides with something
        float direction=((cam3Dx+DX)-testPoint.x)/abs((cam3Dx+DX)-testPoint.x);//figure out what diretion the cast was going in
        if (Float.isNaN(direction)) {//ckeck if the direction is NaN
          direction=cos(rx_z)/abs(cos(rx_z));//use another silly method to get the direction
        }
        
        StageComponentPlacementContext placementContext;
        if(isCoin){//fancy coin placement things
          placementContext = new StageComponentPlacementContext((int)(testPoint.x+5*direction), (int)(testPoint.y), (float)(int)(testPoint.z), numCoins);
          if(!editingBlueprint){
             level.numOfCoins++;
             level.reloadCoins();
           }
        }else{
          placementContext = new StageComponentPlacementContext((int)(testPoint.x+5*direction), (int)(testPoint.y), (float)(int)(testPoint.z));
        }
        current.add(constructor.apply(placementContext));//create the new object
        break;
      }
      omp.y=testPoint.y;//change the current testing y value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new ypoint colides with something
        float direction=((cam3Dy-DY)-testPoint.y)/abs((cam3Dy-DY)-testPoint.y);//figure out what direction the case was going in
        if (Float.isNaN(direction)) {//if the direction is NaN
          direction=sin(ry_xz)/abs(sin(ry_xz));//use another silly method to get the direction
        }
         StageComponentPlacementContext placementContext;
         if(isCoin){//fancy coin placement things
           placementContext = new StageComponentPlacementContext((int)(testPoint.x), (int)(testPoint.y), (float)(int)(testPoint.z), numCoins);
           if(!editingBlueprint){
             level.numOfCoins++;
             level.reloadCoins();
           }
         }else{
           placementContext = new StageComponentPlacementContext((int)(testPoint.x), (int)(testPoint.y), (float)(int)(testPoint.z));
         }
         current.add(constructor.apply(placementContext));//create the new object
        break;
      }
      omp.z=testPoint.z;//change the current testing z value
      if (colid_index(omp.x, omp.y, omp.z, current)!=-1) {//check if the new zpoint colies with something
        float direction=((cam3Dz-DZ)-testPoint.z)/abs((cam3Dz-DZ)-testPoint.z);//figure out the direction the cast was going in
        if (Float.isNaN(direction)) {//if the diretion is nan
          direction=sin(rx_z)/abs(sin(rx_z));//use another silly method to get the direction
        }
        StageComponentPlacementContext placementContext ;
        if(isCoin){//fancy coin placement things
          placementContext = new StageComponentPlacementContext((int)(testPoint.x), (int)(testPoint.y), (float)(int)(testPoint.z+5*direction), numCoins);
          if(!editingBlueprint){
             level.numOfCoins++;
             level.reloadCoins();
           }
        }else{
          placementContext = new StageComponentPlacementContext((int)(testPoint.x), (int)(testPoint.y), (float)(int)(testPoint.z+5*direction));
        }
        current.add(constructor.apply(placementContext));//create the new object
        break;
      }
    }
  }
  
  if (deleteing) {//if deleting things
    for (int i=0; i<5000; i++) {//ray cast to find things
      Point3D testPoint = genMousePoint(i);
      int deleteIndex=colid_index(testPoint.x, testPoint.y, testPoint.z, current);
      if (deleteIndex!=-1) {//if a thing was found
        //delet the thing
        StageComponent removed = current.parts.remove(deleteIndex);
        if (current.interactables.contains(removed)) {
          current.interactables.remove(removed);
        }
        break;
      }else{//other wize, check if there is an entity that can be deleted
        Collider3D c3D = Collider3D.createBoxHitBox(testPoint.x-0.5, testPoint.y-0.5, testPoint.z-0.5,1,1,1);
        for(int j=0;j<current.entities.size();j++){
          if(collisionDetection.collide3D(current.entities.get(j).getHitBox3D(0,0,0),c3D)){
            current.entities.remove(j);
            return;
          }
        }
      }
    }
  }
}




/**Coppy the currently selected blueprint so it can be correctly positoned on top of the stage for viewing
 */
void generateDisplayBlueprint() {
  String type = blueprints[currentBluieprintIndex].type;
  boolean type3d = type.equals("3D blueprint");
  displayBlueprint=new Stage("tmp", type);//create the display blueprint
  int ix, iy, iz =startingDepth;
  //calculate the base position for the blueprint
  if (grid_mode) {
    ix=Math.round(((int)(mouseX/Scale)+camPos)*1.0/grid_size)*grid_size;
    iy=Math.round(((int)(mouseY/Scale)-camPosY)*1.0/grid_size)*grid_size;
  } else {
    ix=(int)(mouseX/Scale)+camPos;
    iy=(int)(mouseY/Scale)-camPosY;
  }

  //for each part in the blueprint
  for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {
    //TODO replace the stuipid copy thing with use of the serial constructor
    displayBlueprint.parts.add(blueprints[currentBluieprintIndex].parts.get(i).copy());//add a copy of the blueprint object to the display blueprint
    
    //TODO change this to use the simpler proper movemnt methods
    //if this component is a trangular one
    if (displayBlueprint.parts.get(i).type.equals("sloap")||displayBlueprint.parts.get(i).type.equals("holoTriangle")) {
      //translate it over to the correct visual positin  
      displayBlueprint.parts.get(i).dx+=ix;
      displayBlueprint.parts.get(i).dy+=iy;
      if(type3d){
        displayBlueprint.parts.get(i).dz+=iz;
      }
    }
    //translate the component over to the display position
    displayBlueprint.parts.get(i).x+=ix;
    displayBlueprint.parts.get(i).y+=iy;
    if(type3d){
      displayBlueprint.parts.get(i).z+=iz;
    }
  }
}

/**Coppy the currently selected blueprint so it can be correctly displayed in 3D
*/
void generateDisplayBlueprint3D() {
  String type = blueprints[currentBluieprintIndex].type;
  displayBlueprint=new Stage("tmp", type);
  float ix = blueprintPlacemntX, iy = blueprintPlacemntY, iz = blueprintPlacemntZ;
  //calculate the min and max locations of the blueprint (for the arrows render)
  blueprintMax=new float[]{-66666666,-66666666,-66666666};
  blueprintMin=new float[]{66666666,66666666,66666666};
  //for each part of the blueprint
  for (int i=0; i<blueprints[currentBluieprintIndex].parts.size(); i++) {
    //TODO replace stupid copy thing with use of the serial constructor
    StageComponent part = blueprints[currentBluieprintIndex].parts.get(i).copy(ix,iy,iz);
    displayBlueprint.parts.add(part);//add the coppied part to the display blueprint
    //NOTE this will have to be reworked when sloaps are added to 3D. oops forgot to do this
    blueprintMax[0]=max(blueprintMax[0],part.x+part.dx);
    blueprintMax[1]=max(blueprintMax[1],part.y+part.dy);
    blueprintMax[2]=max(blueprintMax[2],part.z+part.dz);
    blueprintMin[0]=min(blueprintMin[0],part.x);
    blueprintMin[1]=min(blueprintMin[1],part.y);
    blueprintMin[2]=min(blueprintMin[2],part.z);
  }
}

/**render the currently selected blueprint on top of the stage
*/
void renderBlueprint() {
  for (int i=0; i<displayBlueprint.parts.size(); i++) {
    displayBlueprint.parts.get(i).draw(g);
  }
}

/**render the currently selected blueprint in 3D
*/
void renderBlueprint3D() {
  for (int i=0; i<displayBlueprint.parts.size(); i++) {
    displayBlueprint.parts.get(i).draw3D(g);
  }
}

//hmmmm apperently theese are global vars
//dfa=default aspect ratio car=current aspect ratio
float dfa=1280.0/720, car=1.0*width/height;
Point3D mousePoint=new Point3D(0, 0, 0);
/**Calculate a 3D point that is at the same postition as the mouse curser in real 3D space
*/
void calcMousePoint() {
  //processing camera values deffinition
  //camera() = camera(defCameraX, defCameraY, defCameraZ,    defCameraX, defCameraY, 0,    0, 1, 0);
  //defCameraX = width/2;
  //defCameraY = height/2;
  //defCameraFOV = 60 * DEG_TO_RAD;
  //defCameraZ = defCameraY / ((float) Math.tan(defCameraFOV / 2.0f));

  car=1.0*width/height;//calculate the current aspect ratio
  float planeDist = 360.0 / tan(settings.getFOV()/2);//calulcate the 720p default render plane for the given FOV
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

/**Calcualte the coords of a new point that is in line through the mouse pointer at a set distance from the camera.
note: calls calcMousePoint automcatially
@param hyp The distance from the camrea eye the point should be
*/
Point3D genMousePoint(float hyp) {
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

//TODO: replace every instance of this class with PVector
/**A 3D point. this should not be used if possible
*/
class Point3D {
  float x, y, z;
  /**Create a new 3D point
  @param x x
  @param y y
  @param z z
  */
  Point3D(float x, float y, float z) {
    this.x=x;
    this.y=y;
    this.z=z;
  }
  /**Create a new 3D point from a PVector
  @param p The position to copy
  */
  Point3D(PVector p) {
    this.x=p.x;
    this.y=p.y;
    this.z=p.z;
  }

  public String toString() {
    return x+" "+y+" "+z;
  }
  
  /**Get this point as a PVector
  */
  public PVector toPVector(){
    return new PVector(x,y,z);
  }
}

//end of stage_editor.pde
