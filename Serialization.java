/**Interface used to make an object sendable over the network.
 * NOTE: all classes that implement this interface should also implement a constructor that takes an argument of a Serial Iterator
 */
public interface Serialization{


    /** serialize the current state of this object
     * @return a SerializedData representing the current state of this object
     */
    SerializedData serialize();

    /** get the serial identifier of this object
     * @return a name spaced Identifier uniquely identifying this object
     */
    Identifier id();
}
