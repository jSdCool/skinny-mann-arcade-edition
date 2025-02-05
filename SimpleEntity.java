import java.util.Random;
import processing.data.*;
import processing.core.*;
class SimpleEntity extends StageEntity{
  
  public static final Identifier ID = new Identifier("SimpleEntity");
  
  public SimpleEntity(float x,float y,float z,Stage stage){
    super(stage);
    spawnX=x;
    spawnY=y;
    spawnZ=z;
    setX(x);
    setY(y);
    setZ(z);
  }
  
  public SimpleEntity(SerialIterator iterator){
    super(null);
    x = iterator.getFloat();
    y = iterator.getFloat();
    z = iterator.getFloat();
    spawnX = iterator.getFloat();
    spawnY = iterator.getFloat();
    spawnZ = iterator.getFloat();
    vVelcoity = iterator.getFloat();
    dead = iterator.getBoolean();
  }
  
  public Entity create(float x,float y,float z){
    return new SimpleEntity(x,y,z,null);
  }
  
  public StageEntity create(JSONObject input,Stage stage){
    return new SimpleEntity(input.getFloat("x"),input.getFloat("y"),input.getFloat("z"),stage);
  }
  
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
      boolean left(){return ax==-1;}
      boolean right(){return ax==1;}
      boolean in(){return az == -1;}
      boolean out(){return az ==1;}
      boolean jump(){return j;}
      void reset(){
        ax = (int)(r.nextInt(-1,2));
        az = (int)(r.nextInt(-1,2));
        j = (int)(Math.random()*2)==1;
      };
      //SerialIterator iterator
      @Override
      public SerializedData serialize() {
        return null;
      }
      
      @Override
      public Identifier id() {
        return null;
      }
    };
  
  public MovementManager getMovementmanager(){
    return m;
  }
  
  float x,y,z;
  float spawnX,spawnY,spawnZ;
  float vVelcoity;
  boolean dead = false;
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public float getZ(){
    return z;
  }
  
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
  
  public boolean collidesWithEntites(){
    return false;
  }
  
  public Collider3D getHitBox3D(float offsetX,float offsetY,float offsetZ){
    return Collider3D.createBoxHitBox(x+offsetX,y+offsetY,z+offsetZ,40,40,40);
  }
  
  public Collider2D getHitBox2D(float offsetX,float offsetY){
   return Collider2D.createRectHitbox(x+offsetX,y+offsetY,40,40); 
  }
  
  public boolean in3D(boolean playerIn3D){
    return playerIn3D;
  }
  
  public float getVerticalVelocity(){
    return vVelcoity;
  }
  
  public Entity setVerticalVelocity(float v){
    vVelcoity=v;
    return this;
  }
  
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
  
  public void kill(){
    dead=true;
  }
  
  public boolean isDead(){
    return dead;
  }
  
  public void respawn(){
    dead=false;
    setX(spawnX);
    setY(spawnY);
    setZ(spawnZ);
  }
  
  public PlayerIniteractionResult playerInteraction(Collider2D playerHitBox){
    return null;
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
    data.addFloat(spawnX);
    data.addFloat(spawnY);
    data.addFloat(spawnZ);
    data.addFloat(vVelcoity);
    data.addBool(dead);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
