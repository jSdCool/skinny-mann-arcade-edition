import java.util.ArrayList;
import processing.data.*;
/**The base for all Entities that can be placed in a stage.<br>
*/
public abstract class StageEntity extends Entity implements Killable,Serialization{
  /**Get a JSONObject representation of this entity that can be saved to a file
  @return JSONObject representation of this object
  */
  public abstract JSONObject save();
  
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
  @param dt The number of milliseconds Since the last update
  @param stageHitBoxes The hitboxes of the stage this entity is in
  */
  public abstract void update(float dt,ArrayList<Collider2D> stageHitBoxes);
  
}
