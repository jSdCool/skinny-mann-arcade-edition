import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

//GenericLogicComponent
/**An unused testing logic component. It does nothing.
*/
public class GenericLogicComponent extends LogicComponent {
  
  public static final Identifier ID = new Identifier("GenericLogicComponent");
  /**Place a new generic component 
  @param context The context for the placement
  */
  public GenericLogicComponent(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "GenericLogicComponent", context.getLogicBoard());
  }
  /**Create a new and gate from saved json data
  @param data The saved json data
  */
  public GenericLogicComponent(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "GenericLogicComponent", data.getJSONArray("connections"));
  }
  /**Create an and gate from serialized binarry data
  @param iterator The source of the data
  */
  public GenericLogicComponent(SerialIterator iterator){
    super(iterator);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
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
