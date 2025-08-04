import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/**The base of all logic gates and components
*/
public abstract class LogicComponent implements Serialization {//the base of all logic gates and things
  static transient skiny_mann source;
  float x, y;//for visuals only
  String type;
  Button button;
  ArrayList<Integer[]> connections=new ArrayList<>();
  LogicBoard lb;
  boolean outputTerminal=false, inputTerminal1Buffer=false, inputTerminal2Buffer=false, inputTerminal1=false, inputTerminal2=false;
  /**Create a logic component at the provided position with the given type
  @param x the visual x position
  @param y the visual y position
  @param type The type name to display on the component
  @param board The logic board the component is on
  */
  public LogicComponent(float x, float y, String type, LogicBoard board) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
    lb=board;
  }
  
  /**Creates a logic compoennet at the proviede position with the provided connections
  @param x the visual x position
  @param y the visual y position
  @param type The type name to display on the component
  @param cnects JSONArray containing a list of connections consisting of an index and terminal integers
  */
  public LogicComponent(float x, float y, String type, JSONArray cnects) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(source, x, y, 100*source.Scale, 80*source.Scale, "  "+type+"  ");
    for (int i=0; i<cnects.size(); i++) {
      JSONObject data= cnects.getJSONObject(i);
      connections.add(new Integer[]{data.getInt("index"), data.getInt("terminal")});
    }
  }
  /**Creates a logic component from serialized data
  @param iterator The source of the data
  */
  public LogicComponent(SerialIterator iterator){
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
  
  /**sets the logic board for this component
  @param board The logic board to set for this component
  */
  protected void setLogicBoard(LogicBoard board){
    lb = board;
  }

  /**renders the logic component a long with its I/O terminals
  */
  public void draw() {
    button.x=(x-source.camPos)*source.Scale;
    button.y=(y-source.camPosY)*source.Scale;
    button.draw();
    source.fill(-26416);
    source.ellipse((x-2-source.camPos)*source.Scale, (y+20-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
    source.ellipse((x-2-source.camPos)*source.Scale, (y+60-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
    source.fill(-369706);
    source.ellipse((x+102-source.camPos)*source.Scale, (y+40-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
  }

  /**Get the position of a I/O terminal
  @param t The index of the terminal to get
  @return A float array containg 2 elemts represeting the on screen x,y coords of the terminal. NOTE: theese have allready been camera adjusted
  */
  public float[] getTerminalPos(int t) {
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
  
  /**connect a terminal to another ternianl
  @param index The index of the other component to connect to
  @param terminal the index of the terminal on the other component to connect to
  */
  public void connect(int index, int terminal) {
    if (index>=lb.components.size()||index<0)//check if the index is valid
      return;
    if (terminal<0||terminal>1)//check id the terminal attemping to connect to is valid
      return;
    connections.add(new Integer[]{index, terminal});//create the connection
  }

  /**Render the connections to other components
  */
  public void drawConnections() {
    //for each connection
    for (int i=0; i<connections.size(); i++) {
      //this uses stroke
      if (outputTerminal) {
        source.stroke(220, 0, 0);
      } else {
        source.stroke(0);
      }
      source.strokeWeight(5*source.Scale);
      //get that connection info
      Integer[] connectionInfo =connections.get(i);
      //get the onscreen terminal corrds
      float[] thisTerminal = getTerminalPos(2), toTerminal=lb.components.get(connectionInfo[0]).getTerminalPos(connectionInfo[1]);
      //draw the line
      source.line(thisTerminal[0]*source.Scale, thisTerminal[1]*source.Scale, toTerminal[0]*source.Scale, toTerminal[1]*source.Scale);
    }
  }

  /**Set the position of the compoent
  @param x The x position of the component at the components center
  @param y The y position of the component at the components center
  */
  public void setPos(float x, float y) {
    this.x=x-button.lengthX/2;//adjust coordinate from center to corner
    this.y=y-button.lengthY/2;
    button.setX(this.x).setY(this.y);//set the position of the actual button
  }
  
  /**Set the current state for a given input terminal
  @param terminal The index of the terminal to set
  @param state the value to apply to that terminal
  */
  public void setTerminal(int terminal, boolean state) {
    if (terminal==0){
      inputTerminal1Buffer=state;
    }
    if (terminal==1){
      inputTerminal2Buffer=state;
    }
  }
  
  /**Set copy the values passed in to the terminals to the acutal internal varables used
  */
  public void flushBuffer() {
    inputTerminal1=inputTerminal1Buffer;
    inputTerminal2=inputTerminal2Buffer;
  }
  
  /**The function where the logic/functionality of this component is execuated
  */
  public abstract void tick();
  
  /**Copy the data from the output terminal of this component to the input terminal of all conncetions
  */
  public void sendOut() {
    for (int i=0; i<connections.size(); i++) {
      lb.components.get(connections.get(i)[0]).setTerminal( connections.get(i)[1], outputTerminal);
    }
  }
  
  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
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

  /**set an integer data field
  @param data The data to set
  */
  @Deprecated
  public void setData(int data) {
  }
  
  /**Get an integer data field
  @return the value of that data
  */
  @Deprecated
  public int getData() {
    return 0;
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  This representation is contained inside of the passed in object
  @param data The object the bytes will be written to, may allready contain the data of other objects
  */
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
