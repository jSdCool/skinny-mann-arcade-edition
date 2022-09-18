import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SetXOffset extends LogicOutputComponent {
  int groupNumber=0;
  float offset=0;
  SetXOffset(float x, float y, LogicBoard lb) {
    super(x, y, "x-offset", lb);
    button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }

  SetXOffset(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "x-offset", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    offset=data.getFloat("offset");
    button.setText("x-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  void tick() {
    if (inputTerminal1) {
      source.level.groups.get(groupNumber).xOffset=offset;
    }
    if (inputTerminal2) {
      source.level.groups.get(groupNumber).xOffset=0;
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
    button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("set", x+5-source.camPos, y+16-source.camPosY);
    source.text("reset", x+5-source.camPos, y+56-source.camPosY);
  }
  void setOffset(float of) {
    offset=of;
    button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  float getOffset() {
    return offset;
  }
}
