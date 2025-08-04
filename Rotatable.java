import processing.core.PVector;
/**Allows stage components that implment this to be rotated
*/
public interface Rotatable{
  
  /**Reset the current rotation of this component
  */
  void resetRotate();
  /**Set the x roatation of this component
  @param x Set the new x roatation (in radiains)
  */
  void rotateX(float x);
  /**Set the y roatation of this component
  @param y Set the new y roatation (in radiains)
  */
  void rotateY(float y);
  /**Set the z roatation of this component
  @param z Set the new z roatation (in radiains)
  */
  void rotateZ(float z);
  /**Update the position of the vertices of this component
  */
  void updateVerticies();
  /**Get the current x roation of this component
  @return The current x roation (in radians)
  */
  float getRotateX();
  /**Get the current y roation of this component
  @return The current y roation (in radians)
  */
  float getRotateY();
  /**Get the current z roation of this component
  @return The current z roation (in radians)
  */
  float getRotateZ();
  /**Get the local x axis of this component
  @return The local x axis of this componrnt
  */
  PVector getXLocal();
  /**Get the local y axis of this component
  @return The local y axis of this componrnt
  */
  PVector getYLocal();
  /**Get the local z axis of this component
  @return The local z axis of this componrnt
  */
  PVector getZLocal();
  /**Get the axis arround witch this compoennt will be roated when rotated in the x axis
  @return The x rotation axis
  */
  PVector getXRotationAxis();
  /**Get the axis arround witch this compoennt will be roated when rotated in the y axis
  @return The y rotation axis
  */
  PVector getYRotationAxis();
  /**Get the axis arround witch this compoennt will be roated when rotated in the z axis
  @return The z rotation axis
  */
  PVector getZRotationAxis();
  /**Get if this compoennt has been rotated
  @return true if rotated in any axis
  */
  boolean isRotated();
  /**Get if this component has been roated in the x or y axis
  return true if rotated in the x or y axis
  */
  boolean isRotated3D();
}
