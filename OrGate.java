//OrGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class OrGate extends LogicComponent {
  
  public static final Identifier ID = new Identifier("OrGate");
  
  OrGate(float x, float y, LogicBoard lb) {
    super(x, y, "OR", lb);
  }
  OrGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "OR", lb, data.getJSONArray("connections"));
  }
  
  public OrGate(SerialIterator iterator){
    super(iterator);
  }

  void tick() {
    outputTerminal=inputTerminal1||inputTerminal2;
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
