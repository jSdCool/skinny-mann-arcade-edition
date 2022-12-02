import java.util.ArrayList;
class CoOpStateInfo extends DataPacket{
  public ArrayList<Boolean> vars;
  public ArrayList<Group> groups;
  CoOpStateInfo(ArrayList<Boolean> variables, ArrayList<Group> grups){
    vars=variables;
    groups=grups;
  }
}
