import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class WritableSign extends StageComponent {
  String contents;
  WritableSign(JSONObject data, boolean stage_3D) {
    type="WritableSign";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    contents=data.getString("contents");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  WritableSign(float X, float Y) {
    x=X;
    y=Y;
    contents="";
    type="WritableSign";
  }
  WritableSign(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    contents="";
    type="WritableSign";
  }
  StageComponent copy() {
    WritableSign e=new WritableSign(x, y, z);
    e.contents=contents;
    return  e;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSign(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale);

    float playx=source.players[source.currentPlayer].getX(), playy=source.players[source.currentPlayer].getY();
    if (playx>(x+group.xOffset)-35&&playx<(x+group.xOffset)+35&&playy>(y+group.yOffset)-40&&playy<(y+group.yOffset)) {//display the press e message to the player
      source.fill(255);
      source.textSize(source.Scale*20);
      source.displayText="Press E";
      source.displayTextUntill=source.millis()+100;

      if (source.E_pressed) {
        source.E_pressed=false;
        source.viewingItemContents=true;
      }
    }
  }
  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSign((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), source.Scale);

    float playx=source.players[source.currentPlayer].getX(), playy=source.players[source.currentPlayer].getY();
    if (playx>(x+group.xOffset)-35&&playx<(x+group.xOffset)+35&&playy>(y+group.yOffset)-40&&playy<(y+group.yOffset)&& source.players[source.currentPlayer].z >= (z+group.zOffset)-20 && source.players[source.currentPlayer].z <= (z+group.zOffset)+20) {
      source.fill(255);
      source.textSize(source.Scale*20);
      source.displayText="Press E";
      source.displayTextUntill=source.millis()+100;
      if (source.E_pressed) {
        source.E_pressed=false;
        source.viewingItemContents=true;
      }
    }
  }
  boolean colide(float x, float y, boolean c) {
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

  boolean colide(float x, float y, float z, boolean c) {
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

  JSONObject save(boolean stage_3D) {
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

  void setData(String data) {
    contents=data;
  }

  String getData() {
    return contents;
  }
}
