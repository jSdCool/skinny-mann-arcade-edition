import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Read3DMode extends LogicInputComponent {
  int variableNumber=0;
  Read3DMode(float x, float y, LogicBoard lb) {
    super(x, y, "read 3D ", lb);
  }

  Read3DMode(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "read 3D ", lb, data.getJSONArray("connections"));
  }
  void tick() {
    if (source.level.multyplayerMode!=2)
      outputTerminal=source.e3DMode;
    else
      outputTerminal=false;
  }
}
