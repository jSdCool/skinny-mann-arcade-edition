class KillEntityDataPacket extends DataPacket{
  int stage,index;
  KillEntityDataPacket(int stage,int index){
    this.stage=stage;
    this.index=index;
  }
  
  public int getStage(){
    return stage;
  }
  
  public int getIndex(){
    return index;
  }
}
