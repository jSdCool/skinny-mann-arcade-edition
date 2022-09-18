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

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
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
    float playx=source.players[source.currentPlayer].getX(), playy=source.players[source.currentPlayer].getY();
    source.drawPortal(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*1);
    if ((playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60)) {
      source.fill(255);
      source.textSize(source.Scale*20);
      source.displayText="Press E";
      source.displayTextUntill=source.millis()+100;
    }

    if (source.E_pressed&&(playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60)) {
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
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=source.players[source.currentPlayer].getX(), playy=source.players[source.currentPlayer].getY();

    source.translate(0, 0, z);
    source.drawPortal((x+group.xOffset), (y+group.yOffset), 1);
    source.translate(0, 0, -z);
    if ((playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60&& source.players[source.currentPlayer].z >= z-20 && source.players[source.currentPlayer].z <= z+20)) {
      source.fill(255);
      source.textSize(20);
      source.displayText="Press E";
      source.displayTextUntill=source.millis()+100;
    }

    if (source.E_pressed&&(playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60)) {
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
}
