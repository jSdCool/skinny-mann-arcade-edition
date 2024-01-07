import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import processing.sound.*;

class SoundBox extends StageComponent {
  String soundKey="";

  SoundBox(float X, float Y) {
    x=X;
    y=Y;
    type = "sound box";
  }
  SoundBox(JSONObject data, boolean stage_3D) {
    type = "sound box";
    x=data.getFloat("x");
    y=data.getFloat("y");
    soundKey=data.getString("sound key");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSoundBox((x+group.xOffset)*source.Scale-source.drawCamPosX*source.Scale, (y+group.yOffset)*source.Scale+source.drawCamPosY*source.Scale);
    if (source.players[source.currentPlayer].getX()>=(x+group.xOffset)-30&&source.players[source.currentPlayer].getX()<=(x+group.xOffset)+30&&source.players[source.currentPlayer].y>=(y+group.yOffset)-30&&source.players[source.currentPlayer].getY()<(y+group.yOffset)+30) {
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;
      if (source.E_pressed) {
        try {
          StageSound sound = source.level.sounds.get(soundKey);
          if(sound.isNarration){
            if (!(source.soundHandler.isNarrationPlaying(sound.sound))) {
              source.soundHandler.playNarration(sound.sound);
            }
          }else{
            if (!(source.soundHandler.isPlaying(sound.sound)||source.soundHandler.isInQueue(sound.sound))) {
              source.soundHandler.addToQueue(sound.sound);
            }
          }
        }
        catch(Exception e) {
        }
      }
    }
  }

  boolean colide(float x, float y, boolean c) {
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

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setString("type", type);
    part.setString("sound key", soundKey);
    part.setInt("group", group);
    return part;
  }

  StageComponent copy() {
    SoundBox e=new SoundBox(x, y);
    e.soundKey=soundKey;
    return  e;
  }

  void setData(String data) {
    soundKey=data;
  }

  String getData() {
    return soundKey;
  }
}
