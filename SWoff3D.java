import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class SWoff3D extends StageComponent {//ground component
  SWoff3D(JSONObject data, boolean stage_3D) {
    type="3DoffSW";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  SWoff3D(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    type="3DoffSW";
  }
  
  StageComponent copy() {
    return new SWoff3D(x, y, z);
  }
  
  StageComponent copy(float offsetX,float offsetY){
    return new SWoff3D(x=offsetX,y+offsetY,z);
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new SWoff3D(x+offsetX,y+offsetY,z+offsetZ);
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
    source.draw3DSwitch2(((x+group.xOffset)-source.drawCamPosX), ((y+group.yOffset)+source.drawCamPosY), source.Scale);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.draw3DSwitch2((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), source.Scale);
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
  
  public Collider2D getCollider2D(){
    return null;
  }
  public Collider3D getCollider3D(){ 
    return null;
  }
}
