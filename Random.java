import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Random extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("Random");
  
  int variableNumber=0;
  Random(float x, float y, LogicBoard lb) {
    super(x, y, " random ", lb);
  }

  Random(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), " random ", lb, data.getJSONArray("connections"));
  }
  
  public Random(SerialIterator iterator){
    super(iterator);
    variableNumber = iterator.getInt();
  }
  
  void tick() {
    outputTerminal=(int)(Math.random()*1000000%2)==1;
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(variableNumber);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
