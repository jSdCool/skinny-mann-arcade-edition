import java.io.Serializable;
class Player implements Serializable {
  public float x, y, z=0, scale, animationCooldown, verticalVelocity=0;
  public int pose=1, stage=0;
  int shirt;
  boolean jumping=false, in3D;
  String name="";
  Player(float X, float Y, float Scale, int Color) {
    x=X;
    y=Y;
    scale=Scale;
    shirt=Color;
  }
  public Player setX(float X) {
    x=X;
    return this;
  }
  public Player setY(float Y) {
    y=Y;
    return this;
  }
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public Player setScale(float s) {
    scale=s;
    return this;
  }
  public float getScale() {
    return scale;
  }
  public Player setPose(int p) {
    pose=p;
    return this;
  }
  public int getPose() {
    return pose;
  }
  public Player setAnimationCooldown(float ac) {
    animationCooldown=ac;
    return this;
  }
  public float getAnimationCooldown() {
    return  animationCooldown;
  }
  public int getColor() {
    return shirt;
  }
  public String toString() {
    return "x "+x+" y "+y+" scale "+scale+" pose "+pose ;
  }
  public Player setJumping(boolean a) {
    jumping=a;
    return this;
  }
  public boolean isJumping() {
    return jumping;
  }
}
