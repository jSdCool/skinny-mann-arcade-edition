import processing.core.*;
import java.util.ArrayList;
class Collider3D{
  
  Collider3D(PVector[] verticies){
    for(PVector p: verticies){
      vertices.add(p);
    }
    updateMin();
    updateMax();
  }
  
  private ArrayList<PVector> vertices = new ArrayList<>();
  protected PVector min=new PVector(),max = new PVector();
  
  public PVector findFurthestPoint(PVector direction){
    PVector  maxPoint = null;
    float maxDistance = Float.NEGATIVE_INFINITY;
 
    for (PVector vertex : vertices) {
      float distance = PVector.dot(vertex, direction);
      if (distance > maxDistance) {
        maxDistance = distance;
        maxPoint = vertex;
      }
    }
    return maxPoint;
  }
  
  public PVector getMin(){
    return min;
  }
  
  public PVector getMax(){
    return max;
  }
  
  void updateMin(){
    if(vertices.size()>0){
      min = new PVector(vertices.get(0).x,vertices.get(0).y,vertices.get(0).z);
    }
    for(PVector p:vertices){
      min.x = Math.min(p.x,min.x);
      min.y = Math.min(p.y,min.y);
      min.z = Math.min(p.z,min.z);
    }
  }
  
  void updateMax(){
    if(vertices.size()>0){
      max = new PVector(vertices.get(0).x,vertices.get(0).y,vertices.get(0).z);
    }
    for(PVector p:vertices){
      max.x = Math.max(p.x,max.x);
      max.y = Math.max(p.y,max.y);
      max.z = Math.max(p.z,max.z);
    }
  }
  
  /**creates a 3d collider for the specified box range
   mostly just for code readability
   */
  static Collider3D createBoxHitBox(float x,float y,float z,float dx,float dy,float dz){
    return new Collider3D(new PVector[]{
      new PVector(x,y,z),
      new PVector(x+dx,y,z),
      new PVector(x+dx,y+dy,z),
      new PVector(x,y+dy,z),
      new PVector(x,y+dy,z+dz),
      new PVector(x+dx,y+dy,z+dz),
      new PVector(x+dx,y,z+dz),
      new PVector(x,y,z+dz)
    });
  }
}
