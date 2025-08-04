import processing.core.PVector;
import java.util.ArrayList;
/**A 2D Collider consisting of other 2D colliders
*/
public class ComboBox2D extends Collider2D{
  
  private ArrayList<Collider2D> hitBoxes;
  
  /**Create an empty combo box
  */
  public ComboBox2D(){
    super(new PVector[]{});
    hitBoxes = new ArrayList<>();
  }
  
  /**Add a collider to this combo
  @param box the collider to add
  */
  public void addBox(Collider2D box){
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
      
      max.x = Math.max(max.x,bx.x);
      max.y = Math.max(max.y,bx.y);
    }
  }
  
  /**Get the enclosed colliders
  @return the enclosed colliders
  */
  public ArrayList<Collider2D> getBoxes(){
    return hitBoxes;
  }
}
