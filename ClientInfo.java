/**This class is used to send general data between the client and the server
 */
public class ClientInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("ClientInfo");
  
  public String name;
  boolean readdy, atEnd;
  /**Create a basic client informatio packet
  @param name The multyplayer namme of this client
  @param ready Wether this client is ready to start the level
  @param atEnd Wether this client has reached the end of the level in co op mode
  */
  public ClientInfo(String name, boolean ready, boolean atEnd) {
    this.name=name;
    this.readdy=ready;
    this.atEnd=atEnd;
  }
  /**Recreate this packet from serialized binarry data
  @param iterator The source of the data
  */
  public ClientInfo(SerialIterator iterator){
    name = iterator.getString();
    readdy = iterator.getBoolean();
    atEnd = iterator.getBoolean();
  }
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(SerializedData.ofString(name));
    data.addBool(readdy);
    data.addBool(atEnd);
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
