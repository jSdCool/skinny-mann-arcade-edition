import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import processing.sound.*;
/**Level component representation / container of a sound 
*/
public class StageSound implements Serialization {
  
  public static final Identifier ID = new Identifier("StageSound");
  
  static transient skiny_mann source;
  String path, name, type="sound";
  protected transient int sound;
  boolean isNarration = true;
  /**Load a stage sound from saved json data
  @param input The saved json data
  */
  public StageSound(JSONObject input) {
    name=input.getString("name");
    path=input.getString("location");
    if(!input.isNull("narration")){
      isNarration = input.getBoolean("narration");
    }
    if(isNarration){
      sound = source.soundHandler.registerLevelNarration(source.rootPath+path);
    }else{
      sound = source.soundHandler.registerLevelSound(source.rootPath+path);
    }

  }
  /**Create a new stage sound
  @param Name The name of the sound
  @param location The local path to the sound file
  @param narration If this sound should be used as a narration
  */
  public StageSound(String Name, String location,boolean narration) {
    name=Name;
    path=location;
    isNarration = narration;
    if(isNarration){
      sound = source.soundHandler.registerLevelNarration(source.rootPath+path);
    }else{
      sound = source.soundHandler.registerLevelSound(source.rootPath+path);
    }
  }
  /**Recreate a stage sound from serialized binarray data
  @param iterator The source of the binarry data
  */
  public StageSound(SerialIterator iterator){
    path = iterator.getString();
    name = iterator.getString();
    isNarration = iterator.getBoolean();
  }

  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
    JSONObject out=new JSONObject();
    out.setString("location", path);
    out.setString("name", name);
    out.setString("type", type);
    out.setBoolean("narration", isNarration);
    return out;
  }
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(SerializedData.ofString(path));
    data.addObject(SerializedData.ofString(name));
    data.addBool(isNarration);
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
