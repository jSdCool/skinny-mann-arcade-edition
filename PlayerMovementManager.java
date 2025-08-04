/**The class that represents the movement inputs of the player
*/
public class PlayerMovementManager extends MovementManager{
  
  public static final Identifier ID = new Identifier("PlayerMovementManager");
  
  /**Create a new player movemnt manager
  */
  public PlayerMovementManager(){}
  /**Recreate a player movement manager from serialized binarry data
  @param iterator The source of the binarry data
  */
  public PlayerMovementManager(SerialIterator iterator){}
  
  boolean left,right,in,out,jump;
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
   /**Get wether this entity is attemping to jump(-y)
  @return true if this entity is jumping
  */
   public boolean jump(){
     return jump;
   }
   /**Stop all current movment attempts for this entity
  */
   public void reset(){
     left=false;
     right=false;
     in=false;
     out=false;
     jump=false;
   }
   /**Set if the player is moving left
   @param l If the player is moving left
   */
   public void setLeft(boolean l){
     left=l;
   }
   /**Set if the player is moving right
   @param r If the player is moving right
   */
   public void setRight(boolean r){
     right=r;
   }
   /**Set if the player is moving in
   @param i If the player is moving in
   */
   public void setIn(boolean i){
     in=i;
   }
   /**Set if the player is moving out
   @param o If the player is moving out
   */
   public void setOut(boolean o){
     out=o;
   }
   /**Set if the player is currently jumping
   @param j If the player is currently jumping
   */
   public void setJump(boolean j){
     jump=j;
   }
  
  /**Convert this object to a byte representation that can be sent over the network or saved to a file.<br>
  @return This object as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    return new SerializedData(id());
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
