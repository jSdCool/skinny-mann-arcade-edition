import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A basic container that all packets being sent are packaged into before being sent over the network.<br>
Effectivly it just wrapps an array list of DataPacket.
*/
public class NetworkDataPacket implements Serialization {
  
  public static final Identifier ID = new Identifier("NetworkDataPacket");
  
  boolean test=false;
  public ArrayList<DataPacket> data=new ArrayList<>();
  /**Create a new network data packet
  */
  public NetworkDataPacket() { }
  /**This appears to be some sort of test consturtor, not entirly sure why it exsists
  @param testp Appears to be some sort of test parameter
  */
  public NetworkDataPacket(boolean testp) {//I do not remember why this exsists
    test=testp;
    if (test) {
    }
  }
  /**Recreate This packet from serialized binarry data
  @param iterator The source of the binarry data
  */
  public NetworkDataPacket(SerialIterator iterator){
    test = iterator.getBoolean();
    data = iterator.getArrayList();
  }
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addBool(test);
    data.addObject(SerializedData.ofArrayList(this.data,new Identifier("DataPacket")));
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
