import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Interdimentional_Portal extends StageComponent {//ground component
  float linkX, linkY, linkZ;
  int linkIndex;
  Interdimentional_Portal(JSONObject data, boolean stage_3D) {
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
  StageComponent copy() {
    return null;
  }

  StageComponent copy(float offsetX, float offsetY) {
    System.err.println("Attempted to copy portal. This opperation is not supported");
    return null;
  }

  StageComponent copy(float offsetX, float offsetY, float offsetZ) {
    System.err.println("attempted to copy portal. This opperation is not supported");
    return null;
  }

  JSONObject save(boolean stage_3D) {
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

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0, 0);
    source.drawPortal(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*1);
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

        source.background(0);
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

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;

    Collider3D playerHitbox = source.players[source.currentPlayer].getHitBox3D(0, 0, 0);

    source.translate(0, 0, z);
    source.drawPortal((x+group.xOffset), (y+group.yOffset), 1);
    source.translate(0, 0, -z);
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

        source.background(0);
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

  boolean colide(float x, float y, boolean c) {
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

  boolean colide(float x, float y, float z, boolean c) {
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

  public Collider2D getCollider2D() {
    return null;
  }
  public Collider3D getCollider3D() {
    return null;
  }
}
