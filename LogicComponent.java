import processing.core.*;
import processing.data.*;
import java.util.ArrayList;


abstract class LogicComponent implements Serialization {//the base of all logic gates and things
  static transient skiny_mann source;
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
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
    lb=board;
  }

  LogicComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
    lb=board;
    for (int i=0; i<cnects.size(); i++) {
      JSONObject data= cnects.getJSONObject(i);
      connections.add(new Integer[]{data.getInt("index"), data.getInt("terminal")});
    }
  }
  
  LogicComponent(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    type = iterator.getString();
    
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
    //connections
    int numConnections = iterator.getInt();
    for(int i=0;i<numConnections;i++){
      connections.add(new Integer[]{iterator.getInt(),iterator.getInt()});
    }
    
    
  }

  void draw() {
    button.x=(x-source.camPos)*source.Scale;
    button.y=(y-source.camPosY)*source.Scale;
    button.draw();
    source.fill(-26416);
    source.ellipse((x-2-source.camPos)*source.Scale, (y+20-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
    source.ellipse((x-2-source.camPos)*source.Scale, (y+60-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
    source.fill(-369706);
    source.ellipse((x+102-source.camPos)*source.Scale, (y+40-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
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
      if (outputTerminal) {
        source.stroke(220, 0, 0);
      } else {
        source.stroke(0);
      }
      source.strokeWeight(5*source.Scale);
      Integer[] connectionInfo =connections.get(i);
      float[] thisTerminal = getTerminalPos(2), toTerminal=lb.components.get(connectionInfo[0]).getTerminalPos(connectionInfo[1]);
      source.line(thisTerminal[0]*source.Scale, thisTerminal[1]*source.Scale, toTerminal[0]*source.Scale, toTerminal[1]*source.Scale);
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
  
  public void serialize(SerializedData data) {
    data.addFloat(x);
    data.addFloat(y);
    data.addObject(SerializedData.ofString(type));
    data.addInt(connections.size());
    for(int i=0;i<connections.size();i++){
      data.addInt(connections.get(i)[0]);
      data.addInt(connections.get(i)[1]);
    }
  }
}
