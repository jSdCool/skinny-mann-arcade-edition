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
  
  StageComponent copy(float offsetX,float offsetY){
    return new Coin(x+offsetX,y+offsetY,coinId);
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new Coin(x+offsetX,y+offsetY,z+offsetZ,coinId);
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
      Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);
      if (!source.selectingBlueprint && source.collisionDetection.collide2D(playerHitBox,new CircleCollider(new PVector(x,y),14))) {
        source.coins.set(coinId, true);
        source.coinCount++;
        if(!source.levelCreator){
          source.stats.incrementCollectedCoins();
        }
      }
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    boolean collected;
    if (source.editingBlueprint) {
      collected=false;
    } else {
      if (source.coins.size()==0)
        collected=false;
      else
        collected=source.coins.get(coinId);
    }

    if (!collected) {
      source.translate((x+group.xOffset), (y+group.yOffset), (z+group.zOffset));
      source.rotateY(source.radians(source.coinRotation));
      source.shape(source.coin3D);
      source.rotateY(source.radians(-source.coinRotation));
      source.translate(-(x+group.xOffset), -(y+group.yOffset), -(z+group.zOffset));

      Collider3D playerHitBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
      if (!source.selectingBlueprint && source.collisionDetection.collide3D(playerHitBox, new SphereCollider(new PVector(x,y,z),14))) {
        source.coins.set(coinId, true);
        source.coinCount++;
        if(!source.levelCreator){
          source.stats.incrementCollectedCoins();
        }
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
  
  public Collider2D getCollider2D(){
    return null;
  }
  public Collider3D getCollider3D(){ 
    return null;
  }
}
