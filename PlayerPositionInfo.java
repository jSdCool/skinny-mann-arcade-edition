/**A network data packet for the client to send info about their playter back to the server
*/
public class PlayerPositionInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("PlayerPositionInfo");
  
  Player player;
  /**Create a new player position info packet
  @param player The player to create the packet of
  */
  public PlayerPositionInfo(Player player) {
    this.player=player;
  }
  
  /**Recreate a player position info from serialized binarry data
  @param iterator The source of the binarry data
  */
  public PlayerPositionInfo(SerialIterator iterator){
    player = (Player)iterator.getObject(Player::new);
  }
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(player.serialize());
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
