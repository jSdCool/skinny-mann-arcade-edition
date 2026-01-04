//Delay
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/**A signal delay logic component
*/
public class Delay extends LogicComponent implements Configurable{
  
  public static final Identifier ID = new Identifier("delay");
  
  int time=10;
  ArrayList<Boolean> mem=new ArrayList<>();
  /**Place a new delay component
  @param context The context for the placement
  */
  public Delay(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "delay", context.getLogicBoard());
    button.setText("delay "+time+" ticks  ");
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }
  /**Create a new delay comonent from saved json data
  @param data The saved json data
  */
  public Delay(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "delay", data.getJSONArray("connections"));
    time=data.getInt("delay");
    button.setText("delay "+time+" ticks  ");
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }
  /**Create a delay component from serialized binarry data
  @param iterator The source of the data
  */
  public Delay(SerialIterator iterator){
    super(iterator);
    time = iterator.getInt();
  }
  /**renders the logic component a long with its I/O terminals
  */
  public void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15);
    source.textAlign(PConstants.LEFT, PConstants.CENTER);
    source.text("input", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("clear", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
    if (inputTerminal2) {//if terminal 2 reset the delay memeory
      mem=new ArrayList<>();
      for (int i=0; i<time; i++) {
        mem.add(false);
      }
    }
    outputTerminal=mem.remove(0);
    mem.add(inputTerminal1);
    //System.out.println(mem);
  }
  
  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
    JSONObject contence=super.save();
    contence.setInt("delay", time);
    return contence;
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(time);
    return data;
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
  
  /**Get the properties that can be configured on this component
  @return An array of the properties that can be configured
  */
  @Override
  public Property[] getProperties(){
    return new Property[]{
      new IntegerProperty(() -> time, (value) -> {time = value; button.setText("delay "+time+" ticks  ");}, "Delay in Ticks (50tps)")
    };
  }
}
