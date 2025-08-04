import processing.core.*;
import java.util.ArrayList;
/**A point cloud that represents a 3D hitbox
*/
public class Collider3D{
  /**Create a 3D collider from a cloud of verticies
  @param verticies The verices that make up the hitbox
  */
  Collider3D(PVector[] verticies){
    for(PVector p: verticies){
      vertices.add(p);
    }
    updateMin();
    updateMax();
  }
  
  private ArrayList<PVector> vertices = new ArrayList<>();
  protected PVector min=new PVector(),max = new PVector();
  /**Get the vertex that is farthest from the center in a given direction
  @param direction The direction to look in
  @return the verticy in this collider that is as far as possible in the given direction
  */
  public PVector findFurthestPoint(PVector direction){
    PVector  maxPoint = null;
    float maxDistance = Float.NEGATIVE_INFINITY;
    //look through all the verticies
    for (PVector vertex : vertices) {
      float distance = PVector.dot(vertex, direction);//find the verticy witht he greatesed dot product
      if (distance > maxDistance) {//that one is the farthesed in this direction
        maxDistance = distance;
        maxPoint = vertex;
      }
    }
    return maxPoint;
  }
  
  /**Get the overall minimum coorindate that bounds the verticies in this collider
  @return the threoretical minimum verticy
  */
  public PVector getMin(){
    return min;
  }
  
  /**Get the overall macimum coorindate that bounds the verticies in this collider
  @return the threoretical maximum verticy
  */
  public PVector getMax(){
    return max;
  }
  
  /**Recalucate the minimum coordinate that bounds the verticies in this collider
  */
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
  
  /**Recalucate the maximum coordinate that bounds the verticies in this collider
  */
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
  
  /**Creates a 3D collider for the specified box range.<br>
   Mostly just for code readability.
   @param x The lower x postiion 
   @param y The lower y position
   @param z The lower z position
   @param dx The width of the box
   @param dy The height of the box
   @param dz The depth of the box
   @return An axis aligned hitbox for the specified box dimentions
   */
  public static Collider3D createBoxHitBox(float x,float y,float z,float dx,float dy,float dz){
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
