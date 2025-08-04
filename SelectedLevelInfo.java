/**A network data packet for transmitting informatiuon about the selected level in multyplayer from the server to the clients 
*/
public class SelectedLevelInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("SelectedLevelInfo");
  
  String name, author, gameVersion;
  int multyplayerMode, maxPlayers, minPlayers, id;
  boolean exsists=false, isUGC=false;
  /**Create a new level selected info
  */
  public SelectedLevelInfo() {
    exsists=false;
  }
  /**Create a new level selected info
  @param name The name of the level
  @param author The author of the level
  @param version The version the level was built in
  @param mode The multyplayer mode of the level\
  @param min The minimum number of players for co op mode
  @param max The maximum number of players for co op mode
  @param id The numberical id of the level
  @param UGC If this level is a UGC level
  */
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
  /**Recreate a level select info from serialized binarry data
  @param iterator The source of the binarry data
  */
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
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
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
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
