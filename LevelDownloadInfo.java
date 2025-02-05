class LevelDownloadInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("LevelDownloadInfo");
  
  public Level level;
  public String files[];
  public int fileSizes[], blockSize, realSize[];
  public LevelDownloadInfo(Level level, String files[], int fileSizes[], int blockSize, int realSize[]) {
    this.level=level;
    this.files=files;
    this.fileSizes=fileSizes;
    this.blockSize=blockSize;
    this.realSize=realSize;
  }
  
  public LevelDownloadInfo(SerialIterator iterator){
    level = (Level)iterator.getObject(Level::new);
    files = new String[iterator.getInt()];
    for(int i=0;i<files.length;i++){
      files[i] = iterator.getString();
    }
    
    fileSizes = new int[iterator.getInt()];
    for(int i=0;i<fileSizes.length;i++){
      fileSizes[i] = iterator.getInt();
    }
    blockSize = iterator.getInt();
    realSize = new int[iterator.getInt()];
    for(int i=0;i<realSize.length;i++){
      realSize[i] = iterator.getInt();
    }
    
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    
    data.addObject(level.serialize());
    
    data.addInt(files.length);
    for(int i=0;i<files.length;i++){
      data.addObject(SerializedData.ofString(files[i]));
    }
    data.addInt(fileSizes.length);
    
    for(int s:fileSizes){
      data.addInt(s);
    }
    data.addInt(blockSize);
    data.addInt(realSize.length);
    for(int rs: realSize){
      data.addInt(rs);
    }
    
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
