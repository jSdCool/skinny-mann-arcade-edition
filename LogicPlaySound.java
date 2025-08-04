import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A logic component that can play a stage sound
*/
public class LogicPlaySound extends LogicComponent {
  
  public static final Identifier ID = new Identifier("play_sound");
  
  String soundKey="";
  /**Place a new play sound component 
  @param context The context for the placement
  */
  public LogicPlaySound(LogicCompoentnPlacementContext context) {
    super(context.getX(), context.getY(), "play sound", context.getLogicBoard());
    button.setText("  play sound ");
  }
  /**Create a new play sound component from saved json data
  @param data The saved json data
  */
  public LogicPlaySound(JSONObject data) {
    super(data.getFloat("x"), data.getFloat("y"), "play sound", data.getJSONArray("connections"));
    soundKey=data.getString("sound key");
    button.setText("  play sound: "+soundKey);
  }
  /**Create a play sound component from serialized binarry data
  @param iterator The source of the data
  */
  public LogicPlaySound(SerialIterator iterator){
    super(iterator);
    soundKey = iterator.getString();
  }
  
  /**The function where the logic/functionality of this component is execuated
  */
  public void tick() {
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
    } catch(Exception e) {
    }
  }

  /**Get a JSONObject representation of this component that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save() {
    JSONObject component=super.save();
    component.setString("sound key", soundKey);
    return component;
  }
  /**set an integer data field<br>
  In this case the id of the sound
  @param data The data to set
  */
  public void setData(int data) {
    String[] keys=new String[0];
    keys=source.level.sounds.keySet().toArray(keys);
    soundKey=keys[data];
    button.setText("  play sound: "+soundKey);
  }
  /**Get an integer data field<br>
  in this case the id of the sound
  @return the value of that data
  */
  public int getData() {
    String[] keys=new String[0];
    keys=source.level.sounds.keySet().toArray(keys);
    for (int i=0; i<keys.length; i++) {
      if (keys[i].equals(soundKey)) {
        return i;
      }
    }
    return -1;
  }
  /**renders the logic component a long with its I/O terminals
  */
  public void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15*source.Scale);
    source.textAlign(PConstants.LEFT, PConstants.CENTER);
    source.text("play", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("stop", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
    source.textAlign(PConstants.RIGHT, PConstants.CENTER);
    source.text("playing", (x+97-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
  }
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addObject(SerializedData.ofString(soundKey));
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
