import processing.core.*;
class CircleCollider extends Collider2D{
  float radius;
  CircleCollider(PVector center,float radius){
    super(new PVector[]{});
    this.center=center;
    this.radius=radius;
    updateMin();
    updateMax();
  }
  
  void updateMin(){
    min.x = center.x-radius;
    min.y = center.y-radius;
  }
  
  void updateMax(){
    max.x = center.x+radius;
    max.y = center.y+radius;
  }
  
  public PVector furthestPoint(PVector d) {
    PVector o = PVector.fromAngle(d.heading());
    o.setMag(radius);
    return PVector.add(PVector.sub(new PVector(),o,null),center,null);
  }
}
