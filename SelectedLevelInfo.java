
class SelectedLevelInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("SelectedLevelInfo");
  
  String name, author, gameVersion;
  int multyplayerMode, maxPlayers, minPlayers, id;
  boolean exsists=false, isUGC=false;
  public SelectedLevelInfo() {
    exsists=false;
  }
  public SelectedLevelInfo(String name, String author, String version, int mode, int min, int max, int id, boolean UGC) {
    exsists=true;
    this.name=name;
    this.author=author;
    gameVersion=version;
    multyplayerMode=mode;
    minPlayers=min;
    maxPlayers=max;
    isUGC=UGC;
    this.id=id;
  }
  
  public SelectedLevelInfo(SerialIterator iterator){
    name = iterator.getString();
    author = iterator.getString();
    gameVersion = iterator.getString();
    multyplayerMode = iterator.getInt();
    maxPlayers = iterator.getInt();
    minPlayers = iterator.getInt();
    id = iterator.getInt();
    exsists = iterator.getBoolean();
    isUGC = iterator.getBoolean();
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(SerializedData.ofString(name!=null?name:""));
    data.addObject(SerializedData.ofString(author!=null?author:""));
    data.addObject(SerializedData.ofString(gameVersion!=null?gameVersion:""));
    data.addInt(multyplayerMode);
    data.addInt(maxPlayers);
    data.addInt(minPlayers);
    data.addInt(id);
    data.addBool(exsists);
    data.addBool(isUGC);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
