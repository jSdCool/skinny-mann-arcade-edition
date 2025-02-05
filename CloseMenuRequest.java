class CloseMenuRequest extends DataPacket {
  public static final Identifier ID = new Identifier("CloseMenuRequest");
  
  public CloseMenuRequest(){}
  
  public CloseMenuRequest(SerialIterator iterator){}
  
  @Override
  public SerializedData serialize() {
    return new SerializedData(id());
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
