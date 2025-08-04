import java.io.IOException;
import java.io.OutputStream;
/**An output stream that can serialize objects that implment the Serialization interface, relying on the objects internal serialization deffinition
*/
public class ObjectSerializingOutputStream extends OutputStream {
    /**Create a new object serializing output stream on the given data output sourse
   * @param out where the serialized data goes
   */
    public ObjectSerializingOutputStream(OutputStream out){
        this.out = out;
    }

    private final OutputStream out;
    
    /**Write a single byte to the underlying output stream
    @param b The byte to write. Note: only the lower byte of the passed in int will be written
    */
    @Override
    public void write(int b) throws IOException {
        out.write(b);
    }

    /**write the data of the serialized object to the underlying output stream
     * @param data the serialized data to write
     */
    public void write(SerializedData data) throws IOException{
        write(data.getSerializedData());
    }

    /**write an object to the underlying output stream
     * @param data the object to write
     */
    public void write(Serialization data) throws IOException{
        write(data.serialize());
    }
    
    /**Flush the underlying output stream
    */
    @Override
    public void flush() throws IOException {
        out.flush();
    }
    
    /**Close the underlying output stream
    */
    @Override
    public void close() throws IOException {
        out.close();
    }
}
