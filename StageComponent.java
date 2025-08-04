import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/**The base class for all components that exsist inside of and make up a stage
*/
public abstract class StageComponent implements Serialization {//the base class for all components that exsist inside a stage
  static transient skiny_mann source;
  public float x, y, z, dx, dy, dz;
  public int ccolor, group=-1;
  public String type;
  
  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public abstract void draw(PGraphics render);
  
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public abstract void draw3D(PGraphics render);
  
  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, boolean c) {
    return false;
  }//c= is colideing with click box
  
  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param z The z position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, float z, boolean c) {
    return false;
  }
  
  /**Check if this position is colliding with a deth plane
  @param x The x position 
  @param y The y position
  @return true if a collision is occoring
  */
  public boolean colideDethPlane(float x, float y) {
    return false;
  }
  
  /**Get a JSONObject representation of this component that can be saved to a file
  @param stage_3D Wether this stage is a 3D stage
  @return JSONObject representation of this object
  */
  public abstract JSONObject save(boolean stage_3D);

  /**Set a string data property
  @param data The data to set
  */
  @Deprecated
  public void setData(String data) {
  }
  
  /**Set an integer data property
  @param data The data to set
  */
  @Deprecated
  public void setData(int data) {
  }

  /**Get the value of a string data proerty
  @return The value of the string data
  */
  @Deprecated
  public String getData() {
    return null;
  }
  
  /**Get the value of an integer data proerty
  @return The value of the int data
  */
  @Deprecated
  public int getDataI() {
    return -1;
  }
  
  /**Make a copy of this component.<br>
  Used by blueprint pasting.
  @return A new object that is a carbon coppy of this object but points to a diffrent place in memory
  */
  public abstract StageComponent copy();
  /**Make a copy of this component.<br>
  Used by blueprint pasting.
  @param offsetX How far to offset the copy in the X - axis
  @param offsetY How far to offset the copy in the Y - axis
  @return A new object that is a carbon coppy of this object but points to a diffrent place in memory
  */
  public abstract StageComponent copy(float offsetX,float  offsetY);
  /**Make a copy of this component.<br>
  Used by blueprint pasting.
  @param offsetX How far to offset the copy in the X - axis
  @param offsetY How far to offset the copy in the Y - axis
  @param offsetZ How far to offset the copy in the Z - axis
  @return A new object that is a carbon coppy of this object but points to a diffrent place in memory
  */
  public abstract StageComponent copy(float offsetX,float  offsetY,float offsetZ);
  
  /**Get the current group this component is accosicated with
  @return The group this object is accocitated with
  */
  public Group getGroup() {
    //if no group is selceted
    if (group==-1){
      return new Group();//return the base group
    }
    //if there is not level
    if(source.level == null){
      return new Group();//return the base group
    }
    //if the selected group is outside the range of the groups that exsist
    if(group>=source.level.groups.size()){
      return new Group();
    }
    //return the group
    return source.level.groups.get(group);
  }
  
  /**Set the group this object belongs to
  @param grp The group to set, set to -1 for none
  */
  public void setGroup(int grp) {
    group=grp;
  }
  
  /**Process Interactions between this component and the stage
  @param data Some sort of useful data to the interaction, potential the index of the stage
  */
  public void worldInteractions(int data) {
  }
  
  /**Get the 2D collision box for entitiy collisions
  @return 2D hitbox for this component or null for none
  */
  abstract public Collider2D getCollider2D();
  /**Get the 3D collision box for entitiy collisions
  @return 3D hitbox for this component or null for none
  */
  abstract public Collider3D getCollider3D();
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  This representation is contained inside of the passed in object
  @param data The object the bytes will be written to, may allready contain the data of other objects
  */
  public void serialize(SerializedData data){
    data.addFloat(x);
    data.addFloat(y);
    data.addFloat(z);
    data.addFloat(dx);
    data.addFloat(dy);
    data.addFloat(dz);
    data.addInt(ccolor);
    data.addInt(group);
    data.addObject(SerializedData.ofString(type));
  }
  
  /**Deserialize common stage comononet data, the inverse of serialize
  @param iterator the iterator that contains the serial data
  */
  public void deserial(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    dx = iterator.getFloat();
    dy = iterator.getFloat();
    dz = iterator.getFloat();
    ccolor = iterator.getInt();
    group = iterator.getInt();
    type = iterator.getString();
  }
  
  /**Get the position at the current center of this component
  @return A PVector representing the center of the component
  */
  public PVector getCenter(){
     Group group = getGroup();
     return new PVector(getX()+getWidth()/2+group.xOffset,getY()+getHeight()/2+group.yOffset,getZ()+getDepth()/2+group.zOffset);
  }
  
  /**Get the X position of the upper left corner of the compoent, or the x value of the component
  @return the x position of this compoenent
  */
  public float getX(){
    return x;
  }
  
  /**Get the Y position of the upper left corner of the compoent, or the y value of the component
  @return the y position of this compoenent
  */
  public float getY(){
    return y;
  }
  
  /**Get the Z position of the upper left corner of the compoent, or the z value of the component
  @return the z position of this compoenent
  */
  public float getZ(){
    return z;
  }
  
  /**Get the width of the component
  @return the width position of this compoenent
  */
  public float getWidth(){
    return dx;
  }
  
  /**Get the height of the component
  @return the height position of this compoenent
  */
  public float getHeight(){
    return dy;
  }
  
  /**Get the depth of the component
  @return the depth position of this compoenent
  */
  public float getDepth(){
    return dz;
  }
  
  /**Set the X position of the upper left corner of the compoent, or the x value of the component
  @param x The new x position
  */
  public void setX(float x){
    this.x=x;
  }
  /**Set the Y position of the upper left corner of the compoent, or the y value of the component
  @param y The new y position
  */
  public void setY(float y){
    this.y=y;
  }
  /**Set the Z position of the upper left corner of the compoent, or the z value of the component
  @param z The new z position
  */
  public void setZ(float z){
    this.z=z;
  }
  /**Set the width position of the upper left corner of the compoent, or the width value of the component
  @param w The new width
  */
  public void setWidth(float w){
    dx=w;
  }
  /**Set the height position of the upper left corner of the compoent, or the height value of the component
  @param h The new x position
  */
  public void setHeight(float h){
    dy=h;
  }
  /**Set the depth position of the upper left corner of the compoent, or the depth value of the component
  @param d The new depth position
  */
  public void setDepth(float d){
    dz=d;
  }
  
}
