class RequestLevel extends DataPacket {
  
  public static final Identifier ID = new Identifier("RequestLevel");
  
  public RequestLevel(){}
  public RequestLevel(SerialIterator iterator){}
  
  @Override
  public SerializedData serialize() {
    return new SerializedData(id());
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
  
}
