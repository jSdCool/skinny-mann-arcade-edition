class Group implements Serialization {
  public boolean visable=true;
  public float xOffset=0, yOffset=0, zOffset=0;
  
  public static final Identifier ID = new Identifier("Group");
  
  Group(){}
  
  Group(SerialIterator iterator){
    visable = iterator.getBoolean();
    xOffset = iterator.getFloat();
    yOffset = iterator.getFloat();
    zOffset = iterator.getFloat();
  }
  
  //SerialIterator iterator
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addBool(visable);
    data.addFloat(xOffset);
    data.addFloat(yOffset);
    data.addFloat(zOffset);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
