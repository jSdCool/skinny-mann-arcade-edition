import java.io.Serializable;
import processing.core.*;
class Player extends Entity implements Serializable {
  public float x, y, z=0, scale, animationCooldown, verticalVelocity=0;
  private final float arbitrayNumber=0.0023f;//slight adjustemnt to the hitboxes just to make shure all collisions are as accurate as posible
  public int pose=1, stage=0;
  public transient static skiny_mann source;
  int shirt;
  boolean jumping=false, in3D;
  String name="";
  Player(float X, float Y, float Scale, int Color) {
    x=X;
    y=Y;
    scale=Scale;
    shirt=Color;
  }
  public Entity setX(float X) {
    x=X;
    return this;
  }
  public Entity setY(float Y) {
    y=Y;
    return this;
  }
  public Entity setZ(float Z){
    z=Z;
    return this;
  }
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public float getZ(){
    return z;
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
  
  public MovementManager getMovementmanager(){
    if(source.players[source.currentPlayer] == this){
      return source.playerMovementManager;
    }
    return new NoMovementManager();
  }
  
  public Collider2D getHitBox2D(float offsetX, float offsetY){
    return new Collider2D(new PVector[]{
      new PVector(x+offsetX-15*scale+arbitrayNumber,y+offsetY-75*scale+arbitrayNumber),
      new PVector(x+offsetX+15*scale-arbitrayNumber,y+offsetY-75*scale+arbitrayNumber),
      new PVector(x+offsetX+15*scale-arbitrayNumber,y+offsetY-arbitrayNumber),
      new PVector(x+offsetX-15*scale+arbitrayNumber,y+offsetY-arbitrayNumber)
    });
  }
  public Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ){
    return new Collider3D(new PVector[]{
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber),
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber ,z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber , z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber)
    });
  }
  
  public boolean collidesWithEntites(){
    return false;
  }
  
  public float getVerticalVelocity(){
    return verticalVelocity;
  }
  public Entity setVerticalVelocity(float v){
    verticalVelocity = v;
    return this;
  }
  
  public boolean in3D(boolean playerIn3D){
    return in3D;
  }
  
  //mabby implment theese later
  public void draw(skiny_mann context){}
  public void draw3D(skiny_mann context){}
  public Entity create(float x,float y,float z){return null;}
}
