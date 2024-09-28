import processing.core.*;
class SphereCollider extends Collider3D{
  PVector center = new PVector();
  float radius;
  SphereCollider(PVector center,float radius){
    super(new PVector[]{center});
    this.center=center;
    this.radius=radius;
    updateMin();
    updateMax();
  }
  
  void updateMin(){
    if(center == null)
      return;
    min.x = center.x-radius;
    min.y = center.y-radius;
    min.z = center.z-radius;
  }
  
  void updateMax(){
    if(center == null)
      return;
    max.x = center.x+radius;
    max.y = center.y+radius;
    max.z = center.z+radius;
  }
  
  public PVector findFurthestPoint(PVector direction){
    PVector norm = direction.normalize(null);
    norm.setMag(radius);
    return PVector.add(norm,center,null);
  }

}
