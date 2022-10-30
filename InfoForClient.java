import java.util.ArrayList;
class InfoForClient extends DataPacket{
  int playerNumber;
  ArrayList<String> playerNames;
  String hostVersion;
  boolean inGame=false;
  InfoForClient(int number,ArrayList<String> names,String version,boolean inGame){
    playerNumber=number;
    playerNames=names;
    hostVersion=version;
    this.inGame=ingame;
  }
}
