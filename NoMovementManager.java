/**a movement manager for an entity that can not move on its own. ex: any player that is not the one currently being played as
 */
class NoMovementManager extends MovementManager {

  public static final Identifier ID = new Identifier("NoMovementManager");

  public NoMovementManager() {
  }

  public NoMovementManager(SerialIterator iterator) {
  }

  boolean left() {
    return false;
  }
  boolean right() {
    return false;
  }
  boolean in() {
    return false;
  }
  boolean out() {
    return false;
  }
  boolean jump() {
    return false;
  }
  void reset() {
  };

  @Override
    public SerializedData serialize() {
    return new SerializedData(id());
  }

  @Override
    public Identifier id() {
    return ID;
  }
}
