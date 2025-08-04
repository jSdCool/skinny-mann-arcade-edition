import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A loigc omcponent that outputs that current status of the player being in 3D mode
*/
public class Read3DMode extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("read_3D");
  /**Place a new read 3D mode
  @param context The context for the placement
  */
  public Read3DMode(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "read 3D ", context.getLogicBoard());
  }
  /**Create a new read 3D mode from saved json data
  @param data The saved json data
  */
  public Read3DMode(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "read 3D ", data.getJSONArray("connections"));
  }
  /**Create a read 3D mode from serialized binarry data
  @param iterator The source of the data
  */
  public Read3DMode(SerialIterator iterator){
    super(iterator);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    if (source.level.multyplayerMode!=2)
      outputTerminal=source.e3DMode;
    else
      outputTerminal=false;
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
