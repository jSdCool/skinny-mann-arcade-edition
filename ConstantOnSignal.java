import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class ConstantOnSignal extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("ConstantOnSignal");
  
  ConstantOnSignal(float x, float y, LogicBoard lb) {
    super(x, y, "ON", lb);
    outputTerminal=true;
  }

  ConstantOnSignal(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "ON", lb, data.getJSONArray("connections"));
    outputTerminal=true;
  }
  
  public ConstantOnSignal(SerialIterator iterator){
    super(iterator);
  }
  
  void tick() {
    outputTerminal=true;
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
