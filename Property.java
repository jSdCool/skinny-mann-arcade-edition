/**Represents a configruable property of a component
 @param <T> The type of the property
 @param <P> A refrnce to the extending class, so bsacially its a self refrence
*/
public abstract class Property<T, P extends Property<T,P>>{
  /**The visable name of this property
  */
  private final String name;
  
  /**Create a new property with the given name
  @param name the visable name of the property
  */
  public Property(String name){
    this.name = name;
  }
  
  /**Set the value of this property
  @param newValue The new value of this property
  */
  public abstract void set(T newValue);
  /**Get the current value of this property
  @return The current value of this property
  */
  public abstract T get();
  
  /**Get the visable name of this property
  @return The name of this property
  */
  public String getName(){
    return name;
  }
  
  /**Get the config UI for this type of property
  @return The single instace of the config ui for this property
  */
  public abstract PropertyConfigUi<T,P> getConfigUi();
  
  /**Functional interface used as a getter for this property's value.<br>
  Implment this as a lambda expression
  @param <T> The type of the property
  */
  public static interface Getter<T>{
    /**Get the current value of this property
    @return The current value of this property
    */
    T get();
  }
  
  /**Functional interface used as a setter for this property's value.<br>
  Implment this as a lambda expression
  @param <T> The type of the property
  */
  public static interface Setter<T>{
    /**Set the current value of this property
    @param value The new value of this property
    */
    void set(T value);
  }
  
  /**Render the configuration for this propery at the given slot.<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void draw(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().draw(slotId,self(), context);
  }
  
  /**Process mouse clicks that happen while a property is being configured..<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void mouseClicked(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().mouseClicked(slotId,self(), context);
  }
  
  /**Process mouse pressed events that happen while a property is being configured..<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void mousePressed(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().mousePressed(slotId,self(), context);
  }
  
  /**Process mouse released that happen while a property is being configured..<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void mouseReleased(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().mouseReleased(slotId,self(), context);
  }
  
  /**Process key pressed events that happen while a property is being configured..<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void keyPressed(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().keyPressed(slotId,self(), context);
  }
  
  /**Process key released that happen while a property is being configured..<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void keyReleased(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().keyReleased(slotId,self(), context);
  }
  
  /**Process key typed events that happen while a property is being configured..<br>
  Called by the tool box window, do not call
  @param slotId The index of the slot to display this property
  @param context The context for the property configuration
  */
  public final void keyTyped(int slotId, PropertyConfigEnviormentContext context){
    getConfigUi().keyTyped(slotId,self(), context);
  }
  
  /**Return this but cast to whatever type P is because generics can be a bit of a bith
  @return this but as a P
  */
  @SuppressWarnings("unchecked")
  private final P self(){
    return (P)this;
  }
}
