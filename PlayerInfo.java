/**A network data packet containg information about the players in a session. Sent from the server to the clients
*/
public class PlayerInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("PlayerInfo");
  
  Player[] players;
  boolean[] visable;
  /**Create a new player info packet
  @param players The current players in the game
  @param viablePlayers Same length as the players, represens wich players should be renderd
  */
  public PlayerInfo(Player[] players, boolean[] viablePlayers) {
    this.players= players;
    visable=viablePlayers;
  }
  /**Recreate a player info packet from serialized binarry data
  @param iterator the source of the binarry data
  */
  public PlayerInfo(SerialIterator iterator){
    players = new Player[iterator.getInt()];
    for(int i=0;i<players.length;i++){
      players[i] = (Player)iterator.getObject(Player::new);
    }
    visable = new boolean[iterator.getInt()];
    for(int i=0;i<visable.length;i++){
      visable[i] = iterator.getBoolean();
    }
  }
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(players.length);
    for(Player p:players){
      data.addObject(p.serialize());
    }
    data.addInt(visable.length);
    for(boolean b: visable){
      data.addBool(b);
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
