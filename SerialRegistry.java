import java.util.ArrayList;
import java.util.HashMap;
import java.util.function.Function;

public class SerialRegistry {
    private static final HashMap<Identifier, Function<SerialIterator, Serialization>> reg = new HashMap<>();

    static{
        register(Serializers.STRING_ID,SerialString::new);
        register(Serializers.ARRAYLIST_ID,SerialArrayList::new);
    }


    /**register an object to be deserialized
     * @param id the ID of the object
     * @param constructor a reference to a constructor for an object. this constructor sakes a SerialIterator as an argument. Pass in MyClass::new
     */
    public static void register(Identifier id,Function<SerialIterator, Serialization> constructor){
        if(reg.containsKey(id)){
            throw new RuntimeException("An object with that id had already been registered: "+id);
        }

        reg.put(id,constructor);
    }

    /**get the constructor for a given object
     * @param id the ID of the object to get the constructor of
     * @return the constructor corresponding to the object ID
     */
    public static Function<SerialIterator, Serialization> get(Identifier id){
        Function<SerialIterator, Serialization> ser = reg.get(id);
        if(ser == null){
            throw new RuntimeException("Unknown Serializer: "+id);
        }
        return ser;
    }

    /**wrapper class for the java string class allowing it to be deserialized with this system
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

    /**wrapper class for the java array list allowing it to be automatically deserialized in this system
     *
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
