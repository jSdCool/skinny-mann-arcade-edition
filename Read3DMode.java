import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Read3DMode extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("Read3DMode");
  
  Read3DMode(float x, float y, LogicBoard lb) {
    super(x, y, "read 3D ", lb);
  }

  Read3DMode(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "read 3D ", lb, data.getJSONArray("connections"));
  }
  
  public Read3DMode(SerialIterator iterator){
    super(iterator);
  }
  
  void tick() {
    if (source.level.multyplayerMode!=2)
      outputTerminal=source.e3DMode;
    else
      outputTerminal=false;
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
