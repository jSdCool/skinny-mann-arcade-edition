import java.util.ArrayList;
class InfoForClient extends DataPacket {
  int playerNumber;
  ArrayList<String> playerNames;
  String hostVersion;
  boolean inGame=false;
  int sessionTime;
  InfoForClient(int number, ArrayList<String> names, String version, boolean inGame, int time) {
    playerNumber=number;
    playerNames=names;
    hostVersion=version;
    this.inGame=inGame;
    sessionTime=time;
  }
}
