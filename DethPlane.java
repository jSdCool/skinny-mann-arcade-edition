import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A solid rectangle compoentn that kills what stands on top of it
*/
public class DethPlane extends StageComponent {//ground component

  public static final Identifier ID = new Identifier("dethPlane");
  /**Load a deth plane from saved JOSN data
  @param data The JSON Object containing the check point data
  */
  public DethPlane(JSONObject data) {
    type="dethPlane";
    x=data.getFloat("x");
    y=data.getFloat("y");
    dx=data.getFloat("dx");
    dy=data.getFloat("dy");
    
    boolean stage_3D = data.getBoolean("s3d");
    
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  
  /**Place a new deth plane
  @param context The context for the placement
  */
  public DethPlane(StageComponentDragPlacementContext context){
    type="dethPlane";
    x = context.getX();
    y = context.getY();
    dx = context.getDX();
    dy = context.getDY();
    if(context.has3D()){
      z = context.getZ();
      dx = context.getDZ();
    }
  }
  
  public StageComponent copy() {
    return new DethPlane(new StageComponentDragPlacementContext(x, y, dx, dy,0));
  }

  public StageComponent copy(float offsetX, float offsetY) {
    return new DethPlane(new StageComponentDragPlacementContext(x+offsetX, y+offsetY, dx, dy,0));
  }

  public StageComponent copy(float offsetX, float offsetY, float offsetZ) {
    System.err.println("Attempted to create a 3D copy of a deth plane. This opperation is not supported");
    return null;
  }
  /**Create a deth plane from serialized binarry data
  @param iterator The source of the data
  */
  public DethPlane(SerialIterator iterator){
    deserial(iterator);
  }
  /**Get a JSONObject representation of this component that can be saved to a file
  @param stage_3D Wether this stage is a 3D stage
  @return JSONObject representation of this object
  */
  public JSONObject save(boolean stage_3D) {
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
  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    render.fill(-114431);
    render.rect(source.Scale*((x+group.xOffset)-source.drawCamPosX)-0.02f, source.Scale*((y+group.yOffset)+source.drawCamPosY)-0.02f, source.Scale*dx+0.04f, source.Scale*dy+0.04f);
  }
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    render.fill(-114431);
    render.strokeWeight(0);
    render.translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, (z+group.zOffset)+dz/2);
    render.box(dx, dy, dz);
    render.translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*((z+group.zOffset)+dz/2));
  }
  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }
  /**Check if this position is colliding with a deth plane
  @param x The x position 
  @param y The y position
  @return true if a collision is occoring
  */
  public boolean colideDethPlane(float x, float y) {
    //note to self consider replacing this with the new hitbox system
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 =(this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }
  /**Get the 2D collision box for entitiy collisions
  @return 2D hitbox for this component or null for none
  */
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
  /**Get the 3D collision box for entitiy collisions
  @return 3D hitbox for this component or null for none
  */
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
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    return data;
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
