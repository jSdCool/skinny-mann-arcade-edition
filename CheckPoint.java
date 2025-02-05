import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import processing.core.*;

class CheckPoint extends StageComponent {//ground component
  static transient skiny_mann source;
  public static final Identifier ID = new Identifier("CheckPoint");
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
  
  public CheckPoint(SerialIterator iterator){
    deserial(iterator);
  }
  
  StageComponent copy() {
    return new CheckPoint(x, y, z);
  }
  
  StageComponent copy(float offsetX,float  offsetY){
    return new CheckPoint(x+offsetX,y+offsetY);
  }
  
  StageComponent copy(float offsetX,float  offsetY,float offsetZ){
    return new CheckPoint(x+offsetZ,y+offsetY,z+offsetZ);
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

  void draw(PGraphics render) {
    Group group=getGroup();
    //TODO: move this off the render thread
    if (!group.visable)
      return;
    Collider2D playerBox=source.players[source.currentPlayer].getHitBox2D(0,0);
    boolean po=false;
    if (source.collisionDetection.collide2D(playerBox,new Collider2D(new PVector[]{new PVector(x-3,y-60),new PVector(x+3,y-60),new PVector(x+3,y),new PVector(x-3,y)}))) {
      source.respawnX=(int)x;
      source.respawnY=(int)y;
      source.respawnStage=source.currentStageIndex;
      po=true;
      source.checkpointIn3DStage=false;
    }

    float x2=(x+group.xOffset)-source.drawCamPosX;
    float y2=(y+group.yOffset)+source.drawCamPosY;
    if (po)
      render.fill(-1719293);
    else
      render.fill(-4605510);
    render.rect((x2-3)*source.Scale, (y2-60)*source.Scale, 5*source.Scale, 60*source.Scale);
    render.fill(-1441277);
    render.triangle(x2*source.Scale, (y2-60)*source.Scale, x2*source.Scale, (y2-40)*source.Scale, (x2+30)*source.Scale, (y2-50)*source.Scale);
  }

  void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    //noStroke();
    Collider3D playerBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
    boolean po=false;
    if (source.collisionDetection.collide3D(playerBox,new Collider3D(new PVector[]{ new PVector(x-3,y-60,z-3),new PVector(x+3,y-60,z-3),new PVector(x+3,y,z-3),new PVector(x-3,y,z-3),new PVector(x-3,y-60,z+3),new PVector(x+3,y-60,z+3),new PVector(x+3,y,z+3),new PVector(x-3,y,z+3) } ))) {
      source.respawnX=(int)x;
      source.respawnY=(int)y;
      source.respawnZ=(int)source.players[source.currentPlayer].z;
      source.respawnStage=source.stageIndex;
      source.checkpointIn3DStage=true;
      po=true;
    }


    if (po)
      render.fill(-1719293);
    else
      render.fill(-4605510);
    //strokeWeight(0);
    render.translate((x+group.xOffset), (y+group.yOffset)-30, (z+group.zOffset));
    render.box(4, 60, 4);
    render.translate(-(x+group.xOffset), -((y+group.yOffset)-30), -(z+group.zOffset));
    render.fill(-1441277);
    render.translate((x+group.xOffset)+10, (y+group.yOffset)-50, (z+group.zOffset));
    render.box(20, 20, 2);
    render.translate(-((x+group.xOffset)+10), -((y+group.yOffset)-50), -(z+group.zOffset));
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
  
  public Collider2D getCollider2D(){
    return null;
  }
  public Collider3D getCollider3D(){ 
    return null;
  }
  
  //SerialIterator iterator
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
