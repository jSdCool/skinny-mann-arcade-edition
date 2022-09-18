import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SetVariable extends LogicOutputComponent {
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
  void tick() {
    if (inputTerminal2)
      source.level.variables.set(variableNumber, inputTerminal1);
  }
  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("data", x+5-source.camPos, y+16-source.camPosY);
    source.text("set", x+5-source.camPos, y+56-source.camPosY);
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
}
