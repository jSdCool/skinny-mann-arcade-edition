/**A network data paket to transmit level file data
*/
public class LevelFileComponentData extends DataPacket {
  
  public static final Identifier ID = new Identifier("LevelFileComponentData");
  
  byte data[];
  /**Create a new packet for transmitting file data
  @param data The raw file data up to the the block size
  */
  public LevelFileComponentData(byte data[]) {
    this.data=data;
  }
  
  /**Recreate the file data from serialized binarry data
  @param iterator The serialized binarry data
  */
  public LevelFileComponentData(SerialIterator iterator){
    data = new byte[iterator.getInt()];
    for(int i=0;i<data.length;i++){
      data[i] = iterator.getByte();
    }
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    
    data.addInt(this.data.length);
    for(byte b:this.data){
      data.addByte(b);
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
