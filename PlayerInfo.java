class PlayerInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("PlayerInfo");
  
  Player[] players;
  boolean[] visable;
  PlayerInfo(Player[] players, boolean[] viablePlayers) {
    this.players= players;
    visable=viablePlayers;
  }
  
  public PlayerInfo(SerialIterator iterator){
    players = new Player[iterator.getInt()];
    for(int i=0;i<players.length;i++){
      players[i] = (Player)iterator.getObject(Player::new);
    }
    visable = new boolean[iterator.getInt()];
    for(int i=0;i<visable.length;i++){
      visable[i] = iterator.getBoolean();
    }
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(players.length);
    for(Player p:players){
      data.addObject(p.serialize());
    }
    data.addInt(visable.length);
    for(boolean b: visable){
      data.addBool(b);
    }
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
