import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import java.util.function.Function;
/**The strcture that stores and processes logic components
*/
public class LogicBoard implements Serialization {//stores all the logic components

  public static final Identifier ID = new Identifier("LogicBoard");

  static transient skiny_mann source;
  public String name="This value has not been initilized, If you can see this report it as a bug";//temp name
  public ArrayList<LogicComponent> components=new ArrayList<>();
  /*Load a logic board from a saved file
  @param file The file to load the board from
  @param level The level the board is in. Note: we need to find a way arrund needing this paramater
  */
  public LogicBoard(JSONArray file, Level level) {
    JSONObject head=file.getJSONObject(0);
    name=head.getString("name");//load the name
    for (int i=1; i<file.size(); i++) {//for each component in the file
      JSONObject component=file.getJSONObject(i);
      String type = Identifier.convertToId(component.getString("type"));//get the type identifier of the component
      Identifier typeId = new Identifier(type);
      Function<JSONObject, LogicComponent> constructor = LogicComponentRegistry.getJsonConstructor(typeId);//get the constructor of this component
      if(constructor == null){//if there was no constructor for that component
        System.err.println("No constructor found for idntifier: "+typeId);
        throw new RuntimeException("No constructor found for identifier: "+typeId);//throw an error
      }
      LogicComponent comp = constructor.apply(component);//use the constructor passing in the component data
      comp.setLogicBoard(this);//set the logic board of the component, note: find a way to arround needing this
      components.add(comp);//add this component to the list of components
    }
  }
  
  /**Create a new logic board with a given name
  @param name The name of this board
  */
  public LogicBoard(String name) {
    this.name=name;
  }

  /**Recreate a logic board from serialized binarry data
  @param iterator The source of the binarry data
  */
  public LogicBoard(SerialIterator iterator){
    name = iterator.getString();
    components = iterator.getArrayList();
  }
  
  /**Save this logic board to a file
  @return The name of the file that was saved, begining with /
  */
  public String save() {
    JSONArray logicComponents=new JSONArray();
    JSONObject head=new JSONObject();
    head.setString("name", name);
    logicComponents.setJSONObject(0, head);
    for (int i=0; i<components.size(); i++) {
      logicComponents.setJSONObject(i+1, components.get(i).save());//save each component to the file
    }
    source.saveJSONArray(logicComponents, source.rootPath+"/"+name+".json");
    return "/"+name+".json";
  }

  /**Remove a logic component from the board
  @param index The index of the component to remove
  */
  public void remove(int index) {
    if (components.size()<=index||index<0)//check if the porvided index is valid
      return;
    components.remove(index);//remove the object
    for (int i=0; i<components.size(); i++) {//make shure all connects still point to the correct components and remove connects that went to the deleted one
      LogicComponent component=components.get(i);//get the component
      for (int j=0; j<component.connections.size(); j++) {//go through all the connections
        if (component.connections.get(j)[0]==index) {//if the indexes align
          component.connections.remove(j);//remove the connnection
          j--;//go back a connection becuse we just removed one
          continue;//dont need to check further on this connection because we just removed it
        }
        if (component.connections.get(j)[0]>index){//if the connection was to an index above the one that was removed
          component.connections.get(j)[0]--;//decrease it by 1 so it point to the correct place
        }
      }
    }
  }

  /**Process a single tick of this logic board. Ticking each logic component once
  */
  public void tick() {//tick each component once
    for (int i=0; i<components.size(); i++) {//process a tick on each component
      components.get(i).tick();
    }
    for (int i=0; i<components.size(); i++) {//copy the processed outputs of each component to the approprate input terminals
      components.get(i).sendOut();
    }
    for (int i=0; i<components.size(); i++) {//moved those prevously coppied values from the buffer to the actuall internal storage of those values 
      components.get(i).flushBuffer();//I can not remeber why this was nessarry, but for now I will assume it is
    }//perhaps its to add an additional step to the process so someone who has no idea what they are doing doesent accedentally break something. Still no idea tho
  }
  
  /**Tick this logic board 256 times with no delay inbetween ticks
  */
  public void superTick() {//
    for (int i=0; i<256; i++) {
      tick();
    }
  }
  
  /**Convert this object to a byte representation that can be sent over the network or saved to a file.<br>
  @return This object as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(SerializedData.ofString(name));
    data.addObject(SerializedData.ofArrayList(components,new Identifier("LogicComponent")));
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
