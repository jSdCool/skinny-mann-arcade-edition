import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Ground extends StageComponent {//ground component

  public static final Identifier ID = new Identifier("Ground");

  Ground(JSONObject data, boolean stage_3D) {
    type="ground";
    x=data.getFloat("x");
    y=data.getFloat("y");
    dx=data.getFloat("dx");
    dy=data.getFloat("dy");
    ccolor=data.getInt("color");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Ground(float X, float Y, float DX, float DY, int fcolor) {
    type="ground";
    x=X;
    y=Y;
    dx=DX;
    dy=DY;
    ccolor=fcolor;
  }
  Ground(float X, float Y, float Z, float DX, float DY, float DZ, int fcolor) {
    type="ground";
    x=X;
    y=Y;
    z=Z;
    dx=DX;
    dy=DY;
    dz=DZ;
    ccolor=fcolor;
  }
  
  public Ground(SerialIterator iterator){
    deserial(iterator);
  }
  
  StageComponent copy() {
    return new Ground(x, y, z, dx, dy, dz, ccolor);
  }
  
  StageComponent copy(float offsetX,float offsetY){
    return new Ground(x+offsetX,y+offsetY,dx,dy,ccolor);
  }
  
  StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new Ground(x+offsetX,y+offsetY,z+offsetZ,dx,dy,dz,ccolor);
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
    part.setInt("color", ccolor);
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    render.fill(ccolor);
    render.rect(source.Scale*((x+group.xOffset)-source.drawCamPosX)-0.02f, source.Scale*((y+group.yOffset)+source.drawCamPosY)-0.02f, source.Scale*dx+0.04f, source.Scale*dy+0.04f);
  }

  void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    render.fill(ccolor);
    //strokeWeight(0);
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

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy, z2=(this.z+group.zOffset)+dz;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2 && z>=(this.z+group.zOffset) && z<=z2/* terain hit box*/) {
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
