import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**The stage component for the in level button that can interact with logic
*/
public class LogicButton extends StageComponent implements Interactable {
  
  public static final Identifier ID = new Identifier("logic_button");

  int variable=-1;
  /**Load a logic button from saved json data
  @param data The saved json data
  */
  public LogicButton(JSONObject data) {
    type="logic button";
    x=data.getFloat("x");
    y=data.getFloat("y");
    boolean stage_3D = data.getBoolean("s3d");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
    variable=data.getInt("variable");
  }
  /**Place a new logic button
  @param context The context for the placement
  */
  public LogicButton(StageComponentPlacementContext context){
    type="logic button";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
  }
  
  public StageComponent copy() {
    return new LogicButton(new StageComponentPlacementContext(x, y, z));
  }
  
  public StageComponent copy(float offsetX,float offsetY){
    return new LogicButton(new StageComponentPlacementContext(x+offsetX,y+offsetY));
  }
  
  public StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new LogicButton(new StageComponentPlacementContext(x+offsetX,y+offsetY,z+offsetZ));
  }
  /**Create a logic button from serialized binarry data
  @param iterator The source of the data
  */
  public LogicButton(SerialIterator iterator){
    deserial(iterator);
    variable = iterator.getInt();
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
    part.setInt("group", group);
    part.setInt("variable", variable);
    return part;
  }

  /**Render the 2D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    boolean state=false;
    if (source.level.multyplayerMode!=2) {//if this level is not in co op mode

      if (variable!=-1) {//if the variable is set
        state=source.level.variables.get(variable);
        Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);
        //check if the player is standing on the button
        if (CollisionDetection.collide2D(playerHitBox,Collider2D.createRectHitbox(x+group.xOffset-10,y+group.yOffset-10,20,10))) {
          source.level.variables.set(variable, true);//set the variable to true
          if(!state){//if this button was just activated
            if(!source.levelCreator){//and not in the level creator
              source.stats.incrementButtonsActivated();//increment the stats
            }
          }
        } else {//player is not staning on top of it
          source.level.variables.set(variable, false);//set the varaible to false
        }
      }
    }
    if (variable!=-1) {//if the variables is set
      state=source.level.variables.get(variable);//get its current value
    }
    //draw the button
    source.drawLogicButton(((x+group.xOffset)-source.drawCamPosX)*source.Scale, ((y+group.yOffset)+source.drawCamPosY)*source.Scale, source.Scale, state,render);
  }
  
  /**Render the 3D representation of this component.<br>
  NOTE: this method may be called more then once per frame
  @param render The surface to draw to
  */
  public void draw3D(PGraphics render) {
    Group group=getGroup();
    if (!group.visable)
      return;
    boolean state=false;
    if (source.level.multyplayerMode!=2) {//if not in co op mode

      if (variable!=-1) {//if the variable is set
        state=source.level.variables.get(variable);
        Collider3D playerHitBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
        //check if the player is staning on top of the button
        if (CollisionDetection.collide3D(playerHitBox,Collider3D.createBoxHitBox(x+group.xOffset-10,y+group.yOffset-10,z+group.zOffset-10,20,10,20))) {
          source.level.variables.set(variable, true);//set the variable to true
          if(!state){//if the button was just pressed
            if(!source.levelCreator){//and not in the level creator 
              source.stats.incrementButtonsActivated();//increment the stat
            }
          }
        } else {//if not staning on the button
          source.level.variables.set(variable, false);//set the bariable to false
        }
      }
    }
    if (variable!=-1) {//if the variable is set
      state=source.level.variables.get(variable);//get the current state of the varaible
    }
    //render the button
    source.drawLogicButton((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), 1, state,render);
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
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset)) {
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
      if (x >= (this.x+group.xOffset) - 20 && x <= (this.x+group.xOffset) + 20 && y >= (this.y+group.yOffset) - 10 && y <= (this.y+group.yOffset) && z >= (this.z+group.zOffset) - 20 && z <= (this.z+group.zOffset) + 20) {
        return true;
      }
    }
    return false;
  }

  /**set the value of an in data proerty<br>
  In this case the variable index
  @param data The new data value
  */
  public void setData(int data) {
    variable=data;
  }

  /**Get the value of an integer data proerty<br>
  In this case the variable index
  @return The value of the int data
  */
  public int getDataI() {
    return variable;
  }

  /**this instance of this function allows the portal to test if a player is standing on it
   @param data the index of the stage the button is in
   */
  public void worldInteractions(int data) {
    if (source.level.multyplayerMode==2) {//if in co op mode
      Group group=getGroup();
      if (!group.visable)
        return;
      if (variable!=-1){//if the variable is set
        for (int i=0; i<source.currentNumberOfPlayers; i++) {//for each player
          if (source.players[i].stage!=data)//test if the player is in the same stage as the button
            continue;
          if (source.players[i].in3D) {//test if the player is in 3d mode
            if (source.players[i].x>=(x+group.xOffset)-10&&source.players[i].x<=(x+group.xOffset)+10&&source.players[i].y >=(y+group.yOffset)-10&&source.players[i].y<= (y+group.yOffset)+2 && source.players[i].z >= (z+group.zOffset)-10 && source.players[i].z <= (z+group.zOffset)+10) {
              source.level.variables.set(variable, true);
              return;
            }
          } else {//if in 2D
            if (source.players[i].x>=(x+group.xOffset)-10&&source.players[i].x<=(x+group.xOffset)+10&&source.players[i].y >=(y+group.yOffset)-10&&source.players[i].y<= (y+group.yOffset)+2) {
              source.level.variables.set(variable, true);
              return;
            }
          }
        }
      source.level.variables.set(variable, false);
      }
    }
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
    data.addInt(variable);
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
