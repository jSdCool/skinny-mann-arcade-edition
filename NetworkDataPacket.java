import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
class NetworkDataPacket implements Serializable {
  boolean test=false;
  public ArrayList<DataPacket> data=new ArrayList<>();
  NetworkDataPacket() {
  }
  NetworkDataPacket(boolean testp) {
    test=testp;
    if (test) {
    }
  }
}
