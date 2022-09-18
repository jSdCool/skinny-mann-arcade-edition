import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Coin extends StageComponent {//ground component
  int coinId;
  Coin(JSONObject data, boolean stage_3D) {
    type="coin";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    coinId=data.getInt("coin id");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Coin(float X, float Y, int ind) {
    x=X;
    y=Y;
    coinId=ind;
    type="coin";
  }
  Coin(float X, float Y, float Z, int ind) {
    x=X;
    y=Y;
    coinId=ind;
    type="coin";
    z=Z;
  }
  StageComponent copy() {
    return new Coin(x, y, z, coinId);
  }
  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("coin id", coinId);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=source.players[source.currentPlayer].getX(), playy=source.players[source.currentPlayer].getY();
    boolean collected;
    if (source.editingBlueprint) {
      collected=false;
    } else {
      if (source.coins.size()==0)
        collected=false;
      else
        collected=source.coins.get(coinId);
    }
    float x2=(x+group.xOffset)-source.drawCamPosX;
    if (!collected) {
      source.drawCoin(source.Scale*x2, source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*3);
      if (Math.sqrt(Math.pow(playx-source.drawCamPosX-x2, 2)+Math.pow(playy-(y+group.yOffset), 2))<30) {
        source.coins.set(coinId, true);
        source.coinCount++;
      }
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=source.players[source.currentPlayer].getX(), playy=source.players[source.currentPlayer].getY(), playz=source.players[source.currentPlayer].z;
    boolean collected=source.coins.get(coinId);

    if (!collected) {
      source.translate((x+group.xOffset), (y+group.yOffset), (z+group.zOffset));
      source.rotateY(source.radians(source.coinRotation));
      source.shape(source.coin3D);
      source.rotateY(source.radians(-source.coinRotation));
      source.translate(-(x+group.xOffset), -(y+group.yOffset), -(z+group.zOffset));
      if (Math.sqrt(Math.pow(playx-(x+group.xOffset), 2)+Math.pow(playy-(y+group.yOffset), 2)+Math.pow(playz-(z+group.zOffset), 2))<35) {
        source.coins.set(coinId, true);
        source.coinCount++;
      }
    }
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (Math.sqrt(Math.pow(x-(this.x+group.xOffset), 2)+Math.pow(y-(this.y+group.yOffset), 2))<19) {
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
      if (Math.sqrt(Math.pow(x-(this.x+group.xOffset), 2)+Math.pow(y-(this.y+group.yOffset), 2)+Math.pow(z-(this.z+group.zOffset), 2))<19) {
        return true;
      }
    }
    return false;
  }
}
