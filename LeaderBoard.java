class LeaderBoard extends DataPacket {
  
  public static final Identifier ID = new Identifier("LeaderBoard");
  
  String[] leaderboard;
  LeaderBoard(String [] names) {
    leaderboard=names;
  }
  
  public LeaderBoard(SerialIterator iterator){
    leaderboard = new String[iterator.getInt()];
    for(int i=0;i<leaderboard.length;i++){
      leaderboard[i] = iterator.getString();
    }
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(leaderboard.length);
    for(String s:leaderboard){
      data.addObject(SerializedData.ofString(s));
    }
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
