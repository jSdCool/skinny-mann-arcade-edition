/**this class is used to send general data between the client and the server

*/
class ClientInfo extends DataPacket{
  public String name;
  ClientInfo(String name){
    this.name=name;
  }
}
