import processing.core.*;
class Collider2D {
  PVector[] vertices;
  PVector center;
  protected PVector min=new PVector(), max = new PVector();
  public Collider2D(PVector[] vertices) {
    this.vertices=vertices;
    float cx=0, cy=0, cz=0;
    for (int i=0; i<vertices.length; i++) {
      cx+=vertices[i].x;
      cy+=vertices[i].y;
      cx+=vertices[i].z;

      updateMin();
      updateMax();
    }
    center=new PVector(cx/vertices.length, cy/vertices.length, cz/vertices.length);
  }

  public PVector furthestPoint(PVector d) {
    float largestDP=0;
    int indexof=0;
    for (int i=0; i<vertices.length; i++) {
      PVector np = new PVector();
      PVector.sub(center, vertices[i], np);
      float dp=d.dot(np);
      if (dp>largestDP) {
        largestDP=dp;
        indexof=i;
      }
    }
    return vertices[indexof];
  }

  public PVector getMin() {
    return min;
  }

  public PVector getMax() {
    return max;
  }

  void updateMin() {
    if (vertices.length>0) {
      min = new PVector(vertices[0].x, vertices[0].y);
    }
    for (PVector p : vertices) {
      min.x = Math.min(p.x, min.x);
      min.y = Math.min(p.y, min.y);
    }
  }

  void updateMax() {
    if (vertices.length>0) {
      max = new PVector(vertices[0].x, vertices[0].y);
    }
    for (PVector p : vertices) {
      max.x = Math.max(p.x, max.x);
      max.y = Math.max(p.y, max.y);
    }
  }
  
  PVector getCenter(){
    return center.copy();
  }
  
  /**creates a 2d collider for the specified box range
   mostly just for code readability
   */
  static Collider2D createRectHitbox(float x, float y, float dx, float dy) {
    return new Collider2D(new PVector[]{new PVector(x, y), new PVector(x+dx, y), new PVector(x+dx, y+dy), new PVector(x, y+dy)});
  }
}
