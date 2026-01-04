import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A portal stage component to allow the player to switch between stages
*/
public class Interdimentional_Portal extends StageComponent {

  public static final Identifier ID = new Identifier("interdimentional_Portal");
  
  float linkX, linkY, linkZ;
  int linkIndex;
  /**Load a portal from saved JOSN data.<br>
  Note: This is the primarry method for placement of prtals as well as loading.
  @param data The JSON Object containing the check point data
  */
  public Interdimentional_Portal(JSONObject data) {
    type="interdimentional Portal";
    x=data.getFloat("x");
    y=data.getFloat("y");
    linkX=data.getFloat("linkX");
    linkY=data.getFloat("linkY");
    linkIndex=data.getInt("link Index")-1;
    if (!data.isNull("z")) {
      z=data.getFloat("z");
    }
    if (!data.isNull("linkZ")) {
      linkZ=data.getFloat("linkZ");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  
  /**Create a portal from serialized binarry data
  @param iterator The source of the data
  */
  public Interdimentional_Portal(SerialIterator iterator){
    deserial(iterator);
    linkX = iterator.getFloat();
    linkY = iterator.getFloat();
    linkZ = iterator.getFloat();
    linkIndex = iterator.getInt();
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
    if (source.level.stages.get(linkIndex).is3D) {
      part.setFloat("linkZ", linkZ);
    }
    part.setString("type", type);
    part.setFloat("linkX", linkX);
    part.setFloat("linkY", linkY);
    part.setInt("link Index", linkIndex+1);
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
    Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0, 0);
    source.drawPortal(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*1,render);
    //if the player is colliding with the portal
    if (source.collisionDetection.collide2D(playerHitBox, Collider2D.createRectHitbox(x-25, y-50, 50, 100))) {
      //display the "Press E" text
      source.fill(255);
      source.textSize(source.Scale*20);
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;

      //if the E button is pressed
      if (source.E_pressed) {
        //send the player to the portal's destination
        source.E_pressed=false;
        source.selectedIndex=-1;
        source.stageIndex=linkIndex;
        source.currentStageIndex=linkIndex;

        render.background(0);
        if (linkZ!=-1) {
          source.setPlayerPosZ=(int)linkZ;
          source.players[source.currentPlayer].z=linkZ;
          source.tpCords[2]=linkZ;
        }
        source.players[source.currentPlayer].setX(linkX).setY(linkY+48);
        source.setPlayerPosTo=true;
        source.tpCords[0]=(int)linkX;
        source.tpCords[1]=(int)linkY+48;
        source.gmillis=source.millis()+850;
        
        if(!source.levelCreator){
          source.stats.incrementPortalsUsed();
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

    Collider3D playerHitbox = source.players[source.currentPlayer].getHitBox3D(0, 0, 0);

    render.translate(0, 0, z);
    source.drawPortal((x+group.xOffset), (y+group.yOffset), 1,render);
    render.translate(0, 0, -z);
    if (source.collisionDetection.collide3D(playerHitbox, Collider3D.createBoxHitBox(x-25, y-50, z-20, 50, 100, 20))) {
      source.fill(255);
      source.textSize(20);
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;


      if (source.E_pressed) {
        source.E_pressed=false;
        source.selectedIndex=-1;
        source.stageIndex=linkIndex;
        source.currentStageIndex=linkIndex;

        render.background(0);
        if (linkZ!=-1) {
          source.setPlayerPosZ=(int)linkZ;
          source.players[source.currentPlayer].z=linkZ;
          source.tpCords[2]=linkZ;
        }
        source.players[source.currentPlayer].setX(linkX).setY(linkY);
        source.setPlayerPosTo=true;
        source.tpCords[0]=(int)linkX;
        source.tpCords[1]=(int)linkY;
        source.gmillis=source.millis()+850;
        if(!source.levelCreator){
          source.stats.incrementPortalsUsed();
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
      if (x>(this.x+group.xOffset)-25&&x<(this.x+group.xOffset)+25&&y>(this.y+group.yOffset)-50&&y<(this.y+group.yOffset)+60) {
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
      if (x > (this.x+group.xOffset)-25 && x < (this.x+group.xOffset)+25 && y >(this.y+group.yOffset)-50 && y < (this.y+group.yOffset)+60 && z > (this.z+group.zOffset)-2 && z < (this.z+group.zOffset)+2) {
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
    data.addFloat(linkX);
    data.addFloat(linkY);
    data.addFloat(linkZ);
    data.addInt(linkIndex);
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
