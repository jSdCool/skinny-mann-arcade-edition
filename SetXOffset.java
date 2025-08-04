import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic component to set the x offset of a group
  */
public class SetXOffset extends LogicOutputComponent {
  
  public static final Identifier ID = new Identifier("x-offset");
  
  int groupNumber=0;
  float offset=0;
  boolean reText = false;
  /**Place a new set x offset 
  @param context The context for the placement
  */
  public SetXOffset(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "x-offset", context.getLogicBoard());
    button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  /**Create a new set x offset from saved json data
  @param data The saved json data
  */
  public SetXOffset(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "x-offset", data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    offset=data.getFloat("offset");
    reText = true;
  }
  /**Create a set x offset from serialized binarry data
  @param iterator The source of the data
  */
  public SetXOffset(SerialIterator iterator){
    super(iterator);
    groupNumber = iterator.getInt();
    offset = iterator.getFloat();
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    if (inputTerminal1) {
      source.level.groups.get(groupNumber).xOffset=offset;
    }
    if (inputTerminal2) {
      source.level.groups.get(groupNumber).xOffset=0;
    }
  }
  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    component.setFloat("offset", offset);
    return component;
  }
  /**set an integer data field
  @param data The data to set
  */
  public void setData(int data) {
    groupNumber=data;
    button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  /**Get an integer data field
  @return the value of that data
  */
  public int getData() {
    return groupNumber;
  }
  /**renders the logic component a long with its I/O terminals
  */
  public void draw() {
    if(reText){
      button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
      reText = false;
    }
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("set", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("reset", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  /**Set the value of the offset
  @param of The new value of the offset
  */
  void setOffset(float of) {
    offset=of;
    button.setText("x-offset "+source.level.groupNames.get(groupNumber)+" by "+offset);
  }
  /**Get the current value of the offset
  */
  float getOffset() {
    return offset;
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(groupNumber);
    data.addFloat(offset);
    return data;
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
