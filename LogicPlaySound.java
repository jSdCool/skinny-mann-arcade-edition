import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class LogicPlaySound extends LogicComponent {
  
  public static final Identifier ID = new Identifier("LogicPlaySound");
  
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
  
  public LogicPlaySound(SerialIterator iterator){
    super(iterator);
    soundKey = iterator.getString();
  }

  void tick() {
    try {
      StageSound sound = source.level.sounds.get(soundKey);
      if(sound.isNarration){
        boolean isPlaying = source.soundHandler.isNarrationPlaying(sound.sound);
        if (inputTerminal1) {//if the play terminal is high then  play the sound if it is not playing
          if (!(isPlaying)) {
            source.soundHandler.playNarration(sound.sound);
          }
        }
        if (inputTerminal2) {//if the stop terminal is high then stop the sound if it is playing
          if ((isPlaying)) {
            source.soundHandler.stopNarration(sound.sound);
          }
        }
        
        outputTerminal = isPlaying;
      }else{
        boolean isPlaying = source.soundHandler.isPlaying(sound.sound)||source.soundHandler.isInQueue(sound.sound);
        if (inputTerminal1) {//if the play terminal is high then  play the sound if it is not playing
          if (!(isPlaying)) {
            source.soundHandler.addToQueue(sound.sound);
          }
        }
        if (inputTerminal2) {//if the stop terminal is high then stop the sound if it is playing
  
          if ((isPlaying)) {
            source.soundHandler.cancleSound(sound.sound);
          }
        }
        
        outputTerminal = isPlaying;
      }
    }
    catch(Exception e) {
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
    source.textSize(15*source.Scale);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("play", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("stop", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
    source.textAlign(source.RIGHT, source.CENTER);
    source.text("playing", (x+97-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addObject(SerializedData.ofString(soundKey));
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
