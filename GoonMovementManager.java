import java.util.ArrayList;
/**The movement manager / AI for the goon enemy
*/
public class GoonMovementManager extends MovementManager{
  
  public static final Identifier ID = new Identifier("goonMovementManager");
  
  /**Create a new movement manager for a goon
  @param goon The goon this movement manager is controlling
  */
  public GoonMovementManager(Goon goon){
    this.goon=goon;
  }
  
  /**This should not exsist, but it is here for completeness
  */
  public GoonMovementManager(SerialIterator iterator){
    
  }
  
  Goon goon;
  
  boolean left,right,jump,in,out;
  
  /** Get wether this entity should be moving left(-x)
  @return true if this entity is moving left
  */
  public boolean left(){
    return left;
  }
  /**Get wether this entity is moving right(+x)
  @return true if this entity is moving right
  */
  public boolean right(){
    return right;
  }
  /**Get wether this entity is attemping to jump(-y)
  @return true if this entity is jumping
  */
  public boolean jump(){
    return jump;
  }
  /**Get wether this entity is moving in (-z)
  @return true if this entity is moving in
  */
  public boolean in(){
    return in;
  }
  /**Get wether this entity is moving out (+z)
  @return true if this entity is moving out
  */
  public boolean out(){
    return out;
  }
  
  /**Stop all current movment attempts for this entity
  */
  public void reset(){
    left=false;
    right=false;
    jump=false;
    in=false;
    out=false;
  }
  
  /**Recalculate this entities movments (its AI)
  @param stage The collision for the stage this entity is in
  */
  public void recalculateMovements(ArrayList<Collider2D> stage){
    if(!goon.isDead()){
      if(!goon.in3D){
        if(right){
          //if there is a wall in fron the the entity
          if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(2,0),stage)){
            //and there is sill a wall 9 units up
            if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(2,-6),stage)){
              right=false;
              left=true;
              return;
            }
          }
          //if there is a clif in front of the entity
          if(!StageEntityCollisionManager.level_colide(goon.getHitBox2D(2,11),stage)){
            right=false;
            left=true;
            return;
          }
        }else if(left){
          //if there is a wall in fron the the entity
          if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(-2,0),stage)){
            //and there is sill a wall 9 units up
            if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(-2,-6),stage)){
              right=true;
              left=false;
              return;
            }
          }
          //if there is a clif in front of the entity
          if(!StageEntityCollisionManager.level_colide(goon.getHitBox2D(-2,11),stage)){
            right=true;
            left=false;
            return;
          }
        }else{
          right=true;
        }
      }
    }
  }
  
  /**Convert this object to a byte representation that can be sent over the network or saved to a file.<br>
  @return This object as a binarry representation
  */
  public SerializedData serialize(){
    SerializedData data = new SerializedData(id());
    
    return data;
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  public Identifier id(){
    return ID;
  }
  
}
