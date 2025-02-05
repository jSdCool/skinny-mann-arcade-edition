class LoadLevelRequest extends DataPacket {
  
  public static final Identifier ID = new Identifier("LevelLoadRequest");
  
  boolean isBuiltIn=false;
  String path, hash;
  int id;
  LoadLevelRequest(String location) {
    isBuiltIn=true;
    path=location;
  }
  LoadLevelRequest(int levelId, String levelHash) {
    isBuiltIn=false;
    id=levelId;
    hash=levelHash;
  }
  
  public LoadLevelRequest(SerialIterator iterator){
    isBuiltIn = iterator.getBoolean();
    path = iterator.getString();
    hash = iterator.getString();
    id = iterator.getInt();
  }
  
  @Override
  public SerializedData serialize() {
    
    SerializedData data = new SerializedData(id());
    data.addBool(isBuiltIn);
    data.addObject(SerializedData.ofString(path));
    data.addObject(SerializedData.ofString(hash));
    data.addInt(id);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
