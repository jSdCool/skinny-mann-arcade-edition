/**Interface used to make an object sendable over the network.
 * NOTE: all classes that implement this interface should also implement a constructor that takes an argument of a SerialIterator
 */
public interface Serialization{


    /**Serialize the current state of this object
     * @return A SerializedData representing the current state of this object
     */
    SerializedData serialize();

    /**Get the serial identifier of this object
     * @return A name spaced Identifier uniquely identifying this object
     */
    Identifier id();
}
