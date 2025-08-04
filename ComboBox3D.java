import processing.core.PVector;
import java.util.ArrayList;
/**A 3D Collider consisting of other 3D colliders
*/
public class ComboBox3D extends Collider3D{
  
  private ArrayList<Collider3D> hitBoxes;
  /**Create an empty 3D combo box
  */
  public ComboBox3D(){
    super(new PVector[]{});
    hitBoxes = new ArrayList<>();
  }
  
  /**Add a collider to this combo box
  @param box The collider to add
  */
  public void addBox(Collider3D box){
    //add the box to the combo collection
    hitBoxes.add(box);
    
    //update the overall min and max
    if(hitBoxes.size() == 1){
      //if there is only a single box then set the min and max to its min and max
      min = box.getMin().copy();
      max = box.getMax().copy();
    }else{
      //else calculate the minimum minimum and maximum maxiumum
      PVector bm = box.getMin();
      PVector bx = box.getMax();
      
      min.x = Math.min(min.x,bm.x);
      min.y = Math.min(min.y,bm.y);
      min.z = Math.min(min.z,bm.z);
      
      max.x = Math.max(max.x,bx.x);
      max.y = Math.max(max.y,bx.y);
      max.z = Math.max(max.z,bx.z);
    }
  }
  
  /**Get the enclosed colliders
  @return the enclosed colliders
  */
  public ArrayList<Collider3D> getBoxes(){
    return hitBoxes;
  }
}
