import processing.core.*;
import java.util.ArrayList;
class CollisionDetection{
  public boolean collide2D(Collider2D c1, Collider2D c2){
    //AABB
    if(!AABB2D(c1,c2))
      return false;
    //GJK
    return GJK2D(c1,c2);
  }
  
  public boolean collide3D(Collider3D c1, Collider3D c2){
    
    //AABB
    if(!AABB3D(c1,c2))
      return false;
    //GJK
    return GJK3D(c1,c2);
  }
  
  private boolean GJK2D(Collider2D s1, Collider2D s2) {
    //true if shapes s1 and s2 intersect
    //all  vextors/points are 3D Pvectors but the z value will almost always be 0
    PVector d = new PVector();
    PVector.sub(s2.center, s1.center, d);
    d.normalize();//pick initial direction

    ArrayList<PVector> simplex = new ArrayList<>();
    simplex.add(support2D(s1, s2, d));//find the point on the shape that is the combonation of s1 and s2 that is closest the the direction


    //find the next direction witch is tward the origin from the first point
    //note it will still be going to a point on the combo shape
    PVector.sub(new PVector(),simplex.get(0),d);
    d.normalize();


    for (int i=0; i<100000; i++) {//this should be a while true but this will prevent any infinite loops
      PVector A = support2D(s1, s2, d);
      if (A.dot(d) < 0) {//if the new resultant point did not pass the origin then there is no way the resultant shape contain the origin. therefore the 2 shape do not touch
        return false;
      }
      simplex.add(A);//add the point to the simplex

      if (handleSimplex2D(simplex, d)) {//if the simplex handling returns true then the shapes are touching
        return true;
      }
    }
    //mabby but some debuging here
    //this should never be reached bus just in case
    System.out.println("edge case");
    return false;
  }

  private PVector support2D(Collider2D s1, Collider2D s2, PVector d) {
    PVector supportPoint = new PVector(), reverseDirection = new PVector();
    PVector.mult(d, -1, reverseDirection);
    PVector.sub( s2.furthestPoint(reverseDirection),s1.furthestPoint(d), supportPoint);
    supportPoint.normalize();
    return supportPoint;
  }

  private boolean handleSimplex2D(ArrayList<PVector> simplex, PVector d) {//find new direction and update the simplex
    if (simplex.size()==2) {
      return lineCase2D(simplex, d);
    }
    return triangleCase2D(simplex, d);
  }
  
  private boolean lineCase2D(ArrayList<PVector> simplex, PVector d) {
    PVector A = simplex.get(1),B = simplex.get(0);
    PVector AB = new PVector(),AO = new PVector();
    PVector.sub(B,A,AB);
    AB.normalize();
    PVector.sub(new PVector(),A,AO);
    AO.normalize();
    
    PVector ABperp = trippleProd2D(AB,AO,AB);//the line perpendicular to AB pointing in the direction of the origin
    d.set(ABperp);
    return false;
    //edge case about origin falling on a line this could be important
    
  }
  
  private boolean triangleCase2D(ArrayList<PVector> simplex, PVector d) {
    PVector A = simplex.get(2),B = simplex.get(1),C = simplex.get(0);
    PVector AB = new PVector(),AC = new PVector(),AO = new PVector();
    //create the vectors that represent the line of the simplex triangle
    PVector.sub(B,A,AB);
    AB.normalize();
    PVector.sub(C,A,AC);
    AC.normalize();
    PVector.sub(new PVector(),A,AO);
    AO.normalize();
    
    //find lines perpendicular to them
    PVector ABperp = trippleProd2D(AC,AB,AB);
    PVector ACperp = trippleProd2D(AB,AC,AC);
    
    if(ABperp.dot(AO) > 0){//origin is in reagon AB / off the AB line
      simplex.remove(0);//remove point C
      d.set(ABperp);//set the new direction to perpendicular to AB
      return false;//the oirgin was in this regin and there for not in the shape
      
    } else if(ACperp.dot(AO) > 0){//origin is in reagon AC / off the AB line
      simplex.remove(1);//remove point B
      d.set(ACperp);//set the new direction to perpendicular to AB
      return false;//the oirgin was in this regin and therer for not in the shape
      
    } else {//triangle must include the origin and therefore a colision has occored
      return true;
    }
    
    //handle orgin is on line edge case
    
  }
  
  private PVector trippleProd2D(PVector A, PVector B , PVector C){
    PVector aXb = new PVector(), axbXc = new PVector();
    PVector.cross(A,B,aXb);
    PVector.cross(aXb,C,axbXc);
    axbXc.normalize();
    return axbXc;
  }
  
  private boolean AABB2D(Collider2D c1, Collider2D c2){
    PVector min1 = c1.getMin();
    PVector min2 = c2.getMin();
    PVector max1 = c1.getMax();
    PVector max2 = c2.getMax();
    
    return 
    min1.x <= max2.x &&
    max1.x >= min2.x &&
    min1.y <= max2.y &&
    max1.y >= min2.y;
  }
  
