import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SetVisibility extends LogicOutputComponent {
  
  public static final Identifier ID = new Identifier("SetVisability");
  
  int groupNumber=0;
  SetVisibility(float x, float y, LogicBoard lb) {
    super(x, y, "set visable", lb);
    button.setText("  visibility of "+source.level.groupNames.get(groupNumber));
  }

  SetVisibility(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "set visable", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    button.setText("  visibility of "+level.groupNames.get(groupNumber));
  }
  
  public SetVisibility(SerialIterator iterator){
    super(iterator);
    groupNumber = iterator.getInt();
  }
  
  void tick() {
    if (inputTerminal1) {
      source.level.groups.get(groupNumber).visable=true;
    }
    if (inputTerminal2) {
      source.level.groups.get(groupNumber).visable=false;
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    return component;
  }
  void setData(int data) {
    groupNumber=data;
    button.setText("  visibility of "+source.level.groupNames.get(groupNumber));
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("true", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("false", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(groupNumber);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
