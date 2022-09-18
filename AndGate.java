//AndGate
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class AndGate extends LogicComponent {
  AndGate(float x, float y, LogicBoard lb) {
    super(x, y, "AND", lb);
  }

  AndGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "AND", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=inputTerminal1&&inputTerminal2;
  }
}
