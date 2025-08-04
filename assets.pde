//start of assets.pde
/**Draw a coin to the given renderer
@param x The x position to draw the coin at
@param y The y position to draw the coin at
@param Scale the scale to draw the coin at
@param render The place to render the coin to
*/
void drawCoin(float x, float y, float Scale,PGraphics render) {
  render.fill(#FCC703);
  render.circle(x, y, 12*Scale);
  render.fill(255, 255, 0);
  render.circle(x, y, 10*Scale);
  render.fill(#FCC703);
  render.rect(x-2*Scale, y-3*Scale, 4*Scale, 6*Scale);
}

/**Draw the 2D stage icon
@param x The x position to draw the icon at
@param y The y position to draw the icon at
@param render The place to draw the icon to
*/
void drawWorldSymbol(float x, float y,PGraphics render) {
  render.strokeWeight(0);
  render.fill(#05F5F3);
  render.stroke(#05F5F3);
  render.rect(x, y, 40, 20);
  render.fill(#00F73B);
  render.stroke(#00F73B);
  render.rect(x, y+20, 40, 20);
  render.rect(x, y+10, 10, 10);
  render.fill(#8E6600);
  render.stroke(#8E6600);
  render.rect(x+25, y+10, 5, 10);
  render.fill(#008E08);
  render.stroke(#008E08);
  render.rect(x+20, y+8, 15, 4);
  render.rect(x+23, y+4, 9, 4);
}

/**draw the interdimentional portal on the given renderer
@param x The x position of the portal
@param y The y position of the portal
@param scale The scale to draw the portal at
@param render The place to draw the portal to
*/
void drawPortal(float x, float y, float scale,PGraphics render) {
  render.fill(0);
  render.ellipse(x, y, 50*scale, 100*scale);
  render.fill(#AE00FA);
  render.ellipse(x, y, 35*scale, 80*scale);
  render.fill(0);
  render.ellipse(x, y, 20*scale, 60*scale);
  render.fill(#AE00FA);
  render.ellipse(x, y, 5*scale, 40*scale);
}

/**Draw the 2D version of the 3D on switch on the given renderer
@param x The unscaled x position of the switch
@param y The unscaled y position of the switch
@param Scale The scale to draw the swiotch at 
@param render The place to draw the switch to
*/
void draw3DSwitch1(float x, float y, float Scale,PGraphics render) {
  render.fill(196);
  render.rect((x-20)*Scale, (y-5)*Scale, 40*Scale, 5*Scale);
  render.fill(#FAB800);
  render.rect((x-10)*Scale, (y-10)*Scale, 20*Scale, 5*Scale);
}

/**Draw the 3D version of the 3D on switch on the given renderer
@param x The x position of the switch
@param y The y position of the switch
@param z The z position of the switch
@param Scale Unused
@param render The place to draw the switch to
*/
void draw3DSwitch1(float x, float y, float z, float Scale,PGraphics render) {
  render.fill(196);
  //strokeWeight(0);
  render.translate(x, y-2.5, z);
  render.box(40, 5, 40);
  render.fill(#FAB800);
  render.translate(0, -2.5, 0);
  render.box(20, 2, 20);
  render.translate(-x, -(y-5), -z);
}
/**Draw the 2D version of the 3D off switch on the given renderer
@param x The unscaled x position of the switch
@param y The unscaled y position of the switch
@param Scale The scale to draw the switch at 
@param render The place to draw the switch to
*/
void draw3DSwitch2(float x, float y, float Scale,PGraphics render) {
  render.fill(196);
  render.rect((x-20)*Scale, (y-5)*Scale, 40*Scale, 5*Scale);
}
/**Draw the 3D version of the 3D off switch on the given renderer
@param x The x position of the switch
@param y The y position of the switch
@param z The z position of the switch
@param Scale Unused
@param render The place to draw the switch to
*/
void draw3DSwitch2(float x, float y, float z, float Scale,PGraphics render) {
  render.fill(196);
  //strokeWeight(0);
  render.translate(x, y-2.5, z);
  render.box(40, 5, 40);
  render.fill(#FF03D1);
  render.translate(0, -5, 0);
  render.box(20, 5, 20);
  render.translate(-x, -(y-7.5), -z);
}

/**Draw the 2D version of the check point flag
@param x The x unscaled x position of the flag
@param y The y unscaled y position of the flag
@param scale The scale to draw the flag at
@param render The place to render the flag to

*/
void drawCheckPoint(float x, float y,float scale, PGraphics render) {
  render.fill(#B9B9B9);
  render.rect((x-3)*scale, (y-60)*scale, 5*scale, 60*scale);
  render.fill(#EA0202);
  render.triangle(x*scale, (y-60)*scale, x*scale, (y-40)*scale, (x+30)*scale, (y-50)*scale);
}

/**Draw the 2D version of the sign
@param x The unscaled x position of the sign
@param y The unscaled y position of the sign
@param Scale The scale to draw the sign at
@param render The place to draw the sign to
*/
void drawSign(float x, float y, float Scale,PGraphics render) {
  render.fill(#A54A00);
  render.rect(x-5*Scale, y-30*Scale, 10*Scale, 30*Scale);
  render.rect(x-35*Scale, y-65*Scale, 70*Scale, 40*Scale);
  render.fill(#C4C4C4);
  render.rect(x-33*Scale, y-63*Scale, 66*Scale, 36*Scale);
  render.fill(#767675);
  render.rect(x-30*Scale, y-58*Scale, 60*Scale, 2*Scale);
  render.rect(x-30*Scale, y-52*Scale, 60*Scale, 2*Scale);
  render.rect(x-30*Scale, y-46*Scale, 60*Scale, 2*Scale);
  render.rect(x-30*Scale, y-40*Scale, 60*Scale, 2*Scale);
  render.rect(x-30*Scale, y-34*Scale, 60*Scale, 2*Scale);
}

/**Draw the 3D version of the sign
@param x The x position of the sign
@param y The y postiion of the sign
@param z The z position of the sign
@param Scale Unused
@param render The place to draw the sign to
*/
void drawSign(float x, float y, float z, float Scale,PGraphics render) {
  render.translate(x, y, z);
  render.fill(#A54A00);
  render.translate(0, -15, 0);
  render.box(10, 30, 10);
  render.translate(0, -20, 0);
  render.box(70, 40, 10);
  render.fill(#C4C4C4);
  render.translate(0, 0, 6);
  render.box(66, 36, 1);
  render.translate(0, -13, 1);
  render.fill(#767675);
  render.box(60, 2, 1);
  render.translate(0, 6, 0);
  render.box(60, 2, 1);
  render.translate(0, 6, 0);
  render.box(60, 2, 1);
  render.translate(0, 6, 0);
  render.box(60, 2, 1);
  render.translate(0, 6, 0);
  render.box(60, 2, 1);

  render.translate(0, -6, 0);
  render.translate(0, -6, 0);
  render.translate(0, -6, 0);
  render.translate(0, -6, 0);
  render.translate(0, 13, -1);
  render.translate(0, 0, -6);
  render.translate(0, 20, 0);
  render.translate(0, 15, 0);
  render.translate(-x, -y, -z);
}
/**Draw the speaker icon
@param x The unscaled x position of the speaker
@param y The unscaled y position of the speaker
@param scale The to draw the speaker at
@param render The place to draw the speaker to
*/
void drawSpeakericon(float x, float y, float scale,PGraphics render) {
  render.fill(#767676);
  render.strokeWeight(0);
  render.rect(x-40*scale, y-20*scale, 40*scale, 40*scale);
  render.triangle(x-20*scale, y-20*scale, x, y-20*scale, x, y-35*scale);
  render.triangle(x-20*scale, y+20*scale, x, y+20*scale, x, y+35*scale);
  render.rect(x+5*scale, y-10*scale, 5*scale, 20*scale);
  render.rect(x+15*scale, y-20*scale, 5*scale, 40*scale);
  render.rect(x+25*scale, y-30*scale, 5*scale, 60*scale);
}

/**Draw or dont draw the sound box based on wether the level crator is active or not
@param x The x position of the box
@param y The y position of the box
@param scale The scale to draw the box at
@param render The palce to draw the box to
*/
void drawSoundBox(float x, float y,float scale,PGraphics render) {
  if (levelCreator) {
    render.fill(#F2C007, 127);
    render.rect(x-30*scale, y-30*scale, 60*scale, 60*scale);
  }
}

/**Draw the 2D version of the logic button
@param x The unscaled x position of the button
@param y The unscaled y position of the button
@param Scale The scale to draw the button at
@param pressed Wether or not the button is currently pressed down
@param render The place to draw the button to
*/
void drawLogicButton(float x, float y, float Scale, boolean pressed,PGraphics render) {
  render.fill(196);
  render.rect((x-20*Scale), (y-5*Scale), 40*Scale, 5*Scale);
  if (!pressed) {
    render.fill(#FC2121);
    render.rect((x-10*Scale), (y-10*Scale), 20*Scale, 5*Scale);
  }
}
/**Draw the 4D version of the logic button
@param x The x position of the button
@param y The y position of the button
@param z The z position of the button
@param Scale unused
@param pressed Wether or not the button is currently pressed down
@param render The place to draw the button to
*/
void drawLogicButton(float x, float y, float z, float Scale, boolean pressed,PGraphics render) {
  render.fill(196);
  // strokeWeight(0);
  render.translate(x, y-2.5, z);
  render.box(40, 5, 40);
  render.fill(#FC2121);
  render.translate(0, -5, 0);
  if (!pressed)
    render.box(20, 5, 20);
  render.translate(-x, -(y-7.5), -z);
}
/**Draw the logic board icon
@param x The x position of the icon
@param y The y position of the icon
@param scale The scale to draw the button at
@param render The place to render the icon to
*/
void logicIcon(float x, float y, float scale,PGraphics render) {
  render.noStroke();
  render.fill(#B9B9B9);
  render.rect(x-10*scale, y+20*scale, 20*scale, 15*scale);
  render.fill(#989898);
  render.rect(x-10*scale, y+23*scale, 20*scale, 3*scale);
  render.rect(x-10*scale, y+29*scale, 20*scale, 3*scale);
  render.fill(#FFF300);
  render.rect(x-15*scale, y-10*scale, 30*scale, 30*scale);
  render.fill(#D38A00);
  render.rect(x-8*scale, y, 5*scale, 20*scale);
  render.rect(x+3*scale, y, 5*scale, 20*scale);
  render.rect(x-3*scale, y, 6*scale, 5*scale);
}

/**Draw the 3D stage icon
@param x The x position to draw the icon
@param y The y position to draw the icon
@param scale The scale to draw the icon at
@param render the place to draw the icon to
*/
void draw3DStageIcon(float x, float y, float scale,PGraphics render) {
  render.directionalLight(255, 255, 255, 0.8, 1, -0.35);//setr up the lighting
  render.ambientLight(102, 102, 102);
  render.noStroke();
  render.translate(x, y, 0);
  render.rotateX(-radians(30));
  render.rotateY(radians(75));
  render.rotateZ(radians(24));

  render.translate(0, 20*scale, 0);
  render.fill(#00F73B);
  render.box(40*scale, 20*scale, 40*scale);
  render.translate(0, -20*scale, 0);
  render.translate(0, -10*scale, 0);
  render.fill(#BC6022);
  render.box(10*scale, 40*scale, 10*scale);
  render.translate(0, 10*scale, 0);
  render.translate(0, -25*scale, 0);
  render.fill(#089D06);
  render.box(25*scale, 15*scale, 25*scale);
  render.translate(0, 25*scale, 0);
  render.translate(0, -18*scale, 0);
  render.box(35*scale, 12*scale, 35*scale);
  render.translate(0, 18*scale, 0);

  render.rotateZ(-radians(24));
  render.rotateY(-radians(75));
  render.rotateX(radians(30));
  render.translate(-x, -y, 0);
  render.noLights();
}
/**Draw the floppy disk save icon
@param x The x position to draw the icon
@param y The y position to draw the icon
@param scale The scale to draw the icon at
@param render The place to draw the icon to
*/
void saveIcon(float x, float y, float scale, PGraphics render){
  //floppy background color
  render.fill(#4E74FA);
  render.rect(x-20*scale,y-20*scale,35*scale,40*scale);
  render.rect(x+15*scale,y-15*scale,5*scale,30*scale);
  render.rect(x+15*scale,y+17*scale,5*scale,3*scale);
  render.rect(x+15*scale,y+15*scale,2*scale,2*scale);
  render.rect(x+19*scale,y+15*scale,1*scale,2*scale);
  render.triangle(x+15*scale,y-20*scale,x+15*scale,y-15*scale,x+20*scale,y-15*scale);
  
  render.fill(0);//wright protect
  render.rect(x-19*scale,y+15*scale,2*scale,2*scale);
  
  render.fill(#C4C4C4);//disk protector
  render.rect(x-10*scale,y-20*scale,12*scale,10*scale);
  render.rect(x+5*scale,y-20*scale,3*scale,10*scale);
  render.rect(x+2*scale,y-20*scale,3*scale,2*scale);
  render.rect(x+2*scale,y-12*scale,3*scale,2*scale);
  
  render.fill(255);//label
  render.rect(x-15*scale,y-7*scale,30*scale,25*scale);
  render.fill(255,0,0);//red lines on lebel
  render.rect(x-15*scale,y+18*scale,30*scale,2*scale);
  
  render.rect(x-15*scale,y-5*scale,30*scale,1*scale);
  render.rect(x-15*scale,y-1*scale,30*scale,1*scale);
  render.rect(x-15*scale,y+3*scale,30*scale,1*scale);
  render.rect(x-15*scale,y+7*scale,30*scale,1*scale);
  render.rect(x-15*scale,y+11*scale,30*scale,1*scale);
  render.rect(x-15*scale,y+15*scale,30*scale,1*scale);
}
//end of assets.pde
