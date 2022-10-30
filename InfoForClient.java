import java.util.ArrayList;
class InfoForClient extends DataPacket{
  int playerNumber;
  ArrayList<String> playerNames;
  InfoForClient(int number,ArrayList<String> names){
    playerNumber=number;
    playerNames=names;
  }
}
