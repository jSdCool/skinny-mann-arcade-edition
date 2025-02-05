class PlayerPositionInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("PlayerPositionInfo");
  
  Player player;
  PlayerPositionInfo(Player player) {
    this.player=player;
  }
  
  public PlayerPositionInfo(SerialIterator iterator){
    player = (Player)iterator.getObject(Player::new);
  }
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(player.serialize());
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
