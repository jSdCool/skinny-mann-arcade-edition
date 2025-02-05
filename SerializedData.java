import java.util.ArrayList;

public class SerializedData {
    private final Identifier identifier;
    private final ArrayList<Byte> data2;
    public SerializedData(Identifier identifier){
        this.identifier=identifier;
        data2 = new ArrayList<>();
    }

    private SerializedData(Identifier identifier, ArrayList<Byte> data){
        this.identifier = identifier;
        data2 = data;
    }

    /**get the serialized data as an array of bytes that can be sent to an output stream and interpreted on the other side
     * @return byte array with the following arrangement: {identifier\<string: null terminated\> length\<int: 4bytes\> data\<length bytes\>}
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
        //copy the content into the output

        for(int i=index;i<index+data2.size();i++){
            serialized[i] = data2.get(i-index);
        }

        return serialized;
    }

    private ArrayList<Byte> getData(){
        ArrayList<Byte> out = new ArrayList<>();
        for(byte b: identifier.asBytes()){
            out.add(b);
        }
        byte[] length = Serializers.intToBytes(data2.size());
        out.add(length[0]);
        out.add(length[1]);
        out.add(length[2]);
        out.add(length[3]);

        out.addAll(data2);
        return out;
    }

    /**write a byte to the data
     * @param b the byte to wright
     */
    public void addByte(byte b){
        data2.add(b);
    }

    /**write a short to the data
     * @param s the short to write
     */
    public void addShort(short s){
        byte[] tmp = Serializers.shortToBytes(s);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
    }

    /**write an int to the data
     * @param i the int to write
     */
    public void addInt(int i){
        byte[] tmp = Serializers.intToBytes(i);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
        data2.add(tmp[2]);
        data2.add(tmp[3]);
    }

    /**write a long to the data
     * @param l the long to write
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

    /**write a float to the data
     * @param f the float to write
     */
    void addFloat(float f){
        byte[] tmp = Serializers.floatToBytes(f);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
        data2.add(tmp[2]);
        data2.add(tmp[3]);
    }

    /**write a double to the data
     * @param d the double to write
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

    /**write a char to the data
     * @param c the char to write
     */
    void addChar(char c){
        byte[] tmp = Serializers.charToBytes(c);
        data2.add(tmp[0]);
        data2.add(tmp[1]);
    }

    /**write a boolean to the data
     * @param b the boolean to write
     */
    void addBool(boolean b){
        data2.add(Serializers.booleanToByte(b));
    }

    /**write an object to the data
     * @param obj the object to write
     */
    void addObject(SerializedData obj){
        data2.addAll(obj.getData());
    }

    /**create a serialized representation of a string
     * @param s the string to serialize
     * @return the serial representation of the passed in string
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

    /**create a serialized representation of an array list
     * @param list the list to serialized
     * @param type the type of the list
     * @return a serialized representation of the passed in array list
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
