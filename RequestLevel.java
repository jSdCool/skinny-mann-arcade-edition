/**A packet the client uses to request a level from the server
*/
public class RequestLevel extends DataPacket {
  
  public static final Identifier ID = new Identifier("RequestLevel");
  
  /**Create a new level request
  */
  public RequestLevel(){}
  /**Recreate a level request from serialized binarry data
  @param iterator The source of the binarry data
  */
  public RequestLevel(SerialIterator iterator){}
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    return new SerializedData(id());
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
  
}
