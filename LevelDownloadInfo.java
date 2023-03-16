class LevelDownloadInfo extends DataPacket{
  public Level level;
  public String files[];
  public int fileSizes[],blockSize;
  public LevelDownloadInfo(Level level,String files[],int fileSizes[],int blockSize){
    this.level=level;
    this.files=files;
    this.fileSizes=fileSizes;
    this.blockSize=blockSize;
  }
}
