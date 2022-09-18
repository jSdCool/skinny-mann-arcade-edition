import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

abstract class LogicOutputComponent extends LogicComponent {
  LogicOutputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(source, x, y, 100, 80, "  "+type+"  ");
  }
  LogicOutputComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    super(x, y, type, board, cnects);
    button=new Button(source, x, y, 100, 80, "  "+type+"  ");
  }
  void draw() {
    button.x=x-source.camPos;
    button.y=y-source.camPosY;
    button.draw();
    source.fill(-26416);
    source.ellipse(x-2-source.camPos, y+20-source.camPosY, 20, 20);
    source.ellipse(x-2-source.camPos, y+60-source.camPosY, 20, 20);
  }
  float[] getTerminalPos(int t) {
    if (t==0) {
      return new float[]{x-2-source.camPos, y+20-source.camPosY};
    }
    if (t==1) {
      return new float[]{x-2-source.camPos, y+60-source.camPosY};
    }
    return new float[]{-1000, -1000};
  }
}
