import java.util.ArrayList;

/**A container for serialized data that makes it conveient to format data into serialized bytes
*/
public class SerializedData {
    private final Identifier identifier;
    private final ArrayList<Byte> data2;
    /**Create a new data serializer
    @param identifier The identifier of the object that is being serialized. This will be the identifier used to deserialized the object later
    */
    public SerializedData(Identifier identifier){
        this.identifier=identifier;
        data2 = new ArrayList<>();
    }
    /**Create a new data serializer.<br>
    used intrenally for serializing raw java types like string
    @param identifier The identifier of the object that is being serialized. This will be the identifier used to deserialized the object later
    @param data Allready serialized byte data of the object
    */
    private SerializedData(Identifier identifier, ArrayList<Byte> data){
        this.identifier = identifier;
        data2 = data;
    }

    /**Get the serialized data as an array of bytes that can be sent to an output stream and interpreted on the other side
     * @return Byte array with the following arrangement: {identifierLength: 4 bytes, Identifier: length bytes, objectLength: 4 bytes, objectData: length bytes}
     */
    public byte[] getSerializedData(){
        byte[] idAsBytes = identifier.asBytes();

        //ID length and content bytes
        byte[] serialized = new byte[idAsBytes.length+4+data2.size()];
        int index =idAsBytes.length;
        System.arraycopy(idAsBytes,0,serialized,0,idAsBytes.length);
        //content length
        byte[] length = Serializers.intToBytes(data2.size());
        System.arraycopy(length,0,serialized,index,length.length);
        index+=length.length;
        //copy the content from the array list into the output
        for(int i=index;i<index+data2.size();i++){
            serialized[i] = data2.get(i-index);
        }
        return serialized;
    }
    
    /**Get the current serialized data as an array list
    @return An array list containg the fully serialized bytes from this serialized object
    */
    private ArrayList<Byte> getData(){
        ArrayList<Byte> out = new ArrayList<>();
        //copy the identitier and length into the output
        for(byte b: identifier.asBytes()){
            out.add(b);
        }
        byte[] length = Serializers.intToBytes(data2.size());
        out.add(length[0]);
        out.add(length[1]);
        out.add(length[2]);
        out.add(length[3]);
        //copy the byte data to the output
        out.addAll(data2);
        return out;
    }

    /**Write a byte to the data
     * @param b The byte to wright
     */
    public void addByte(byte b){
        data2.add(b);
    }

    /**Write a short to the data
     * @param s The short to write
     */
    public void addShort(short s){
        byte[] tmp = Serializers.shortToBytes(s);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
    }

    /**Write an int to the data
     * @param i The int to write
     */
    public void addInt(int i){
        byte[] tmp = Serializers.intToBytes(i);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
        data2.add(tmp[2]);
        data2.add(tmp[3]);
    }

    /**Write a long to the data
     * @param l The long to write
     */
    public void addLong(long l){
        byte[] tmp = Serializers.longToBytes(l);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
        data2.add(tmp[2]);
        data2.add(tmp[3]);
        data2.add(tmp[4]);
        data2.add(tmp[5]);
        data2.add(tmp[6]);
        data2.add(tmp[7]);
    }

    /**Write a float to the data
     * @param f The float to write
     */
    void addFloat(float f){
        byte[] tmp = Serializers.floatToBytes(f);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
        data2.add(tmp[2]);
        data2.add(tmp[3]);
    }

    /**Write a double to the data
     * @param d The double to write
     */
    void addDouble(double d){
        byte[] tmp = Serializers.doubleToBytes(d);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
        data2.add(tmp[2]);
        data2.add(tmp[3]);
        data2.add(tmp[4]);
        data2.add(tmp[5]);
        data2.add(tmp[6]);
        data2.add(tmp[7]);
    }

    /**Write a char to the data
     * @param c The char to write
     */
    void addChar(char c){
        byte[] tmp = Serializers.charToBytes(c);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
    }

    /**Write a boolean to the data
     * @param b The boolean to write
     */
    void addBool(boolean b){
        data2.add(Serializers.booleanToByte(b));
    }

    /**Write an object to the data
     * @param obj The object to write
     */
    void addObject(SerializedData obj){
        data2.addAll(obj.getData());
    }

    /**Create a serialized representation of a string
     * @param s The string to serialize
     * @return The serial representation of the passed in string
     */
    public static SerializedData ofString(String s){
        if(s==null){
          s = "";
        }
        byte[] sb = s.getBytes();
        ArrayList<Byte> gb = new ArrayList<>(sb.length);
        for(byte b: sb){
            gb.add(b);
        }
        return new SerializedData(Serializers.STRING_ID,gb);
    }

    /**Create a serialized representation of an array list
     * @param list The list to serialized
     * @param type The type of the list
     * @return A serialized representation of the passed in array list
     */
    public static SerializedData ofArrayList(ArrayList<? extends Serialization> list,Identifier type){

        ArrayList<Byte> out = new ArrayList<>();
        byte[] typeBytes = type.asBytes();
        //number of elements
        //serialized Element Data
        byte[][] initialData = new byte[list.size()][];

        //get the bytes for each element
        for(int i=0;i<list.size();i++){
            initialData[i] = list.get(i).serialize().getSerializedData();
        }


        //copy the list type identifier to the final byte array
        for(byte b: typeBytes){
            out.add(b);
        }

        //copy the array list length to the final byte array
        byte[] lengthBytes = Serializers.intToBytes(list.size());

        out.add(lengthBytes[0]);
        out.add(lengthBytes[1]);
        out.add(lengthBytes[2]);
        out.add(lengthBytes[3]);

        //copy the objects serial data to the final byte array
        for(byte[] b1: initialData){
            for(byte b: b1){
                out.add(b);
            }
        }

        return new SerializedData(Serializers.ARRAYLIST_ID,out);
    }
}
