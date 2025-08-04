import java.util.function.Function;
import processing.data.*;
import java.util.ArrayList;
import java.util.HashMap;
import processing.core.PGraphics;
/**Stores information about each stage component. Used to dynamically load stage components at runtime and make them apper in the level creator toolbox.<br>
NOTE: All stage components that are to be used/loaded in a level MUST be registerd here
*/
public class StageComponentRegistry{
  private static ArrayList<Identifier> ids = new ArrayList<>();
  private static HashMap<Identifier, Function<JSONObject, StageComponent>> jsonConstructors = new HashMap<>();
  private static HashMap<Identifier, Function<StageComponentPlacementContext, StageComponent>> placementConstrucors = new HashMap<>();
  private static HashMap<Identifier, Function<StageComponentDragPlacementContext, StageComponent>> dragPlacementConstructors = new HashMap<>();
  private static HashMap<Identifier, ComponentButtonIconDraw> buttonIcons = new HashMap<>();
  private static HashMap<Identifier, String> descriptionText = new HashMap<>();
  private static HashMap<Identifier, Boolean[]> dimentionAllow = new HashMap<>();
  private static HashMap<Identifier, PlacementPreview> previews = new HashMap<>();
  private static HashMap<Identifier, DraggablePlacementPreview> draggablePreviews = new HashMap<>();
  
