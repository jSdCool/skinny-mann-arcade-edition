import java.io.IOException;
import java.io.InputStream;
import java.util.function.Function;

public class ObjectDeserializingInputStream extends InputStream {

    /**
     * @param input the source of the data
     */
    public ObjectDeserializingInputStream(InputStream input){
        this.input = input;
    }

    private final byte[] identifierInputBuffer = new byte[4096];

    private final InputStream input;

    @Override
    public int read() throws IOException {
        return input.read();
    }

    /**read and deserialize the next object in the source input stream
     * @return an object deserialized from the input data
     */
    public Object readSerializedObject() throws IOException{
        //read the identifier
        int inval,index=0,readN=4;
        for(;readN>=0;readN--){
            inval = read();
            if(inval == -1){
                throw new IOException("End of stream reached");
            }
            identifierInputBuffer[index] = (byte)(0xFF & inval);
            index++;
            if(index==4){
                readN = Deserializers.bytesToInt(identifierInputBuffer,new SerialIterator(0,identifierInputBuffer));
            }
        }
        SerialIterator iterator = new SerialIterator(0,identifierInputBuffer);
        Identifier objectId = Deserializers.deserializeIdentifier(identifierInputBuffer,iterator);

        Function<SerialIterator,Serialization> deserializer = SerialRegistry.get(objectId);
        //if this is equal to null then throw an exception

        //read the object size
        for(int i=0;i<4;i++){
            inval = read();
            if(inval == -1){
                throw new IOException("End of stream reached");
            }
            identifierInputBuffer[index] = (byte)(0xFF & inval);
            index++;
        }

        int objectLength = Deserializers.bytesToInt(identifierInputBuffer,iterator);

        byte[] objectBytes = new byte[objectLength+4];
        //copy the length into the output object array in case the object deserializer needs it for some reason.
        //it shouldest but string already does soooooooo
        objectBytes[0] = identifierInputBuffer[index-4];
        objectBytes[1] = identifierInputBuffer[index-3];
        objectBytes[2] = identifierInputBuffer[index-2];
        objectBytes[3] = identifierInputBuffer[index-1];
        int read = readNBytes(objectBytes,4,objectLength);
        if(read == -1 || read != objectLength){
            throw new IOException("End of stream reached");
        }


        Object o = deserializer.apply(new SerialIterator(4,objectBytes));
        return o;
    }

    @Override
    public int available() throws IOException {
        return input.available();
    }

    @Override
    public void close() throws IOException {
        input.close();
}
}
