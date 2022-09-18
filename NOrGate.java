//NOrGate
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class NOrGate extends LogicComponent {
  NOrGate(float x, float y, LogicBoard lb) {
    super(x, y, "NOR", lb);
  }
  NOrGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "NOR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=!(inputTerminal1||inputTerminal2);
  }
}
