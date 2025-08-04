/**A network packet sent form the client to the server to request a part of a level file
*/ 
public class RequestLevelFileComponent extends DataPacket {

  public static final Identifier ID = new Identifier("RequestLevelFileComponent");
  
  int file, block;
  /**Create a new level file component request packet
  @param file The idnex of the file to get
  @param block The index of the file block to get
  */
  public RequestLevelFileComponent(int file, int block) {
    this.file=file;
    this.block=block;
  }
  /**Recreate a level file component request
  */
  public RequestLevelFileComponent(SerialIterator iterator){
    file = iterator.getInt();
    block = iterator.getInt();
  }
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    
    SerializedData data = new SerializedData(id());
    data.addInt(file);
    data.addInt(block);
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
