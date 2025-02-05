import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

abstract class LogicOutputComponent extends LogicComponent {
  LogicOutputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
  }
  LogicOutputComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    super(x, y, type, board, cnects);
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
  }
  public LogicOutputComponent(SerialIterator iterator){
    super(iterator);
  }
  void draw() {
    button.x=(x-source.camPos)*source.Scale;
    button.y=(y-source.camPosY)*source.Scale;
    button.draw();
    source.fill(-26416);
    source.ellipse((x-2-source.camPos)*source.Scale, (y+20-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
    source.ellipse((x-2-source.camPos)*source.Scale, (y+60-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
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
