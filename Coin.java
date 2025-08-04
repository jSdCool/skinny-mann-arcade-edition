import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**Coin stage component
*/
public class Coin extends StageComponent {//ground component

  public static final Identifier ID = new Identifier("coin");

  int coinId;
  /**Load a coin from saved JSON data
  @param data The data to load the compoentn from
  */
  public Coin(JSONObject data) {
    type="coin";
    x=data.getFloat("x");
    y=data.getFloat("y");
    boolean stage_3D = data.getBoolean("s3d");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    coinId=data.getInt("coin id");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  
  /**Place a new Coin
  @param context The context of the placement
  */
  public Coin(StageComponentPlacementContext context){
    type="coin";
    x = context.getX();
    y = context.getY();
    if(context.has3D()){
      z = context.getZ();
    }
    coinId = context.index();
  }
  
  /**Create a coin from serialized binarry data
  @param iterator The source of the data
  */
  public Coin(SerialIterator iterator){
    deserial(iterator);
    coinId = iterator.getInt();
  }
  public StageComponent copy() {
    return new Coin(new StageComponentPlacementContext(x, y, z, coinId));
  }
  
  public StageComponent copy(float offsetX,float offsetY){
    return new Coin(new StageComponentPlacementContext(x+offsetX,y+offsetY,coinId));
  }
  
  public StageComponent copy(float offsetX,float offsetY,float offsetZ){
    return new Coin(new StageComponentPlacementContext(x+offsetX,y+offsetY,z+offsetZ,coinId));
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
    part.setInt("coin id", coinId);
    part.setInt("group", group);
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
    boolean collected;
    if (source.editingBlueprint) {//if in a blueprint it will not be collected
      collected=false;
    } else {//get the collection status
      if (source.coins.size()==0)
        collected=false;
      else
        collected=source.coins.get(coinId);
    }
    //get the camera adjusted position
    float x2=(x+group.xOffset)-source.drawCamPosX;
    if (!collected) {//if it has not been collected then 
      source.drawCoin(source.Scale*x2, source.Scale*((y+group.yOffset)+source.drawCamPosY), source.Scale*3,render);//draw the coin
      Collider2D playerHitBox = source.players[source.currentPlayer].getHitBox2D(0,0);//check if the player is colliding with the coin
      if (!source.selectingBlueprint && source.collisionDetection.collide2D(playerHitBox,new CircleCollider(new PVector(x,y),14))) {
        source.coins.set(coinId, true);//set the coin to collected
        source.coinCount++;
        if(!source.levelCreator){//if not in the level creator then increasse the coins collected stats
          source.stats.incrementCollectedCoins();
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
    boolean collected;
    if (source.editingBlueprint) {//if in a blueprint it will not be collected
      collected=false;
    } else {//get the collected status
      if (source.coins.size()==0)
        collected=false;
      else
        collected=source.coins.get(coinId);
    }

    if (!collected) {//if the coin has not been collected
      //rendder the coin
      render.translate((x+group.xOffset), (y+group.yOffset), (z+group.zOffset));
      render.rotateY(source.radians(source.coinRotation));
      render.shape(source.coin3D);
      render.rotateY(source.radians(-source.coinRotation));
      render.translate(-(x+group.xOffset), -(y+group.yOffset), -(z+group.zOffset));
      //ckeck if the player is colliding with the coin
      Collider3D playerHitBox = source.players[source.currentPlayer].getHitBox3D(0,0,0);
      if (!source.selectingBlueprint && source.collisionDetection.collide3D(playerHitBox, new SphereCollider(new PVector(x,y,z),14))) {
        source.coins.set(coinId, true);//set the coin to selected
        source.coinCount++;
        if(!source.levelCreator){//if not in the level crator, increase the coins collected stat
          source.stats.incrementCollectedCoins();
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
      if (Math.sqrt(Math.pow(x-(this.x+group.xOffset), 2)+Math.pow(y-(this.y+group.yOffset), 2))<19) {
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
      if (Math.sqrt(Math.pow(x-(this.x+group.xOffset), 2)+Math.pow(y-(this.y+group.yOffset), 2)+Math.pow(z-(this.z+group.zOffset), 2))<19) {
        return true;
      }
    }
    return false;
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
    data.addInt(coinId);
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
