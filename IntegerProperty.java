/**Represents a configruable integer property of a component
*/
public class IntegerProperty extends Property<Integer,IntegerProperty>{
  private final Getter<Integer> getter;
  private final Setter<Integer> setter;
  
  /**Create a new int property with the given name
  @param getter The getter for this property
  @param setter The setter for this property
  @param name the visable name of the property
  */
  public IntegerProperty(Getter<Integer> getter, Setter<Integer> setter, String name){
    super(name);
    this.getter = getter;
    this.setter = setter;
  }
  
  /**Set the value of this property
  @param newValue The new value of this property
  */
  public void set(Integer newValue){
    setter.set(newValue);
  }
  
  /**Get the current value of this property
  @return The current value of this property
  */
  public Integer get(){
    return getter.get();
  }
  
  /**Get the config UI for this type of property
  @return The single instace of the config ui for this property
  */
  public PropertyConfigUi<Integer,IntegerProperty> getConfigUi(){
    return IntPropertyConfigUi.getInstace();
  }
}
