import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SetZOffset extends LogicOutputComponent {
  
  public static final Identifier ID = new Identifier("SetZOffset");
  
  int groupNumber=0;
  float offset=0;
  SetZOffset(float x, float y, LogicBoard lb) {
    super(x, y, "z-offset", lb);
    button.setText("z-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }

  SetZOffset(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "z-offset", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    offset=data.getFloat("offset");
    button.setText("z-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  
  public SetZOffset(SerialIterator iterator){
    super(iterator);
    groupNumber = iterator.getInt();
    offset = iterator.getFloat();
  }
  
  void tick() {
    if (inputTerminal1) {
      source.level.groups.get(groupNumber).zOffset=offset;
    }
    if (inputTerminal2) {
      source.level.groups.get(groupNumber).zOffset=0;
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    component.setFloat("offset", offset);
    return component;
  }
  void setData(int data) {
    groupNumber=data;
    button.setText("z-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("set", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("reset", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  void setOffset(float of) {
    offset=of;
    button.setText("z-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  float getOffset() {
    return offset;
  }
  
  //SerialIterator iterator
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(groupNumber);
    data.addFloat(offset);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
