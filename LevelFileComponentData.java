class LevelFileComponentData extends DataPacket {
  
  public static final Identifier ID = new Identifier("LevelFileComponentData");
  
  byte data[];
  LevelFileComponentData(byte data[]) {
    this.data=data;
  }
  
  public LevelFileComponentData(SerialIterator iterator){
    data = new byte[iterator.getInt()];
    for(int i=0;i<data.length;i++){
      data[i] = iterator.getByte();
    }
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    
    data.addInt(this.data.length);
    for(byte b:this.data){
      data.addByte(b);
    }
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
