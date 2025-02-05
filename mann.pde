void draw_mann(float x, float y, int pose, float scale, int shirt_color,PGraphics render) {
  render.strokeWeight(0);
  if (shirt_color==0) {//red
    render.fill(255, 0, 0);
    render.stroke(255, 0, 0);
  }
  if (shirt_color==1) {//green
    render.fill(0, 181, 0);
    render.stroke(0, 181, 0);
  }
  if (shirt_color==2) {//blue
    render.fill(0, 29, 255);
    render.stroke(0, 29, 255);
  }
  if (shirt_color==3) {//yellow
    render.fill(255, 226, 0);
    render.stroke(255, 226, 0);
  }
  if (shirt_color==4) {//magenta
    render.fill(232, 0, 221);
    render.stroke(232, 0, 221);
  }
  if (shirt_color==5) {//mint
    render.fill(0, 232, 121);
    render.stroke(0, 232, 121);
  }
  if (shirt_color==6) {//orange
    render.fill(252, 156, 0);
    render.stroke(252, 156, 0);
  }
  if (shirt_color==7) {//pink
    render.fill(255, 149, 153);
    render.stroke(255, 149, 153);
  }
  if (shirt_color==8) {//maroon
    render.fill(64, 12, 12);
    render.stroke(64, 12, 12);
  }
  if (shirt_color==9) {//purple
    render.fill(139, 0, 255);
    render.stroke(139, 0, 255);
  }

  if (pose==1) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-10*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-10*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==2) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-12*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+6*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-14*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+8*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==3) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-13*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+7*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-18*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+12*scale, y-10*scale, scale*6, scale*10);
  }
  if (pose==4) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-12*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+6*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-16*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+10*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-19*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+15*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==5) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-13*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+7*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-18*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+12*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==6) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-12*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+6*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-14*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+8*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==7) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-10*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-10*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==8) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-8*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+2*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-6*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+1*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==9) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-7*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+1*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-2*scale, y-10*scale, scale*6, scale*10);
    render.rect(x-4*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==10) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-8*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+2*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-4*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-4*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+2*scale, y-10*scale, scale*6, scale*10);
    render.rect(x-7*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==11) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-7*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+1*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-2*scale, y-10*scale, scale*6, scale*10);
    render.rect(x-4*scale, y-10*scale, scale*6, scale*10);
  }

  if (pose==12) {
    render.rect(x-10*scale, y-55*scale, scale*20, scale*25);
    render.fill(-17813);
    render.stroke(-17813);
    render.rect(x-15*scale, y-75*scale, scale*30, scale*20);
    render.fill(-16763137);
    render.stroke(-16763137);
    render.rect(x-10*scale, y-30*scale, scale*6, scale*10);
    render.rect(x+4*scale, y-30*scale, scale*6, scale*10);
    render.rect(x-8*scale, y-20*scale, scale*6, scale*10);
    render.rect(x+2*scale, y-20*scale, scale*6, scale*10);
    render.rect(x-6*scale, y-10*scale, scale*6, scale*10);
    render.rect(x+1*scale, y-10*scale, scale*6, scale*10);
  }
}

