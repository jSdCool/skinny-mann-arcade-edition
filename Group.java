/**Common modification information for a group of stage compoentns in a level
*/
public class Group implements Serialization {
  public boolean visable=true;
  public float xOffset=0, yOffset=0, zOffset=0;
  
  public static final Identifier ID = new Identifier("Group");
  
  /**Create a new group
  */
  public Group(){}
  
  /**Load a groupd from serialized binarry data
  @param iterator The source of the binarry data
  */
  public Group(SerialIterator iterator){
    visable = iterator.getBoolean();
    xOffset = iterator.getFloat();
    yOffset = iterator.getFloat();
    zOffset = iterator.getFloat();
  }
  
  /**Convert this object to a byte representation that can be sent over the network or saved to a file.<br>
  @return This object as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addBool(visable);
    data.addFloat(xOffset);
    data.addFloat(yOffset);
    data.addFloat(zOffset);
    return data;
  }
  
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
  
  /**Get wether components in this groups should be visable
  @return true if the opbjects should be visable
  */
  public boolean isVisable(){
    return visable;
  }
  
  /**Get the x offset components in this group should have
  @return The x offset compoentns should have
  */
  public float getXOffset(){
    return xOffset;
  }
  /**Get the y offset components in this group should have
  @return The y offset compoentns should have
  */
  public float getYOffset(){
    return yOffset;
  }
  /**Get the z offset components in this group should have
  @return The z offset compoentns should have
  */
  public float getZOffset(){
    return zOffset;
  }
  
  /**Set wether components in this group should be visable
  @param v Wether components in this group should be visable
  */
  public void setVisable(boolean v){
    visable = v;
  }
  
  /**Set what x offset compoentns in thsi group should have
  @param x The new x offset
  */
  public void setxOffset(float x){
    xOffset = x;
  }
  
  /**Set what y offset compoentns in thsi group should have
  @param y The new y offset
  */
  public void setyOffset(float y){
    yOffset = y;
  }
  
  /**Set what z offset compoentns in thsi group should have
  @param z The new z offset
  */
  public void setzOffset(float z){
    zOffset = z;
  }
}
