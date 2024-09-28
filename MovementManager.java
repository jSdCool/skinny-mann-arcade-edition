import java.io.Serializable;
abstract class MovementManager implements Serializable{
  abstract boolean left();
  abstract boolean right();
  abstract boolean in();
  abstract boolean out();
  abstract boolean jump();
  abstract void reset();
}
