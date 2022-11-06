
class SelectedLevelInfo extends DataPacket {
  String name, author, gameVersion;
  int multyplayerMode, maxPlayers, minPlayers;
  boolean exsists=false;
  SelectedLevelInfo() {
    exsists=false;
  }
  SelectedLevelInfo(String name, String author, String version, int mode, int min, int max) {
    exsists=true;
    this.name=name;
    this.author=author;
    gameVersion=version;
    multyplayerMode=mode;
    minPlayers=min;
    maxPlayers=max;
  }
}
