/**This class is the base class used to controll the movent/inputs of entities<br>
I might remove the implmentation of Serialization later. seems unnessarry
*/
public abstract class MovementManager implements Serialization {
  /** Get wether this entity should be moving left(-x)
  @return true if this entity is moving left
  */
  public abstract boolean left();
  /**Get wether this entity is moving right(+x)
  @return true if this entity is moving right
  */
  public abstract boolean right();
  /**Get wether this entity is moving in (-z)
  @return true if this entity is moving in
  */
  public abstract boolean in();
  /**Get wether this entity is moving out (+z)
  @return true if this entity is moving out
  */
  public abstract boolean out();
  /**Get wether this entity is attemping to jump(-y)
  @return true if this entity is jumping
  */
  public abstract boolean jump();
  /**Stop all current movment attempts for this entity
  */
  public abstract void reset();
}
