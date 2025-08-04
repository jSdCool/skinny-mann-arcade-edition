/**Allows stage components that implment this to be resized/scaled
*/
public interface Resizeable{
  /**Set the x position of this component
  @param x The new x position
  */
  void setX(float x);
  /**Set the y position of this component
  @param y The new y position
  */
  void setY(float y);
  /**Set the z position of this component
  @param z The new z position
  */
  void setZ(float z);
  
  /**Set the new width of this component
  @param width The new width of this component
  */
  void setWidth(float width);
  /**Set the new height of this component
  @param height The new height of this component
  */
  void setHeight(float height);
  /**Set the new depth of this component
  @param depth The new depth of this component
  */
  void setDepth(float depth);
  
  /**Get the current x position of the component
  @return The current x position
  */
  float getX();
  /**Get the current y position of the component
  @return The current y position
  */
  float getY();
  /**Get the current z position of the component
  @return The current z position
  */
  float getZ();
  
  /**Get the current width position of the component
  @return The current width position
  */
  float getWidth();
  /**Get the current height position of the component
  @return The current height position
  */
  float getHeight();
  /**Get the current depth position of the component
  @return The current depth position
  */
  float getDepth();
}
