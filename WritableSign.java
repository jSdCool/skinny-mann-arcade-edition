import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

/**Sign stage component
*/
public class WritableSign extends StageComponent implements Configurable {
  
  public static final Identifier ID = new Identifier("WritableSign");
  
  String contents;
  /**Load a sign from saved JOSN data
  @param data The JSON Object containing the sign data
  */
  public WritableSign(JSONObject data) {
    type="WritableSign";
    x=data.getFloat("x");
    y=data.getFloat("y");
    boolean stage_3D = data.getBoolean("s3d");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    contents=data.getString("contents");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  
  /**Place a new sign
  @param context The context for the placement
  */
  public WritableSign(StageComponentPlacementContext context){
    type="WritableSign";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
    contents="";
  }
  
  /**Create a sign from serialized binarry data
  @param iterator The source of the data
  */
  public WritableSign(SerialIterator iterator){
    deserial(iterator);
    contents = iterator.getString();
  }

  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSign(source.Scale*((x+group.xOffset)-source.drawCamPosX), source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale,render);

    Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);
    if (CollisionDetection.collide2D(playerHitBox,Collider2D.createRectHitbox(x-35,y-40,70,40))) {//display the press e message to the player
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;

      if (source.E_pressed) {
        source.E_pressed=false;
        source.viewingItemContents=true;
        if(!source.levelCreator){
          source.stats.incrementSignsRead();
        }
      }
    }
  }
  
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    source.drawSign((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), source.Scale,render);

     Collider3D playerHitBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
    if (CollisionDetection.collide3D(playerHitBox,Collider3D.createBoxHitBox(x-35,y-40,z-20,70,40,40))) {
      source.displayText="Press B";
      source.displayTextUntill=source.millis()+100;
      if (source.E_pressed) {
        source.E_pressed=false;
        source.viewingItemContents=true;
        if(!source.levelCreator){
          source.stats.incrementSignsRead();
        }
      }
    }
  }
  
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
      if (x >= ((this.x+group.xOffset))-35 && x <= ((this.x+group.xOffset)) + 35 && y >= ((this.y+group.yOffset)) - 65 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }

  /**used for mouse click detecteion
  @param x The x position of the mouse
  @param y The y position of the mouse
  @param z The z position of the mouse
  @param c Check colliding with hitbox reghuardless of if the compoennt normally has collision during gameplay
  @return true if a collision is occoring
  */
  public boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-35 && x <= ((this.x+group.xOffset)) + 35 && y >= ((this.y+group.yOffset)) - 65 && y <= (this.y+group.yOffset) && z >= ((this.z+group.yOffset)) - 5 && z <= (this.z+group.zOffset)+5) {
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
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setString("contents", contents);
    part.setInt("group", group);
    return part;
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
    data.addObject(SerializedData.ofString(contents));
    return data;
  }
  
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }

  /**Get the properties that can be configured on this component
  @return An array of the properties that can be configured
  */
  public Property[] getProperties(){
    String[] lines = contents.split("\n",-1);
    final int numLines = lines.length;
    Property[] props = new Property[numLines+1];
    props[0] = new IntegerProperty( ()-> numLines, (value) -> setNumLines(value), "Number of Lines");
    for(int i=0;i<lines.length;i++){
      final int i2 = i;
      props[i+1] = new StringProperty( ()->lines[i2], (value) -> updateLine(i2,value,lines), "Line "+(i2+1));
    }
    return props;
  }

  /**Set the number of lines on the sign
  @param num The new number of lines
  */
  private void setNumLines(int num){
    if( num > 0 && num <= 8){
      String[] lines = contents.split("\n");
      final int numLines = lines.length;
      if(num > numLines){//grow
        contents += "\n";//just add a new line to the end
      } else if (num < numLines){//shrink
        String[] newLines = new String[numLines-1];
        for(int i=0;i<newLines.length;i++){
          newLines[i] = lines[i];
        }
        contents = String.join("\n",newLines);
      }
    }
  }

  /**update a specific line on the sign
  @param lineNum The index of the line
  @param content The new content of the line
  @param lines The current lines of the sign
  */
  private void updateLine(int lineNum,String content, String[] lines){
    content = content.replaceAll("\n","");//filter out any line breaks
    lines[lineNum] = content;
    contents = String.join("\n",lines);
  }

  /**Get the text that is on the sign
  */
  public String getContent(){
    return contents;
  }
}
