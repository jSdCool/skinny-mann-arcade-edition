int xangle=25+180,yangle=15,dist=700;//camera presets
         float DY=sin(radians(yangle))*dist,hd=cos(radians(yangle))*dist,DX=sin(radians(xangle))*hd,DZ=cos(radians(xangle))*hd;//camera rotation
         
void stageLevelDraw(){
  level_terain=loadJSONArray(file_path);
  stageType=level_terain.getJSONObject(0).getString("type");
  if(stageType.equals("stage")){
    e3DMode=false;
      camera();
         for(int i=1;i<level_terain.size();i++){
          JSONObject block=level_terain.getJSONObject(i); 
          String type=block.getString("type");
          
          strokeWeight(0);
          if(type.equals("ground")){
            int Color = block.getInt("color");
            float x = block.getFloat("x")-1,y = block.getFloat("y")-1,dx = block.getFloat("dx")+2,dy = block.getFloat("dy")+2;
            fill(Color);
            stroke(Color);
           rect(Scale*(x-camPos),Scale*(y+camPosY),Scale*dx,Scale*dy); 
          }
          if(type.equals("holo")){
            int Color = block.getInt("color");
            float x = block.getFloat("x")-1,y = block.getFloat("y")-1,dx = block.getFloat("dx")+2,dy = block.getFloat("dy")+2;
            fill(Color);
            stroke(Color);
           rect(Scale*(x-camPos),Scale*(y+camPosY),Scale*dx,Scale*dy); 
          }
          if(type.equals("dethPlane")){
            float x = block.getFloat("x")-1,y = block.getFloat("y")-1,dx = block.getFloat("dx")+2,dy = block.getFloat("dy")+2;
            fill(-114431);
            stroke(-114431);
           rect(Scale*(x-camPos),Scale*(y+camPosY),Scale*dx,Scale*dy); 
          }
          if(type.equals("check point")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            float playx=player1.getX();
            boolean po=false;
            if(playx>=x-5 && playx<= x+5 && y-50 <= player1.getY() && y>=player1.getY()-10){
              respawnX=(int)x;
             respawnY=(int)y;
             respawnStage=stageIndex;
             po=true;
             checkpointIn3DStage=false;
            }
            
            x-=camPos;
            y+=camPosY;
            if(po)
            fill(#E5C402);
            else
            fill(#B9B9B9);
            strokeWeight(0);
            rect((x-3)*Scale,(y-60)*Scale,5*Scale,60*Scale);
            fill(#EA0202);
            stroke(#EA0202);
            strokeWeight(0);
            triangle(x*Scale,(y-60)*Scale,x*Scale,(y-40)*Scale,(x+30)*Scale,(y-50)*Scale);
          }
          
          if(type.equals("goal")){
            float x = block.getFloat("x")-camPos,y = block.getFloat("y");
            fill(255);
            stroke(255);
            rect(Scale*x,Scale*(y+camPosY),Scale*50,Scale*50);
            rect(Scale*(x+100),Scale*(y+camPosY),Scale*50,Scale*50);
            rect(Scale*(x+200),Scale*(y+camPosY),Scale*50,Scale*50);
            fill(0);
            stroke(0);
            rect(Scale*(x+50),Scale*(y+camPosY),Scale*50,Scale*50);
            rect(Scale*(x+150),Scale*(y+camPosY),Scale*50,Scale*50);
            {
               float px =player1.getX(),py=player1.getY();
               
               if(px >= x+camPos && px <= x+camPos + 250 && py >= y - 50 && py <= y + 50){
                level_complete=true; 
               }
            
          }
         }
         
         if(type.equals("coin")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            float playx=player1.getX(),playy=player1.getY();
            boolean collected=coins.getJSONObject(block.getInt("coin id")).getBoolean("collected");
            JSONObject cic= coins.getJSONObject(block.getInt("coin id"));
            x-=camPos;
            if(!collected){
             drawCoin(Scale*x,Scale*(y+camPosY),Scale*3);
             if(Math.sqrt(Math.pow(playx-camPos-x,2)+Math.pow(playy-y,2))<30){
               cic.setBoolean("collected",true);
               coins.setJSONObject(block.getInt("coin id"),cic);
               coinCount++;
             }
            }
          }
          if(type.equals("interdimentional Portal")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            float playx=player1.getX(),playy=player1.getY();
            x-=camPos;
            drawPortal(Scale*x,Scale*(y+camPosY),Scale*1);
            x+=camPos;
            if((playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)){
             fill(255);
             textSize(Scale*20);
             textAlign(CENTER,CENTER);
             text("press E",Scale*(playx-camPos),Scale*(playy-90+camPosY));
            }
            if(E_pressed&&(playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)){
              E_pressed=false;
              int newX=block.getInt("linkX"),newY=block.getInt("linkY");
              file_path=rootPath+mainIndex.getJSONObject(block.getInt("link Index")).getString("location");
              stageIndex=block.getInt("link Index");
              level_terain=loadJSONArray(file_path);
              background(0);
              try{
                setPlayerPosZ=block.getInt("linkZ");
                player1.z=block.getInt("linkZ");
              }catch(Throwable e){
                
              }
              player1.setX(newX).setY(newY);
              setPlayerPosTo=true;
              setPlayerPosX=newX;
              setPlayerPosY=newY;
              gmillis=millis()+850;
            }
           
            
          }
          
          if(type.equals("sloap")){
            int Color = block.getInt("color");
            float x1 = block.getFloat("x1")-1,y1 = block.getFloat("y1")-1,x2 = block.getFloat("x2")+2,y2 = block.getFloat("y2")+2;
            int direction= block.getInt("rotation");
            fill(Color);
            stroke(Color);
           if(direction==0){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==1){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==2){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY)); 
           }
           if(direction==3){
            triangle(Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
          }
           
          if(type.equals("holoTriangle")){
            int Color = block.getInt("color");
            float x1 = block.getFloat("x1")-1,y1 = block.getFloat("y1")-1,x2 = block.getFloat("x2")+2,y2 = block.getFloat("y2")+2;
            int direction= block.getInt("rotation");
            fill(Color);
            stroke(Color);
           if(direction==0){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==1){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==2){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY)); 
           }
           if(direction==3){
            triangle(Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
          }
          
         }
         draw_mann(Scale*(player1.getX()-camPos),Scale*(player1.getY()+camPosY),player1.getPose(),Scale*player1.getScale(),player1.getColor());
         //====================================================================================================================================================================================================
         //====================================================================================================================================================================================================
         //====================================================================================================================================================================================================
         //====================================================================================================================================================================================================
         //====================================================================================================================================================================================================
  }else if(stageType.equals("3Dstage")){
    if(e3DMode){//render the level in 3D
    camera(player1.x+DX,player1.y-DY,player1.z-DZ,player1.x,player1.y,player1.z,0,1,0);
        directionalLight(255, 255, 255, 0.8, 1, -0.35);
        ambientLight(102, 102, 102);
        coinRotation+=3;
        if(coinRotation>360)
        coinRotation-=360;
      for(int i=1;i<level_terain.size();i++){
          JSONObject block=level_terain.getJSONObject(i); 
          String type=block.getString("type");
          
          strokeWeight(0);
          if(type.equals("ground")||type.equals("holo")){
            int Color = block.getInt("color");
            float x = block.getFloat("x"),y = block.getFloat("y"),z=block.getFloat("z"),dx = block.getFloat("dx"),dy = block.getFloat("dy"),dz = block.getFloat("dz");
            fill(Color);
            strokeWeight(0);
           translate(x+dx/2,y+dy/2,z+dz/2);
           box(dx,dy,dz);
           translate(-1*(x+dx/2),-1*(y+dy/2),-1*(z+dz/2));
          }
          
          
          if(type.equals("check point")){
            float x = block.getFloat("x"),y = block.getFloat("y"),z = block.getFloat("z");
            float playx=player1.getX();
            boolean po=false;
            if(playx>=x-20 && playx<= x+20 && y-50 <= player1.getY() && y>=player1.getY()-10 && player1.z >= z-20 && player1.z <= z+20){
              respawnX=(int)x;
             respawnY=(int)y;
             respawnZ=(int)player1.z;
             respawnStage=stageIndex;
             checkpointIn3DStage=true;
             po=true;
            }
            

            if(po)
            fill(#E5C402);
            else
            fill(#B9B9B9);
            strokeWeight(0);
            translate(x,y-30,z);
            box(4,60,4);
            translate(-x,-(y-30),-z);
            fill(#EA0202);
            stroke(#EA0202);
            strokeWeight(0);
            translate(x+10,y-50,z);
            box(20,20,2);
            translate(-(x+10),-(y-50),-z);
            
          }
          
            if(type.equals("coin")){
            float x = block.getFloat("x"),y = block.getFloat("y"),z = block.getFloat("z");
            float playx=player1.getX(),playy=player1.getY(),playz=player1.z;
            boolean collected=coins.getJSONObject(block.getInt("coin id")).getBoolean("collected");
            JSONObject cic= coins.getJSONObject(block.getInt("coin id"));
            if(!collected){
             translate(x,y,z);
             rotateY(radians(coinRotation));
             shape(coin3D);
             rotateY(radians(-coinRotation));
             translate(-x,-y,-z);
             if(Math.sqrt(Math.pow(playx-x,2)+Math.pow(playy-y,2)+Math.pow(playz-z,2))<35){
               cic.setBoolean("collected",true);
               coins.setJSONObject(block.getInt("coin id"),cic);
               coinCount++;
             }
            }
          }
          
          if(type.equals("interdimentional Portal")){
            float x = block.getFloat("x"),y = block.getFloat("y"),z=0;
            try{
              z=block.getFloat("z");
            }catch(Throwable e){}
            float playx=player1.getX(),playy=player1.getY();
            
            translate(0,0,z);
            drawPortal(x,y,1);
           translate(0,0,-z);
            if((playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60&& player1.z >= z-20 && player1.z <= z+20)){
             fill(255);
             textSize(20);
             textAlign(CENTER,CENTER);
             translate(0,0,player1.z);
             text("press E",(playx),(playy-90));
             translate(0,0,-player1.z);
            }
            
            if(E_pressed&&(playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60&& player1.z >= z-20 && player1.z <= z+20)){
              E_pressed=false;
              int newX=block.getInt("linkX"),newY=block.getInt("linkY");
              file_path=rootPath+mainIndex.getJSONObject(block.getInt("link Index")).getString("location");
              stageIndex=block.getInt("link Index");
              level_terain=loadJSONArray(file_path);
              background(0);
              try{
                setPlayerPosZ=block.getInt("linkZ");
                player1.z=block.getInt("linkZ");
              }catch(Throwable e){
                
              }
              player1.setX(newX).setY(newY);
              setPlayerPosTo=true;
              setPlayerPosX=newX;
              setPlayerPosY=newY;
              gmillis=millis()+850;
              return;
            }
          }
          
          if(type.equals("3DonSW")){
            float x = block.getFloat("x"),y = block.getFloat("y"),z=block.getFloat("z");
            draw3DSwitch1(x,y,z,Scale);
          }
          
          if(type.equals("3DoffSW")){
            float x = block.getFloat("x"),y = block.getFloat("y"),z=block.getFloat("z");
            draw3DSwitch2(x,y,z,Scale);
            if(player1.x>=x-10&&player1.x<=x+10&&player1.y >=y-10&&player1.y<= y+2 && player1.z >= z-10 && player1.z <= z+10){
              e3DMode=false;
              WPressed=false;
              SPressed=false;
              gmillis=millis()+1200;
            }
          }
          
          fill(255);
         }//end of for loop
         
         draw_mann_3D(player1.x,player1.y,player1.z,player1.getPose(),player1.getScale(),player1.getColor());
         
         
         
         //camera(player1.x+DX,player1.y-DY,player1.z-DZ,player1.x,player1.y,player1.z,0,1,0);
         
    }else{//redner the level in 2D
    camera();
      for(int i=1;i<level_terain.size();i++){
          JSONObject block=level_terain.getJSONObject(i); 
          String type=block.getString("type");
          
          strokeWeight(0);
          if(type.equals("ground")){
            int Color = block.getInt("color");
            float x = block.getFloat("x")-1,y = block.getFloat("y")-1,dx = block.getFloat("dx")+2,dy = block.getFloat("dy")+2;
            fill(Color);
            stroke(Color);
           rect(Scale*(x-camPos),Scale*(y+camPosY),Scale*dx,Scale*dy); 
          }
          if(type.equals("holo")){
            int Color = block.getInt("color");
            float x = block.getFloat("x")-1,y = block.getFloat("y")-1,dx = block.getFloat("dx")+2,dy = block.getFloat("dy")+2;
            fill(Color);
            stroke(Color);
           rect(Scale*(x-camPos),Scale*(y+camPosY),Scale*dx,Scale*dy); 
          }
          if(type.equals("dethPlane")){
            float x = block.getFloat("x")-1,y = block.getFloat("y")-1,dx = block.getFloat("dx")+2,dy = block.getFloat("dy")+2;
            fill(-114431);
            stroke(-114431);
           rect(Scale*(x-camPos),Scale*(y+camPosY),Scale*dx,Scale*dy); 
          }
          if(type.equals("check point")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            float playx=player1.getX();
            boolean po=false;
            if(playx>=x-5 && playx<= x+5 && y-50 <= player1.getY() && y>=player1.getY()-10){
              respawnX=(int)x;
             respawnY=(int)y;
             respawnZ=(int)player1.z;
             respawnStage=stageIndex;
             checkpointIn3DStage=true;
             po=true;
            }
            
            x-=camPos;
            y+=camPosY;
            if(po)
            fill(#E5C402);
            else
            fill(#B9B9B9);
            strokeWeight(0);
            rect((x-3)*Scale,(y-60)*Scale,5*Scale,60*Scale);
            //line(x*Scale,y*Scale,x*Scale,(y-60)*Scale);
            fill(#EA0202);
            stroke(#EA0202);
            strokeWeight(0);
            triangle(x*Scale,(y-60)*Scale,x*Scale,(y-40)*Scale,(x+30)*Scale,(y-50)*Scale);
          }
          
          if(type.equals("goal")){
            float x = block.getFloat("x")-camPos,y = block.getFloat("y");
            fill(255);
            stroke(255);
            rect(Scale*x,Scale*(y+camPosY),Scale*50,Scale*50);
            rect(Scale*(x+100),Scale*(y+camPosY),Scale*50,Scale*50);
            rect(Scale*(x+200),Scale*(y+camPosY),Scale*50,Scale*50);
            fill(0);
            stroke(0);
            rect(Scale*(x+50),Scale*(y+camPosY),Scale*50,Scale*50);
            rect(Scale*(x+150),Scale*(y+camPosY),Scale*50,Scale*50);
            {
               float px =player1.getX(),py=player1.getY();
               
               if(px >= x+camPos && px <= x+camPos + 250 && py >= y - 50 && py <= y + 50){
                level_complete=true; 
               }
            
          }
         }
         
         if(type.equals("coin")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            float playx=player1.getX(),playy=player1.getY();
            boolean collected=coins.getJSONObject(block.getInt("coin id")).getBoolean("collected");
            JSONObject cic= coins.getJSONObject(block.getInt("coin id"));
            x-=camPos;
            if(!collected){
             drawCoin(Scale*x,Scale*(y+camPosY),Scale*3);
             if(Math.sqrt(Math.pow(playx-camPos-x,2)+Math.pow(playy-y,2))<30){
               cic.setBoolean("collected",true);
               coins.setJSONObject(block.getInt("coin id"),cic);
               coinCount++;
             }
            }
          }
          if(type.equals("interdimentional Portal")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            float playx=player1.getX(),playy=player1.getY();
            x-=camPos;
            drawPortal(Scale*x,Scale*(y+camPosY),Scale*1);
            x+=camPos;
            if((playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)){
             fill(255);
             textSize(Scale*20);
             textAlign(CENTER,CENTER);
             text("press E",Scale*(playx-camPos),Scale*(playy-90+camPosY));
            }
            if(E_pressed&&(playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)){
              E_pressed=false;
              int newX=block.getInt("linkX"),newY=block.getInt("linkY");
              file_path=rootPath+mainIndex.getJSONObject(block.getInt("link Index")).getString("location");
              stageIndex=block.getInt("link Index");
              level_terain=loadJSONArray(file_path);
              background(0);
              try{
                setPlayerPosZ=block.getInt("linkZ");
                player1.z=block.getInt("linkZ");
              }catch(Throwable e){
                
              }
              player1.setX(newX).setY(newY);
              setPlayerPosTo=true;
              setPlayerPosX=newX;
              setPlayerPosY=newY;
              gmillis=millis()+850;
              return;
              
            }
           
            
          }
          
          if(type.equals("sloap")){
            int Color = block.getInt("color");
            float x1 = block.getFloat("x1")-1,y1 = block.getFloat("y1")-1,x2 = block.getFloat("x2")+2,y2 = block.getFloat("y2")+2;
            int direction= block.getInt("rotation");
            fill(Color);
            stroke(Color);
           if(direction==0){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==1){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==2){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY)); 
           }
           if(direction==3){
            triangle(Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
          }
           
          if(type.equals("holoTriangle")){
            int Color = block.getInt("color");
            float x1 = block.getFloat("x1")-1,y1 = block.getFloat("y1")-1,x2 = block.getFloat("x2")+2,y2 = block.getFloat("y2")+2;
            int direction= block.getInt("rotation");
            fill(Color);
            stroke(Color);
           if(direction==0){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==1){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
           if(direction==2){
            triangle(Scale*(x1-camPos),Scale*(y1+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x1-camPos),Scale*(y2+camPosY)); 
           }
           if(direction==3){
            triangle(Scale*(x1-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y2+camPosY),Scale*(x2-camPos),Scale*(y1+camPosY)); 
           }
          }
          
          if(type.equals("3DonSW")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            draw3DSwitch1((x-camPos)*Scale,(y+camPosY)*Scale,Scale);
            if(player1.x>=x-10&&player1.x<=x+10&&player1.y >=y-10&&player1.y<= y+2){
              player1.z=block.getFloat("z");
              e3DMode=true;
              gmillis=millis()+1200;
            }
          }
          
          if(type.equals("3DoffSW")){
            float x = block.getFloat("x"),y = block.getFloat("y");
            draw3DSwitch2((x-camPos)*Scale,(y+camPosY)*Scale,Scale);
            
          }
          
         }
         draw_mann(Scale*(player1.getX()-camPos),Scale*(player1.getY()+camPosY),player1.getPose(),Scale*player1.getScale(),player1.getColor());
    }
  }
         
         
         
         
         
         
         
         
         if(level_complete){
           textAlign(LEFT,BOTTOM);
          textSize(Scale*100);
         fill(255,255,0);
         text("LEVEL COMPLETE!!!",Scale*200,Scale*400);
         
         
         strokeWeight(0);
         fill(255,0,0);
         rect(Scale*540,Scale*440,Scale*220,Scale*60);
         fill(255,126,0);
         rect(Scale*550,Scale*450,Scale*200,Scale*40);
         fill(0);
         textSize(Scale*40);
         text("continue",Scale*565,Scale*490);
        }
        
}
//////////////////////////////////////////-----------------------------------------------------



void playerPhysics(){


if(!e3DMode){         
         if(player1_moving_right){//move the player right
          float newpos=player1.getX()+mspc*0.2;
          
          if(!level_colide(newpos+10,player1.getY())){
            if(!level_colide(newpos+10,player1.getY()-25)){
              if(!level_colide(newpos+10,player1.getY()-50)){
                if(!level_colide(newpos+10,player1.getY()-75)){
                  player1.setX(newpos);
                }
              }
            }
          }else if((!level_colide(newpos+10,player1.getY()-10)&&!level_colide(newpos+10,player1.getY()-50)&&!level_colide(newpos+10,player1.getY()-75))&&player1.getAirTime()==0){
           if(!level_colide(newpos+10,player1.getY()-1)){//autojump
             player1.setX(newpos);
             player1.setY(player1.getY()-1);
           }
           else if(!level_colide(newpos-10,player1.getY()-2)){
             player1.setX(newpos);
             player1.setY(player1.getY()-2);
           }else if(!level_colide(newpos-10,player1.getY()-3)){
             player1.setX(newpos);
             player1.setY(player1.getY()-3);
           }
           else if(!level_colide(newpos-10,player1.getY()-4)){
             player1.setX(newpos);
             player1.setY(player1.getY()-4);
           }
           else if(!level_colide(newpos-10,player1.getY()-5)){
             player1.setX(newpos);
             player1.setY(player1.getY()-5);
           }
           else if(!level_colide(newpos-10,player1.getY()-6)){
             player1.setX(newpos);
             player1.setY(player1.getY()-6);
           }
           else if(!level_colide(newpos-10,player1.getY()-7)){
             player1.setX(newpos);
             player1.setY(player1.getY()-7);
           }
           else if(!level_colide(newpos-10,player1.getY()-8)){
             player1.setX(newpos);
             player1.setY(player1.getY()-8);
           }
           else if(!level_colide(newpos-10,player1.getY()-9)){
             player1.setX(newpos);
             player1.setY(player1.getY()-9);
           }
           else if(!level_colide(newpos-10,player1.getY()-10)){
             player1.setX(newpos);
             player1.setY(player1.getY()-10);
           }
          }
          
          if(player1.getAnimationCooldown()<=0){//chmage the player pose to make them look like there waljking
            player1.setPose(player1.getPose()+1);
             player1.setAnimationCooldown(4);
            if(player1.getPose()==13){
             player1.setPose(1); 
            }
          }else{
            player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
          }
         }
         
         if(player1_moving_left){//player moving left
          float newpos=player1.getX()-mspc*0.2;
          if(!level_colide(newpos-10,player1.getY())){
            if(!level_colide(newpos-10,player1.getY()-25)){
              if(!level_colide(newpos-10,player1.getY()-50)){
                if(!level_colide(newpos-10,player1.getY()-75)){
                  player1.setX(newpos);
                }
              }
            }
          }else if((!level_colide(newpos-10,player1.getY()-10)&&!level_colide(newpos-10,player1.getY()-50)&&!level_colide(newpos-10,player1.getY()-75))&&player1.getAirTime()==0){
           if(!level_colide(newpos+10,player1.getY()-1)){//auto jump
             player1.setX(newpos);
             player1.setY(player1.getY()-1);
           }
           else if(!level_colide(newpos-10,player1.getY()-2)){
             player1.setX(newpos);
             player1.setY(player1.getY()-2);
           }else if(!level_colide(newpos-10,player1.getY()-3)){
             player1.setX(newpos);
             player1.setY(player1.getY()-3);
           }
           else if(!level_colide(newpos-10,player1.getY()-4)){
             player1.setX(newpos);
             player1.setY(player1.getY()-4);
           }
           else if(!level_colide(newpos-10,player1.getY()-5)){
             player1.setX(newpos);
             player1.setY(player1.getY()-5);
           }
           else if(!level_colide(newpos-10,player1.getY()-6)){
             player1.setX(newpos);
             player1.setY(player1.getY()-6);
           }
           else if(!level_colide(newpos-10,player1.getY()-7)){
             player1.setX(newpos);
             player1.setY(player1.getY()-7);
           }
           else if(!level_colide(newpos-10,player1.getY()-8)){
             player1.setX(newpos);
             player1.setY(player1.getY()-8);
           }
           else if(!level_colide(newpos-10,player1.getY()-9)){
             player1.setX(newpos);
             player1.setY(player1.getY()-9);
           }
           else if(!level_colide(newpos-10,player1.getY()-10)){
             player1.setX(newpos);
             player1.setY(player1.getY()-10);
           }
          }
          
          if(player1.getAnimationCooldown()<=0){//change the playerb pose to make them look lie there walking
            player1.setPose(player1.getPose()-1);
             player1.setAnimationCooldown(4);
            if(player1.getPose()==0){
             player1.setPose(12); 
            }
          }else{
            player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
          }
         }
         
         if(!player1_moving_right&&!player1_moving_left){//reset the player pose if the player is not moving
           player1.setPose(1);
           player1.setAnimationCooldown(4);
         }
         
         
         
         if(!player1_jumping||!player1.isJumping()){//gravity
           float pd=1;
            if(!level_colide(player1.getX()-10,player1.getY()+pd)&&!level_colide(player1.getX()-5,player1.getY()+pd)&&!level_colide(player1.getX(),player1.getY()+pd)&&!level_colide(player1.getX()+5,player1.getY()+pd)&&!level_colide(player1.getX()+10,player1.getY()+pd)){
              pd=mspc*0.2;//gravity movement
              //wasDP=false;
              if(!level_colide(player1.getX()-10,player1.getY()+pd)&&!level_colide(player1.getX()-5,player1.getY()+pd)&&!level_colide(player1.getX(),player1.getY()+pd)&&!level_colide(player1.getX()+5,player1.getY()+pd)&&!level_colide(player1.getX()+10,player1.getY()+pd)){
              player1.setY(player1.getY()+pd);
              player1.setAirTime(60);
              }else{
               while((!level_colide(player1.getX()-10,player1.getY()+pd)&&!level_colide(player1.getX()-5,player1.getY()+pd)&&!level_colide(player1.getX(),player1.getY()+pd)&&!level_colide(player1.getX()+5,player1.getY()+pd)&&!level_colide(player1.getX()+10,player1.getY()+pd))&&pd>0){
                pd--; 
               }
               if(pd>0){
                 player1.setY(player1.getY()+pd);
               }
              }
            }else{
               player1.setAirTime(0);
               
            }
         }
         
         if(player_kill(player1.getX()-10,player1.getY()+1)||player_kill(player1.getX()-5,player1.getY()+1)||player_kill(player1.getX(),player1.getY()+1)||player_kill(player1.getX()+5,player1.getY()+1)||player_kill(player1.getX()+10,player1.getY()+1)){
           dead=true;          
         }
         
         
         if(!(!level_colide(player1.getX()-10,player1.getY())&&!level_colide(player1.getX()-5,player1.getY())&&!level_colide(player1.getX(),player1.getY())&&!level_colide(player1.getX()+5,player1.getY())&&!level_colide(player1.getX()+10,player1.getY()))){
           player1.setY(player1.getY()-1);
         }
         
         
         if(player1_jumping){//jumping
          if(player1.getAirTime()==0){
            player1.setJumping(true);
          }
          if(player1.getAirTime()<14&&player1.isJumping()){//jumping
            float pp=(0.1953333*mspc);
            if(!level_colide(player1.getX()-10,player1.getY()-75-pp)&&!level_colide(player1.getX()-5,player1.getY()-75-pp)&&!level_colide(player1.getX(),player1.getY()-75-pp)&&!level_colide(player1.getX()+5,player1.getY()-75-pp)&&!level_colide(player1.getX()+10,player1.getY()-75-pp)){
              player1.setY(player1.getY()-pp);
              player1.setAirTime(player1.getAirTime()+mspc*0.010);
              player1.jumpDist+=pp;
            }else{
              player1.setJumping(false);
              player1.jumpDist=0;
            }
          }else{
            if(player1.getAirTime()<16&&player1.isJumping()){
              player1.setAirTime(player1.getAirTime()+mspc*0.010);
              //player1.setY(player1.getY()+(player1.jumpDist-293));
              player1.jumpDist=293;//in the futchre use this varible to judge wether the jump is at the max height
            }else{
            player1.setJumping(false);
            player1.jumpDist=0;
            }
          }
         }else{
           player1.setJumping(false);
           player1.jumpDist=0;
         }
         
         
         if(player1.getX()-camPos>(1280-eadgeScroleDist)){
           camPos=(int)(player1.getX()-(1280-eadgeScroleDist));
         }
         
         
         if(player1.getX()-camPos<eadgeScroleDist&&camPos>0){
           camPos=(int)(player1.getX()-eadgeScroleDist);
         }
         
         if(player1.getY()+camPosY>720-eadgeScroleDist&&camPosY>0){
           camPosY-=player1.getY()+camPosY-(720-eadgeScroleDist);
         }  
         
         if(player1.getY()+camPosY<eadgeScroleDist+75){
           camPosY-=player1.getY()+camPosY-(eadgeScroleDist+75);
           
         }
         if(camPos<0)
         camPos=0;
         if(camPosY<0)
         camPosY=0;
         
         
}else{//end of not 3D mode


         if(player1_moving_right){//move the player right
          float newpos=player1.getX()+mspc*0.2;
          
          if(!level_colide(newpos+10,player1.getY(),player1.z-7)&&!level_colide(newpos+10,player1.getY(),player1.z+7)){
            if(!level_colide(newpos+10,player1.getY()-25,player1.z-7)&&!level_colide(newpos+10,player1.getY()-25,player1.z+7)){
              if(!level_colide(newpos+10,player1.getY()-50,player1.z-7)&&!level_colide(newpos+10,player1.getY()-50,player1.z+7)){
                if(!level_colide(newpos+10,player1.getY()-75,player1.z-7)&&!level_colide(newpos+10,player1.getY()-75,player1.z+7)){
                  player1.setX(newpos);
                }
              }
            }
          }else if((!level_colide(newpos+10,player1.getY()-10,player1.z)&&!level_colide(newpos+10,player1.getY()-50,player1.z)&&!level_colide(newpos+10,player1.getY()-75,player1.z))&&player1.getAirTime()==0){
           if(!level_colide(newpos+10,player1.getY()-1,player1.z)){//autojump
             player1.setX(newpos);
             player1.setY(player1.getY()-1);
           }
           else if(!level_colide(newpos-10,player1.getY()-2,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-2);
           }else if(!level_colide(newpos-10,player1.getY()-3,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-3);
           }
           else if(!level_colide(newpos-10,player1.getY()-4,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-4);
           }
           else if(!level_colide(newpos-10,player1.getY()-5,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-5);
           }
           else if(!level_colide(newpos-10,player1.getY()-6,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-6);
           }
           else if(!level_colide(newpos-10,player1.getY()-7,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-7);
           }
           else if(!level_colide(newpos-10,player1.getY()-8,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-8);
           }
           else if(!level_colide(newpos-10,player1.getY()-9,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-9);
           }
           else if(!level_colide(newpos-10,player1.getY()-10,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-10);
           }
          }
          
          if(player1.getAnimationCooldown()<=0){//chmage the player pose to make them look like there waljking
            player1.setPose(player1.getPose()+1);
             player1.setAnimationCooldown(4);
            if(player1.getPose()==13){
             player1.setPose(1); 
            }
          }else{
            player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
          }
         }
         
         if(player1_moving_left){//player moving left
          float newpos=player1.getX()-mspc*0.2;
          if(!level_colide(newpos-10,player1.getY(),player1.z-7)&&!level_colide(newpos-10,player1.getY(),player1.z+7)){
            if(!level_colide(newpos-10,player1.getY()-25,player1.z-7)&&!level_colide(newpos-10,player1.getY()-25,player1.z+7)){
              if(!level_colide(newpos-10,player1.getY()-50,player1.z-7)&&!level_colide(newpos-10,player1.getY()-50,player1.z+7)){
                if(!level_colide(newpos-10,player1.getY()-75,player1.z-7)&&!level_colide(newpos-10,player1.getY()-75,player1.z+7)){
                  player1.setX(newpos);
                }
              }
            }
          }else if((!level_colide(newpos-10,player1.getY()-10,player1.z)&&!level_colide(newpos-10,player1.getY()-50,player1.z)&&!level_colide(newpos-10,player1.getY()-75,player1.z))&&player1.getAirTime()==0){
           if(!level_colide(newpos+10,player1.getY()-1,player1.z)){//auto jump
             player1.setX(newpos);
             player1.setY(player1.getY()-1);
           }
           else if(!level_colide(newpos-10,player1.getY()-2,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-2);
           }else if(!level_colide(newpos-10,player1.getY()-3,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-3);
           }
           else if(!level_colide(newpos-10,player1.getY()-4,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-4);
           }
           else if(!level_colide(newpos-10,player1.getY()-5,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-5);
           }
           else if(!level_colide(newpos-10,player1.getY()-6,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-6);
           }
           else if(!level_colide(newpos-10,player1.getY()-7,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-7);
           }
           else if(!level_colide(newpos-10,player1.getY()-8,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-8);
           }
           else if(!level_colide(newpos-10,player1.getY()-9,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-9);
           }
           else if(!level_colide(newpos-10,player1.getY()-10,player1.z)){
             player1.setX(newpos);
             player1.setY(player1.getY()-10);
           }
          }
          
          if(player1.getAnimationCooldown()<=0){//change the playerb pose to make them look lie there walking
            player1.setPose(player1.getPose()-1);
             player1.setAnimationCooldown(4);
            if(player1.getPose()==0){
             player1.setPose(12); 
            }
          }else{
            player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
          }
         }
         
         if(WPressed){
           float newpos=player1.z-mspc*0.2;
          if(!level_colide(player1.x,player1.getY(),newpos-10)){
            if(!level_colide(player1.x,player1.getY()-25,newpos-10)){
              if(!level_colide(player1.x,player1.getY()-50,newpos-10)){
                if(!level_colide(player1.x,player1.getY()-75,newpos-10)){
                  player1.z=newpos;
                }
              }
            }
          }else if((!level_colide(player1.x,player1.getY()-10,newpos-10)&&!level_colide(player1.x,player1.getY()-50,newpos-10)&&!level_colide(player1.x,player1.getY()-75,newpos-10))&&player1.getAirTime()==0){
           if(!level_colide(player1.x,player1.getY()-1,newpos-10)){//auto jump
             player1.z=newpos;
             player1.setY(player1.getY()-1);
           }
           else if(!level_colide(player1.x,player1.getY()-2,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-2);
           }else if(!level_colide(player1.x,player1.getY()-3,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-3);
           }
           else if(!level_colide(player1.x,player1.getY()-4,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-4);
           }
           else if(!level_colide(player1.x,player1.getY()-5,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-5);
           }
           else if(!level_colide(player1.x,player1.getY()-6,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-6);
           }
           else if(!level_colide(player1.x,player1.getY()-7,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-7);
           }
           else if(!level_colide(player1.x,player1.getY()-8,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-8);
           }
           else if(!level_colide(player1.x,player1.getY()-9,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-9);
           }
           else if(!level_colide(player1.x,player1.getY()-10,newpos-10)){
             player1.z=newpos;
             player1.setY(player1.getY()-10);
           }
          }
          
          if(player1.getAnimationCooldown()<=0){//change the playerb pose to make them look lie there walking
            player1.setPose(player1.getPose()-1);
             player1.setAnimationCooldown(4);
            if(player1.getPose()==0){
             player1.setPose(12); 
            }
          }else{
            player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
          }
         }
         
         if(SPressed){
           float newpos=player1.z+mspc*0.2;
          if(!level_colide(player1.x,player1.getY(),newpos+10)){
            if(!level_colide(player1.x,player1.getY()-25,newpos+10)){
              if(!level_colide(player1.x,player1.getY()-50,newpos+10)){
                if(!level_colide(player1.x,player1.getY()-75,newpos+10)){
                  player1.z=newpos;
                }
              }
            }
          }else if((!level_colide(player1.x,player1.getY()-10,newpos+10)&&!level_colide(player1.x,player1.getY()-50,newpos+10)&&!level_colide(player1.x,player1.getY()-75,newpos+10))&&player1.getAirTime()==0){
           if(!level_colide(player1.x,player1.getY()-1,newpos-10)){//auto jump
             player1.z=newpos;
             player1.setY(player1.getY()-1);
           }
           else if(!level_colide(player1.x,player1.getY()-2,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-2);
           }else if(!level_colide(player1.x,player1.getY()-3,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-3);
           }
           else if(!level_colide(player1.x,player1.getY()-4,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-4);
           }
           else if(!level_colide(player1.x,player1.getY()-5,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-5);
           }
           else if(!level_colide(player1.x,player1.getY()-6,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-6);
           }
           else if(!level_colide(player1.x,player1.getY()-7,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-7);
           }
           else if(!level_colide(player1.x,player1.getY()-8,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-8);
           }
           else if(!level_colide(player1.x,player1.getY()-9,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-9);
           }
           else if(!level_colide(player1.x,player1.getY()-10,newpos+10)){
             player1.z=newpos;
             player1.setY(player1.getY()-10);
           }
          }
          
          if(player1.getAnimationCooldown()<=0){//change the playerb pose to make them look lie there walking
            player1.setPose(player1.getPose()-1);
             player1.setAnimationCooldown(4);
            if(player1.getPose()==0){
             player1.setPose(12); 
            }
          }else{
            player1.setAnimationCooldown(player1.getAnimationCooldown()-0.05*mspc);
          }
         }
         
         if(!player1_moving_right&&!player1_moving_left&&!WPressed&&!SPressed){//reset the player pose if the player is not moving
           player1.setPose(1);
           player1.setAnimationCooldown(4);
         }
         
         
         
         if(!player1_jumping||!player1.isJumping()){//gravity
           float pd=1;
            if(!level_colide(player1.getX(),player1.getY()+pd,player1.z+7)&&!level_colide(player1.getX(),player1.getY()+pd,player1.z-7)){
              pd=mspc*0.2;//gravity movement
              //wasDP=false;
              if(!level_colide(player1.getX(),player1.getY()+pd,player1.z+7)&&!level_colide(player1.getX(),player1.getY()+pd,player1.z-7)){
              player1.setY(player1.getY()+pd);
              player1.setAirTime(60);
              }else{
               while((!level_colide(player1.getX(),player1.getY()+pd,player1.z+7)&&!level_colide(player1.getX(),player1.getY()+pd,player1.z-7))&&pd>0){
                pd--; 
               }
               if(pd>0){
                 player1.setY(player1.getY()+pd);
               }
              }
            }else{
               player1.setAirTime(0);
               
            }
         }
         
         //if(player_kill(player1.getX()-10,player1.getY()+1)||player_kill(player1.getX()-5,player1.getY()+1)||player_kill(player1.getX(),player1.getY()+1)||player_kill(player1.getX()+5,player1.getY()+1)||player_kill(player1.getX()+10,player1.getY()+1)){
         //  dead=true;          
         //}
         
         
         if(!(!level_colide(player1.getX(),player1.getY(),player1.z+7)&&!level_colide(player1.getX(),player1.getY(),player1.z-7))){
           player1.setY(player1.getY()-1);
         }
         
         
         if(player1_jumping){//jumping
          if(player1.getAirTime()==0){
            player1.setJumping(true);
          }
          if(player1.getAirTime()<14&&player1.isJumping()){//jumping
            float pp=(0.1953333*mspc);
            if(!level_colide(player1.getX()-10,player1.getY()-75-pp,player1.z)&&!level_colide(player1.getX()-5,player1.getY()-75-pp,player1.z)&&!level_colide(player1.getX(),player1.getY()-75-pp,player1.z)&&!level_colide(player1.getX()+5,player1.getY()-75-pp,player1.z)&&!level_colide(player1.getX()+10,player1.getY()-75-pp,player1.z)){
              player1.setY(player1.getY()-pp);
              player1.setAirTime(player1.getAirTime()+mspc*0.010);
              player1.jumpDist+=pp;
            }else{
              player1.setJumping(false);
              player1.jumpDist=0;
            }
          }else{
            if(player1.getAirTime()<16&&player1.isJumping()){
              player1.setAirTime(player1.getAirTime()+mspc*0.010);
              //player1.setY(player1.getY()+(player1.jumpDist-293));
              player1.jumpDist=293;//in the futchre use this varible to judge wether the jump is at the max height
            }else{
            player1.setJumping(false);
            player1.jumpDist=0;
            }
          }
         }else{
           player1.setJumping(false);
           player1.jumpDist=0;
         }
         
         
         
         
         
}//end of 3D mode
         if(player1.getY()>720){
          dead=true; 
         }
         if(dead){
           file_path=rootPath+mainIndex.getJSONObject(respawnStage).getString("location");
              level_terain=loadJSONArray(file_path);
              stageIndex=respawnStage;
              
          player1.setX(respawnX);
          player1.setY(respawnY);
          if(checkpointIn3DStage){
           player1.z=respawnZ; 
          }
          dead=false;
         }
         if(setPlayerPosTo){
              player1.setX(setPlayerPosX).setY(setPlayerPosY);
              player1.z=setPlayerPosZ;
           setPlayerPosTo=false;
         }
         //////////////////////////////
         
         
          
}

void glitchEffect(){
 int n=millis()/100%10;
 //n=9;
 strokeWeight(0);
 if(n==0){
   fill(0,255,0,120);
   rect(12*Scale,30*Scale,200*Scale,80*Scale);
   rect(800*Scale,300*Scale,100*Scale,300*Scale);
   rect(400*Scale,240*Scale,500*Scale,20*Scale);
   fill(124,0,250,120);
   rect(620*Scale,530*Scale,240*Scale,50*Scale);
   rect(100*Scale,400*Scale,300*Scale,40*Scale);
   rect(50*Scale,600*Scale,550*Scale,20*Scale);
    fill(115,0,58,120);
   rect(720*Scale,90*Scale,360*Scale,112*Scale);
   rect(150*Scale,619*Scale,203*Scale,90*Scale);
   rect(526*Scale,306*Scale,266*Scale,165*Scale);
 }
 if(n==1){
   fill(0,255,0,120);
   rect(925*Scale,60*Scale,89*Scale,96*Scale);
   rect(305*Scale,522*Scale,84*Scale,140*Scale);
   rect(13*Scale,332*Scale,234*Scale,313*Scale);
   fill(124,0,250,120);
   rect(716*Scale,527*Scale,317*Scale,111*Scale);
   rect(318*Scale,539*Scale,233*Scale,118*Scale);
   rect(902*Scale,3*Scale,255*Scale,42*Scale);
    fill(115,0,58,120);
   rect(163*Scale,150*Scale,221*Scale,127*Scale);
   rect(216*Scale,142*Scale,7*Scale,49*Scale);
   rect(538*Scale,224*Scale,41*Scale,48*Scale);
 }
 if(n==2){
   fill(0,255,0,120);
   rect(410*Scale,335*Scale,94*Scale,74*Scale);
  rect(45*Scale,222*Scale,276*Scale,90*Scale);
  rect(871*Scale,287*Scale,268*Scale,174*Scale);
  fill(124,0,250,120);
  rect(996*Scale,535*Scale,18*Scale,28*Scale);
  rect(722*Scale,523*Scale,82*Scale,107*Scale);
  rect(263*Scale,201*Scale,161*Scale,88*Scale);
  fill(115,0,58,120);
  rect(697*Scale,436*Scale,165*Scale,44*Scale);
  rect(843*Scale,486*Scale,98*Scale,105*Scale);
  rect(755*Scale,20*Scale,151*Scale,51*Scale);
 }
 if(n==3){
   fill(0,255,0,120);
   rect(5*Scale,228*Scale,226*Scale,131*Scale);
  rect(813*Scale,428*Scale,83*Scale,60*Scale);
  rect(285*Scale,452*Scale,166*Scale,135*Scale);
  fill(124,0,250,120);
  rect(277*Scale,514*Scale,11*Scale,87*Scale);
  rect(905*Scale,152*Scale,8*Scale,160*Scale);
  rect(369*Scale,80*Scale,279*Scale,153*Scale);
  fill(115,0,58,120);
  rect(179*Scale,96*Scale,159*Scale,65*Scale);
  rect(432*Scale,296*Scale,47*Scale,12*Scale);
  rect(944*Scale,412*Scale,22*Scale,50*Scale);

 }
 if(n==4){
   fill(0,255,0,120);
   rect(679*Scale,159*Scale,76*Scale,168*Scale);
  rect(144*Scale,58*Scale,180*Scale,61*Scale);
  rect(950*Scale,89*Scale,155*Scale,13*Scale);
  fill(124,0,250,120);
  rect(542*Scale,463*Scale,177*Scale,156*Scale);
  rect(527*Scale,70*Scale,115*Scale,28*Scale);
  rect(211*Scale,151*Scale,58*Scale,164*Scale);
  fill(115,0,58,120);
  rect(88*Scale,440*Scale,278*Scale,23*Scale);
  rect(642*Scale,440*Scale,231*Scale,91*Scale);
  rect(737*Scale,524*Scale,69*Scale,71*Scale);

 }
 if(n==5){
   fill(0,255,0,120);
   rect(226*Scale,71*Scale,291*Scale,37*Scale);
  rect(91*Scale,436*Scale,210*Scale,8*Scale);
  rect(396*Scale,72*Scale,10*Scale,136*Scale);
  fill(124,0,250,120);
  rect(666*Scale,274*Scale,175*Scale,171*Scale);
  rect(251*Scale,513*Scale,280*Scale,13*Scale);
  rect(663*Scale,141*Scale,290*Scale,33*Scale);
  fill(115,0,58,120);
  rect(900*Scale,47*Scale,315*Scale,125*Scale);
  rect(10*Scale,156*Scale,231*Scale,73*Scale);
  rect(377*Scale,253*Scale,175*Scale,22*Scale);
 }
 if(n==6){
   fill(0,255,0,120);
   rect(756*Scale,447*Scale,205*Scale,161*Scale);
  rect(304*Scale,341*Scale,276*Scale,144*Scale);
  rect(4*Scale,141*Scale,35*Scale,176*Scale);
  fill(124,0,250,120);
  rect(307*Scale,98*Scale,204*Scale,89*Scale);
  rect(478*Scale,476*Scale,44*Scale,52*Scale);
  rect(620*Scale,57*Scale,242*Scale,144*Scale);
  fill(115,0,58,120);
  rect(495*Scale,374*Scale,199*Scale,62*Scale);
  rect(724*Scale,71*Scale,34*Scale,2*Scale);
  rect(853*Scale,88*Scale,199*Scale,114*Scale);
 }
 if(n==7){
   fill(0,255,0,120);
   rect(276*Scale,181*Scale,220*Scale,38*Scale);
    rect(955*Scale,514*Scale,33*Scale,51*Scale);
    rect(621*Scale,135*Scale,100*Scale,74*Scale);
  fill(124,0,250,120);
  rect(200*Scale,333*Scale,165*Scale,99*Scale);
  rect(709*Scale,503*Scale,84*Scale,117*Scale);
  rect(212*Scale,275*Scale,238*Scale,27*Scale);
  fill(115,0,58,120);
  rect(787*Scale,477*Scale,115*Scale,9*Scale);
  rect(239*Scale,443*Scale,155*Scale,149*Scale);
  rect(794*Scale,267*Scale,185*Scale,80*Scale);
 }
 if(n==8){
   fill(0,255,0,120);
   rect(543*Scale,498*Scale,22*Scale,125*Scale);
  rect(749*Scale,151*Scale,79*Scale,174*Scale);
  rect(667*Scale,380*Scale,311*Scale,45*Scale);
  fill(124,0,250,120);
  rect(886*Scale,193*Scale,87*Scale,50*Scale);
  rect(135*Scale,128*Scale,151*Scale,83*Scale);
  rect(651*Scale,128*Scale,20*Scale,85*Scale);
  fill(115,0,58,120);
  rect(862*Scale,374*Scale,319*Scale,136*Scale);
  rect(258*Scale,149*Scale,65*Scale,143*Scale);
  rect(299*Scale,63*Scale,297*Scale,152*Scale);
 }
 if(n==9){
   fill(0,255,0,120);
   rect(953*Scale,386*Scale,11*Scale,30*Scale);
  rect(453*Scale,104*Scale,50*Scale,95*Scale);
  rect(71*Scale,157*Scale,23*Scale,49*Scale);
  fill(124,0,250,120);
  rect(373*Scale,447*Scale,28*Scale,136*Scale);
  rect(598*Scale,321*Scale,227*Scale,19*Scale);
  rect(500*Scale,314*Scale,218*Scale,113*Scale);
  fill(115,0,58,120);
  rect(423*Scale,512*Scale,295*Scale,30*Scale);
  rect(186*Scale,489*Scale,208*Scale,76*Scale);
  rect(178*Scale,269*Scale,117*Scale,133*Scale);
 }
}

void engageHUDPosition(){
         //translate(player1.x+DX,player1.y-DY,player1.z-DZ);
         //rotateY(radians(-(xangle-180)));
         //rotateX(radians(yangle));
         //translate(-640,-360,-623);
         camera();
         hint(DISABLE_DEPTH_TEST);
         noLights();
}

void disEngageHUDPosition(){
         //translate(640,360,623);
         //rotateX(radians(-yangle));
         //rotateY(radians((xangle-180)));
         //translate(-1*(player1.x+DX),-1*(player1.y-DY),-1*(player1.z-DZ));  
         hint(ENABLE_DEPTH_TEST); 
}
//////////////////////





/////////////////////

boolean level_colide(float x,float y){
  level_terain=loadJSONArray(file_path);
         for(int i=1;i<level_terain.size();i++){
          JSONObject block=level_terain.getJSONObject(i); 
          String type=block.getString("type");
          
         
          if(type.equals("ground")||type.equals("dethPlane")){
             float tx = block.getFloat("x"),ty = block.getFloat("y"),dx = block.getFloat("dx"),dy = block.getFloat("dy");
          float x2 = tx+dx,y2=ty+dy;
            if(x >= tx && x <= x2 && y >= ty && y <= y2/* terain hit box*/){
                return true;
            }
           
          }
          if(type.equals("sloap")){
            float x1 = block.getFloat("x1"),y1 = block.getFloat("y1"),x2 = block.getFloat("x2"),y2 = block.getFloat("y2");
            int rot=block.getInt("rotation");
           if(rot==0){
             if(x<=x2&&y>=y1&&y<=x*((y2-y1)/(x2-x1)) + (y2-(x2*((y2-y1)/(x2-x1))))  ){
              return true; 
             }
            //triangle(X1,Y1,X2,Y2,X2,Y1); 
           }
           if(rot==1){
             if(x>=x1&&y>=y1&&y<=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ){
              return true; 
             }
            //triangle(X1,Y1,X1,Y2,X2,Y1); 
           }
           if(rot==2){
             if(x>=x1&&y<=y2&&y>=x*((y2-y1)/(x2-x1)) + ( y2-(x2*((y2-y1)/(x2-x1))))  ){
              return true; 
             }
            //triangle(X1,Y1,X2,Y2,X1,Y2); 
           }
           if(rot==3){
             if(x<=x2&&y<=y2&&y>=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ){
              return true; 
             }
            //triangle(X1,Y2,X2,Y2,X2,Y1); 
           }
          }
         }
         
  
  
  return false;
}

boolean level_colide(float x,float y,float z){//3d collions 
  for(int i=1;i<level_terain.size();i++){
          JSONObject block=level_terain.getJSONObject(i); 
          String type=block.getString("type");
          
         
          if(type.equals("ground")||type.equals("dethPlane")||type.equals("holo")){
             float tx = block.getFloat("x"),ty = block.getFloat("y"),tz = block.getFloat("z"),dx = block.getFloat("dx"),dy = block.getFloat("dy"),dz = block.getFloat("dz");
          float x2 = tx+dx,y2=ty+dy,z2=tz+dz;
            if(x >= tx && x <= x2 && y >= ty && y <= y2 && z>=tz && z<=z2/* terain hit box*/){
                return true;
            }
           
          }
         }
         return false;
  
}

boolean player_kill(float x,float y){
  level_terain=loadJSONArray(file_path);
         for(int i=1;i<level_terain.size();i++){
          JSONObject block=level_terain.getJSONObject(i); 
          String type=block.getString("type");
          
         
          if(type.equals("dethPlane")){
             float tx = block.getFloat("x"),ty = block.getFloat("y"),dx = block.getFloat("dx"),dy = block.getFloat("dy");
          float x2 = tx+dx,y2=ty+dy;
            if(x >= tx && x <= x2 && y >= ty && y <= y2/* terain hit box*/){
              
                return true;
            }
           
          }
         }
  
  return false;
}
