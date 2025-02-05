class BestScore extends DataPacket {
  
  public static final Identifier ID = new Identifier("BestScore");
  
  String name;
  int score;
  BestScore(String n, int s) {
    name=n;
    score=s;
  }
  
  public BestScore(SerialIterator iterator){
    score = iterator.getInt();
    name = iterator.getString();
  }
  
 
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(score);
    data.addObject(SerializedData.ofString(name));
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
