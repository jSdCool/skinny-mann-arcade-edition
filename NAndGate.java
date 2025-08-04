//NAndGate
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic gate for the NAND opperation on logic boards
*/
public class NAndGate extends LogicComponent {
  
  public static final Identifier ID = new Identifier("NAND");
  
  /**Place a new nand gate 
  @param context The context for the placement
  */
  public NAndGate(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "NAND", context.getLogicBoard());
  }
  /**Create a new nand gate from saved json data
  @param data The saved json data
  */
  public NAndGate(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "NAND", data.getJSONArray("connections"));
  }
  /**Create a nand gate from serialized binarry data
  @param iterator The source of the data
  */
  public NAndGate(SerialIterator iterator){
    super(iterator);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  @Override
  public void tick() {
    outputTerminal=!(inputTerminal1&&inputTerminal2);
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
