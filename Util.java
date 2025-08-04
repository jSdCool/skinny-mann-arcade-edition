import processing.core.PMatrix3D;
import processing.core.PVector;
import processing.core.PGraphics;
/**Various utility methods
*/
public class Util{
  /** Apply the given transformation to 4 verticies at the same time,
  the values of the input verticies will be modified by this function
  @param transform The transformation to apply
  @param a The first vertex to transform
  @param b The second vertex to transform
  @param c The third vertex to transform
  @param d The forth vertex to transform
  */
  public static void transform4Vert(PMatrix3D transform, PVector a, PVector b, PVector c, PVector d){
    transform4Vert(transform,a,b,c,d,new PMatrix3D());
  }
  
  /** Apply the given transformation to 4 verticies at the same time,
  the values of the input verticies will be modified by this function.<br>
  NOTE: supplying and reusing a value for tmpMat will improve preformace when calling repetidly
  @param transform The transformation to apply
  @param a The first vertex to transform
  @param b The second vertex to transform
  @param c The third vertex to transform
  @param d The forth vertex to transform
  @param tmpMat Temportaty matrix used for transformations, reuse in each call for imporved preformace
  */
  public static void transform4Vert(PMatrix3D transform, PVector a, PVector b, PVector c, PVector d,PMatrix3D tmpMat){
    if(tmpMat == null){
      //just in case
      tmpMat = new PMatrix3D();
    }
    //verify all verticies are present
    if(a==null || b == null || c == null || d == null){
      PVector tmpVec = new PVector();
      if(a == null){
        a = tmpVec;
      }
      if(b == null){
        b = tmpVec;
      }
      if(c == null){
        c = tmpVec;
      }
      if(d == null){
        d = tmpVec;
      }
    }
    //combine the verticies into a single matrix
    tmpMat.set(a.x,b.x,c.x,d.x,
               a.y,b.y,c.y,d.y,
               a.z,b.z,c.z,d.z,
               1,  1,  1,  1);
    //apply the transformation 
    tmpMat.preApply(transform);
    
    //extract each verticy from the matrix
    a.x = tmpMat.m00;
    a.y = tmpMat.m10;
    a.z = tmpMat.m20;
    b.x = tmpMat.m01;
    b.y = tmpMat.m11;
    b.z = tmpMat.m21;
    c.x = tmpMat.m02;
    c.y = tmpMat.m12;
    c.z = tmpMat.m22;
    d.x = tmpMat.m03;
    d.y = tmpMat.m13;
    d.z = tmpMat.m23;
    
  }
  
  /**Creates a 3D rotation matix for a rotation in all 3 axsis
  @param x The angle in the x-axis to rotate (in radians)
  @param y The angle in the y-axis to rotate (in radians)
  @param z The angle in the z-axis to rotate (in radians)
  @return A matrix containing the requirested 3D roation
  */
  public static PMatrix3D rotateXYZ(float x, float y,float z){
    return rotateXYZ(x, y,z,null);
  }
  
  /**Applies a 3D rotation to the input transformation matix
  @param x The angle in the x-axis to rotate (in radians)
  @param y The angle in the y-axis to rotate (in radians)
  @param z The angle in the z-axis to rotate (in radians)
  @param currentTransform The current transformation to apply the rotation to
  @return The new transforamtion including the rotation, note the input matrix is also updateing with this transformation
  */
  public static PMatrix3D rotateXYZ(float x, float y,float z,PMatrix3D currentTransform){
    if(currentTransform == null){
      currentTransform = new PMatrix3D();
    }
    
    float cosz = (float)Math.cos(z);
    float cosy = (float)Math.cos(y);
    float cosx = (float)Math.cos(x);
    float sinz = (float)Math.sin(z);
    float siny = (float)Math.sin(y);
    float sinx = (float)Math.sin(x);
    
    currentTransform.apply(cosz*cosy, cosz*siny*sinx - sinz*cosx, cosz*siny*cosx + sinz*sinx, 0,
                           sinz*cosy, sinz*siny*sinx + cosz*cosx, sinz*siny*cosx - cosz*sinx, 0,
                           -siny,     cosy*sinx,                  cosy*cosx,                  0,
                           0,         0,                          0,                          1);
    
    return currentTransform;
    
  }
  
  /**Project a 3D point into a 2D plane in 3D space
  @param point The point to project
  @param center The center point the the 2D plane
  @param normal The normal vector of the 2D plane
  @return The inputted point projected onto the closetd point on the 2D plane
  */
  public static PVector projectToPlane(PVector point, PVector center,PVector normal){
    PVector work = new PVector();
    // P - ((((P-C) dot N )/ (N dot N)) dot N)
    return PVector.sub(point,PVector.mult(normal,((PVector.sub(point,center,work).dot(normal))/(normal.dot(normal))),work),work);
  }
  
  /**Calculate the point at witch a line intersects a 2D plane in 3D space
  @param lineA The first point on the line
  @param lineB The seccond point on the line
  @param planePoint The center point of the 2D plane
  @param planeNormal The normal vector of the 2D plane
  @return The point in 3D space where the line and the plane intersect. Will have NaN values if the line and place are parallel
  */
  public static PVector intersectPlaneAndLine(PVector lineA,PVector lineB, PVector planePoint,PVector planeNormal){
    float t = planeNormal.x*(planePoint.x-lineA.x) + planeNormal.y*(planePoint.y-lineA.y) + planeNormal.z*(planePoint.z-lineA.z);
    t /= planeNormal.x*(lineB.x-lineA.x) + planeNormal.y*(lineB.y-lineA.y) + planeNormal.z*(lineB.z-lineA.z);
    
    PVector reslut = new PVector(lineA.x+t*(lineB.x-lineA.x),lineA.y+t*(lineB.y-lineA.y),lineA.z+t*(lineB.z-lineA.z));
    return reslut;
  }
  
  /**Scale and offset the vertex of a shape currently being renderd. primarily for 2D graphics but can also be used in 3D
  @param g The graphics object to write the vertex to
  @param v The base vertex to wright
  @param offsetX How far to offset the x value by pre scale
  @param offsetY How far to offset the y value by pre scale
  @param scale The factor by witch to scale the vertex position by after offsetting(1 for 3D)
  */
  public static void shapeVertex(PGraphics g, PVector v,float offsetX, float offsetY, float scale){
    g.vertex((v.x+offsetX)*scale,(v.y+offsetY)*scale,v.z*scale);
  }
}
