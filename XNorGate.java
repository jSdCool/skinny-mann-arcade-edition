//XNorGate
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class XNorGate extends LogicComponent {
  XNorGate(float x, float y, LogicBoard lb) {
    super(x, y, "XNOR", lb);
  }

  XNorGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "XNOR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=!(inputTerminal1!=inputTerminal2);
  }
}
