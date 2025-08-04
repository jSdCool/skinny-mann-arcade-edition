import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**We all strive to reachn it, but only the best will.<br>
The stage component for the finish line.
*/
class Goal extends StageComponent {//ground component

  public static final Identifier ID = new Identifier("goal");
  /**Load a goal from saved JOSN data
  @param data The JSON Object containing the goal data
  */
  Goal(JSONObject data) {
    type="goal";
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
  /**Place a new goal
  @param context The context for the placement
  */
  public Goal(StageComponentPlacementContext context){
    type="goal";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
  }
  /**Create a goal from serialized binarry data
  @param iterator The source of the data
  */
  public Goal(SerialIterator iterator){
    deserial(iterator);
  }

  public StageComponent copy() {
    return new Goal(new StageComponentPlacementContext(x, y));
  }
  
  public StageComponent copy(float offsetX,float offsetY){
    return new Goal(new StageComponentPlacementContext(x+offsetX,y+offsetY));
  }
  
  public StageComponent copy(float offsetX,float offsetY,float offsetZ){
    System.err.println("attempted to copy a goal in 3D. This opperation is not supported");
    return null;
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
    float x2 = (x+group.xOffset)-source.drawCamPosX, y2 = (y+group.yOffset);
    render.fill(255);
    render.rect(source.Scale*x2, source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    render.rect(source.Scale*(x2+100), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    render.rect(source.Scale*(x2+200), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    render.fill(0);
    render.rect(source.Scale*(x2+50), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    render.rect(source.Scale*(x2+150), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);

    Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);

    if (source.collisionDetection.collide2D(playerHitBox,Collider2D.createRectHitbox(x+group.xOffset,y+group.yOffset-50,250,100))) {
      if (!source.level_complete) {
        source.level.logicBoards.get(source.level.levelCompleteBoard).superTick();
      }
      if (source.level.multyplayerMode!=2) {
        source.level_complete=true;
      } else {
        source.reachedEnd=true;
      }
    }
  }
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render) {
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
      if (x >= (this.x+group.xOffset) && x <= ((this.x+group.xOffset)) + 250 && y >= ((this.y+group.yOffset)) - 50 && y <= ((this.y+group.yOffset)) + 50) {
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
