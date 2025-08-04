import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import java.util.function.Function;
/**Structure that represens a specific stage and contiains all of its components
*/
public class Stage implements Serialization {
  
  public static final Identifier ID = new Identifier("Stage");
  
  static transient skiny_mann source;
  public ArrayList<StageComponent> parts = new ArrayList<>(), interactables=new ArrayList<>();
  public ArrayList<StageEntity> entities = new ArrayList<>();
  public boolean is3D=false;
  public String type, name;
  public int stageID, skyColor=-9131009;
  /**Load a stage from a saved json file
  @param file The file to load from
  */
  public Stage(JSONArray file) {//single varible instance for a stage
    load(file);
  }
  
  /**Create a new stage
  @param Name The name of the stage
  @param Type The type of the level (stage/3Dstage/blueprint/3D blueprint)
  */
  public Stage(String Name, String Type) {
    name=Name;
    type=Type;
    is3D=type.equals("3Dstage")||type.equals("3D blueprint");
  }
  
  /**Recreate a stage from serialized binarry data
  @param iterator The source of the serialized binarry data
  */
  public Stage(SerialIterator iterator){
    parts = iterator.getArrayList();
    entities = iterator.getArrayList();
    is3D = iterator.getBoolean();
    type = iterator.getString();
    name = iterator.getString();
    stageID = iterator.getInt();
    skyColor = iterator.getInt();
  }

  /**Load the level, no idea why this is seperate from the constructor but ok
  @param file The file to load from
  */
  private void load(JSONArray file) {
    type=file.getJSONObject(0).getString("type");//load the name and type
    name=file.getJSONObject(0).getString("name");
    try {
      skyColor=file.getJSONObject(0).getInt("sky color");//load the sky color if possible
    } catch(Throwable e) { }

    if (type.equals("stage")||type.equals("3Dstage")||type.equals("blueprint")||type.equals("3D blueprint")) {//if the type is valid
      is3D=type.equals("3Dstage")||type.equals("3D blueprint");//check if it is a 3D type
      for (int i=1; i<file.size(); i++) {//for each element
        
        JSONObject ob=file.getJSONObject(i);
        String otype=Identifier.convertToId(ob.getString("type"));
        ob.setBoolean("s3d",is3D);
        Identifier typeID = new Identifier(otype);
        Function<JSONObject, StageComponent> constructor = StageComponentRegistry.getJsonConstructor(typeID);//get the constructor for this component
        if(constructor == null){//check if it is an entity
          //if the current thing is an entity, load it
          Function<JSONObject, StageEntity> entityConstructor = EntityRegistry.getJsonConstructor(typeID);//get the constrcutor for this entity
          if(entityConstructor!=null){//as long as the cnstructr exsists
            entities.add(entityConstructor.apply(ob));//run the constructor
          }else{
            System.err.println("No constructor found for idntifier: "+typeID);
            throw new RuntimeException("No constructor found for identifier: "+typeID);
          }
          continue;
        }
        
        StageComponent component = constructor.apply(ob);//run the constructor
        add(component);
      }
    }
  }
  
  /**Add a new component to the stage
  @param component The component to add
  */
  public void add(StageComponent component){
    parts.add(component);
    if(component instanceof Interactable){//if the component can be interacted with
      interactables.add(component);//add it to the list of things that can be interacted with
    }
  }

  /**Save this stage to a file
  @return The file name of the saved file
  */
  public String save() {
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
  
  /**Respawn all entities resetting them back to their spawn positions
  */
  public void respawnEntities(){
    for(StageEntity se : entities){
      se.respawn();
    }
  }
  
  /**Convert this stage to a byte representation that can be sent over the network or saved to a file.<br>
  @return This stage as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(SerializedData.ofArrayList(parts,new Identifier("StageComponent")));
    data.addObject(SerializedData.ofArrayList(entities,new Identifier("StageEntity")));
    data.addBool(is3D);
    data.addObject(SerializedData.ofString(type));
    data.addObject(SerializedData.ofString(name));
    data.addInt(stageID);
    data.addInt(skyColor);
    return data;
  }
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
  
  /**Check if this stage is the same as another stage. note: this only does a shallow compare, components and entities are not individially checked for equality
  @param o The object to check equality for
  */
  public boolean equals(Object o){
    if(o instanceof Stage){
      Stage s = (Stage)o;
      if(!s.name.equals(name)){
        return false;
      }
      if(!s.type.equals(type)){
        return false;
      }
      if(stageID!=s.stageID){
        return false;
      }
      if(skyColor!=s.skyColor){
        return false;
      }
      if(parts.size()!=s.parts.size()){
        return false;
      }
      if(entities.size()!=s.entities.size()){
        return false;
      }
      
      return true;
    }
    return false;
  }
}
