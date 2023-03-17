class LevelDownloadInfo extends DataPacket{
  public Level level;
  public String files[];
  public int fileSizes[],blockSize,realSize[];
  public LevelDownloadInfo(Level level,String files[],int fileSizes[],int blockSize,int realSize[]){
    this.level=level;
    this.files=files;
    this.fileSizes=fileSizes;
    this.blockSize=blockSize;
    this.realSize=realSize;
  }
}
