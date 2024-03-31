import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/** I have no idea why this class exsists
*/
class GenericStageComponent extends StageComponent {
  StageComponent copy() {
    return this;
  }
  
  StageComponent copy(float offsetX,float offsetY){
    return this;
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return this;
  }
  
  JSONObject save(boolean e) {
    return null;
  }
}
