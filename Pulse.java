//Pulse
import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Pulse extends LogicComponent {
  boolean prevousState=false;
  Pulse(float x, float y, LogicBoard lb) {
    super(x, y, "pulse", lb);
  }

  Pulse(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "pulse", lb, data.getJSONArray("connections"));
  }

  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("input", x+5-source.camPos, y+16-source.camPosY);
    source.text("invert", x+5-source.camPos, y+56-source.camPosY);
  }

  void tick() {
    if (inputTerminal2) {//invert terminal
      outputTerminal=!(inputTerminal1 && !prevousState);//if invert is activated then set the output high nles a pulse comes in
    } else {
      outputTerminal=inputTerminal1 && !prevousState;//if the invert is deactivated then set the output low untill a pulse comes
    }
    prevousState=inputTerminal1;
  }
}
