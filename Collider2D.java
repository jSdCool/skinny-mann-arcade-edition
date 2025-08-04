import processing.core.*;
/**A point cloud that represents a 2D hitbox
*/
public class Collider2D {
  PVector[] vertices;
  PVector center;
  protected PVector min=new PVector(), max = new PVector();
  /**Create a 2D collider from a cloud of verticies
  @param vertices The verices that make up the hitbox
  */
  public Collider2D(PVector[] vertices) {
    this.vertices=vertices;
    float cx=0, cy=0, cz=0;
    for (int i=0; i<vertices.length; i++) {//caluclate the center
      cx+=vertices[i].x;
      cy+=vertices[i].y;
      cx+=vertices[i].z;

      updateMin();//this prbly should not be in this loop
      updateMax();
    }
    center=new PVector(cx/vertices.length, cy/vertices.length, cz/vertices.length);
  }

  /**Get the vertex that is farthest from the center in a given direction
  @param d The direction to look in
  @return the verticy in this collider that is as far as possible in the given direction
  */
  public PVector furthestPoint(PVector d) {
    float largestDP=0;
    int indexof=0;
    for (int i=0; i<vertices.length; i++) {//look through all verticies
      PVector np = new PVector();
      PVector.sub(center, vertices[i], np);
      float dp=d.dot(np);//get the dot product and use that to determine wich verticy is the farthest in this dirction
      if (dp>largestDP) {
        largestDP=dp;
        indexof=i;
      }
    }
    return vertices[indexof];
  }

  /**Get the overall minimum coorindate that bounds the verticies in this collider
  @return the threoretical minimum verticy
  */
  public PVector getMin() {
    return min;
  }

  /**Get the overall macimum coorindate that bounds the verticies in this collider
  @return the threoretical maximum verticy
  */
  public PVector getMax() {
    return max;
  }

  /**Recalucate the minimum coordinate that bounds the verticies in this collider
  */
  void updateMin() {
    if (vertices.length>0) {
      min = new PVector(vertices[0].x, vertices[0].y);
    }
    for (PVector p : vertices) {
      min.x = Math.min(p.x, min.x);
      min.y = Math.min(p.y, min.y);
    }
  }
  /**Recalucate the maximum coordinate that bounds the verticies in this collider
  */
  void updateMax() {
    if (vertices.length>0) {
      max = new PVector(vertices[0].x, vertices[0].y);
    }
    for (PVector p : vertices) {
      max.x = Math.max(p.x, max.x);
      max.y = Math.max(p.y, max.y);
    }
  }
  
  /**Get the position that is in the theorectal center of the verticies
  @return The position in the center of the collider
  */
  PVector getCenter(){
    return center.copy();
  }
  
  /**Creates a 2D collider for the specified box range.<br>
   Mostly just for code readability.
   @param x The upper left x position of the box
   @param y The upper left y position of the box
   @param dx The width of the box
   @param dy The height of the box
   @return An axis alligned 2D box collider 
   */
  static Collider2D createRectHitbox(float x, float y, float dx, float dy) {
    return new Collider2D(new PVector[]{new PVector(x, y), new PVector(x+dx, y), new PVector(x+dx, y+dy), new PVector(x, y+dy)});
  }
}
