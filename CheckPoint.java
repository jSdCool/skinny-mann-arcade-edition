import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class CheckPoint extends StageComponent {//ground component
  static skiny_mann source;
  CheckPoint(JSONObject data, boolean stage_3D) {
    type="check point";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  CheckPoint(float X, float Y) {
    type="check point";
    x=X;
    y=Y;
  }
  CheckPoint(float X, float Y, float Z) {
    type="check point";
    x=X;
    y=Y;
    z=Z;
  }
  StageComponent copy() {
    return new CheckPoint(x, y, z);
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
    float playx=source.players[source.currentPlayer].getX();
    boolean po=false;
    if (playx>=(x+group.xOffset)-5 && playx<= (x+group.xOffset)+5 && (y+group.yOffset)-50 <= source.players[source.currentPlayer].getY() && (y+group.yOffset)>=source.players[source.currentPlayer].getY()-10) {
      source.respawnX=(int)x;
      source.respawnY=(int)y;
      source.respawnStage=source.currentStageIndex;
      po=true;
      source.checkpointIn3DStage=false;
    }

    float x2=(x+group.xOffset)-source.drawCamPosX;
    float y2=(y+group.yOffset)+source.drawCamPosY;
    if (po)
      source.fill(-1719293);
    else
      source.fill(-4605510);
    source.rect((x2-3)*source.Scale, (y2-60)*source.Scale, 5*source.Scale, 60*source.Scale);
    source.fill(-1441277);
    source.triangle(x2*source.Scale, (y2-60)*source.Scale, x2*source.Scale, (y2-40)*source.Scale, (x2+30)*source.Scale, (y2-50)*source.Scale);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    //noStroke();
    float playx=source.players[source.currentPlayer].getX();
    boolean po=false;
    if (playx>=(x+group.xOffset)-20 && playx<= (x+group.xOffset)+20 && (y+group.yOffset)-50 <= source.players[source.currentPlayer].getY() && (y+group.yOffset)>=source.players[source.currentPlayer].getY()-10 && source.players[source.currentPlayer].z >= (z+group.zOffset)-20 && source.players[source.currentPlayer].z <= (z+group.zOffset)+20) {
      source.respawnX=(int)x;
      source.respawnY=(int)y;
      source.respawnZ=(int)source.players[source.currentPlayer].z;
      source.respawnStage=source.stageIndex;
      source.checkpointIn3DStage=true;
      po=true;
    }


    if (po)
      source.fill(-1719293);
    else
      source.fill(-4605510);
    //strokeWeight(0);
    source.translate((x+group.xOffset), (y+group.yOffset)-30, (z+group.zOffset));
    source.box(4, 60, 4);
    source.translate(-(x+group.xOffset), -((y+group.yOffset)-30), -(z+group.zOffset));
    source.fill(-1441277);
    source.translate((x+group.xOffset)+10, (y+group.yOffset)-50, (z+group.zOffset));
    source.box(20, 20, 2);
    source.translate(-((x+group.xOffset)+10), -((y+group.yOffset)-50), -(z+group.zOffset));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x>=(this.x+group.xOffset)-8 && x<= (this.x+group.xOffset)+8 && y >= (this.y+group.yOffset)-50 && y <= (this.y+group.yOffset)) {
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
      if (x>=(this.x+group.xOffset)-8 && x<= (this.x+group.xOffset)+8 && y >= (this.y+group.yOffset)-50 && y <= (this.y+group.yOffset) && z>=(this.z+group.zOffset)-8 && z<= (this.z+group.zOffset)+8 ) {
        return true;
      }
    }
    return false;
  }
}
