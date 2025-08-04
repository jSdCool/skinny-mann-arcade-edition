import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic coponent to set the value of a level variable
*/
public class SetVariable extends LogicOutputComponent {
  
  public static final Identifier ID = new Identifier("set_var");
  
  int variableNumber=0;
  /**Place a new set varaible
  @param context The context for the placement
  */
  public SetVariable(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "set var", context.getLogicBoard());
    button.setText("  set var b"+variableNumber);
  }
  /**Create a new set variable from saved json data
  @param data The saved json data
  */
  public SetVariable(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "set var", data.getJSONArray("connections"));
    variableNumber=data.getInt("variable number");
    button.setText("  set var b"+variableNumber);
  }
  /**Create a set variable from serialized binarry data
  @param iterator The source of the data
  */
  public SetVariable(SerialIterator iterator){
    super(iterator);
    variableNumber = iterator.getInt();
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    if (inputTerminal2)
      source.level.variables.set(variableNumber, inputTerminal1);
  }
  /**renders the logic component a long with its I/O terminals
  */
  public void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("data", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("set", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
    JSONObject component=super.save();
    component.setInt("variable number", variableNumber);
    return component;
  }
  /**set an integer data field
  @param data The data to set
  */
  public void setData(int data) {
    variableNumber=data;
    button.setText("  set var b"+variableNumber);
  }
  /**Get an integer data field
  @return the value of that data
  */
  public int getData() {
    return variableNumber;
  }
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(variableNumber);
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
