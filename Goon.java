import java.util.ArrayList;
import processing.data.*;
import processing.core.*;
/**The basic goon enemy
*/
public class Goon extends StageEntity{
  
  public static final Identifier ID = new Identifier("goon");
  
  /**Place a new goon
  @param context The context for the placement
  */
  public Goon(StageEntityPlacementContext context){
    this.x=context.getX();
    this.y=context.getY();
    this.z=context.getX();
    ix = x;
    iy = y;
    iz = z;
  }
  
  /**Load a goon from saved JSON data
  @param data The saved JSON data
  */
  public Goon(JSONObject data){
    x = data.getFloat("x");
    y = data.getFloat("y");
    z = data.getFloat("z");
    ix=x;
    iy=y;
    iz=z;
  }
  
  /**Recreate a goon from serialized binarry data
  @param iterator The source of the binarry data
  */
  public Goon(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    ix = iterator.getFloat();
    iy = iterator.getFloat();
    iz = iterator.getFloat();
    verticalVelocity = iterator.getFloat();
    dead = iterator.getBoolean();
    in3D = iterator.getBoolean();
  }
  
  float x,y,z;
  float ix,iy,iz;
  float verticalVelocity=0;
  boolean dead=false,in3D =false;
  GoonMovementManager mm= new GoonMovementManager(this);
  
  /**Get this entities' specific movemnt manger.<br>
  Responcable for storing movement commands.
  */
  public MovementManager getMovementmanager(){
    return mm;
  }
  
  /**Get this entities' 2D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @return The 2D hitbox for this entity offset from the entities' position by the given ammount
  */
  public Collider2D getHitBox2D(float offsetX, float offsetY){
    return Collider2D.createRectHitbox(x-15+offsetX,y-50+offsetY,30,65);
  }
  /**Get this entities' 3D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @param offsetZ How far to offset the returned box from the entities current position in the z axis
  @return The 3D hitbox for this entity offset from the entities' position by the given ammount
  */
  public Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ){
    return null;
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
  
  /**Gets the current vertical velocity of this entity
  @return the current vertical velocity
  */
  public float getVerticalVelocity(){
    return verticalVelocity;
  }
  /**Set the current vertical velocity of this entity
  @param v The new velocity
  @return this
  */
  public Entity setVerticalVelocity(float v){
    verticalVelocity = v;
    return this;
  }
  
  /**Get wether or not this entity colides with outher entities
  @return true if this entity collides with other collideable entities
  */
  public boolean collidesWithEntites(){
    return false;
  }
  /**Get wether to render / process this entity in 3D mode
  @param playerIn3D wether the current player is in 3D mode
  */
  public boolean in3D(boolean playerIn3D){
    return in3D;
  }

  /**Render the 2D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the render
  @param render The surface to draw to
  */
  public void draw(skiny_mann context,PGraphics render){
    float localX = x-context.drawCamPosX;
    float loaclY = y+context.drawCamPosY;
    float Scale = context.Scale;
    //hat
    render.fill(59,59,59);
    render.rect((localX-10)*Scale,(loaclY-50)*Scale,20*Scale,5*Scale);
    render.rect((localX-12.5f)*Scale,(loaclY-45)*Scale,25*Scale,5*Scale);
    render.fill(255);
    render.rect((localX-15)*Scale,(loaclY-40)*Scale,30*Scale,5*Scale);
    render.fill(0);
    render.rect((localX-17.5f)*Scale,(loaclY-35)*Scale,35*Scale,5*Scale);
    //face
    render.fill(255,0xBA,0x6B);
    render.rect((localX-15)*Scale,(loaclY-30)*Scale,30*Scale,15*Scale);
    render.fill(0);
    //sun glasses
    render.rect((localX-15)*Scale,(loaclY-27)*Scale,30*Scale,2*Scale);
    if(mm.right()){
      render.rect((localX-10)*Scale,(loaclY-27)*Scale,10*Scale,5*Scale);
      render.rect((localX+5)*Scale,(loaclY-27)*Scale,10*Scale,5*Scale);
    }else{
      render.rect((localX-15)*Scale,(loaclY-27)*Scale,10*Scale,5*Scale);
      render.rect((localX+0)*Scale,(loaclY-27)*Scale,10*Scale,5*Scale);
    }
    
    //shirt
    render.fill(21,18,15);
    render.rect((localX-10)*Scale,(loaclY-15)*Scale,20*Scale,20*Scale);
    
    //legs
    render.fill(70,70,70);
    render.rect((localX-10)*Scale,(loaclY+5)*Scale,5*Scale,10*Scale);
    render.rect((localX+5)*Scale,(loaclY+5)*Scale,5*Scale,10*Scale);
    
  }
  /**Render the 3D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the renders
  @param render The surface to draw to
  */
  public void draw3D(skiny_mann context,PGraphics render){
    
  }
  
  //killable methods
  /**Kill this entity
  */
  public void kill(){
    dead=true;
    mm.reset();
  }
  /**respawn this entity
  */
  public void respawn(){
    dead=false;
    x=ix;
    y=iy;
    z=iz;
    mm.reset();
  }
  
  /**get weather or not this entity is dead
  @return true if the entity is dead
  */
  public boolean isDead(){
    return dead;
  }
  
  /**Get a JSONObject representation of this entity that can be saved to a file
  @return JSONObject representation of this object
  */
  public JSONObject save(){
    JSONObject data = new JSONObject();
    data.setFloat("x",ix);
    data.setFloat("y",iy);
    data.setFloat("z",iz);
    data.setString("type","goon");
    return data;
  }
  
  /**Get the result of the player interacting with this entity in 2D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public PlayerIniteractionResult playerInteraction(Collider2D playerHitBox){
    
    //if the player hits the kill Entity box section
    if(CollisionDetection.collide2D(playerHitBox,Collider2D.createRectHitbox(x-10,y-50,20,10))){
      //kill this entity
      kill();
      return null;
    }
    
    return new PlayerIniteractionResult().setKill();
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
    mm.recalculateMovements(stageHitBoxes);
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
    data.addFloat(ix);
    data.addFloat(iy);
    data.addFloat(iz);
    data.addFloat(verticalVelocity);
    data.addBool(dead);
    data.addBool(in3D);
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
