import processing.core.*;
abstract class Entity{
  //entity specific movemnt manger. responcable for storing movement commands
  public abstract MovementManager getMovementmanager();
  
  //entiy hitboxes for 2D and 3D. offset from the players position but the specified ammount
  public abstract Collider2D getHitBox2D(float offsetX, float offsetY);
  public abstract Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ);

  //get and set the position of the entity
  public abstract Entity setX(float x);
  public abstract Entity setY(float y);
  public abstract Entity setZ(float z);
  
  public abstract float getX();
  public abstract float getY();
  public abstract float getZ();
  
  //velocity
  public abstract float getVerticalVelocity();
  public abstract Entity setVerticalVelocity(float v);
  
  //wether or not this entity colides with outher entityes 
  public abstract boolean collidesWithEntites();
  
  public abstract boolean in3D(boolean playerIn3D);

  //rener methods
  public abstract void draw(skiny_mann context,PGraphics render);
  public abstract void draw3D(skiny_mann context,PGraphics render);
  
  //factory methhod
  public abstract Entity create(float x,float y,float z);
}
