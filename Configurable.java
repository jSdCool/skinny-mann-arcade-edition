/**Used to indicate that this component has at leased 1 property that can be configued in the level creator
*/
public interface Configurable{
  /**Get the properties that can be configured on this component
  @return An array of the properties that can be configured
  */
  Property<?,?>[] getProperties();
}
