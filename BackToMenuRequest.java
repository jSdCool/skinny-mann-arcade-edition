class BackToMenuRequest extends DataPacket {
  
  public static final Identifier ID = new Identifier("BackToMenuRequest");
  
  public BackToMenuRequest(){}
  
  public BackToMenuRequest(SerialIterator iterator){}

  @Override
  public SerializedData serialize() {
    return new SerializedData(id());
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
