//NAndGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class NAndGate extends LogicComponent {
  
  public static final Identifier ID = new Identifier("NandGate");
  
  NAndGate(float x, float y, LogicBoard lb) {
    super(x, y, "NAND", lb);
  }

  NAndGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "NAND", lb, data.getJSONArray("connections"));
  }
  
  public NAndGate(SerialIterator iterator){
    super(iterator);
  }

  void tick() {
    outputTerminal=!(inputTerminal1&&inputTerminal2);
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
