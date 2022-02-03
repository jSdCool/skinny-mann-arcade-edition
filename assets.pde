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

void drawSign(float x, float y, float z, float Scale) {
  translate(x, y, z);
  fill(#A54A00);
  translate(0, -15, 0);
  box(10, 30, 10);
  translate(0, -20, 0);
  box(70, 40, 10);
  fill(#C4C4C4);
  translate(0, 0, 6);
  box(66, 36, 1);
  translate(0, -13, 1);
  fill(#767675);
  box(60, 2, 1);
  translate(0, 6, 0);
  box(60, 2, 1);
  translate(0, 6, 0);
  box(60, 2, 1);
  translate(0, 6, 0);
  box(60, 2, 1);
  translate(0, 6, 0);
  box(60, 2, 1);

  translate(0, -6, 0);
  translate(0, -6, 0);
  translate(0, -6, 0);
  translate(0, -6, 0);
  translate(0, 13, -1);
  translate(0, 0, -6);
  translate(0, 20, 0);
  translate(0, 15, 0);
  translate(-x, -y, -z);
}
