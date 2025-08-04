import java.util.ArrayList;
/**Utility for doing collision checks in the AI calculations for entities
*/
public class StageEntityCollisionManager{
  
  //TODO: this needs to be changed to be more effishent, does it?
  /**Check if the given hitbox collides with any of the boxes from the stage
  @param hitbox The 2D hitbox of the thing preforimg the collision checks
  @param stageBoxes The collective hitboxes of the stage
  */
  public static boolean level_colide(Collider2D hitbox, ArrayList<Collider2D> stageBoxes){
    for (Collider2D stageBox:stageBoxes) {//loop over all the objects in the stage
      if (CollisionDetection.collide2D(hitbox, stageBox)) {//check if the objects collide
        return true;
      }
    }
    return false;
  }
  /**Check if the given hitbox collides with any of the boxes from the stage
  @param hitbox The 3D hitbox of the thing preforimg the collision checks
  @param stageBoxes The collective hitboxes of the stage
  */
  public static boolean level_colide(Collider3D hitbox, ArrayList<Collider3D> stageBoxes){
    for (Collider3D stageBox:stageBoxes) {//loop over all the objects in the stage
      if (CollisionDetection.collide3D(hitbox, stageBox)) {//check if the objects collide
        return true;
      }
    }
    return false;
  }
}
