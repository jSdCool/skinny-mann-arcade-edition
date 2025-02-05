//AndGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class AndGate extends LogicComponent {
  public static final Identifier ID = new Identifier("AndGate");
  
  AndGate(float x, float y, LogicBoard lb) {
    super(x, y, "AND", lb);
  }

  AndGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "AND", lb, data.getJSONArray("connections"));
  }
  
  public AndGate(SerialIterator iterator){
    super(iterator);
  }

  void tick() {
    outputTerminal=inputTerminal1&&inputTerminal2;
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
