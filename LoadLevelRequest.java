class LoadLevelRequest extends DataPacket {
  boolean isBuiltIn=false;
  String path,id,hash;
  LoadLevelRequest(String location) {
    isBuiltIn=true;
    path=location;
  }
  LoadLevelRequest(String levelId, String levelHash) {
    isBuiltIn=false;
    id=levelId;
    hash=levelHash;
  }
}
