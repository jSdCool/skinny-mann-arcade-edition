import java.util.ArrayList;
import java.util.HashMap;
import java.util.function.Function;
import processing.core.*;
import processing.data.*;
/**Stores information about each logic component. Used to dynamically load logic components at runtime and make them apper in the level creator toolbox.<br>
NOTE: All logic components that are to be used/loaded in a level MUST be registerd here
*/
public class LogicComponentRegistry{
  private static ArrayList<Identifier> ids = new ArrayList<>();
  private static HashMap<Identifier, Function<JSONObject, LogicComponent>> jsonConstructors = new HashMap<>();
  private static HashMap<Identifier, Function<LogicCompoentnPlacementContext, LogicComponent>> placementConstructors = new HashMap<>();
  private static HashMap<Identifier, ComponentButtonIconDraw> icons = new HashMap<>();
  private static HashMap<Identifier, String> descriptions = new HashMap<>();
  
  /**Register a logic component to the registry
  @param id The unique Identifier of this logic component (this will be used for future loading and network opperations)
  @param serialConstructor A refrence to the constructor that takes a SerialIterator as an argument. This constructor will be automcatally registerd with the serial registry. (use MyClass::new for this)
  @param jsonConstructor A refrence to the constructor that takes a JSONObject as an argument. This constructor is used to laod the logic component from saved json data. (use MyClass::new for this)
  @param placementConstructor A refrence to the constructor that takes a LogicComponentPlacementContext as an argument. This constructor is used to create a new logic component from placment in the level creator. (use MyClass::new for this)
  @param icon The instructrions for drawing an icon on the level creator toolbox button for this logic component. (can be implmeted as a lambda expression)
  @param description A short description of this logic component for the level creator toolbox button. Tipically the name of this component
  */
  public static void register(Identifier id,Function<SerialIterator,Serialization> serialConstructor, Function<JSONObject, LogicComponent> jsonConstructor, Function<LogicCompoentnPlacementContext,LogicComponent> placementConstructor, ComponentButtonIconDraw icon, String description){
    SerialRegistry.register(id,serialConstructor);
    if(!id.equals(GenericLogicComponent.ID)){//make this one not show up in the toolbox
      ids.add(id);  
    }
    jsonConstructors.put(id, jsonConstructor);
    placementConstructors.put(id, placementConstructor);
    icons.put(id, icon);
    descriptions.put(id,description);
  }
  /**Get the number of components registerd to this registry
  @return The size of this registry
  */
  public static int size(){
    return ids.size();
  }
  /**Get the identifier of a compoennt for the given index
  @param index The index of the component to get
  @return The identifier of the given component
  */
  public static Identifier get(int index){
    return ids.get(index);
  }
  /**Get the json constructor for a given component
  @param id The identifier of the component 
  @return The json constructor for the component
  */
  public static Function<JSONObject, LogicComponent> getJsonConstructor(Identifier id){
    return jsonConstructors.get(id);
  }
  /**Get the placment constructor for a given component
  @param id The identifier of the component
  @return The placement constructor for the component
  */
  public static Function<LogicCompoentnPlacementContext, LogicComponent> getPlacementConstructor(Identifier id){
    return placementConstructors.get(id);
  }
  /**Get the Icon render for a given component
  @param id The identifier of the component
  @return The icon render for the component
  */
  public static ComponentButtonIconDraw getIcon(Identifier id){
    return icons.get(id);
  }
  /**Get the discription for the given component
  @param id The identifier of the component
  @return The description of the component
  */
  public static String getDescription(Identifier id){
    return descriptions.get(id);
  }
  /**Level creator tool box icon render instructions interface.
  */
  public interface ComponentButtonIconDraw{
    /**Draw the icon for this component on the tool box button
    @param render The renderer to draw to
    @param x The x position of the button
    @param y The y position of the button
    */
    void draw(PGraphics render, float x, float y); 
  }
}
