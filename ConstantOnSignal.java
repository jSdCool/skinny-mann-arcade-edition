import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class ConstantOnSignal extends LogicInputComponent {
  ConstantOnSignal(float x, float y, LogicBoard lb) {
    super(x, y, "ON", lb);
    outputTerminal=true;
  }

  ConstantOnSignal(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "ON", lb, data.getJSONArray("connections"));
    outputTerminal=true;
  }
  void tick() {
    outputTerminal=true;
  }
}
