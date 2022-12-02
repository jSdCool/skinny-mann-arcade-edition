import java.util.ArrayList;
class CoOpStateInfo extends DataPacket{
  public ArrayList<Boolean> vars;
  public ArrayList<Group> groups;
  public boolean levelCompleted;
  CoOpStateInfo(ArrayList<Boolean> variables, ArrayList<Group> grups,boolean lvlCmplete){
    vars=variables;
    groups=grups;
    levelCompleted=lvlCmplete;
  }
}
