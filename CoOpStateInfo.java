import java.util.ArrayList;
/**A network packet containing varius information about the current state of the co op level. Intednerd to be sent from the server to the clients
*/
public class CoOpStateInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("CoOpStateInfo");
  
  public ArrayList<Boolean> vars;
  public ArrayList<Group> groups;
  public boolean levelCompleted;
  /**Create a packet with state information about the co op level
  @param variables The current value of the level's variable
  @param grups The current value of the level's groups
  @param lvlCmplete Wether the level is currently completed
  */
  public CoOpStateInfo(ArrayList<Boolean> variables, ArrayList<Group> grups, boolean lvlCmplete) {
    vars=variables;
    groups=grups;
    levelCompleted=lvlCmplete;
  }
  /**Recreate the packet from serialized binarry data
  @param iterator The source of the data
  */
  public CoOpStateInfo(SerialIterator iterator){
    vars = new ArrayList<>();
    int numVars = iterator.getInt();
    for(int i=0;i<numVars;i++){
      vars.add(iterator.getBoolean());
    }
    groups = iterator.getArrayList();
    levelCompleted = iterator.getBoolean();
  }
  
  /**Convert this packet to a byte representation that can be sent over the network or saved to a file.<br>
  @return This packet as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(vars.size());//write how many variable there are
    for(int i=0;i<vars.size();i++){//write the state of each variable
      data.addBool(vars.get(i));
    }
    //write the groups
    data.addObject(SerializedData.ofArrayList(groups,groups.get(0).id()));
    data.addBool(levelCompleted);//write the level complete status
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
