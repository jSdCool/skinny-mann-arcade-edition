//XorGate
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class XorGate extends LogicComponent {
  XorGate(float x, float y, LogicBoard lb) {
    super(x, y, "XOR", lb);
  }

  XorGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "XOR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=inputTerminal1!=inputTerminal2;
  }
}
