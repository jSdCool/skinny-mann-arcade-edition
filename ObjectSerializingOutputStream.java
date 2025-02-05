import java.io.IOException;
import java.io.OutputStream;

public class ObjectSerializingOutputStream extends OutputStream {

    public ObjectSerializingOutputStream(OutputStream out){
        this.out = out;
    }

    private final OutputStream out;

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

    @Override
    public void flush() throws IOException {
        out.flush();
    }

    @Override
    public void close() throws IOException {
        out.close();
    }
}
