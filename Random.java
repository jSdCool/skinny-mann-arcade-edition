import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic component that outputs a random input
*/
public class Random extends LogicInputComponent {
  
  public static final Identifier ID = new Identifier("random");
  
  int variableNumber=0;
  /**Place a new random output component
  @param context The context for the placement
  */
  public Random(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), " random ", context.getLogicBoard());
  }
  /**Create a new random output component from saved json data
  @param data The saved json data
  */
  public Random(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), " random ", data.getJSONArray("connections"));
  }
  /**Create a random output component from serialized binarry data
  @param iterator The source of the data
  */
  public Random(SerialIterator iterator){
    super(iterator);
    variableNumber = iterator.getInt();
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    outputTerminal=(int)(Math.random()*1000000%2)==1;
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
