import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Goal extends StageComponent {//ground component
  Goal(JSONObject data, boolean stage_3D) {
    type="goal";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Goal(float X, float Y) {
    type="goal";
    x=X;
    y=Y;
  }

  StageComponent copy() {
    return new Goal(x, y);
  }
  
  StageComponent copy(float offsetX,float offsetY){
    return new Goal(x+offsetX,y+offsetY);
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    System.err.println("attempted to copy a goal in 3D. This opperation is not supported");
    return null;
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
    float x2 = (x+group.xOffset)-source.drawCamPosX, y2 = (y+group.yOffset);
    source.fill(255);
    source.rect(source.Scale*x2, source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    source.rect(source.Scale*(x2+100), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    source.rect(source.Scale*(x2+200), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    source.fill(0);
    source.rect(source.Scale*(x2+50), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);
    source.rect(source.Scale*(x2+150), source.Scale*(y2+source.drawCamPosY), source.Scale*50, source.Scale*50);

    float px =source.players[source.currentPlayer].getX(), py=source.players[source.currentPlayer].getY();

    if (px >= x2+source.drawCamPosX && px <= x2+source.drawCamPosX + 250 && py >= y2 - 50 && py <= y2 + 50) {
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

  void draw3D() {
  }

  boolean colide(float x, float y, boolean c) {
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
}
