class PlayerIniteractionResult{
  boolean killPlayer;
  
  public PlayerIniteractionResult setKill(){
    killPlayer=true;
    return this;
  }
  
  public boolean isKill(){
    return killPlayer;
  }
}
