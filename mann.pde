void draw_mann(float x, float y, int pose, float scale, int shirt_color) {
  strokeWeight(0);
  if (shirt_color==0) {//red
    fill(255, 0, 0);
    stroke(255, 0, 0);
  }
  if (shirt_color==1) {//green
    fill(0, 181, 0);
    stroke(0, 181, 0);
  }
  if (shirt_color==2) {//blue
    fill(0, 29, 255);
    stroke(0, 29, 255);
  }
  if (shirt_color==3) {//yellow
    fill(255, 226, 0);
    stroke(255, 226, 0);
  }
  if (shirt_color==4) {//magenta
    fill(232, 0, 221);
    stroke(232, 0, 221);
  }
  if (shirt_color==5) {//mint
    fill(0, 232, 121);
    stroke(0, 232, 121);
  }
  if (shirt_color==6) {//orange
    fill(252, 156, 0);
    stroke(252, 156, 0);
  }
  if (shirt_color==7) {//pink
    fill(255, 149, 153);
    stroke(255, 149, 153);
  }
  if (shirt_color==8) {//maroon
    fill(64, 12, 12);
    stroke(64, 12, 12);
  }
  if (shirt_color==9) {//purple
    fill(139, 0, 255);
    stroke(139, 0, 255);
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

  if (pose==2) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-12*scale, y-20*scale, scale*6, scale*10);
    rect(x+6*scale, y-20*scale, scale*6, scale*10);
    rect(x-14*scale, y-10*scale, scale*6, scale*10);
    rect(x+8*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==3) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-13*scale, y-20*scale, scale*6, scale*10);
    rect(x+7*scale, y-20*scale, scale*6, scale*10);
    rect(x-18*scale, y-10*scale, scale*6, scale*10);
    rect(x+12*scale, y-10*scale, scale*6, scale*10);
  }
  if (pose==4) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-12*scale, y-30*scale, scale*6, scale*10);
    rect(x+6*scale, y-30*scale, scale*6, scale*10);
    rect(x-16*scale, y-20*scale, scale*6, scale*10);
    rect(x+10*scale, y-20*scale, scale*6, scale*10);
    rect(x-19*scale, y-10*scale, scale*6, scale*10);
    rect(x+15*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==5) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-13*scale, y-20*scale, scale*6, scale*10);
    rect(x+7*scale, y-20*scale, scale*6, scale*10);
    rect(x-18*scale, y-10*scale, scale*6, scale*10);
    rect(x+12*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==6) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-12*scale, y-20*scale, scale*6, scale*10);
    rect(x+6*scale, y-20*scale, scale*6, scale*10);
    rect(x-14*scale, y-10*scale, scale*6, scale*10);
    rect(x+8*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==7) {
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

  if (pose==8) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-8*scale, y-20*scale, scale*6, scale*10);
    rect(x+2*scale, y-20*scale, scale*6, scale*10);
    rect(x-6*scale, y-10*scale, scale*6, scale*10);
    rect(x+1*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==9) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-7*scale, y-20*scale, scale*6, scale*10);
    rect(x+1*scale, y-20*scale, scale*6, scale*10);
    rect(x-2*scale, y-10*scale, scale*6, scale*10);
    rect(x-4*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==10) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-8*scale, y-30*scale, scale*6, scale*10);
    rect(x+2*scale, y-30*scale, scale*6, scale*10);
    rect(x-4*scale, y-20*scale, scale*6, scale*10);
    rect(x-4*scale, y-20*scale, scale*6, scale*10);
    rect(x+2*scale, y-10*scale, scale*6, scale*10);
    rect(x-7*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==11) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-7*scale, y-20*scale, scale*6, scale*10);
    rect(x+1*scale, y-20*scale, scale*6, scale*10);
    rect(x-2*scale, y-10*scale, scale*6, scale*10);
    rect(x-4*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==12) {
    rect(x-10*scale, y-55*scale, scale*20, scale*25);
    fill(-17813);
    stroke(-17813);
    rect(x-15*scale, y-75*scale, scale*30, scale*20);
    fill(-16763137);
    stroke(-16763137);
    rect(x-10*scale, y-30*scale, scale*6, scale*10);
    rect(x+4*scale, y-30*scale, scale*6, scale*10);
    rect(x-8*scale, y-20*scale, scale*6, scale*10);
    rect(x+2*scale, y-20*scale, scale*6, scale*10);
    rect(x-6*scale, y-10*scale, scale*6, scale*10);
    rect(x+1*scale, y-10*scale, scale*6, scale*10);
  }
}

