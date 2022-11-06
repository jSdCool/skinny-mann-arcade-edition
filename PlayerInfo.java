class PlayerInfo extends DataPacket {
  Player[] players;
  boolean[] visable;
  PlayerInfo(Player[] players, boolean[] viablePlayers) {
    this.players= players;
    visable=viablePlayers;
  }
}
