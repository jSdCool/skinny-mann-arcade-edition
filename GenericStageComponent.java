import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class GenericStageComponent extends StageComponent {
  StageComponent copy() {
    return this;
  }
  JSONObject save(boolean e) {
    return null;
  }
}
