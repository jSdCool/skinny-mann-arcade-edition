/**A network request to request the client close the menu and start the level
*/
public class CloseMenuRequest extends DataPacket {
  public static final Identifier ID = new Identifier("CloseMenuRequest");
  
  /**Create the request
  */
  public CloseMenuRequest(){}
  
  /**Recreate this request from serialized binarry data
  @param iterator The source of the data
  */
  public CloseMenuRequest(SerialIterator iterator){}
  
  /**Convert this request to a byte representation that can be sent over the network or saved to a file.<br>
  @return This request as a binarry representation
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
