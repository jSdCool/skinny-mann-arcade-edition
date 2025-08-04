/**contextual information about the placement of an entity on a stage
*/
public class StageEntityPlacementContext{
  /**Create an entity placement context
  @param x The x position of the placement
  @param y The y position of the placement
  @param z The z position of the placement
  */ 
  public StageEntityPlacementContext(float x,float y,float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }
  
  private float x,y,z;
  
  /**Get the x position of this placement
  @return the x position of the placement
  */
  public float getX(){
    return x;
  }
  /**Get the y position of this placement
  @return the y position of the placement
  */
  public float getY(){
    return y;
  }
  /**Get the z position of this placement
  @return the z position of the placement
  */
  public float getZ(){
    return z;
  }
}
