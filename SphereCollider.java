import processing.core.*;
/**A sphereical 3D hitbox 
*/
public class SphereCollider extends Collider3D{
  PVector center = new PVector();
  float radius;
  /**Create a 3D sphereical collider
  @param center The center position of the sphere
  @param radius The radius of the sphere
  */
  public SphereCollider(PVector center,float radius){
    super(new PVector[]{center});
    this.center=center;
    this.radius=radius;
    updateMin();
    updateMax();
  }
  /**Recalculate the minimum coordinate value 
  */
  public void updateMin(){
    if(center == null)
      return;
    min.x = center.x-radius;
    min.y = center.y-radius;
    min.z = center.z-radius;
  }
  /**Recalculate the maximum coordinate value
  */
  public void updateMax(){
    if(center == null)
      return;
    max.x = center.x+radius;
    max.y = center.y+radius;
    max.z = center.z+radius;
  }
  /**Calculate the furthest vertex from the center in a given direction
  @param direction The direction to get the vertex for
  */
  public PVector findFurthestPoint(PVector direction){
    PVector norm = direction.normalize(null);
    norm.setMag(radius);
    return PVector.add(norm,center,null);
  }

}
