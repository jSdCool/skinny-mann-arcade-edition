import java.util.Random;
import java.util.ArrayList;
import processing.data.*;
import processing.core.*;
/**A simple entity used to test the entity system
*/
public class SimpleEntity extends StageEntity{
  
  public static final Identifier ID = new Identifier("simple_entity");
  /**Place a simple entity
  @param context The context for the placement
  */
  public SimpleEntity(StageEntityPlacementContext context){
    spawnX=context.getX();
    spawnY=context.getY();
    spawnZ=context.getZ();
    setX(context.getX());
    setY(context.getY());
    setZ(context.getZ());
  }
  /**Load a simple entity from saved json data
  @param data The saved json data
  */
  public SimpleEntity(JSONObject data){
    setX(data.getFloat("x"));
    setY(data.getFloat("y"));
    setZ(data.getFloat("z"));
    spawnX=x;
    spawnY=y;
    spawnZ=z;
  }
  /**Create a simple entity from serialized binarry data
  @param iterator The source of the binarry data
  */
  public SimpleEntity(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    spawnX = iterator.getFloat();
    spawnY = iterator.getFloat();
    spawnZ = iterator.getFloat();
    vVelcoity = iterator.getFloat();
    dead = iterator.getBoolean();
  }
  /**Get a JSONObject representation of this entity that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save(){
    JSONObject output = new JSONObject();
    output.setString("type","simple entity");
    output.setFloat("x",spawnX);
    output.setFloat("y",spawnY);
    output.setFloat("z",spawnZ);
    
    return output;
  }
  int to =0;
  MovementManager m  = new MovementManager(){
      int ax =0,az =0;
      Random r = new Random();
      boolean j=false;
      public boolean left(){return ax==-1;}
      public boolean right(){return ax==1;}
      public boolean in(){return az == -1;}
      public boolean out(){return az ==1;}
      public boolean jump(){return j;}
      public void reset(){
        ax = (int)(r.nextInt(-1,2));
        az = (int)(r.nextInt(-1,2));
        j = (int)(Math.random()*2)==1;
      };
      
      @Override
      public SerializedData serialize() {
        return null;
      }
      
      @Override
      public Identifier id() {
        return null;
      }
    };
  
  /**Get this entities' specific movemnt manger.<br>
  Responcable for storing movement commands.
  @return The movement manager for this entity
  */
  public MovementManager getMovementmanager(){
    return m;
  }
  
  float x,y,z;
  float spawnX,spawnY,spawnZ;
  float vVelcoity;
  boolean dead = false;
  
  /**Get the current x position of the entity
  @return the current x position
  */
  public float getX(){
    return x;
  }
  /**Get the current y position of the entity
  @return the current y position
  */
  public float getY(){
    return y;
  }
  /**Get the current z position of the entity
  @return the current z position
  */
  public float getZ(){
    return z;
  }
  /**set the entities' x position
  @param x The new x position
  @return this
  */
  public Entity setX(float x){
    this.x=x;
    return this;
  }
  /**set the entities' y position
  @param y The new y position
  @return this
  */
  public Entity setY(float y){
    this.y=y;
    return this;
  }
  /**set the entities' z position
  @param z The new z position
  @return this
  */
  public Entity setZ(float z){
    this.z=z;
    return this;
  }
  /**Get wether or not this entity colides with outher entities
  @return true if this entity collides with other collideable entities
  */
  public boolean collidesWithEntites(){
    return false;
  }
  /**Get this entities' 3D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @param offsetZ How far to offset the returned box from the entities current position in the z axis
  @return The 3D hitbox for this entity offset from the entities' position by the given ammount
  */
  public Collider3D getHitBox3D(float offsetX,float offsetY,float offsetZ){
    return Collider3D.createBoxHitBox(x+offsetX,y+offsetY,z+offsetZ,40,40,40);
  }
  /**Get this entities' 2D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @return The 2D hitbox for this entity offset from the entities' position by the given ammount
  */
  public Collider2D getHitBox2D(float offsetX,float offsetY){
   return Collider2D.createRectHitbox(x+offsetX,y+offsetY,40,40); 
  }
  /**Get wether to render / process this entity in 3D mode
  @param playerIn3D wether the current player is in 3D mode
  */
  public boolean in3D(boolean playerIn3D){
    return playerIn3D;
  }
  /**Gets the current vertical velocity of this entity
  @return the current vertical velocity
  */
  public float getVerticalVelocity(){
    return vVelcoity;
  }
  /**Set the current vertical velocity of this entity
  @param v The new velocity
  @return this
  */
  public Entity setVerticalVelocity(float v){
    vVelcoity=v;
    return this;
  }
  /**Render the 2D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the render
  @param render The surface to draw to
  */
  public void draw(skiny_mann context,PGraphics render){
    render.fill(40);
    render.rect(context.Scale*(x-context.drawCamPosX),context.Scale*(y+context.drawCamPosY),40*context.Scale,40*context.Scale);
    if(m.left()){
      render.fill(130,130,0);
      render.rect(context.Scale*(x-context.drawCamPosX),context.Scale*(y+context.drawCamPosY),10*context.Scale,40*context.Scale);
    }
    if(m.right()){
      render.fill(0,130,0);
      render.rect(context.Scale*(x-context.drawCamPosX+30),context.Scale*(y+context.drawCamPosY),10*context.Scale,40*context.Scale);
    }
    if(m.jump()){
      render.fill(130,0,0);
      render.rect(context.Scale*(x-context.drawCamPosX),context.Scale*(y+context.drawCamPosY),40*context.Scale,10*context.Scale);
    }
    if(to ==0 ){
      to = 20;
      m.reset();
    }
    to--;
  }
  /**Render the 3D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the renders
  @param render The surface to draw to
  */
  public void draw3D(skiny_mann context,PGraphics render){
    render.fill(40);
    render.translate(x+20,y+20,z+20);
    render.box(40);
    render.translate(-x-20,-y-20,-z-20);
    if(to ==0 ){
      to = 20;
      m.reset();
    }
    to--;
  }
  /**Kill this entity
  */
  public void kill(){
    dead=true;
  }
  /**Check if this entity is dead
  @return true if the endity is dead
  */
  public boolean isDead(){
    return dead;
  }
  /**Respawn this entity
  */
  public void respawn(){
    dead=false;
    setX(spawnX);
    setY(spawnY);
    setZ(spawnZ);
  }
  /**Get the result of the player interacting with this entity in 2D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public PlayerIniteractionResult playerInteraction(Collider2D playerHitBox){
    return null;
  }
  /**Get the result of the player interacting with this entity in 3D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public PlayerIniteractionResult playerInteraction(Collider3D playerHitBox){
    return null;
  }
  /**Process an entity AI update
  @param dt The number of milliseconds Since the last update
  @param stageHitBoxes The hitboxes of the stage this entity is in
  */
  public void update(float dt, ArrayList<Collider2D> stageHitBoxes){
    
  }
  /**Convert this entity to a byte representation that can be sent over the network or saved to a file.<br>
  @return This entity as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addFloat(x);
    data.addFloat(y);
    data.addFloat(z);
    data.addFloat(spawnX);
    data.addFloat(spawnY);
    data.addFloat(spawnZ);
    data.addFloat(vVelcoity);
    data.addBool(dead);
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
