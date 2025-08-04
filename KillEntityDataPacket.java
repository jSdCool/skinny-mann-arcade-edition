/**A network data packet to request an entity be killed 
*/
public class KillEntityDataPacket extends DataPacket{
  
  public static final Identifier ID = new Identifier("KillEntityDataPacket");
  
  int stage,index;
  /**Create a request to kill an entity
  @param stage The index of the stage the entity is in
  @param index The index of the entity in the stage
  */
  public KillEntityDataPacket(int stage,int index){
    this.stage=stage;
    this.index=index;
  }
  
  /**Recreate a kill entity request from serialized binarry data
  @param iterator The source of the binarry data
  */
  public KillEntityDataPacket(SerialIterator iterator){
    stage = iterator.getInt();
    index = iterator.getInt();
  }
  
  /**Get the stage the entity is on
  @return The index of the stage the entity is on
  */
  public int getStage(){
    return stage;
  }
  
  /**Get the specific entity the request is attempting to kill
  @return the index of the entity
  */
  public int getIndex(){
    return index;
  }
  
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(stage);
    data.addInt(index);
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
