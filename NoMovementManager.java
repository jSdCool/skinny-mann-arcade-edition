/**A movement manager for an entity that can not move on its own, and should not have physics calculated on it. ex: any player that is not the one currently being played as
 */
public class NoMovementManager extends MovementManager {

  public static final Identifier ID = new Identifier("NoMovementManager");
  
  public static final NoMovementManager noMovement = new NoMovementManager();//a static refrence to an instance of this class in case anyone wants it

  /**Create a new no movement manager
  */
  public NoMovementManager() {}

  /**Create a new no movement manager from serilized binarry data
  @param iterator The source of the data
  */
  public NoMovementManager(SerialIterator iterator) {}
  /** Get wether this entity should be moving left(-x)
  @return true if this entity is moving left
  */
  public boolean left() {
    return false;
  }
  /**Get wether this entity is moving right(+x)
  @return false
  */
  public boolean right() {
    return false;
  }
  /**Get wether this entity is moving in (-z)
  @return false
  */
  public boolean in() {
    return false;
  }
  /**Get wether this entity is moving out (+z)
  @return false
  */
  public boolean out() {
    return false;
  }
  /**Get wether this entity is attemping to jump(-y)
  @return false
  */
  public boolean jump() {
    return false;
  }
  /**Stop all current movment attempts for this entity
  */
  public void reset() {
  };
  
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
