import java.util.ArrayList;
/**A network data packet for sending basic multyplayer session info to the client
*/
public class InfoForClient extends DataPacket {
  
  public static final Identifier ID = new Identifier("InfoForClient");
  
  int playerNumber;
  ArrayList<String> playerNames;
  String hostVersion;
  boolean inGame=false;
  int sessionTime;
  /**Create a new info for the client
  @param number The number of players in the session
  @param names The names of all players in the session
  @param version The version string of the host
  @param inGame wether or not a level is currently being played
  @param time Current level time
  */
  public InfoForClient(int number, ArrayList<String> names, String version, boolean inGame, int time) {
    playerNumber=number;
    playerNames=names;
    hostVersion=version;
    this.inGame=inGame;
    sessionTime=time;
  }
  
  /**Recreate an info for client from serialized binarry data
  @param iterator The source of the data
  */
  public InfoForClient(SerialIterator iterator){
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
 
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
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
  
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
