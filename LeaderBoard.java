/**Multyplayer Leader board. Contains the raking of each player in speed run mode
*/
public class LeaderBoard extends DataPacket {
  
  public static final Identifier ID = new Identifier("LeaderBoard");
  
  String[] leaderboard;
  /**Create a new leaderboard with the given players
  @param names The list of the names Currently playing this level
  */
  public LeaderBoard(String [] names) {
    leaderboard=names;
  }
  
  /**Recreate a leaderboard from serialized binarry data
  @param iterator The source of the binarry data
  */
  public LeaderBoard(SerialIterator iterator){
    leaderboard = new String[iterator.getInt()];
    for(int i=0;i<leaderboard.length;i++){
      leaderboard[i] = iterator.getString();
    }
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(leaderboard.length);
    for(String s:leaderboard){
      data.addObject(SerializedData.ofString(s));
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
