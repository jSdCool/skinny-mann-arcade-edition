import java.util.ArrayList;
import java.util.function.Function;
/**A simplifide way of extracting useful data from serialized binarry data.<br>
Contains an array of bytes from an input stream. As well as an automatically incrementing pointer to the current position in that data.<br> Note: This object is usually shared between all object in the deseralization tree, meaning mistakes made with this object may propigate to other objects down the line.
*/
public class SerialIterator {
    private int value;
    private final byte[] data;
    
    /**Create a new serial itterator at a given position with the given data
    @param pos The position in the data to start the iterator at
    @param data The data to be used to deserialize objects from
    */
    public SerialIterator(int pos, byte[] data){
        value = pos;
        this.data=data;
    }

    /**Gets the current position of the iterator in the array.<br>
    Not particlularly useful in most application. Mostly for internal use.
     * @return The current value of the iterator
     */
    public int value(){
        return value;
    }

    /**Move the position of the iterator.<br>
    Use of this method is not reccomneded unless you need to specifically skip serialized data. 
     * @param amount How much to increase the position
     */
    public void advance(int amount){
        value+=amount;
    }

    /**Get the value of a specific byte
     * @param i The byte to get
     * @return The value of the byte
     */
    public byte getData(int i) {
        return data[i];
    }

    /**Get the total number of bytes in this iterator
     * @return The length of the internal byte array
     */
    public int dataLength(){
        return data.length;
    }

    /**Read a single byte from the iterators position
     * @return The next byte in the internal buffer
     */
    public byte getByte(){
        advance(1);
        return data[value-1];
    }

    /**Reads a short from the iterators position
     * @return The next short in the internal buffer
     */
    public short getShort(){
        return Deserializers.bytesToShort(data,this);
    }

    /**Reads an int from the iterators position
     * @return The next int from the internal buffer
     */
    public int getInt(){
        return Deserializers.bytesToInt(data,this);
    }

    /**Reads a long from the iterators position
     * @return The next long from the internal buffer
     */
    public long getLong(){
        return Deserializers.bytesToLong(data,this);
    }

    /**Reads the next char from the iterators position
     * @return The next char from the internal buffer
     */
    public char getChar(){
        return Deserializers.bytesToChar(data,this);
    }

    /**Reads the next float from the iterators position
     * @return The next char from the internal buffer
     */
    public float getFloat(){
        return Deserializers.bytesToFloat(data,this);
    }

    /**Reads the next double from the iterators position
     * @return The next double from the internal buffer
     */
    public double getDouble(){
        return Deserializers.bytesToDouble(data,this);
    }

    /**Reads the next boolean from the iterators position
     * @return The next boolean from the internal buffer
     */
    public boolean getBoolean(){
        return Deserializers.byteToBoolean(data,this);
    }

    /**Reads the next string from the iterators position
     * NOTE: this method verifies that the current position points to a string
     * @return The string at the current position in the internal buffer
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

    /**Read an array list from the iterators current position
     * NOTE: this method verifies that the current position points to an array list
     * @return The array list at the current position in the internal buffer
     * @param <E> The type of the array list
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

    /**Reads the next object from the iterators position
     * @return The object from the current position in the internal buffer
     */
    public Object getObject(){
        return Deserializers.deserializeObject(data,this);
    }

    /**Reads the next object from the iterators position
     * NOTE: this method is prbly slightly faster then the version without a parameter due to not needing to determine how to deserialize
     * @param serializer The constructor of the object to deserialized
     * @return The object from the current position in the internal buffer
     */
    public Object getObject(Function<SerialIterator, Serialization> serializer){
        //consume the Identifier and length
        Deserializers.deserializeIdentifier(data,this);
        getInt();
        return serializer.apply(this);
    }

    /**For internal use only<br>
     * DO NOT USE!!
     */
    protected byte[] getDataDoNotUse(){
        return data;
    }

}
