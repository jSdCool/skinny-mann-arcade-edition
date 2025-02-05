class RequestLevelFileComponent extends DataPacket {

  public static final Identifier ID = new Identifier("RequestLevelFileComponent");
  
  int file, block;
  RequestLevelFileComponent(int file, int block) {
    this.file=file;
    this.block=block;
  }
  
  public RequestLevelFileComponent(SerialIterator iterator){
    file = iterator.getInt();
    block = iterator.getInt();
  }
  
  @Override
  public SerializedData serialize() {
    
    SerializedData data = new SerializedData(id());
    data.addInt(file);
    data.addInt(block);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
