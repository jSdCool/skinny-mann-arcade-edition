import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**Stage component that allow the player to trigger a sound while standing inside of it
*/
public class SoundBox extends StageComponent {
  
  public static final Identifier ID = new Identifier("sound_box");
  
  String soundKey="";
  /**Load a sound box from saved JOSN data
  @param data The JSON Object containing the sound box data
  */
  public SoundBox(JSONObject data) {
    type = "sound box";
    x=data.getFloat("x");
    y=data.getFloat("y");
    soundKey=data.getString("sound key");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  /**Place a new sound box
  @param context The sound box for the placement
  */
  public SoundBox(StageComponentPlacementContext context){
    type="sound box";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
  }
  /**Create a sound box from serialized binarry data
  @param iterator The source of the data
  */
  public SoundBox(SerialIterator iterator){
    deserial(iterator);
    soundKey = iterator.getString();
  }
  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSoundBox((x+group.xOffset)*source.Scale-source.drawCamPosX*source.Scale, (y+group.yOffset)*source.Scale+source.drawCamPosY*source.Scale,source.Scale,render);
    Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);
    if (source.collisionDetection.collide2D(playerHitBox,Collider2D.createRectHitbox(x-30,y-30,60,60))) {
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;
      if (source.E_pressed) {
        try {
          StageSound sound = source.level.sounds.get(soundKey);
          if(sound.isNarration){
            if (!(source.soundHandler.isNarrationPlaying(sound.sound))) {
              source.soundHandler.playNarration(sound.sound);
              if(!source.levelCreator){
                source.stats.incrementSoundBoxesUsed();
              }
            }
          }else{
            if (!(source.soundHandler.isPlaying(sound.sound)||source.soundHandler.isInQueue(sound.sound))) {
              source.soundHandler.addToQueue(sound.sound);
              if(!source.levelCreator){
                source.stats.incrementSoundBoxesUsed();
              }
            }
          }
        }
        catch(Exception e) {
        }
      }
    }
  }
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render){}
  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-30 && x <= ((this.x+group.xOffset)) + 30 && y >= ((this.y+group.yOffset)) - 30 && y <= (this.y+group.yOffset)+30) {
        return true;
      }
    }
    return false;
  }
  /**Get a JSONObject representation of this component that can be saved to a file
  @param stage_3D Wether this stage is a 3D stage
  @return JSONObject representation of this object
  */
  public JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setString("type", type);
    part.setString("sound key", soundKey);
    part.setInt("group", group);
    return part;
  }

  public StageComponent copy() {
    SoundBox e=new SoundBox(new StageComponentPlacementContext(x, y));
    e.soundKey=soundKey;
    return  e;
  }
  
  public StageComponent copy(float offsetX,float offsetY){
    SoundBox e = new SoundBox(new StageComponentPlacementContext(x+offsetX,y+offsetY));
    e.soundKey=soundKey;
    return e;
  }
  
  public StageComponent copy(float offsetX,float offsetY,float offsetZ){
    System.err.println("Attempted to copy sound box in 3D. This opperation is not allowed");
    return null;
  }
  /**Set a string data property
  @param data The data to set
  */
  public void setData(String data) {
    soundKey=data;
  }
  /**Get the value of a string data proerty
  @return The value of the string data
  */
  public String getData() {
    return soundKey;
  }
  /**Get the 2D collision box for entitiy collisions
  @return 2D hitbox for this component or null for none
  */
  public Collider2D getCollider2D(){
    return null;
  }
  /**Get the 3D collision box for entitiy collisions
  @return 3D hitbox for this component or null for none
  */
  public Collider3D getCollider3D(){ 
    return null;
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
