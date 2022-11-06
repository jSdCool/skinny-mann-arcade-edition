class LoadLevelRequest extends DataPacket {
  boolean isBuiltIn=false;
  String path;
  LoadLevelRequest(boolean bi, String location) {
    isBuiltIn=bi;
    path=location;
  }
}
