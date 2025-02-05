import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class DethPlane extends StageComponent {//ground component

  public static final Identifier ID = new Identifier("DeathPlane");

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

  StageComponent copy(float offsetX, float offsetY) {
    return new DethPlane(x+offsetX, y+offsetY, dx, dy);
  }

  StageComponent copy(float offsetX, float offsetY, float offsetZ) {
    System.err.println("Attempted to create a 3D copy of a deth plane. This opperation is not supported");
    return null;
  }
  
  public DethPlane(SerialIterator iterator){
    deserial(iterator);
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

  void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    render.fill(-114431);
    render.rect(source.Scale*((x+group.xOffset)-source.drawCamPosX)-0.02f, source.Scale*((y+group.yOffset)+source.drawCamPosY)-0.02f, source.Scale*dx+0.04f, source.Scale*dy+0.04f);
  }

  void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    render.fill(-114431);
    render.strokeWeight(0);
    render.translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, (z+group.zOffset)+dz/2);
    render.box(dx, dy, dz);
    render.translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*((z+group.zOffset)+dz/2));
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

  public Collider2D getCollider2D() {
    Group group=getGroup();
    if (!group.visable)
        return null;
    return new Collider2D(new PVector[]{
      new PVector(x+group.xOffset, y+group.yOffset),
      new PVector(x+group.xOffset+dx, y+group.yOffset),
      new PVector(x+group.xOffset+dx, y+group.yOffset+dy),
      new PVector(x+group.xOffset, y+group.yOffset+dy)
      });
  }
  public Collider3D getCollider3D() {
    Group group=getGroup();
    if (!group.visable)
        return null;
    return new Collider3D(new PVector[]{
      new PVector(x+group.xOffset, y+group.yOffset, z+group.zOffset),
      new PVector(x+group.xOffset+dx, y+group.yOffset, z+group.zOffset),
      new PVector(x+group.xOffset+dx, y+group.yOffset+dy, z+group.zOffset),
      new PVector(x+group.xOffset, y+group.yOffset+dy, z+group.zOffset),
      new PVector(x+group.xOffset, y+group.yOffset, z+group.zOffset+dz),
      new PVector(x+group.xOffset+dx, y+group.yOffset, z+group.zOffset+dz),
      new PVector(x+group.xOffset+dx, y+group.yOffset+dy, z+group.zOffset+dz),
      new PVector(x+group.xOffset, y+group.yOffset+dy, z+group.zOffset+dz)
      });
  }
  
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
