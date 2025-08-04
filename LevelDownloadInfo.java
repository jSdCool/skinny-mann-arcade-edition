/**A network data packet contianing info about a level download
*/
public class LevelDownloadInfo extends DataPacket {//feels a bit unfair to call this a single packet given its potential size, oh well
  
  public static final Identifier ID = new Identifier("LevelDownloadInfo");
  
  public Level level;
  public String files[];
  public int fileSizes[], blockSize, realSize[];
  /**Create a packet containiong data related to downloading a level
  @param level The level to download
  @param files A list of other files that need to be downloaded
  @param fileSizes The sizes of the other files that need to be downloaded(blocks)
  @param blockSize The size of a single data download block
  @param realSize the real size of all the additional files that need to be downloaded (bytes)
  */
  public LevelDownloadInfo(Level level, String files[], int fileSizes[], int blockSize, int realSize[]) {
    this.level=level;
    this.files=files;
    this.fileSizes=fileSizes;
    this.blockSize=blockSize;
    this.realSize=realSize;
  }
  
  /**Recreate the level download info from Serialized binarry data
  @param iterator The source of the binarry data
  */
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
  
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
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
  
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