  // 3D stuff 
  class Simplex{
    private PVector[] m_points = new PVector[4];
    private int size=0;
  
  
    public Simplex(){
  
    }
  
    Simplex add(PVector[] list) {
      m_points = new PVector[4];
      size=0;
      for (PVector point : list)
        m_points[size++] = point;
  
      return this;
    }
  
    public void push_front(PVector point) 
    {
      m_points = new PVector[]{ point, m_points[0], m_points[1], m_points[2] };
      size = PApplet.min(size + 1, 4);
    }
  
    public PVector get(int i) { 
      return m_points[i]; 
    }
    
    public int size(){ 
      return size; 
    }
  }
  
  private PVector support3D(Collider3D colliderA, Collider3D colliderB, PVector direction){
    return PVector.sub(colliderA.findFurthestPoint(direction)
         ,colliderB.findFurthestPoint(PVector.mult(direction,-1)));
  }
  
  private boolean GJK3D(Collider3D colliderA,Collider3D colliderB) {
    // Get initial support point in any direction
    PVector support = support3D(colliderA, colliderB, new PVector(1, 0, 0));
    // Simplex is an array of points, max count is 4
    Simplex points = new Simplex();
    points.push_front(support);
  
    // New direction is towards the origin
    PVector direction = PVector.mult(support,-1);
    while (true) {
      support = support3D(colliderA, colliderB, direction);
   
      if (PVector.dot(support, direction) <= 0) {
        return false; // no collision
      }
  
      points.push_front(support);
      if (nextSimplex3D(points, direction)) {
        return true;
      }
    }
  }
  
  private boolean nextSimplex3D(Simplex points, PVector direction){
    switch (points.size()) {
      case 2: return line       (points, direction);
      case 3: return triangle3D   (points, direction);
      case 4: return tetrahedron3D(points, direction);
    }
   
    // never should be here
    return false;
  }
  
  private boolean sameDirection3D(PVector direction,PVector ao){
    return PVector.dot(direction, ao) > 0;
  }
  
  private boolean line(Simplex points, PVector direction){
    PVector a = points.get(0);
    PVector b = points.get(1);
  
    PVector ab = PVector.sub(b,a);
    PVector ao = PVector.mult(a,-1);
   
    if (sameDirection3D(ab, ao)) {
      direction.set(PVector.cross(PVector.cross(ab, ao,null), ab,null));
    }else {
      points.add(new PVector[]{a});
      direction.set(ao);
    }
  
    return false;
  }
  
  private boolean triangle3D(Simplex points, PVector direction){
    PVector a = points.get(0);
    PVector b = points.get(1);
    PVector c = points.get(2);
  
    PVector ab = PVector.sub(b,a);
    PVector ac = PVector.sub(c,a);
    PVector ao = PVector.mult(a,-1);
   
    PVector abc = PVector.cross(ab, ac,null);
   
    if (sameDirection3D(PVector.cross(abc, ac,null), ao)) {
      if (sameDirection3D(ac, ao)) {
        points.add(new PVector[]{a,c});
        direction.set(PVector.cross(PVector.cross(ac, ao,null), ac,null));
      } else {
        return line(points.add(new PVector[]{a,b}), direction);
      }
    } else {
      if (sameDirection3D(PVector.cross(ab, abc,null), ao)) {
        return line(points.add(new PVector[]{a,b}), direction);
      } else {
        if (sameDirection3D(abc, ao)) {
          direction.set(abc);
        } else {
          points.add(new PVector[]{a,c,b});
          direction.set(PVector.mult(abc,-1));
        }
      }
    }
  
    return false;
  }
  
  private boolean tetrahedron3D(Simplex points, PVector direction){
    PVector a = points.get(0);
    PVector b = points.get(1);
    PVector c = points.get(2);
    PVector d = points.get(3);
  
    PVector ab = PVector.sub(b,a);
    PVector ac = PVector.sub(c,a);
    PVector ad = PVector.sub(d,a);
    PVector ao = PVector.mult(a,-1);
   
    PVector abc = PVector.cross(ab, ac,null);
    PVector acd = PVector.cross(ac, ad,null);
    PVector adb = PVector.cross(ad, ab,null);
   
    if (sameDirection3D(abc, ao)) {
      return triangle3D(points.add(new PVector[]{ a, b, c }), direction);
    }
      
    if (sameDirection3D(acd, ao)) {
      return triangle3D(points.add(new PVector[]{ a, c, d }), direction);
    }
   
    if (sameDirection3D(adb, ao)) {
      return triangle3D(points.add(new PVector[]{ a, d, b }), direction);
    }
   
    return true;
  }
  
  private boolean AABB3D(Collider3D c1, Collider3D c2){
    PVector min1 = c1.getMin();
    PVector min2 = c2.getMin();
    PVector max1 = c1.getMax();
    PVector max2 = c2.getMax();
    
    return 
    min1.x <= max2.x &&
    max1.x >= min2.x &&
    min1.y <= max2.y &&
    max1.y >= min2.y &&
    min1.z <= max2.z &&
    max1.z >= min2.z;
  }
}
