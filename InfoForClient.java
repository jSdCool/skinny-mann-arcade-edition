import java.util.ArrayList;
class InfoForClient extends DataPacket{
  int playerNumber;
  ArrayList<String> playerNames;
  String hostVersion;
  InfoForClient(int number,ArrayList<String> names,String version){
    playerNumber=number;
    playerNames=names;
    hostVersion=version;
  }
}
