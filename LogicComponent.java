import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;


abstract class LogicComponent {//the base of all logic gam=ts and things
  static skiny_mann source;
  float x, y;//for visuals only
  String type;
  Button button;
  ArrayList<Integer[]> connections=new ArrayList<>();
  LogicBoard lb;
  boolean outputTerminal=false, inputTerminal1Buffer=false, inputTerminal2Buffer=false, inputTerminal1=false, inputTerminal2=false;
  LogicComponent(float x, float y, String type, LogicBoard board) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(source, x, y, 100, 80, "  "+type+"  ");
    lb=board;
  }

  LogicComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(source, x, y, 100, 80, "  "+type+"  ");
    lb=board;
    for (int i=0; i<cnects.size(); i++) {
      JSONObject data= cnects.getJSONObject(i);
      connections.add(new Integer[]{data.getInt("index"), data.getInt("terminal")});
    }
  }

  void draw() {
    button.x=x-source.camPos;
    button.y=y-source.camPosY;
    button.draw();
    source.fill(-26416);
    source.ellipse(x-2-source.camPos, y+20-source.camPosY, 20, 20);
    source.ellipse(x-2-source.camPos, y+60-source.camPosY, 20, 20);
    source.fill(-369706);
    source.ellipse(x+102-source.camPos, y+40-source.camPosY, 20, 20);
  }

  float[] getTerminalPos(int t) {
    if (t==0) {
      return new float[]{x-2-source.camPos, y+20-source.camPosY};
    }
    if (t==1) {
      return new float[]{x-2-source.camPos, y+60-source.camPosY};
    }
    if (t==2) {
      return new float[]{x+102-source.camPos, y+40-source.camPosY};
    }
    return new float[]{-1000, -1000};
  }

  void connect(int index, int terminal) {
    if (index>=lb.components.size()||index<0)//check if the index is valid
      return;
    if (terminal<0||terminal>1)//check id the terminal attemping to connect to is valid
      return;
    connections.add(new Integer[]{index, terminal});//create the connection
  }

  void drawConnections() {
    for (int i=0; i<connections.size(); i++) {
      source.stroke(0);
      source.strokeWeight(5);
      Integer[] connectionInfo =connections.get(i);
      float[] thisTerminal = getTerminalPos(2), toTerminal=lb.components.get(connectionInfo[0]).getTerminalPos(connectionInfo[1]);
      source.line(thisTerminal[0], thisTerminal[1], toTerminal[0], toTerminal[1]);
    }
  }

  void setPos(float x, float y) {
    this.x=x-button.lengthX/2;
    this.y=y-button.lengthY/2;
    button.setX(this.x).setY(this.y);
  }

  void setTerminal(int terminal, boolean state) {
    if (terminal==0)
      inputTerminal1Buffer=state;
    if (terminal==1)
      inputTerminal2Buffer=state;
  }

  void flushBuffer() {
    inputTerminal1=inputTerminal1Buffer;
    inputTerminal2=inputTerminal2Buffer;
  }

  abstract void tick();

  void sendOut() {
    for (int i=0; i<connections.size(); i++) {
      lb.components.get(connections.get(i)[0]).setTerminal( connections.get(i)[1], outputTerminal);
    }
  }

  JSONObject save() {
    JSONObject component=new JSONObject();
    component.setString("type", type);
    component.setFloat("x", x);
    component.setFloat("y", y);
    JSONArray connections=new JSONArray();
    for (int i=0; i<this.connections.size(); i++) {
      JSONObject connect=new JSONObject();
      connect.setInt("index", this.connections.get(i)[0]);
      connect.setInt("terminal", this.connections.get(i)[1]);
      connections.setJSONObject(i, connect);
    }
    component.setJSONArray("connections", connections);
    return component;
  }

  void setData(int data) {
  }

  int getData() {
    return 0;
  }
}
