import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SetVariable extends LogicOutputComponent {
  
  public static final Identifier ID = new Identifier("SetVariable");
  
  int variableNumber=0;
  SetVariable(float x, float y, LogicBoard lb) {
    super(x, y, "set var", lb);
    button.setText("  set var b"+variableNumber);
  }

  SetVariable(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "set var", lb, data.getJSONArray("connections"));
    variableNumber=data.getInt("variable number");
    button.setText("  set var b"+variableNumber);
  }
  
  public SetVariable(SerialIterator iterator){
    super(iterator);
    variableNumber = iterator.getInt();
  }
  
  void tick() {
    if (inputTerminal2)
      source.level.variables.set(variableNumber, inputTerminal1);
  }
  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("data", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("set", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("variable number", variableNumber);
    return component;
  }
  void setData(int data) {
    variableNumber=data;
    button.setText("  set var b"+variableNumber);
  }
  int getData() {
    return variableNumber;
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
