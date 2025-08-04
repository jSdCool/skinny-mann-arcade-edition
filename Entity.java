import processing.core.*;
/**The base for Entities that can have physics applied to them.<br>
NOTE: all further implmentations should be of the class StageEntity
*/
abstract public class Entity{
  /**Get this entities' specific movemnt manger.<br>
  Responcable for storing movement commands.
  @return The movement manager for this entity
  */
  public abstract MovementManager getMovementmanager();
  
  /**Get this entities' 2D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @return The 2D hitbox for this entity offset from the entities' position by the given ammount
  */
  public abstract Collider2D getHitBox2D(float offsetX, float offsetY);
  /**Get this entities' 3D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @param offsetZ How far to offset the returned box from the entities current position in the z axis
  @return The 3D hitbox for this entity offset from the entities' position by the given ammount
  */
  public abstract Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ);

  /**set the entities' x position
  @param x The new x position
  @return this
  */
  public abstract Entity setX(float x);
  /**set the entities' y position
  @param y The new y position
  @return this
  */
  public abstract Entity setY(float y);
  /**set the entities' z position
  @param z The new z position
  @return this
  */
  public abstract Entity setZ(float z);
  
  /**Get the current x position of the entity
  @return the current x position
  */
  public abstract float getX();
  /**Get the current y position of the entity
  @return the current y position
  */
  public abstract float getY();
  /**Get the current z position of the entity
  @return the current z position
  */
  public abstract float getZ();
  
  /**Gets the current vertical velocity of this entity
  @return the current vertical velocity
  */
  public abstract float getVerticalVelocity();
  /**Set the current vertical velocity of this entity
  @param v The new velocity
  @return this
  */
  public abstract Entity setVerticalVelocity(float v);
  
  /**Get wether or not this entity colides with outher entities
  @return true if this entity collides with other collideable entities
  */
  public abstract boolean collidesWithEntites();
  
  /**Get wether to render / process this entity in 3D mode
  @param playerIn3D wether the current player is in 3D mode
  @return true if thhis entity should be renderd in 3D
  */
  public abstract boolean in3D(boolean playerIn3D);

  /**Render the 2D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the render
  @param render The surface to draw to
  */
  public abstract void draw(skiny_mann context,PGraphics render);
  /**Render the 3D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the renders
  @param render The surface to draw to
  */
  public abstract void draw3D(skiny_mann context,PGraphics render);
}
