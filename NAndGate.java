//NAndGate
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class NAndGate extends LogicComponent {
  NAndGate(float x, float y, LogicBoard lb) {
    super(x, y, "NAND", lb);
  }

  NAndGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "NAND", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=!(inputTerminal1&&inputTerminal2);
  }
}
