import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/**Sign stage component
*/
public class WritableSign extends StageComponent {
  
  public static final Identifier ID = new Identifier("WritableSign");
  
  String contents;
  /**Load a sign from saved JOSN data
  @param data The JSON Object containing the sign data
  */
  public WritableSign(JSONObject data) {
    type="WritableSign";
    x=data.getFloat("x");
    y=data.getFloat("y");
    boolean stage_3D = data.getBoolean("s3d");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    contents=data.getString("contents");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  
  /**Place a new sign
  @param context The context for the placement
  */
  public WritableSign(StageComponentPlacementContext context){
    type="WritableSign";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
    contents="";
  }
  
  /**Create a sign from serialized binarry data
  @param iterator The source of the data
  */
  public WritableSign(SerialIterator iterator){
    deserial(iterator);
    contents = iterator.getString();
  }
  
  public StageComponent copy() {
    WritableSign e=new WritableSign(new StageComponentPlacementContext(x, y, z));
    e.contents=contents;
    return  e;
  }
  
  public StageComponent copy(float offsetX,float offsetY){
    WritableSign e = new WritableSign(new StageComponentPlacementContext(x+offsetX,y+offsetY));
    e.contents = contents;
    return e;
  }
  
  public StageComponent copy(float offsetX,float offsetY,float offsetZ){
    WritableSign e = new WritableSign(new StageComponentPlacementContext(x+offsetX,y+offsetY,z+offsetZ));
    e.contents = contents;
    return e;
  }
  
  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSign(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale,render);

    Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);
    if (source.collisionDetection.collide2D(playerHitBox,Collider2D.createRectHitbox(x-35,y-40,70,40))) {//display the press e message to the player
      source.fill(255);
      source.textSize(source.Scale*20);
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;

      if (source.E_pressed) {
        source.E_pressed=false;
        source.viewingItemContents=true;
        if(!source.levelCreator){
          source.stats.incrementSignsRead();
        }
      }
    }
  }
  
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSign((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), source.Scale,render);

     Collider3D playerHitBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
    if (source.collisionDetection.collide3D(playerHitBox,Collider3D.createBoxHitBox(x-35,y-40,z-20,70,40,40))) {
      source.fill(255);
      source.textSize(source.Scale*20);
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;
      if (source.E_pressed) {
        source.E_pressed=false;
        source.viewingItemContents=true;
        if(!source.levelCreator){
          source.stats.incrementSignsRead();
        }
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
      if (x >= ((this.x+group.xOffset))-35 && x <= ((this.x+group.xOffset)) + 35 && y >= ((this.y+group.yOffset)) - 65 && y <= (this.y+group.yOffset)) {
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
      if (x >= ((this.x+group.xOffset))-35 && x <= ((this.x+group.xOffset)) + 35 && y >= ((this.y+group.yOffset)) - 65 && y <= (this.y+group.yOffset) && z >= ((this.z+group.yOffset)) - 5 && z <= (this.z+group.zOffset)+5) {
        return true;
      }
    }
    return false;
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
    part.setString("contents", contents);
    part.setInt("group", group);
    return part;
  }

  /**Set a string data property
  @param data The data to set
  */
  public void setData(String data) {
    contents=data;
  }

  /**Get the value of a string data proerty
  @return The value of the string data
  */
  public String getData() {
    return contents;
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
    data.addObject(SerializedData.ofString(contents));
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
