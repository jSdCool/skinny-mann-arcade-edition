//LogicInputComponent
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

abstract class LogicInputComponent extends LogicComponent {
  LogicInputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(source, x, y, 100, 40, "  "+type+"  ");
  }
  LogicInputComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    super(x, y, type, board, cnects);
    button=new Button(source, x, y, 100, 40, "  "+type+"  ");
  }
  void draw() {
    button.x=x-source.camPos;
    button.y=y-source.camPosY;
    button.draw();
    source.fill(-369706);
    source.ellipse(x+102-source.camPos, y+20-source.camPosY, 20, 20);
  }
  float[] getTerminalPos(int t) {
    if (t==2) {
      return new float[]{x+102-source.camPos, y+20-source.camPosY};
    }
    return new float[]{-1000, -1000};
  }
}