void draw_mann_3D(float x, float y, float z, int pose, float scale, int shirt_color,PGraphics render) {
  render.translate(x, y, z);
  render.rotateY(radians(90));
  render.strokeWeight(0);
  if (shirt_color==0) {//red
    render.fill(255, 0, 0);
    render.stroke(255, 0, 0);
  }
  if (shirt_color==1) {//green
    render.fill(0, 181, 0);
    render.stroke(0, 181, 0);
  }
  if (shirt_color==2) {//blue
    render.fill(0, 29, 255);
    render.stroke(0, 29, 255);
  }
  if (shirt_color==3) {//yellow
    render.fill(255, 226, 0);
    render.stroke(255, 226, 0);
  }
  if (shirt_color==4) {//magenta
    render.fill(232, 0, 221);
    render.stroke(232, 0, 221);
  }
  if (shirt_color==5) {//mint
    render.fill(0, 232, 121);
    render.stroke(0, 232, 121);
  }
  if (shirt_color==6) {//orange
    render.fill(252, 156, 0);
    render.stroke(252, 156, 0);
  }
  if (shirt_color==7) {//pink
    render.fill(255, 149, 153);
    render.stroke(255, 149, 153);
  }
  if (shirt_color==8) {//maroon
    render.fill(64, 12, 12);
    render.stroke(64, 12, 12);
  }
  if (shirt_color==9) {//purple
    render.fill(139, 0, 255);
    render.stroke(139, 0, 255);
  }

  render.translate(0, -42.5*scale, 0);
  render.box(scale*20, scale*25, 10*scale);
  render.translate(0, 0-42.5*scale*-1, 0);
  render.fill(-17813);
  render.stroke(-17813);
  render.translate( 0, 0-65*scale, 0);

  render.box(scale*30, scale*20, 20*scale);

  render.translate(- 0, (0-65*scale)*-1, -0);

  if (pose==1) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -0);
    render.translate((0+7*scale), (0-15*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -0);
    render.translate(0-7*scale, 0-5*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -0);
    render.translate((0+7*scale), (0-5*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -0);
  }

  if (pose==2) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0+2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0+2*scale));
    render.translate((0+7*scale), (0-15*scale), 0-2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0-2*scale));
    render.translate(0-7*scale, 0-5*scale, 0+4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0+4*scale));
    render.translate((0+7*scale), (0-5*scale), 0-4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0-4*scale));
  }

  if (pose==3) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0+3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0+3*scale));
    render.translate((0+7*scale), (0-15*scale), 0-3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0-3*scale));
    render.translate(0-7*scale, 0-5*scale, 0+7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0+7*scale));
    render.translate((0+7*scale), (0-5*scale), 0-7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0-7*scale));
  }
  if (pose==4) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0+5*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0+5*scale));
    render.translate((0+7*scale), (0-15*scale), 0-5*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0-5*scale));
    render.translate(0-7*scale, 0-5*scale, 0+10*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0+10*scale));
    render.translate((0+7*scale), (0-5*scale), 0-10*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0-10*scale));
  }

  if (pose==5) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0+3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0+3*scale));
    render.translate((0+7*scale), (0-15*scale), 0-3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0-3*scale));
    render.translate(0-7*scale, 0-5*scale, 0+7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0+7*scale));
    render.translate((0+7*scale), (0-5*scale), 0-7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0-7*scale));
  }

  if (pose==6) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0+2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0+2*scale));
    render.translate((0+7*scale), (0-15*scale), 0-2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0-2*scale));
    render.translate(0-7*scale, 0-5*scale, 0+4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0+4*scale));
    render.translate((0+7*scale), (0-5*scale), 0-4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0-4*scale));
  }

  if (pose==7) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -0);
    render.translate((0+7*scale), (0-15*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -0);
    render.translate(0-7*scale, 0-5*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -0);
    render.translate((0+7*scale), (0-5*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -0);
  }

  if (pose==8) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0-2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0-2*scale));
    render.translate((0+7*scale), (0-15*scale), 0+2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0+2*scale));
    render.translate(0-7*scale, 0-5*scale, 0-4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0-4*scale));
    render.translate((0+7*scale), (0-5*scale), 0+4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0+4*scale));
  }

  if (pose==9) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0-3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0-3*scale));
    render.translate((0+7*scale), (0-15*scale), 0+3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0+3*scale));
    render.translate(0-7*scale, 0-5*scale, 00-7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0-7*scale));
    render.translate((0+7*scale), (0-5*scale), 0+7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0+7*scale));
  }

  if (pose==10) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0-5*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0-5*scale));
    render.translate((0+7*scale), (0-15*scale), 0+5*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0+5*scale));
    render.translate(0-7*scale, 0-5*scale, 0-10*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0-10*scale));
    render.translate((0+7*scale), (0-5*scale), 0+10*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0+10*scale));
  }

  if (pose==11) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0-3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0-3*scale));
    render.translate((0+7*scale), (0-15*scale), 0+3*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0+3*scale));
    render.translate(0-7*scale, 0-5*scale, 0-7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0-7*scale));
    render.translate((0+7*scale), (0-5*scale), 0+7*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0+7*scale));
  }

  if (pose==12) {
    render.fill(-16763137);
    render.stroke(-16763137);
    render.translate(0-7*scale, 0-25*scale, 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-25*scale), -0);
    render.translate((0+7*scale), (0-25*scale), 0);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-25*scale), -0);
    render.translate(0-7*scale, 0-15*scale, 0-2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-15*scale), -(0-2*scale));
    render.translate((0+7*scale), (0-15*scale), 0+2*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-15*scale), -(0+2*scale));
    render.translate(0-7*scale, 0-5*scale, 0-4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0-7*scale), -1*(0-5*scale), -(0-4*scale));
    render.translate((0+7*scale), (0-5*scale), 0+4*scale);

    render.box(scale*6, scale*10, 5*scale);

    render.translate(-1*(0+7*scale), -1*(0-5*scale), -(0+4*scale));
  }
  render.rotateY(radians(-90));
  render.translate(-x, -y, -z);
}
