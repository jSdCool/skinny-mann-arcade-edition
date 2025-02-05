class KillEntityDataPacket extends DataPacket{
  
  public static final Identifier ID = new Identifier("KillEntityDataPacket");
  
  int stage,index;
  KillEntityDataPacket(int stage,int index){
    this.stage=stage;
    this.index=index;
  }
  
  public KillEntityDataPacket(SerialIterator iterator){
    stage = iterator.getInt();
    index = iterator.getInt();
  }
  
  public int getStage(){
    return stage;
  }
  
  public int getIndex(){
    return index;
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(stage);
    data.addInt(index);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
