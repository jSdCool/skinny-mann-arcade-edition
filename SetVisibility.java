import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic component to set the visability of a group
*/
public class SetVisibility extends LogicOutputComponent {
  
  public static final Identifier ID = new Identifier("set_visable");
  
  int groupNumber=0;
  boolean reText = false;
  /**Place a new set visability
  @param context The context for the placement
  */
  public SetVisibility(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "set visable", context.getLogicBoard());
    button.setText("  visibility of "+source.level.groupNames.get(groupNumber));
  }
  /**Create a new set visability from saved json data
  @param data The saved json data
  */
  public SetVisibility(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "set visable", data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    reText = true;
  }
  /**Create a set visability from serialized binarry data
  @param iterator The source of the data
  */
  public SetVisibility(SerialIterator iterator){
    super(iterator);
    groupNumber = iterator.getInt();
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    if (inputTerminal1) {
      source.level.groups.get(groupNumber).visable=true;
    }
    if (inputTerminal2) {
      source.level.groups.get(groupNumber).visable=false;
    }
  }
  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    return component;
  }
  /**set an integer data field
  @param data The data to set
  */
  public void setData(int data) {
    groupNumber=data;
    button.setText("  visibility of "+source.level.groupNames.get(groupNumber));
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
      button.setText("  visibility of "+source.level.groupNames.get(groupNumber));
      reText=false;
    }
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("true", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("false", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(groupNumber);
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
