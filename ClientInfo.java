/**this class is used to send general data between the client and the server
 
 */
class ClientInfo extends DataPacket {
  public String name;
  boolean readdy,atEnd;
  ClientInfo(String name, boolean ready,boolean atEnd) {
    this.name=name;
    this.readdy=ready;
    this.atEnd=atEnd;
  }
}