void draw_mann_3D(float x, float y, float z, int pose, float scale, int shirt_color) {
  translate(x, y, z);
  rotateY(radians(90));
  strokeWeight(0);
  if (shirt_color==0) {//red
    fill(255, 0, 0);
    stroke(255, 0, 0);
  }
  if (shirt_color==1) {//green
    fill(0, 181, 0);
    stroke(0, 181, 0);
  }
  if (shirt_color==2) {//blue
    fill(0, 29, 255);
    stroke(0, 29, 255);
  }
  if (shirt_color==3) {//yellow
    fill(255, 226, 0);
    stroke(255, 226, 0);
  }
  if (shirt_color==4) {//magenta
    fill(232, 0, 221);
    stroke(232, 0, 221);
  }
  if (shirt_color==5) {//mint
    fill(0, 232, 121);
    stroke(0, 232, 121);
  }
  if (shirt_color==6) {//orange
    fill(252, 156, 0);
    stroke(252, 156, 0);
  }
  if (shirt_color==7) {//pink
    fill(255, 149, 153);
    stroke(255, 149, 153);
  }
  if (shirt_color==8) {//maroon
    fill(64, 12, 12);
    stroke(64, 12, 12);
  }
  if (shirt_color==9) {//purple
    fill(139, 0, 255);
    stroke(139, 0, 255);
  }

  translate(0, -42.5*scale, 0);
  box(scale*20, scale*25, 10*scale);
  translate(0, 0-42.5*scale*-1, 0);
  fill(-17813);
  stroke(-17813);
  translate( 0, 0-65*scale, 0);

  box(scale*30, scale*20, 20*scale);

  translate(- 0, (0-65*scale)*-1, -0);

  if (pose==1) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -0);
    translate((0+7*scale), (0-15*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -0);
    translate(0-7*scale, 0-5*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -0);
    translate((0+7*scale), (0-5*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -0);
  }

  if (pose==2) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0+2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0+2*scale));
    translate((0+7*scale), (0-15*scale), 0-2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0-2*scale));
    translate(0-7*scale, 0-5*scale, 0+4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0+4*scale));
    translate((0+7*scale), (0-5*scale), 0-4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0-4*scale));
  }

  if (pose==3) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0+3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0+3*scale));
    translate((0+7*scale), (0-15*scale), 0-3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0-3*scale));
    translate(0-7*scale, 0-5*scale, 0+7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0+7*scale));
    translate((0+7*scale), (0-5*scale), 0-7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0-7*scale));
  }
  if (pose==4) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0+5*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0+5*scale));
    translate((0+7*scale), (0-15*scale), 0-5*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0-5*scale));
    translate(0-7*scale, 0-5*scale, 0+10*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0+10*scale));
    translate((0+7*scale), (0-5*scale), 0-10*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0-10*scale));
  }

  if (pose==5) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0+3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0+3*scale));
    translate((0+7*scale), (0-15*scale), 0-3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0-3*scale));
    translate(0-7*scale, 0-5*scale, 0+7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0+7*scale));
    translate((0+7*scale), (0-5*scale), 0-7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0-7*scale));
  }

  if (pose==6) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0+2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0+2*scale));
    translate((0+7*scale), (0-15*scale), 0-2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0-2*scale));
    translate(0-7*scale, 0-5*scale, 0+4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0+4*scale));
    translate((0+7*scale), (0-5*scale), 0-4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0-4*scale));
  }

  if (pose==7) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -0);
    translate((0+7*scale), (0-15*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -0);
    translate(0-7*scale, 0-5*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -0);
    translate((0+7*scale), (0-5*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -0);
  }

  if (pose==8) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0-2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0-2*scale));
    translate((0+7*scale), (0-15*scale), 0+2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0+2*scale));
    translate(0-7*scale, 0-5*scale, 0-4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0-4*scale));
    translate((0+7*scale), (0-5*scale), 0+4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0+4*scale));
  }

  if (pose==9) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0-3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0-3*scale));
    translate((0+7*scale), (0-15*scale), 0+3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0+3*scale));
    translate(0-7*scale, 0-5*scale, 00-7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0-7*scale));
    translate((0+7*scale), (0-5*scale), 0+7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0+7*scale));
  }

  if (pose==10) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0-5*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0-5*scale));
    translate((0+7*scale), (0-15*scale), 0+5*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0+5*scale));
    translate(0-7*scale, 0-5*scale, 0-10*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0-10*scale));
    translate((0+7*scale), (0-5*scale), 0+10*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0+10*scale));
  }

  if (pose==11) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0-3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0-3*scale));
    translate((0+7*scale), (0-15*scale), 0+3*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0+3*scale));
    translate(0-7*scale, 0-5*scale, 0-7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0-7*scale));
    translate((0+7*scale), (0-5*scale), 0+7*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0+7*scale));
  }

  if (pose==12) {
    fill(-16763137);
    stroke(-16763137);
    translate(0-7*scale, 0-25*scale, 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    translate((0+7*scale), (0-25*scale), 0);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    translate(0-7*scale, 0-15*scale, 0-2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-15*scale), -(0-2*scale));
    translate((0+7*scale), (0-15*scale), 0+2*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-15*scale), -(0+2*scale));
    translate(0-7*scale, 0-5*scale, 0-4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0-7*scale), -1*(0-5*scale), -(0-4*scale));
    translate((0+7*scale), (0-5*scale), 0+4*scale);

    box(scale*6, scale*10, 5*scale);

    translate(-1*(0+7*scale), -1*(0-5*scale), -(0+4*scale));
  }
  rotateY(radians(-90));
  translate(-x, -y, -z);
}
