/**A collection of functions for turing mostly primitives into bytes
*/
public class Serializers {

    public final static Identifier STRING_ID = new Identifier("java","String");
    public final static Identifier ARRAYLIST_ID = new Identifier("java","ArrayList");

    //java primitive serializers

    /**Converts a short into 2 bytes
     * @param s The short to be converted
     * @return An array of 2 bytes representing the short
     */
    public static byte[] shortToBytes(short s){
        return new byte[]{(byte)((s & 0xFF00) >>> 8), (byte)((s & 0x00FF))};
    }

    /**Converts an int into 4 bytes
     * @param i The int to be converted
     * @return An array of 4 bytes representing the int
     */
    public static byte[] intToBytes(int i){
        return new byte[]{(byte)((i & 0xFF000000) >>> 24), (byte)((i & 0x00FF0000) >>> 16), (byte)((i & 0x0000FF00) >>> 8), (byte)((i & 0x000000FF))};
    }

    /**Converts a long into 8 bytes
     * @param l The long to be converted
     * @return An array of 8 bytes representing the long
     */
    public static byte[] longToBytes(long l){
        return new byte[]{
                (byte)((l & 0xFF00000000000000L) >>> 56),
                (byte)((l & 0x00FF000000000000L) >>> 48),
                (byte)((l & 0x0000FF0000000000L) >>> 40),
                (byte)((l & 0x000000FF00000000L) >>> 32),
                (byte)((l & 0x00000000FF000000L) >>> 24),
                (byte)((l & 0x0000000000FF0000L) >>> 16),
                (byte)((l & 0x000000000000FF00L) >>> 8),
                (byte)((l & 0x00000000000000FFL))
        };
    }

    /**Converts a float into 4 bytes
     * @param f The float to be converted
     * @return An array of 4 bytes representing the float
     */
    public static byte[] floatToBytes(float f){
        return intToBytes(Float.floatToRawIntBits(f));
    }

    /**Converts a double into 8 bytes
     * @param d The double to be converted
     * @return An array of 8 bytes representing the double
     */
    public static byte[] doubleToBytes(double d){
        return longToBytes(Double.doubleToLongBits(d));
    }

    /**Converts a char into 2 bytes
     * @param c The char to be converted
     * @return An array of 2 bytes representing the char
     */
    public static byte[] charToBytes(char c){
        return shortToBytes((short)c);
    }

    /**Converts a boolean into a byte with the value of 1 or 0<br>
     * Seriously why do you need to use this
     * @param b The boolean to convert
     * @return A byte with the value of 1 or 0
     */
    public static byte booleanToByte(boolean b){
        return b? (byte)1:(byte)0;
    }
}
