import processing.core.*;
/**A Circular 2D hitbox 
*/
public class CircleCollider extends Collider2D{
  float radius;
  /**Create a 2D Circle Collider
  @param center The center position of the circle
  @param radius The radius of the circle
  */
  public CircleCollider(PVector center,float radius){
    super(new PVector[]{});
    this.center=center;
    this.radius=radius;
    updateMin();
    updateMax();
  }
  
  /**Recalculate the minimum coordinate value 
  */
  public void updateMin(){
    min.x = center.x-radius;
    min.y = center.y-radius;
  }
  
  /**Recalculate the maximum coordinate value
  */
  public void updateMax(){
    max.x = center.x+radius;
    max.y = center.y+radius;
  }
  
  /**Calculate the furthest vertex from the center in a given direction
  @param d The direction to get the vertex for
  */
  public PVector furthestPoint(PVector d) {
    //you see in a circle the farthest point in a given direction is just the point radius distace from the center in that dirction
    //infinite percision :tm:
    PVector o = PVector.fromAngle(d.heading());
    o.setMag(radius);
    return PVector.add(PVector.sub(new PVector(),o,null),center,null);
  }
}
