import processing.core.PVector;
import java.util.ArrayList;
class ComboBox2D extends Collider2D{
  
  private ArrayList<Collider2D> hitBoxes;
  
  public ComboBox2D(){
    super(new PVector[]{});
    hitBoxes = new ArrayList<>();
  }
  
  void addBox(Collider2D box){
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
  
  public ArrayList<Collider2D> getBoxes(){
    return hitBoxes;
  }
}
