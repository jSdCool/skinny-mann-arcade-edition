import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SWon3D extends StageComponent {//ground component
  SWon3D(JSONObject data, boolean stage_3D) {
    type="3DonSW";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  SWon3D(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    type="3DonSW";
  }
  
  StageComponent copy() {
    return new SWon3D(x, y, z);
  }
  
  StageComponent copy(float offsetX,float offsetY){
    return new SWon3D(x+offsetX,y+offsetY,z);
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new SWon3D(x+offsetX,y+offsetY,z+offsetZ);
  }
  
  JSONObject save(boolean stage_3D) {
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

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.draw3DSwitch1(((x+group.xOffset)-source.drawCamPosX), ((y+group.yOffset)+source.drawCamPosY), source.Scale);
    if (source.players[source.currentPlayer].x>=(x+group.xOffset)-10&&source.players[source.currentPlayer].x<=(x+group.xOffset)+10&&source.players[source.currentPlayer].y >=(y+group.yOffset)-10&&source.players[source.currentPlayer].y<= (y+group.yOffset)+2) {
      source.players[source.currentPlayer].z=z;
      source.e3DMode=true;
      source.gmillis=source.millis()+1200;
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.draw3DSwitch1((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), source.Scale);
  }

  boolean colide(float x, float y, boolean c) {
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

  boolean colide(float x, float y, float z, boolean c) {
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
}
