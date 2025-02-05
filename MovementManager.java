
abstract class MovementManager implements Serialization {
  abstract boolean left();
  abstract boolean right();
  abstract boolean in();
  abstract boolean out();
  abstract boolean jump();
  abstract void reset();
}
