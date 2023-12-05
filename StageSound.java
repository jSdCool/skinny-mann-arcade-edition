import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import processing.sound.*;

class StageSound implements Serializable {
  static transient skiny_mann source;
  String path, name, type="sound";
  protected transient int sound;
  boolean isNarration = true;
  StageSound(JSONObject input) {
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
  StageSound(String Name, String location,boolean narration) {
    name=Name;
    path=location;
    isNarration = narration;
    if(isNarration){
      sound = source.soundHandler.registerLevelNarration(source.rootPath+path);
    }else{
      sound = source.soundHandler.registerLevelSound(source.rootPath+path);
    }
  }

  JSONObject save() {
    JSONObject out=new JSONObject();
    out.setString("location", path);
    out.setString("name", name);
    out.setString("type", type);
    out.setBoolean("narration", isNarration);
    return out;
  }
}
