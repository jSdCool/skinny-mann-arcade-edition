//OrGate
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class OrGate extends LogicComponent {
  OrGate(float x, float y, LogicBoard lb) {
    super(x, y, "OR", lb);
  }
  OrGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "OR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=inputTerminal1||inputTerminal2;
  }
}