  /**Register a stage component to the registry
  @param id The unique Identifier of this logic component (this will be used for future loading and network opperations)
  @param serialConstructor A refrence to the constructor that takes a SerialIterator as an argument. This constructor will be automcatally registerd with the serial registry. (use MyClass::new for this)
  @param jsonConstructor A refrence to the constructor that takes a JSONObject as an argument. This constructor is used to laod the logic component from saved json data. (use MyClass::new for this)
  @param placementConstructor A refrence to the constructor that takes a LogicComponentPlacementContext as an argument. This constructor is used to create a new logic component from placment in the level creator. (use MyClass::new for this)
  @param icon The instructrions for drawing an icon on the level creator toolbox button for this logic component. (can be implmeted as a lambda expression)
  @param description A short description of this logic component for the level creator toolbox button. Tipically the name of this component
  @param dimentionAllows an array if up to 4 booleans but no less then 2, represeing the varius situation in wicth this component appears in the tool box. [0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
  @param preview A placment preview rederer obejct, used to render a preview of the compoennt before it is palced
  */
  public static void register(Identifier id, Function<SerialIterator, Serialization> serialConstructor, Function<JSONObject, StageComponent> jsonConstructor, Function<StageComponentPlacementContext, StageComponent> placementConstructor, ComponentButtonIconDraw icon, String description, Boolean[] dimentionAllows, PlacementPreview preview){
    SerialRegistry.register(id, serialConstructor);
    ids.add(id);
    jsonConstructors.put(id,jsonConstructor);
    placementConstrucors.put(id, placementConstructor);
    buttonIcons.put(id,icon);
    descriptionText.put(id, description);
    dimentionAllow.put(id, dimentionAllows);
    previews.put(id,preview);
  }
  /**Register a draggable stage component to the registry
  @param id The unique Identifier of this logic component (this will be used for future loading and network opperations)
  @param serialConstructor A refrence to the constructor that takes a SerialIterator as an argument. This constructor will be automcatally registerd with the serial registry. (use MyClass::new for this)
  @param jsonConstructor A refrence to the constructor that takes a JSONObject as an argument. This constructor is used to laod the logic component from saved json data. (use MyClass::new for this)
  @param placementConstructor A refrence to the constructor that takes a LogicComponentPlacementContext as an argument. This constructor is used to create a new logic component from placment in the level creator. (use MyClass::new for this)
  @param icon The instructrions for drawing an icon on the level creator toolbox button for this logic component. (can be implmeted as a lambda expression)
  @param description A short description of this logic component for the level creator toolbox button. Tipically the name of this component
  @param dimentionAllows an array if up to 4 booleans but no less then 2, represeing the varius situation in wicth this component appears in the tool box. [0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
  @param preview A placment preview rederer obejct, used to render a preview of the compoennt before it is palced
  */
  public static void register(Identifier id, Function<SerialIterator, Serialization> serialConstructor, Function<JSONObject, StageComponent> jsonConstructor, Function<StageComponentDragPlacementContext, StageComponent> placementConstructor, ComponentButtonIconDraw icon, String description, Boolean[] dimentionAllows, DraggablePlacementPreview preview){
    SerialRegistry.register(id, serialConstructor);
    ids.add(id);
    jsonConstructors.put(id,jsonConstructor);
    dragPlacementConstructors.put(id, placementConstructor);
    buttonIcons.put(id,icon);
    descriptionText.put(id, description);
    dimentionAllow.put(id, dimentionAllows);
    draggablePreviews.put(id, preview);
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
  public static Function<JSONObject, StageComponent> getJsonConstructor(Identifier id){
    return jsonConstructors.get(id);
  }
  /**Get the placment constructor for a given component of the placeable type
  @param id The identifier of the component
  @return The placement constructor for the component
  */
  public static Function<StageComponentPlacementContext, StageComponent> getPlacementConstructor(Identifier id){
    return placementConstrucors.get(id);
  }
  /**Get the placment constructor for a given component of the draggable type
  @param id The identifier of the component
  @return The drag placement constructor for the component
  */
  public static Function<StageComponentDragPlacementContext, StageComponent> getDragConstructor(Identifier id){
    return dragPlacementConstructors.get(id);
  }
  /**Get the Icon render for a given component
  @param id The identifier of the component
  @return The icon render for the component
  */
  public static ComponentButtonIconDraw getIcon(Identifier id){
    return buttonIcons.get(id);
  }
  /**Get the discription for the given component
  @param id The identifier of the component
  @return The description of the component
  */
  public static String getDescription(Identifier id){
    return descriptionText.get(id);
  }
  /**Get the situations in witch a component is allowed to appear in the level creator.<br>
  [0] = allow in 2D stage [1] = allow in 3D stage [2] = allow place in 3D mode in 3D stage (default true) [3] allow in blueprints (default true)
  @param id The identifier of the component
  @return An array of 2 - 4 booleans represeing the situations in witch this component will appear in the level creator
  */
  public static Boolean[] getAllowedDimentions(Identifier id){
    return dimentionAllow.get(id);
  }
  
  /**Get if the given component is a draggable
  @param id The identifier of the component
  @return true if the component represented by the identifier is a draggable
  */
  public static boolean isDraggable(Identifier id){
    return dragPlacementConstructors.get(id) != null;
  }
  
  /**Get the placement preview for a given component
  @param id The identifier of the component
  @return The placement preview for a given component
  */
  public static PlacementPreview getPreview(Identifier id){
    return previews.get(id);
  }
  /**Get the drag placement preview for a given component
  @param id The identifier of the component
  @return The drag placement preview for a given component
  */
  public static DraggablePlacementPreview getDragPreview(Identifier id){
    return draggablePreviews.get(id);
  }
  /**Level creator tool box icon render instructions interface.
  */
  public interface ComponentButtonIconDraw{
    /**Render the icon for this component on the toolbox button
    @param render The renderer to draw to
    @param x The upper left x position of the button
    @param y The upper left y position of the button
    */
    void draw(PGraphics render, float x, float y);
  }
  /**Placement preview render instructions interface
  */
  public interface PlacementPreview{
    /**Render the placement preview for this component
    @param render The renderer to draw to
    @param x The x position of the mouse
    @param y The y position of the mouse
    @param scale The Ui scale the game is being rendered in
    */
    void draw(PGraphics render, float x, float y, float scale);
  }
  /**Drag placement preview render instructions interface
  */
  public interface DraggablePlacementPreview{
    /**Render the drag placement preview for this component
    @param render The renderer to draw to
    @param x The upper left x position of the placement
    @param y The upper left y position of the placement
    @param dx The width of the placement
    @param dy The height of the placement
    @param color The current color of the placement
    @param rotation The triangle mode of the placement
    @param scale The Ui scale the game is being rendered in
    */
    void draw(PGraphics render, float x, float y, float dx, float dy, int color, int rotation, float scale);
  }
  
}
