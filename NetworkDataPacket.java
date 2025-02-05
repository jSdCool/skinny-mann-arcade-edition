import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
class NetworkDataPacket implements Serialization {
  
  public static final Identifier ID = new Identifier("NetworkDataPacket");
  
  boolean test=false;
  public ArrayList<DataPacket> data=new ArrayList<>();
  NetworkDataPacket() {
  }
  NetworkDataPacket(boolean testp) {
    test=testp;
    if (test) {
    }
  }
  
  public NetworkDataPacket(SerialIterator iterator){
    test = iterator.getBoolean();
    data = iterator.getArrayList();
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addBool(test);
    data.addObject(SerializedData.ofArrayList(this.data,new Identifier("DataPacket")));
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
