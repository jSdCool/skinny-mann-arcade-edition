import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**Turn 3D mode off button stage component
*/
public class SWoff3D extends StageComponent {

  public static final Identifier ID = new Identifier("3DoffSW");
  /**Load a 3D off switch from saved JOSN data
  @param data The JSON Object containing the switch point data
  */
  public SWoff3D(JSONObject data) {
    type="3DoffSW";
    x=data.getFloat("x");
    y=data.getFloat("y");
    boolean stage_3D = data.getBoolean("s3d");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  /**Place a new 3D off switch
  @param context The context for the placement
  */
  public SWoff3D(StageComponentPlacementContext context){
    type="3DoffSW";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
  }
  /**Create a 3D off switch from serialized binarry data
  @param iterator The source of the data
  */
  public SWoff3D(SerialIterator iterator){
    deserial(iterator);
  }
  
  public StageComponent copy() {
    return new SWoff3D(new StageComponentPlacementContext(x, y, z));
  }
  
  public StageComponent copy(float offsetX,float offsetY){
    return new SWoff3D(new StageComponentPlacementContext(x+offsetX,y+offsetY,z));
  }
  
  public StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new SWoff3D(new StageComponentPlacementContext(x+offsetX,y+offsetY,z+offsetZ));
  }
  /**Get a JSONObject representation of this component that can be saved to a file
  @param stage_3D Wether this stage is a 3D stage
  @return JSONObject representation of this object
  */
  public JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }
  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.draw3DSwitch2(((x+group.xOffset)-source.drawCamPosX), ((y+group.yOffset)+source.drawCamPosY), source.Scale,render);
  }
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.draw3DSwitch2((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), source.Scale,render);
    Collider3D playerHitBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
    if (source.collisionDetection.collide3D(playerHitBox,Collider3D.createBoxHitBox(x+group.xOffset-10,y+group.yOffset-10,z+group.zOffset-10,20,10,20))) {
      source.e3DMode=false;
      source.WPressed=false;
      source.SPressed=false;
      source.gmillis=source.millis()+1200;
      if(!source.levelCreator){
        source.stats.incrementDeactivated3D();
      }
    }
  }
  
  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }
  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param z The z position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset) && z >= ((this.z+group.zOffset)) - 10 && z <= (this.z+group.zOffset)) {
        return true;
      }
    }
    return false;
  }
  /**Get the 2D collision box for entitiy collisions
  @return 2D hitbox for this component or null for none
  */
  public Collider2D getCollider2D(){
    return null;
  }
  /**Get the 3D collision box for entitiy collisions
  @return 3D hitbox for this component or null for none
  */
  public Collider3D getCollider3D(){ 
    return null;
  }
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    return data;
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
