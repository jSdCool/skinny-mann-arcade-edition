/**A network request to send a clients best score to the server
*/
public class BestScore extends DataPacket {
  
  public static final Identifier ID = new Identifier("BestScore");
  
  String name;
  int score;
  /**Create a new score
  @param n The name of the player this score is from
  @param s The value of the score
  */
  public BestScore(String n, int s) {
    name=n;
    score=s;
  }
  /**Recreate a score from Serialized data
  @param iterator the source of the data
  */
  public BestScore(SerialIterator iterator){
    score = iterator.getInt();
    name = iterator.getString();
  }
  
  /**Convert this request to a byte representation that can be sent over the network or saved to a file.<br>
  @return This request as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(score);
    data.addObject(SerializedData.ofString(name));
    return data;
  }
  
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
