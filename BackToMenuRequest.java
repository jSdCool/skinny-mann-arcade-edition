/**A network request to request the client go back to the menu
*/
public class BackToMenuRequest extends DataPacket {
  
  public static final Identifier ID = new Identifier("BackToMenuRequest");
  
  /**Create the request
  */
  public BackToMenuRequest(){}
  
  /**Recreate the request from network data
  @param iterator The source of the data
  */
  public BackToMenuRequest(SerialIterator iterator){}

  
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
