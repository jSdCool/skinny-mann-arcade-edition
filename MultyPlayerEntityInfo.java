/**Sends data about an entity from the server to the client in multyplayer mode 2
*/
class MultyPlayerEntityInfo extends DataPacket{
  
  public static final Identifier ID = new Identifier("MultyplayerEntityInfo");
  
  float x,y,z;
  int stage,index;
  boolean dead;
  /**Used on the server to create a data packet of info to send to the clients
  @param stage The index of the stages the entity is on
  @param entityIndex The index of the entity on the stage
  @param entity The entity to send data of
  */
  public MultyPlayerEntityInfo(int stage,int entityIndex,StageEntity entity){
    this.stage=stage;
    this.index = entityIndex;
    this.x = entity.getX();
    this.y = entity.getY();
    this.z = entity.getZ();
    this.dead = entity.isDead();
  }
  
  /**Recreate this packet from serialized binarry data
  @param iterator The source of the data
  */
  public MultyPlayerEntityInfo(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    stage = iterator.getInt();
    index = iterator.getInt();
    dead = iterator.getBoolean();
  }
  
  /**Used by the client to extract entity position information
  @param entity The entity to set the position of
  */
  void setPos(StageEntity entity){
    entity.setX(x);
    entity.setY(y);
    entity.setZ(z);
  }
  
  /**Used by the client to extract the entiotes death status
  @param entity The entity to set the death stsatus of
  */
  void setDead(StageEntity entity){
    if(dead){
      if(!entity.isDead()){
        entity.kill();
      }
    }else{
      if(entity.isDead()){
        entity.respawn();
      }
    }
  }
  
  /**Get the index of the stage this entity is on
  @return The stage index of the entity
  */
  int getStage(){
    return stage;
  }
  
  /**Get the index of the entity
  @return The index of the entity on the stage
  */
  int getIndex(){
    return index;
  }
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addFloat(x);
    data.addFloat(y);
    data.addFloat(z);
    data.addInt(stage);
    data.addInt(index);
    data.addBool(dead);
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
