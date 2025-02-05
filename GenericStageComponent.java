import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/** I have no idea why this class exsists
*/
class GenericStageComponent extends StageComponent {
	
  public static final Identifier ID = new Identifier("GenericStageComposnent");

  void draw(PGraphics render){
    
  }
  
  void draw3D(PGraphics render){
    
  }
  
  StageComponent copy() {
    return this;
  }
  
  StageComponent copy(float offsetX,float offsetY){
    return this;
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return this;
  }
  
  public GenericStageComponent(SerialIterator iterator){
     deserial(iterator);
  }
  
  public GenericStageComponent(){}
  
  JSONObject save(boolean e) {
    return null;
  }
  
  public Collider2D getCollider2D(){
    return null;
  }
  public Collider3D getCollider3D(){ 
    return null;
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
