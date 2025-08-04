/**A network request to request a client load a level
*/
public class LoadLevelRequest extends DataPacket {
  
  public static final Identifier ID = new Identifier("LevelLoadRequest");
  
  boolean isBuiltIn=false;
  String path, hash;
  int id;
  /**Create a new level load request for a built in level
  @param location The built in level location
  */
  public LoadLevelRequest(String location) {
    isBuiltIn=true;
    path=location;
  }
  /**Create a new level load request for a UGC level
  @param levelId The id of the level
  @param levelHash The combined file hash of the level
  */
  public LoadLevelRequest(int levelId, String levelHash) {
    isBuiltIn=false;
    id=levelId;
    hash=levelHash;
  }
  
  /**Recreate the request from serializde binarry data
  @param iterator The source of the binarry data
  */
  public LoadLevelRequest(SerialIterator iterator){
    isBuiltIn = iterator.getBoolean();
    path = iterator.getString();
    hash = iterator.getString();
    id = iterator.getInt();
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    
    SerializedData data = new SerializedData(id());
    data.addBool(isBuiltIn);
    data.addObject(SerializedData.ofString(path));
    data.addObject(SerializedData.ofString(hash));
    data.addInt(id);
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
