import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A loigc componet that reads the state of a level varaible
*/
public class ReadVariable extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("read_var");
  
  int variableNumber=0;
  /**Place a new read variable 
  @param context The context for the placement
  */
  public ReadVariable(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "read var", context.getLogicBoard());
    button.setText("read var b"+variableNumber+"  ");
  }
  /**Create a new read varaible from saved json data
  @param data The saved json data
  */
  public ReadVariable(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "read var", data.getJSONArray("connections"));
    variableNumber=data.getInt("variable number");
    button.setText("read var b"+variableNumber+"  ");
  }
  /**Create a read varaible from serialized binarry data
  @param iterator The source of the data
  */
  public ReadVariable(SerialIterator iterator){
    super(iterator);
    variableNumber = iterator.getInt();
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    outputTerminal=source.level.variables.get(variableNumber);
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
    button.setText("read var b"+variableNumber+"  ");
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
