import java.util.ArrayList;
import java.util.HashMap;
import java.util.function.Function;
/**Stores a refrence to how to reconstruct objects from serialized binarry data.<br>
All classes involved in netowrking MUST be registerd to this registry
*/
public class SerialRegistry {
    private static final HashMap<Identifier, Function<SerialIterator, Serialization>> reg = new HashMap<>();

    static{//automatically pre register string and array list to the registry because they are base included java classes
        register(Serializers.STRING_ID,SerialString::new);
        register(Serializers.ARRAYLIST_ID,SerialArrayList::new);
    }


    /**Register an object to be deserialized
     * @param id The ID of the object
     * @param constructor A reference to a constructor for an object. This constructor takes a SerialIterator as an argument. (use MyClass::new)
     */
    public static void register(Identifier id,Function<SerialIterator, Serialization> constructor){
        if(reg.containsKey(id)){
            throw new RuntimeException("An object with that id had already been registered: "+id);
        }

        reg.put(id,constructor);
    }

    /**Get the constructor for a given object
     * @param id The ID of the object to get the constructor of
     * @return The constructor corresponding to the object ID
     */
    public static Function<SerialIterator, Serialization> get(Identifier id){
        Function<SerialIterator, Serialization> ser = reg.get(id);
        if(ser == null){
            throw new RuntimeException("Unknown Serializer: "+id);
        }
        return ser;
    }

    /**Wrapper class for the java string class allowing it to be deserialized with this system
     */
    static class SerialString implements Serialization{

        String self;
        public SerialString(SerialIterator iterator){
            Deserializers.deserializeStringFromSerializedData(iterator.getDataDoNotUse(),iterator);
        }
        @Override
        public SerializedData serialize() {
            return null;
        }

        @Override
        public Identifier id() {
            return Serializers.STRING_ID;
        }

        public String get(){
            return self;
        }
    }

    /**Wrapper class for the java array list allowing it to be automatically deserialized in this system<br>
     * DO NOT RELY ON THIS. array lists should be wrapped in a class that can properly determine the type of the list
     */
    public static class SerialArrayList implements Serialization{

        ArrayList<?> self;
        public SerialArrayList(SerialIterator iterator){
            self = Deserializers.deserializeArrayList(iterator.getDataDoNotUse(),iterator);
        }
        @Override
        public SerializedData serialize() {
            return null;
        }

        @Override
        public Identifier id() {
            return Serializers.ARRAYLIST_ID;
        }

        public ArrayList<?> get(){
            return self;
        }
    }
}
