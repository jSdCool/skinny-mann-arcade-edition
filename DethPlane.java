import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class DethPlane extends StageComponent {//ground component
  DethPlane(JSONObject data, boolean stage_3D) {
    type="dethPlane";
    x=data.getFloat("x");
    y=data.getFloat("y");
    dx=data.getFloat("dx");
    dy=data.getFloat("dy");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  DethPlane(float X, float Y, float DX, float DY) {
    type="dethPlane";
    x=X;
    y=Y;
    dx=DX;
    dy=DY;
  }
  StageComponent copy() {
    return new DethPlane(x, y, dx, dy);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setFloat("dx", dx);
    part.setFloat("dy", dy);
    if (stage_3D) {
      part.setFloat("z", z);
      part.setFloat("dz", dz);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.fill(-114431);
    source.rect(source.Scale*((x+group.xOffset)-source.drawCamPosX)-1, source.Scale*((y+group.yOffset)+source.drawCamPosY)-1, source.Scale*dx+2, source.Scale*dy+2);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.fill(-114431);
    source.strokeWeight(0);
    source.translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, (z+group.zOffset)+dz/2);
    source.box(dx, dy, dz);
    source.translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*((z+group.zOffset)+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }

  boolean colideDethPlane(float x, float y) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 =(this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }
}
