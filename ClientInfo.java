/**this class is used to send general data between the client and the server

*/
class ClientInfo extends DataPacket{
  public String name;
  boolean readdy=false;
  ClientInfo(String name,boolean ready){
    this.name=name;
    this.readdy=readdy;
  }
}
