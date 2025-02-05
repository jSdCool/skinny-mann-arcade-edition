import java.util.ArrayList;
class CoOpStateInfo extends DataPacket {
  
  public static final Identifier ID = new Identifier("CoOpStateInfo");
  
  public ArrayList<Boolean> vars;
  public ArrayList<Group> groups;
  public boolean levelCompleted;
  CoOpStateInfo(ArrayList<Boolean> variables, ArrayList<Group> grups, boolean lvlCmplete) {
    vars=variables;
    groups=grups;
    levelCompleted=lvlCmplete;
  }
  
  public CoOpStateInfo(SerialIterator iterator){
    vars = new ArrayList<>();
    int numVars = iterator.getInt();
    for(int i=0;i<numVars;i++){
      vars.add(iterator.getBoolean());
    }
    groups = iterator.getArrayList();
    levelCompleted = iterator.getBoolean();
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addInt(vars.size());
    for(int i=0;i<vars.size();i++){
      data.addBool(vars.get(i));
    }
    data.addObject(SerializedData.ofArrayList(groups,groups.get(0).id()));
    data.addBool(levelCompleted);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
