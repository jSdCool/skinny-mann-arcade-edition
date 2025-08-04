import java.io.IOException;
import java.io.InputStream;
import java.util.function.Function;
/**An input stream that can Deserialize objects, primaryily those that implment Serialization, but can also be anything else registerd in the serial registry
*/
public class ObjectDeserializingInputStream extends InputStream {

  /**Create a new object deserializing input stream on the given data input sourse
   * @param input the source of the data
   */
  public ObjectDeserializingInputStream(InputStream input) {
    this.input = input;
  }

  private final byte[] identifierInputBuffer = new byte[4096];

  private final InputStream input;
  
  /**Read a single byte from the underlying source input stream
  @return A single byte as an int or -1 if at the end of stream
  */
  @Override
  public int read() throws IOException {
    return input.read();
  }

  /**Read and deserialize the next object in the source input stream
   * @return An object deserialized from the input data
   */
  public Object readSerializedObject() throws IOException {
    //read the identifier
    int inval, index=0, readN=4;
    //read 4 bytes to get the identifier length
    for (; readN>=0; readN--) {
      inval = read();
      if (inval == -1) {
        throw new IOException("End of stream reached");
      }
      identifierInputBuffer[index] = (byte)(0xFF & inval);//palce the byte in the identifier input buffer
      index++;
      if (index==4) {//if all length 4 bytes have been read and no more bytes have been read
        readN = Deserializers.bytesToInt(identifierInputBuffer, new SerialIterator(0, identifierInputBuffer));//conver the int bytes to a regular java int
        //then continue reading in the number of bytes that was just depetmined, untill the whole identifier has been read
      }
    }
    //once all the identifier bytes have been read
    SerialIterator iterator = new SerialIterator(0, identifierInputBuffer);//create the iterator for the identifier
    //deserialize the identifier
    Identifier objectId = Deserializers.deserializeIdentifier(identifierInputBuffer, iterator);//if the identifier is invalid this is where the exeception will be thrown
    //get the constrcutor corresponding to this identifier from the serial registry
    Function<SerialIterator, Serialization> deserializer = SerialRegistry.get(objectId);
    //if this is equal to null then throw an exception
    if(deserializer == null){
      throw new IOException("Attempted to deserialize ["+objectId+"] but no serial constructor was found in the serial registry");
    }

    //read the object size
    for (int i=0; i<4; i++) {
      inval = read();
      if (inval == -1) {
        throw new IOException("End of stream reached");
      }
      identifierInputBuffer[index] = (byte)(0xFF & inval);//store the read byte in the input buffer
      index++;
    }

    int objectLength = Deserializers.bytesToInt(identifierInputBuffer, iterator);//convert the length bytes to a java int

    byte[] objectBytes = new byte[objectLength+4];//create a new buffer for the object bytes
    //copy the length into the output object array in case the object deserializer needs it for some reason.
    //it shouldent but java:string already does soooooooooooooooo
    objectBytes[0] = identifierInputBuffer[index-4];
    objectBytes[1] = identifierInputBuffer[index-3];
    objectBytes[2] = identifierInputBuffer[index-2];
    objectBytes[3] = identifierInputBuffer[index-1];
    int read = readNBytes(objectBytes, 4, objectLength);//read length bytes from the input stream
    if (read == -1 || read != objectLength) {
      throw new IOException("End of stream reached");
    }

    Object o = deserializer.apply(new SerialIterator(4, objectBytes));//deserialize the object. Making sure the iterator is setarting at index 4 where the object data starts
    return o;
  }
  
  /**The availabe method from input stream
  */
  @Override
  public int available() throws IOException {
    return input.available();
  }
  
  /**Close this and the underlying source input stream
  */
  @Override
  public void close() throws IOException {
    input.close();
  }
}
