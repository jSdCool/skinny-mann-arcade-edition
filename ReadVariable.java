import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class ReadVariable extends LogicInputComponent {
  int variableNumber=0;
  ReadVariable(float x, float y, LogicBoard lb) {
    super(x, y, "read var", lb);
    button.setText("read var b"+variableNumber+"  ");
  }

  ReadVariable(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "read var", lb, data.getJSONArray("connections"));
    variableNumber=data.getInt("variable number");
    button.setText("read var b"+variableNumber+"  ");
  }
  void tick() {
    outputTerminal=source.level.variables.get(variableNumber);
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("variable number", variableNumber);
    return component;
  }
  void setData(int data) {
    variableNumber=data;
    button.setText("read var b"+variableNumber+"  ");
  }
  int getData() {
    return variableNumber;
  }
}
