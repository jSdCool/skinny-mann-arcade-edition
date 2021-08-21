class Player{
 public float x,y,z=0,scale,timeInAir=0,jumpDist=0,animationCooldown;
 int pose=1;
 String shirt;
 boolean jumping=false;
 Player(float X,float Y,float Scale,String Color){
  x=X;
  y=Y;
  scale=Scale;
  shirt=Color;
 }
 public Player setX(float X){
  x=X;
   return this;
 }
 public Player setY(float Y){
  y=Y;
   return this;
 }
 public float getX(){
  return x; 
 }
 public float getY(){
  return y; 
 }
 public Player setScale(float s){
  scale=s;
  return this;
 }
 public float getScale(){
  return scale; 
 }
 public Player setPose(int p){
  pose=p;
   return this;
 }
 public int getPose(){
  return pose; 
 }
 public Player setAnimationCooldown(float ac){
   animationCooldown=ac;
   return this; 
 }
 public float getAnimationCooldown(){
  return  animationCooldown;
 }
 public String getColor(){
  return shirt; 
 }
 public String toString(){
 return "x "+x+" y "+y+" scale "+scale+" pose "+pose ;
}
public Player setAirTime(float at){
 timeInAir=at;
  return this;
}
public Float getAirTime(){
 return timeInAir; 
}
public Player setJumping(boolean a){
  jumping=a;
  return this;
}
public boolean isJumping(){
  return jumping;
}
  
}
