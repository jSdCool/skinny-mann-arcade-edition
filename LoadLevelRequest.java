class LoadLevelRequest extends DataPacket {
  boolean isBuiltIn=false;
  String path, hash;
  int id;
  LoadLevelRequest(String location) {
    isBuiltIn=true;
    path=location;
  }
  LoadLevelRequest(int levelId, String levelHash) {
    isBuiltIn=false;
    id=levelId;
    hash=levelHash;
  }
}
