/**Represents a configruable sound property of a component<br>
Basically just a string property that has a diffren config UI that only allows the sounds of the level as input
*/
public class SoundProperty extends StringProperty{
  
  /**Create a new sound property with the given name
  @param getter The getter for this property
  @param setter The setter for this property
  @param name the visable name of the property
  */
  public SoundProperty(Getter<String> getter, Setter<String> setter, String name){
    super(getter,setter,name);
  }
  
  /**Get the config UI for this type of property
  @return The single instace of the config ui for this property
  */
  public PropertyConfigUi<String,StringProperty> getConfigUi(){
    return SoundPropertyConfigUi.getInstace();
  }
}
