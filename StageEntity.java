import java.util.ArrayList;
import processing.data.*;
/**The base for all Entities that can be placed in a stage.<br>
*/
public abstract class StageEntity extends Entity implements Killable,Serialization{
  
  
  /**Create a new entity from a placement context
  @param context The context for the placement
  */
  public StageEntity(StageEntityPlacementContext context){
    x = context.getX();
    y = context.getY();
    z = context.getZ();
    respawnX = context.getX();
    respawnY = context.getY();
    respawnZ = context.getZ();
  }
  
  /**Load an entity from saved json data
  @param json The saved JSON data
  */
  public StageEntity(JSONObject json){
    x = json.getFloat("x");
    y = json.getFloat("y");
    z = json.getFloat("z");
    respawnX = x;
    respawnY = y;
    respawnZ = z;
  }
  
  /**Recreate an entity from serialized binarry data
  @param iterator The source of the binarry data
  */
  public StageEntity(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    respawnX = iterator.getFloat();
    respawnY = iterator.getFloat();
    respawnZ = iterator.getFloat();
    verticalVelocity = iterator.getFloat();
  }
  
  /**Get a JSONObject representation of this entity that can be saved to a file.<br>Should call saveInternal first
  @return JSONObject representation of this object
  */
  public abstract JSONObject save();
  
  /**Save the basic common entity data and entity type
  @return JSONObject that contains the basic position and type data for this entity
  */
  public JSONObject saveInternal(){
    JSONObject data = new JSONObject();
    data.setFloat("x",respawnX);
    data.setFloat("y",respawnY);
    data.setFloat("z",respawnZ);
    data.setString("type",id().toString());
    return data;
  }
  
  /**Get the result of the player interacting with this entity in 2D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public abstract PlayerIniteractionResult playerInteraction(Collider2D playerHitBox);
  /**Get the result of the player interacting with this entity in 3D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public abstract PlayerIniteractionResult playerInteraction(Collider3D playerHitBox);
  /**Process an entity AI update
  @param context Relivant context the AI of this entitiy can use to make decisions
  */
  public abstract void update(EntityAgentContext context);
  
  //the x position of this entity
  float x;
  //the y position of this entity
  float y;
  //the z position of this entity
  float z;
  //the vertical veclicty of this entity
  float verticalVelocity = 0;
  //the x position to respawn the entity at
  float respawnX;
  //the y position to respawn the entity at
  float respawnY;
  //the z position to respawn the entity at
  float respawnZ;
  
  /**set the entities' x position
  @param x The new x position
  @return this
  */
  public Entity setX(float x){
    this.x=x;
    return this;
  }
  /**set the entities' y position
  @param y The new y position
  @return this
  */
  public Entity setY(float y){
    this.y=y;
    return this;
  }
  /**set the entities' z position
  @param z The new z position
  @return this
  */
  public Entity setZ(float z){
    this.z=z;
    return this;
  }
  
  /**Get the current x position of the entity
  @return the current x position
  */
  public float getX(){
    return x;
  }
  /**Get the current y position of the entity
  @return the current y position
  */
  public float getY(){
    return y;
  }
  /**Get the current z position of the entity
  @return the current z position
  */
  public float getZ(){
    return z;
  }
  
  /**Gets the current vertical velocity of this entity
  @return the current vertical velocity
  */
  public float getVerticalVelocity(){
    return verticalVelocity;
  }
  /**Set the current vertical velocity of this entity
  @param v The new velocity
  @return this
  */
  public Entity setVerticalVelocity(float v){
    verticalVelocity = v;
    return this;
  }
  
  /**Get wether or not this entity colides with outher entities
  @return true if this entity collides with other collideable entities
  */
  public boolean collidesWithEntites(){
    return false;
  }
  
  /**The common entity data that needs to be serialized.<br>Call this first in your serialize function
  @return Serialized data respreseing the basic information from an entity
  */
  public SerializedData serializeInternal() {
    SerializedData data = new SerializedData(id());
    data.addFloat(x);
    data.addFloat(y);
    data.addFloat(z);
    data.addFloat(respawnX);
    data.addFloat(respawnY);
    data.addFloat(respawnZ);
    data.addFloat(verticalVelocity);
    return data;
  }
}
