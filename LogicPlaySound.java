import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class LogicPlaySound extends LogicOutputComponent {
  String soundKey="";
  LogicPlaySound(float x, float y, LogicBoard lb) {
    super(x, y, "play sound", lb);
    button.setText("  play sound ");
  }

  LogicPlaySound(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "play sound", lb, data.getJSONArray("connections"));
    soundKey=data.getString("sound key");
    button.setText("  play sound: "+soundKey);
  }
  void tick() {
    if (inputTerminal1) {//if the play terminal is high then  play the sound if it is not playing
      try {
        StageSound sound = source.level.sounds.get(soundKey);
        if (!sound.sound.isPlaying()) {
          sound.sound.play();
        }
      }
      catch(Exception e) {
      }
    }
    if (inputTerminal2) {//if the top terminal is high then stop the sound if it is playing
      try {
        StageSound sound = source.level.sounds.get(soundKey);
        if (sound.sound.isPlaying()) {
          sound.sound.stop();
        }
      }
      catch(Exception e) {
      }
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setString("sound key", soundKey);
    return component;
  }
  void setData(int data) {
    String[] keys=new String[0];
    keys=source.level.sounds.keySet().toArray(keys);
    soundKey=keys[data];
    button.setText("  play sound: "+soundKey);
  }
  int getData() {
    String[] keys=new String[0];
    keys=source.level.sounds.keySet().toArray(keys);
    for (int i=0; i<keys.length; i++) {
      if (keys[i].equals(soundKey)) {
        return i;
      }
    }
    return -1;
  }

  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("play", x+5-source.camPos, y+16-source.camPosY);
    source.text("stop", x+5-source.camPos, y+56-source.camPosY);
  }
}
