/**Represents a configruable group property of a component<br>
Basically just an int property with a diffrent selection UI that only allows the values that correspond to groups
*/
public class GroupProperty extends IntegerProperty{
  
  /**Create a new group property with the given name
  @param getter The getter for this property
  @param setter The setter for this property
  @param name the visable name of the property
  */
  public GroupProperty(Getter<Integer> getter, Setter<Integer> setter, String name){
    super(getter,setter,name);
  }
  
  /**Get the config UI for this type of property
  @return The single instace of the config ui for this property
  */
  public PropertyConfigUi<Integer,IntegerProperty> getConfigUi(){
    return GroupPropertyConfigUi.getInstace();
  }
}
