//NOrGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic gate for the OR opperation on logic boards
*/
public class NOrGate extends LogicComponent {
  
  public static final Identifier ID = new Identifier("NOR");
  /**Place a new nor gate 
  @param context The context for the placement
  */
  public NOrGate(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "NOR", context.getLogicBoard());
  }
  /**Create a new nor gate from saved json data
  @param data The saved json data
  */
  public NOrGate(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "NOR", data.getJSONArray("connections"));
  }
  /**Create a nor gate from serialized binarry data
  @param iterator The source of the data
  */
  public NOrGate(SerialIterator iterator){
    super(iterator);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    outputTerminal=!(inputTerminal1||inputTerminal2);
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
