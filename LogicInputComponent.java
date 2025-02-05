//LogicInputComponent
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

abstract class LogicInputComponent extends LogicComponent {
  LogicInputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(source, x, y, 100*source.Scale, 40*source.Scale, "  "+type+"  ");
  }
  LogicInputComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    super(x, y, type, board, cnects);
    button=new Button(source, x, y, 100*source.Scale, 40*source.Scale, "  "+type+"  ");
  }
  public LogicInputComponent(SerialIterator iterator){
    super(iterator);
  }
  void draw() {
    button.x=(x-source.camPos)*source.Scale;
    button.y=(y-source.camPosY)*source.Scale;
    button.draw();
    source.fill(-369706);
    source.ellipse((x+102-source.camPos)*source.Scale, (y+20-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
  }
  float[] getTerminalPos(int t) {
    if (t==2) {
      return new float[]{x+102-source.camPos, y+20-source.camPosY};
    }
    return new float[]{-1000, -1000};
  }
}
