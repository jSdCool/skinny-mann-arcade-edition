import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Stage implements Serializable {
  static transient skiny_mann source;
  public ArrayList<StageComponent> parts = new ArrayList<>(), interactables=new ArrayList<>();
  public ArrayList<StageEntity> entities = new ArrayList<>();
  public boolean is3D=false;
  public String type, name;
  public int stageID, skyColor=-9131009;
  Stage(JSONArray file) {//single varible instance for a stage
    load(file);
  }
  Stage(String Name, String Type) {
    name=Name;
    type=Type;
    is3D=type.equals("3Dstage")||type.equals("3D blueprint");
  }


  void load(JSONArray file) {
    type=file.getJSONObject(0).getString("type");
    name=file.getJSONObject(0).getString("name");
    try {
      skyColor=file.getJSONObject(0).getInt("sky color");
    }
    catch(Throwable e) {
    }

    if (type.equals("stage")||type.equals("3Dstage")||type.equals("blueprint")||type.equals("3D blueprint")) {
      is3D=type.equals("3Dstage")||type.equals("3D blueprint");
      for (int i=1; i<file.size(); i++) {
        try {
          JSONObject ob=file.getJSONObject(i);
          String otype=ob.getString("type");
          if (otype.equals("ground")) {
            parts.add(new Ground(ob, is3D));
          }
          else if (otype.equals("holo")) {
            parts.add(new Holo(ob, is3D));
          }
          else if (otype.equals("dethPlane")) {
            parts.add(new DethPlane(ob, is3D));
          }
          else if (otype.equals("check point")) {
            parts.add(new CheckPoint(ob, is3D));
          }
          else if (otype.equals("goal")) {
            parts.add(new Goal(ob, is3D));
          }
          else if (otype.equals("coin")) {
            parts.add(new Coin(ob, is3D));
          }
          else if (otype.equals("interdimentional Portal")) {
            parts.add(new Interdimentional_Portal(ob, is3D));
          }
          else if (otype.equals("sloap")) {
            parts.add(new Sloap(ob, is3D));
          }
          else if (otype.equals("holoTriangle")) {
            parts.add(new HoloTriangle(ob, is3D));
          }
          else if (otype.equals("3DonSW")) {
            parts.add(new SWon3D(ob, is3D));
          }
          else if (otype.equals("3DoffSW")) {
            parts.add(new SWoff3D(ob, is3D));
          }
          else if (otype.equals("WritableSign")) {
            parts.add(new WritableSign(ob, is3D));
          }
          else if (otype.equals("sound box")) {
            parts.add(new SoundBox(ob, is3D));
          }
          else if (otype.equals("logic button")) {
            parts.add(new LogicButton(ob, is3D));
            interactables.add(parts.get(parts.size()-1));
          }
          else{
            //if the current thing is an entity, load it
            StageEntity ent = source.entityRegistry.get(otype);
            if(ent!=null){
              entities.add(ent.create(ob,this));
            }
          }
          
        }
        catch(Throwable e) {
        }
      }
    }
  }

  String save() {
    JSONArray staeg = new JSONArray();
    JSONObject head=new JSONObject();
    head.setString("name", name);
    head.setString("type", type);
    head.setInt("sky color", skyColor);
    staeg.setJSONObject(0, head);
    for (int i=0; i<parts.size(); i++) {
      staeg.append(parts.get(i).save(is3D));
    }
    for(int i=0;i<entities.size();i++){
      staeg.append(entities.get(i).save());
    }
    source.saveJSONArray(staeg, source.rootPath+"/"+name+".json");
    return "/"+name+".json";
  }
  
  void respawnEntities(){
    for(StageEntity se : entities){
      se.respawn();
    }
  }
}
