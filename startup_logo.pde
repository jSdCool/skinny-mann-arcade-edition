int ptsW, ptsH;

PImage img;

int numPointsW;
int numPointsH_2pi;
int numPointsH;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;
float logorx=-75, logory=-180, logorz=0, start_wate=0;

boolean skipFrameInumeration = true;
int startupMillisTimer =0,prevstartupMillis=0;

PShape CBiSphere;
void drawlogo(boolean controllCamera, boolean setBackground) {
  directionalLight(255, 255, 255, 1, 0.8, -1);
  ambientLight(102, 102, 102);

  if (setBackground)
    background(0);
  if(!skipFrameInumeration){
    startupMillisTimer=millis()-prevstartupMillis;
  }else{
    skipFrameInumeration = false;
    startupMillisTimer = 0;
  }
  
  if (logorx<0) {
    logorx+=(startupMillisTimer/1000.0)*25;
  } else {
    fill(#03FA0C);
    
    
    logoText.draw();
    start_wate+=startupMillisTimer/1000.0;
  }
  prevstartupMillis = millis();
  fill(255);
  if (controllCamera)
    camera(width/2, height/2, 623.5382907, width/2, height/2, 0, 0, 1, 0);

  if(setBackground){
    //loadingText.draw();
    textSize(30);
    textAlign(CENTER,TOP);
    //loadingText = new UiText(ui,"Loading ...",640,180,20,CENTER,TOP);
    text("Loading ...",width/2,height/2-300);
  }
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateZ(radians(logorz));
  rotateX(radians(logorx));
  rotateY(radians(logory));
  shape(CBiSphere, 0, 0);
  //textureSphere(200, 200, 200, CBi);
  popMatrix();
}

void initializeSphere(int numPtsW, int numPtsH_2pi) {

  // The number of points around the width and height
  numPointsW=numPtsW+1;
  numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
  numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW; i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }

  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH);
      multXZ[i]=0;
    } else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH);
      multXZ[i]=sin(thetaH);
    }
  }
}

void textureSphere(float rx, float ry, float rz, PImage t) {
  // These are so we can map certain parts of the image on to the shape
  float changeU=t.width/(float)(numPointsW-1);
  float changeV=t.height/(float)(numPointsH-1);
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture
  CBiSphere= createShape();

  CBiSphere.beginShape(TRIANGLE_STRIP);
  CBiSphere.noStroke();
  CBiSphere.texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
      CBiSphere.normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
      CBiSphere.vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      CBiSphere.normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
      CBiSphere.vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  CBiSphere.endShape();
}
