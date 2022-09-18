import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class HoloTriangle extends StageComponent {//ground component
  int direction;
  HoloTriangle(JSONObject data, boolean stage_3D) {
    type="holoTriangle";
    x=data.getFloat("x1");
    y=data.getFloat("y1");
    dx=data.getFloat("x2");
    dy=data.getFloat("y2");
    ccolor=data.getInt("color");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    direction=data.getInt("rotation");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  HoloTriangle(float x1, float y1, float x2, float y2, int rot, int fcolor) {
    type="holoTriangle";
    x=x1;
    y=y1;
    dx=x2;
    dy=y2;
    direction=rot;
    ccolor=fcolor;
  }
  StageComponent copy() {
    return new HoloTriangle(x, y, dx, dy, direction, ccolor);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x1", x);
    part.setFloat("y1", y);
    part.setFloat("x2", dx);
    part.setFloat("y2", dy);
    part.setInt("color", ccolor);
    part.setString("type", type);
    part.setInt("rotation", direction);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.fill(ccolor);
    if (direction==0) {
      source.triangle(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*((dx+group.xOffset)-source.drawCamPosX), source.Scale*((dy+group.yOffset)+source.drawCamPosY), source.Scale*((dx+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY));
    }
    if (direction==1) {
      source.triangle(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((dy+group.yOffset)+source.drawCamPosY), source.Scale*((dx+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY));
    }
    if (direction==2) {
      source.triangle(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*((dx+group.xOffset)-source.drawCamPosX), source.Scale*((dy+group.yOffset)+source.drawCamPosY), source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((dy+group.yOffset)+source.drawCamPosY));
    }
    if (direction==3) {
      source.triangle(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((dy+group.yOffset)+source.drawCamPosY), source.Scale*((dx+group.xOffset)-source.drawCamPosX), source.Scale*((dy+group.yOffset)+source.drawCamPosY), source.Scale*((dx+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY));
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.fill(ccolor);
    source.strokeWeight(0);
    source.translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, z+dz/2);
    source.box(dx, dy, dz);
    source.translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      float x2 = dx+group.xOffset, y2=dy+group.yOffset, y1=(this.y+group.yOffset), x1=(this.x+group.xOffset), rot=direction;
      if (rot==0) {
        if (x<=x2&&y>=y1&&y<=x*((y2-y1)/(x2-x1)) + (y2-(x2*((y2-y1)/(x2-x1))))  ) {
          return true;
        }
        //triangle(X1,Y1,X2,Y2,X2,Y1);
      }
      if (rot==1) {
        if (x>=x1&&y>=y1&&y<=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ) {
          return true;
        }
        //triangle(X1,Y1,X1,Y2,X2,Y1);
      }
      if (rot==2) {
        if (x>=x1&&y<=y2&&y>=x*((y2-y1)/(x2-x1)) + ( y2-(x2*((y2-y1)/(x2-x1))))  ) {
          return true;
        }
        //triangle(X1,Y1,X2,Y2,X1,Y2);
      }
      if (rot==3) {
        if (x<=x2&&y<=y2&&y>=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ) {
          return true;
        }
        //triangle(X1,Y2,X2,Y2,X2,Y1);
      }
    }
    return false;
  }
}
