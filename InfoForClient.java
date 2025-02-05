import java.util.ArrayList;
class InfoForClient extends DataPacket {
  
  public static final Identifier ID = new Identifier("InfoForClient");
  
  int playerNumber;
  ArrayList<String> playerNames;
  String hostVersion;
  boolean inGame=false;
  int sessionTime;
  InfoForClient(int number, ArrayList<String> names, String version, boolean inGame, int time) {
    playerNumber=number;
    playerNames=names;
    hostVersion=version;
    this.inGame=inGame;
    sessionTime=time;
  }
  
  InfoForClient(SerialIterator iterator){
    playerNumber = iterator.getInt();
    hostVersion = iterator.getString();
    inGame = iterator.getBoolean();
    sessionTime = iterator.getInt();
    int numNames = iterator.getInt();
    playerNames = new ArrayList<>();
    for(int i=0;i<numNames;i++){
      playerNames.add(iterator.getString());
    }
  }
 
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(playerNumber);
    data.addObject(SerializedData.ofString(hostVersion));
    data.addBool(inGame);
    data.addInt(sessionTime);
    data.addInt(playerNames.size());
    for(int i=0;i<playerNames.size();i++){
      data.addObject(SerializedData.ofString(playerNames.get(i)));
    }
    
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
