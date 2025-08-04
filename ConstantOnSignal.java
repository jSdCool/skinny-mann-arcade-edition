import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic component that allways outputs an on signal
*/
public class ConstantOnSignal extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("ON");
  
  /**Place a new constant on signal component
  @param context The context for the placemnt
  */
  public ConstantOnSignal(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "ON", context.getLogicBoard());
    outputTerminal=true;
  }

  /**Load a constant on signal comonent from saved json data
  @param data the saved json data to load from
  */
  public ConstantOnSignal(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "ON", data.getJSONArray("connections"));
    outputTerminal=true;
  }
  
  /**Recreate a constant on signal from serialized binarray data
  @param iterator The serialized binarry data
  */
  public ConstantOnSignal(SerialIterator iterator){
    super(iterator);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    outputTerminal=true;
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
