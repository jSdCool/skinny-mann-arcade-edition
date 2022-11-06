import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Random extends LogicInputComponent {
  int variableNumber=0;
  Random(float x, float y, LogicBoard lb) {
    super(x, y, " random ", lb);
  }

  Random(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), " random ", lb, data.getJSONArray("connections"));
  }
  void tick() {
    outputTerminal=(int)(Math.random()*1000000%2)==1;
  }
}
