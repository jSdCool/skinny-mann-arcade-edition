import java.util.ArrayList;
import java.util.HashMap;
import java.util.function.Function;
import processing.core.PGraphics;
import processing.data.JSONObject;
/**Stores information about each stage entity. Used to dynamically load Entities at runtime and make them apper in the level creator toolbox.<br>
NOTE: All Stage Entities that are to be used/loaded in a level MUST be registerd here
*/
public class EntityRegistry{
  
  private static ArrayList<Identifier> ids = new ArrayList<>();
  private static HashMap<Identifier, Function<JSONObject,StageEntity>> jsonConstructors = new HashMap<>();
  private static HashMap<Identifier, Function<StageEntityPlacementContext, StageEntity>> placementConstructors = new HashMap<>();
  private static HashMap<Identifier, String> desciprions = new HashMap<>();
  private static HashMap<Identifier, EntityButtonIconDraw> icons = new HashMap<>();
  
  /**Register an entity to the registry
  @param id The unique Identifier of this entity (this will be used for future loading and network opperations)
  @param serialConstructor A refrence to the constructor that takes a SerialIterator as an argument. This constructor will be automcatally registerd with the serial registry. (use MyClass::new for this)
  @param jsonConstructor A refrence to the constructor that takes a JSONObject as an argument. This constructor is used to laod the entity from saved json data. (use MyClass::new for this)
  @param placementConstructor A refrence to the constructor that takes a StageEntityPlacementContext as an argument. This constructor is used to create a new entity from placment in the level creator. (use MyClass::new for this)
  @param icon The instructrions for drawing an icon on the level creator toolbox button for this entitys. (can be implmeted as a lambda expression)
  @param description A short description of this entity for the level creator toolbox button. Tipically the name of this entity
  */
  public static void register(Identifier id, Function<SerialIterator,Serialization> serialConstructor, Function<JSONObject, StageEntity> jsonConstructor, Function<StageEntityPlacementContext, StageEntity> placementConstructor, EntityButtonIconDraw icon, String description){
    SerialRegistry.register(id,serialConstructor);
    if(!id.equals(SimpleEntity.ID)){
      ids.add(id);
    }
    jsonConstructors.put(id,jsonConstructor);
    placementConstructors.put(id,placementConstructor);
    icons.put(id,icon);
    desciprions.put(id,description);
  }
  
  /**Get the number of registerd entities
  @return The number of registerd entities
  */
  public static int size(){
    return ids.size();
  }
  /**Get the identifier of an entity for the given index
  @param index The index of the entity to get
  @return The identifier of the given entity
  */
  public static Identifier get(int index){
    return ids.get(index);
  }
  
  /**Get the json constructor for a given entity
  @param id The identifier of the enitty 
  @return The json constructor for the entity
  */
  public static Function<JSONObject,StageEntity> getJsonConstructor(Identifier id){
    return jsonConstructors.get(id);
  }
  /**Get the placment constructor for a given entity
  @param id The identifier of the entity
  @return The placement constructor for the entity
  */
  public static Function<StageEntityPlacementContext, StageEntity> getPlacementConstructor(Identifier id){
    return placementConstructors.get(id);
  }
  /**Get the Icon render for a given entity
  @param id The identifier of the entity
  @return The icon render for the entity
  */
  public static EntityButtonIconDraw getIcon(Identifier id){
    return icons.get(id);
  }
  /**Get the discription for the given entity
  @param id The identifier of the enriry
  @return The description of the entity
  */
  public static String getDescription(Identifier id){
    return desciprions.get(id);
  }
  
  /**Level creator tool box icon render instrion interface.
  */
  interface EntityButtonIconDraw{
    /**Draw the icon for this entity on the tool box button
    @param render The renderer to draw to
    @param x The x position of the button
    @param y The y position of the button
    */
    void draw(PGraphics render, float x, float y);
  }
}
