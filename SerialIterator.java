import java.util.ArrayList;
import java.util.function.Function;

public class SerialIterator {
    private int value;
    private final byte[] data;

    public SerialIterator(int pos, byte[] data){
        value = pos;
        this.data=data;
    }

    /**gets the current position of the iterator in the array
     * @return the current value of the iterator
     */
    public int value(){
        return value;
    }

    /** move the position of the iterator
     * @param amount how much to increase the position
     */
    public void advance(int amount){
        value+=amount;
    }

    /**get the value of a specific byte
     * @param i the byte to get
     * @return the value of the byte
     */
    public byte getData(int i) {
        return data[i];
    }

    /**get the total number of bytes in this iterator
     * @return the length of the internal byte array
     */
    public int dataLength(){
        return data.length;
    }

    /**read a single byte from the iterators position
     * @return the next byte in the internal buffer
     */
    public byte getByte(){
        advance(1);
        return data[value-1];
    }

    /**reads a short from the iterators position
     * @return the next short in the internal buffer
     */
    public short getShort(){
        return Deserializers.bytesToShort(data,this);
    }

    /**reads an int from the iterators position
     * @return the next int from the internal buffer
     */
    public int getInt(){
        return Deserializers.bytesToInt(data,this);
    }

    /**reads a long from the iterators position
     * @return the next long from the internal buffer
     */
    public long getLong(){
        return Deserializers.bytesToLong(data,this);
    }

    /**reads the next char from the iterators position
     * @return the next char from the internal buffer
     */
    public char getChar(){
        return Deserializers.bytesToChar(data,this);
    }

    /**reads the next float from the iterators position
     * @return the next char from the internal buffer
     */
    public float getFloat(){
        return Deserializers.bytesToFloat(data,this);
    }

    /**reads the next double from the iterators position
     * @return the next double from the internal buffer
     */
    public double getDouble(){
        return Deserializers.bytesToDouble(data,this);
    }

    /**reads the next boolean from the iterators position
     * @return the next boolean from the internal buffer
     */
    public boolean getBoolean(){
        return Deserializers.byteToBoolean(data,this);
    }

    /**reads the next string from the iterators position
     * NOTE: this method verifies that the current position points to a string
     * @return the string at the current position in the internal buffer
     */
    public String getString(){
        //verify the next object is a string
        Identifier id = Deserializers.deserializeIdentifier(data,this);
        if(!id.equals(Serializers.STRING_ID)){
            throw new RuntimeException("Attempted to Deserialized String when the next object in the data was not a String: "+id.toString());
        }
        getInt();//consume the length bytes

        return Deserializers.deserializeStringFromSerializedData(data,this);
    }

    /**read an array list from the iterators current position
     * NOTE: this method verifies that the current position points to an array list
     * @return the array list at the current position in the internal buffer
     * @param <E> the type of the array list
     */
    public <E> ArrayList<E> getArrayList(){
        //verify the next object is an array list
        Identifier id = Deserializers.deserializeIdentifier(data,this);
        if(!id.equals(Serializers.ARRAYLIST_ID)){
            throw new RuntimeException("Attempted to Deserialized ArrayList when the next object in the data was not an ArrayList: "+id.toString());
        }
        getInt();//consume the length bytes
        return Deserializers.deserializeArrayList(data,this);
    }

    /**reads the next object from the iterators position
     * @return the object from the current position in the internal buffer
     */
    public Object getObject(){
        return Deserializers.deserializeObject(data,this);
    }

    /**reads the next object from the iterators position
     * NOTE: this method is prbly slightly faster then the version without a parameter due to not needing to determine how to deserialize
     * @param serializer the constructor of the object to deserialized
     * @return the object from the current position in the internal buffer
     */
    public Object getObject(Function<SerialIterator, Serialization> serializer){
        //consume the Identifier and length
        Deserializers.deserializeIdentifier(data,this);
        getInt();
        return serializer.apply(this);
    }

    /**for internal use only
     * NO DO USE
     */
    protected byte[] getDataDoNotUse(){
        return data;
    }

}
