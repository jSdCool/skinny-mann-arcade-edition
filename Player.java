import processing.core.*;
/**The player
*/
public class Player extends Entity implements Serialization {
  
  public static final Identifier ID = new Identifier("Player");
  
  public float x, y, z=0, scale, animationCooldown, verticalVelocity=0;
  private final float arbitrayNumber=0.0023f;//slight adjustemnt to the hitboxes just to make shure all collisions are as accurate as posible
  public int pose=1, stage=0;
  public transient static skiny_mann source;
  int shirt;
  boolean jumping=false, in3D;
  String name="";
  /**Create a new player
  @param X The x position of the player
  @param Y The y position of the player
  @param Scale The scale of the player
  @param Color The shirt color of the player
  */
  public Player(float X, float Y, float Scale, int Color) {
    x=X;
    y=Y;
    scale=Scale;
    shirt=Color;
  }
  /**Recreate a player from serialized binarry data
  @param iterator The source of the binarry data
  */
  public Player(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    scale = iterator.getFloat();
    animationCooldown = iterator.getFloat();
    verticalVelocity = iterator.getFloat();
    pose = iterator.getInt();
    stage = iterator.getInt();
    shirt = iterator.getInt();
    jumping = iterator.getBoolean();
    in3D = iterator.getBoolean();
    name = iterator.getString();
  }
  /**set the entities' x position
  @param X The new x position
  @return this
  */
  public Entity setX(float X) {
    x=X;
    return this;
  }
  /**set the entities' y position
  @param Y The new y position
  @return this
  */
  public Entity setY(float Y) {
    y=Y;
    return this;
  }
  /**set the entities' z position
  @param Z The new z position
  @return this
  */
  public Entity setZ(float Z){
    z=Z;
    return this;
  }
  /**Get the current x position of the entity
  @return the current x position
  */
  public float getX() {
    return x;
  }
  /**Get the current y position of the entity
  @return the current y position
  */
  public float getY() {
    return y;
  }
  /**Get the current z position of the entity
  @return the current z position
  */
  public float getZ(){
    return z;
  }
  /**Set the scale of the player
  @param s The new scale
  @return this
  */
  public Player setScale(float s) {
    scale=s;
    return this;
  }
  /**Get the current scale of the player
  @return The current scale of the player
  */
  public float getScale() {
    return scale;
  }
  /**Set the current pose of the player
  @param p The new player pose
  @return this
  */
  public Player setPose(int p) {
    pose=p;
    return this;
  }
  /**Get the current pose of the player
  @return The players current pose
  */
  public int getPose() {
    return pose;
  }
  /**Set the current animation cooldown of the plauer
  @param ac The new animarion cooldown
  @return this
  */
  public Player setAnimationCooldown(float ac) {
    animationCooldown=ac;
    return this;
  }
  /**Get this player's current animation cooldown
  @return The current animation cooldown
  */
  public float getAnimationCooldown() {
    return  animationCooldown;
  }
  /**Get the player's shirt color
  @return the shirt color number of this player
  */
  public int getColor() {
    return shirt;
  }
  /**Get an info string of this player
  @return An info string for this player
  */
  public String toString() {
    return "x "+x+" y "+y+" scale "+scale+" pose "+pose ;
  }
  /**Set if this player is currently jumping
  @param a If this player is currently jumping
  @return this
  */
  public Player setJumping(boolean a) {
    jumping=a;
    return this;
  }
  /**Get if this player is currently jumping
  */
  public boolean isJumping() {
    return jumping;
  }
  /**Get this player's specific movemnt manger.<br>
  Responcable for storing movement commands.
  */
  public MovementManager getMovementmanager(){
    if(source.players[source.currentPlayer] == this){//if this player is the one controlled by this client
      return source.playerMovementManager;//return the player movmenet manager
    }
    return new NoMovementManager();//else return the no movement manager so that player's client can calculate the player's movement
  }
  /**Get this entities' 2D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @return The 2D hitbox for this entity offset from the entities' position by the given ammount
  */
  public Collider2D getHitBox2D(float offsetX, float offsetY){
    return new Collider2D(new PVector[]{
      new PVector(x+offsetX-15*scale+arbitrayNumber,y+offsetY-75*scale+arbitrayNumber),
      new PVector(x+offsetX+15*scale-arbitrayNumber,y+offsetY-75*scale+arbitrayNumber),
      new PVector(x+offsetX+15*scale-arbitrayNumber,y+offsetY-arbitrayNumber),
      new PVector(x+offsetX-15*scale+arbitrayNumber,y+offsetY-arbitrayNumber)
    });
  }
  /**Get this entities' 3D hitbox
  @param offsetX How far to offset the returned box from the entities current position in the x axis
  @param offsetY How far to offset the returned box from the entities current position in the y axis
  @param offsetZ How far to offset the returned box from the entities current position in the z axis
  @return The 3D hitbox for this entity offset from the entities' position by the given ammount
  */
  public Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ){
    return new Collider3D(new PVector[]{
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber),
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber ,z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX-10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-75*scale+arbitrayNumber , z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ+15*scale-arbitrayNumber),
      new PVector(x+offsetX+10*scale+arbitrayNumber , y+offsetY-arbitrayNumber , z+offsetZ-15*scale+arbitrayNumber)
    });
  }
  /**Get wether or not this entity colides with outher entities
  @return true if this entity collides with other collideable entities
  */
  public boolean collidesWithEntites(){
    return false;
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
  /**Get wether to render / process this entity in 3D mode
  @param playerIn3D wether the current player is in 3D mode
  */
  public boolean in3D(boolean playerIn3D){
    return in3D;
  }
  
  //mabby implment theese later
  public void draw(skiny_mann context,PGraphics render){}
  public void draw3D(skiny_mann context,PGraphics render){}
  
  public Entity create(float x,float y,float z){return null;}//why does this function exsist? its not in the entity class
  
  /**Convert this component to a byte representation that can be sent over the network or saved to a file.<br>
  @return This component as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addFloat(x);
    data.addFloat(y);
    data.addFloat(z);
    data.addFloat(scale);
    data.addFloat(animationCooldown);
    data.addFloat(verticalVelocity);
    data.addInt(pose);
    data.addInt(stage);
    data.addInt(shirt);
    data.addBool(jumping);
    data.addBool(in3D);
    data.addObject(SerializedData.ofString(name));
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
