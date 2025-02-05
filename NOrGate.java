//NOrGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class NOrGate extends LogicComponent {
  
  public static final Identifier ID = new Identifier("NorGate");
  
  NOrGate(float x, float y, LogicBoard lb) {
    super(x, y, "NOR", lb);
  }
  NOrGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "NOR", lb, data.getJSONArray("connections"));
  }
  
  public NOrGate(SerialIterator iterator){
    super(iterator);
  }

  void tick() {
    outputTerminal=!(inputTerminal1||inputTerminal2);
  }
  
  //
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
