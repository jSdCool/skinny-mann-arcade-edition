import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import processing.sound.*;

class StageSound implements Serializable {
  static transient skiny_mann source;
  String path, name, type="sound";
  protected transient int sound;
  StageSound(JSONObject input) {
    name=input.getString("name");
    path=input.getString("location");
    sound = source.soundHandler.registerLevelSound(source.rootPath+path);
  }
  StageSound(String Name, String location) {
    name=Name;
    path=location;
    sound = source.soundHandler.registerLevelSound(source.rootPath+path);
  }

  JSONObject save() {
    JSONObject out=new JSONObject();
    out.setString("location", path);
    out.setString("name", name);
    out.setString("type", type);
    return out;
  }
}
