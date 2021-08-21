void drawCoin(float x,float y,float Scale){
strokeWeight(0);
fill(#FCC703);
circle(x,y,12*Scale);
fill(255,255,0);
circle(x,y,10*Scale);
fill(#FCC703);
rect(x-2*Scale,y-3*Scale,4*Scale,6*Scale);
}

void drawWorldSymbol(float x,float y){
  strokeWeight(0);
  fill(#05F5F3);
  stroke(#05F5F3);
  rect(x,y,40,20);
  fill(#00F73B);
  stroke(#00F73B);
  rect(x,y+20,40,20);
  rect(x,y+10,10,10);
  fill(#8E6600);
  stroke(#8E6600);
  rect(x+25,y+10,5,10);
  fill(#008E08);
  stroke(#008E08);
  rect(x+20,y+8,15,4);
  rect(x+23,y+4,9,4);
}

void drawPortal(float x,float y,float scale){
  fill(0);
  strokeWeight(0);
  ellipse(x,y,50*scale,100*scale);
  fill(#AE00FA);
  ellipse(x,y,35*scale,80*scale);
  fill(0);
  ellipse(x,y,20*scale,60*scale);
  fill(#AE00FA);
  ellipse(x,y,5*scale,40*scale);
}

void draw3DSwitch1(float x,float y,float Scale){
 fill(196);
 strokeWeight(0);
 rect((x-20*Scale),(y-5*Scale),40*Scale,5*Scale);
 fill(#FAB800);
 rect((x-10*Scale),(y-10*Scale),20*Scale,5*Scale);
}

void draw3DSwitch1(float x,float y,float z,float Scale){
 fill(196);
 strokeWeight(0);
 translate(x,y-2.5,z);
 box(40,5,40);
 fill(#FAB800);
 translate(0,-2.5,0);
 box(20,2,20);
 translate(-x,-(y-5),-z);
}

void draw3DSwitch2(float x,float y,float Scale){
 fill(196);
 strokeWeight(0);
 rect((x-20*Scale),(y-5*Scale),40*Scale,5*Scale);
}

void draw3DSwitch2(float x,float y,float z,float Scale){
 fill(196);
 strokeWeight(0);
 translate(x,y-2.5,z);
 box(40,5,40);
 fill(#FF03D1);
 translate(0,-5,0);
 box(20,5,20);
 translate(-x,-(y-7.5),-z);
}
