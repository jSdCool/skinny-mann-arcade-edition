/**contextual information about the placement of a stage component of the dragging variety
*/
public class StageComponentDragPlacementContext{
  
  private float x, y, z, dx, dy, dz;
  private boolean has3D = false;
  private int color, rotation;
  
  /**Create a new stage component drage placement context
  @param x The upper left x position of the placement
  @param y The upper left y position of the placement
  @param dx The width of the placement
  @param dy The height of the placement
  @param color The color of the placement
  */
  public StageComponentDragPlacementContext(float x, float y, float dx, float dy, int color){
    this.x=x;
    this.y=y;
    this.dx=dx;
    this.dy=dy;
    this.color = color;
  }
  /**Create a new stage component drage placement context
  @param x The upper left x position of the placement
  @param y The upper left y position of the placement
  @param z The back position of the placement
  @param dx The width of the placement
  @param dy The height of the placement
  @param dx The depth of the placement
  @param color The color of the placement
  */
  public StageComponentDragPlacementContext(float x, float y, float z, float dx, float dy, float dz, int color){
    this.x=x;
    this.y=y;
    this.z=z;
    this.dx=dx;
    this.dy=dy;
    this.dz=dz;
    this.color = color;
    has3D=true;
  }
  /**Create a new stage component drage placement context
  @param x The upper left x position of the placement
  @param y The upper left y position of the placement
  @param dx The width of the placement
  @param dy The height of the placement
  @param color The color of the placement
  @param rotate The triangle mode at the time of the placement
  */
  public StageComponentDragPlacementContext(float x, float y, float dx, float dy, int color, int rotate){
    this.x=x;
    this.y=y;
    this.dx=dx;
    this.dy=dy;
    this.color = color;
    rotation = rotate;
  }
  /**Create a new stage component drage placement context
  @param x The upper left x position of the placement
  @param y The upper left y position of the placement
  @param z The back position of the placement
  @param dx The width of the placement
  @param dy The height of the placement
  @param dx The depth of the placement
  @param color The color of the placement
  @param rotate The triangle mode at the time of the placement
  */
  public StageComponentDragPlacementContext(float x, float y, float z, float dx, float dy, float dz, int color, int rotate){
    this.x=x;
    this.y=y;
    this.z=z;
    this.dx=dx;
    this.dy=dy;
    this.dz=dz;
    this.color = color;
    rotation = rotate;
    has3D=true;
  }
  
  /**Get the upper left x position of the placement
  @return The x position of the placement
  */
  public float getX(){
    return x;
  }
  /**Get the upper left y position of the placement
  @return The y position of the placement
  */
  public float getY(){
    return y;
  }
  /**Get the upper left z position of the placement
  @return The z position of the placement
  */
  public float getZ(){
    return z;
  }
  /**Get the width of the placment
  @return The width of the placement
  */
  public float getDX(){
    return dx;
  }
  /**Get the height of the placement
  @return The height of the placement
  */
  public float getDY(){
    return dy;
  }
  /**Get the depth of the placement
  @return The depth of the placement
  */
  public float getDZ(){
    return dz;
  }
  /**Get if this placement has a 3D context
  @return true if the placmeent has a 3D context
  */
  public boolean has3D(){
    return has3D;
  }
  /**Get the color of the placement
  @return The color of the placement
  */
  public int getColor(){
    return color;
  }
  /**Get the triangle rotation at the time of the placement
  @return The triangle mode at the time of the placement
  */
  public int getRotation(){
    return rotation;
  }
  /**debug string stuff, like do i really need to tell you what toString does?
  @return a string figure it out genius
  */
  public String toString(){
    return "x: "+x+" y: "+y+" z: "+z+" dx: "+dx+" dy: "+dy+" dz: "+dz+" has3D: "+has3D+" Rotation: "+rotation;
  }
  
}
