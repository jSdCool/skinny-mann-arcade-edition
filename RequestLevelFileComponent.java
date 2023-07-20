class RequestLevelFileComponent extends DataPacket {
  int file, block;
  RequestLevelFileComponent(int file, int block) {
    this.file=file;
    this.block=block;
  }
}
