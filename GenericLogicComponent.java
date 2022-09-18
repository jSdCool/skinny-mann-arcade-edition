import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

//GenericLogicComponent

class GenericLogicComponent extends LogicComponent {
  GenericLogicComponent(float x, float y, LogicBoard lb) {
    super(x, y, "generic", lb);
  }
  GenericLogicComponent(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "generic", lb, data.getJSONArray("connections"));
  }

  void tick() {
  }
}
