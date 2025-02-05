import processing.data.*;
import processing.core.*;
class Goon extends StageEntity{
  
  public static final Identifier ID = new Identifier("Goon");
  
  Goon(float x,float y, float z,Stage stage){
    super(stage);
    this.x=x;
    this.y=y;
    this.z=z;
    ix = x;
    iy = y;
    iz = z;
  }
  
  Goon(JSONObject data,Stage stage){
    super(stage);
    x = data.getFloat("x");
    y = data.getFloat("y");
    z = data.getFloat("z");
    ix=x;
    iy=y;
    iz=z;
  }
  
  public Goon(SerialIterator iterator){
    super(null);
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
  
  public StageEntity create(JSONObject data,Stage stage){
    return new Goon(data,stage);
  }
  
  //entity specific movemnt manger. responcable for storing movement commands
  public MovementManager getMovementmanager(){
    return mm;
  }
  
  //entiy hitboxes for 2D and 3D. offset from the players position but the specified ammount
  public Collider2D getHitBox2D(float offsetX, float offsetY){
    return Collider2D.createRectHitbox(x-15+offsetX,y-50+offsetY,30,65);
  }
  public Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ){
    return null;
  }

  //get and set the position of the entity
  public Entity setX(float x){
    this.x=x;
    return this;
  }
  public Entity setY(float y){
    this.y=y;
    return this;
  }
  public Entity setZ(float z){
    this.z=z;
    return this;
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public float getZ(){
    return z;
  }
  
  //velocity
  public float getVerticalVelocity(){
    return verticalVelocity;
  }
  public Entity setVerticalVelocity(float v){
    verticalVelocity = v;
    return this;
  }
  
  //wether or not this entity colides with outher entityes 
  public boolean collidesWithEntites(){
    return false;
  }

  public boolean in3D(boolean playerIn3D){
    return in3D;
  }

  //rener methods
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
  
  public void draw3D(skiny_mann context,PGraphics render){
    
  }
  
  //factory methhod
  public Entity create(float x,float y,float z){
    return new Goon(x,y,z,null);
  }
  
  //killable methods
  public void kill(){
    dead=true;
    mm.reset();
  }
  
  public void respawn(){
    dead=false;
    x=ix;
    y=iy;
    z=iz;
    mm.reset();
  }
  
  public boolean isDead(){
    return dead;
  }
  
  
  
  public JSONObject save(){
    JSONObject data = new JSONObject();
    data.setFloat("x",ix);
    data.setFloat("y",iy);
    data.setFloat("z",iz);
    data.setString("type","goon");
    return data;
  }
  
  public PlayerIniteractionResult playerInteraction(Collider2D playerHitBox){
    
    //if the player hits the kill Entity box section
    if(new CollisionDetection().collide2D(playerHitBox,Collider2D.createRectHitbox(x-10,y-50,20,10))){
      //kill this entity
      kill();
      return null;
    }
    
    return new PlayerIniteractionResult().setKill();
  }
  
  public PlayerIniteractionResult playerInteraction(Collider3D playerHitBox){
    return null;
  }
  
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
  
  @Override
  public Identifier id() {
    return ID;
  }
  
}
