//OrGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic gate for the OR opperation on logic boards
*/
public class OrGate extends LogicComponent {
  
  public static final Identifier ID = new Identifier("OR");
  /**Place a new or gate 
  @param context The context for the placement
  */
  public OrGate(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "OR", context.getLogicBoard());
  }
  /**Create a new or gate from saved json data
  @param data The saved json data
  */
  public OrGate(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "OR", data.getJSONArray("connections"));
  }
  /**Create a or gate from serialized binarry data
  @param iterator The source of the data
  */
  public OrGate(SerialIterator iterator){
    super(iterator);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    outputTerminal=inputTerminal1||inputTerminal2;
  }
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
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
