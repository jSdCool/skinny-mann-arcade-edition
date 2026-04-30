import processing.core.*;
import java.util.ArrayList;
import processing.data.*;
/**The alien emeny that can be found in game
*/
public class AlienEntity extends StageEntity implements Configurable{
  
  /**Place an alien
  @param context The context for the placement
  */
  public AlienEntity(StageEntityPlacementContext context){
    super(context);
  }
  
  /**Load an alien from saved JSON data
  @param data The saved JSON data
  */
  public AlienEntity(JSONObject data){
    super(data);
    maxWanderDistance = data.getInt("maxWanderDistance");
  }
  
  /**Recreate an alien from serialized binarry data
  @param iterator The source of the binarry data
  */
  public AlienEntity(SerialIterator iterator){
    super(iterator);
    maxWanderDistance = iterator.getInt();
    facingRight = iterator.getBoolean();
    dead = iterator.getBoolean();
  }
  
  //if this entity is facing / moving to the right
  boolean facingRight = true;
  boolean changeDirection = false;
  boolean newDirection = true;
  boolean dead = false;
  boolean chasingPlayer = false;
  boolean stopped = false;
  
  int maxWanderDistance = 300;
  int chasingPlayerIndex = 0;
  int pause = 0;
  
  public static final Identifier ID = new Identifier("alien");
  
  /**Render the 2D representation of this entity.<br>
  NOTE: this method may be called more then once per frame
  @param context The context of the render
  @param render The surface to draw to
  */
  public void draw(skiny_mann context,PGraphics render){
    float scale = context.Scale;
    float drawX = (x+ (facingRight?6:-6) - context.drawCamPosX) * context.Scale;
    float drawY = (y-5 + context.drawCamPosY) * context.Scale;
    int facing = facingRight? -1:1;
    renderAlien2D(render,drawX,drawY,scale,facing);
  }
  
  public static void renderAlien2D(PGraphics render, float drawX, float drawY, float scale, int facing){
    //NOTE: all value offsets will need to be multipled by scale. do not multiply the x or y variblles by scale, they allready are sclaed
    //body
    render.fill(120,152,122);
    render.triangle(drawX,drawY,drawX,drawY-15*scale,drawX+15*scale*facing,drawY-12*scale);
    render.triangle(drawX+10*scale*facing,drawY-20*scale,drawX,drawY-15*scale,drawX+15*scale*facing,drawY-12*scale);
    render.triangle(drawX+10*scale*facing,drawY-20*scale,drawX,drawY-15*scale,drawX+5*scale*facing,drawY-20*scale);
    render.triangle(drawX,drawY-10*scale,drawX+4*scale*facing,drawY+20*scale,drawX-15*scale*facing,drawY+20*scale);
    render.triangle(drawX-8*scale*facing,drawY+25*scale,drawX+4*scale*facing,drawY+20*scale,drawX-15*scale*facing,drawY+20*scale);
    render.triangle(drawX-8*scale*facing,drawY+25*scale,drawX+4*scale*facing,drawY+20*scale,drawX+2*scale*facing,drawY+25*scale);
    //head
    render.fill(25,155,17);
    render.triangle(drawX-12*scale*facing,drawY-20*scale,drawX-12*scale*facing,drawY-28*scale,drawX+30*scale*facing,drawY-20*scale);
    render.triangle(drawX-12*scale*facing,drawY-20*scale,drawX-12*scale*facing,drawY-18*scale,drawX,drawY-20*scale);
    render.triangle(drawX+20*scale*facing,drawY-20*scale,drawX+30*scale*facing,drawY-20*scale,drawX+30*scale*facing,drawY-19*scale);
    //mouth mabby
    
    //legs
    render.fill(21,193,28);
    render.triangle(drawX-8*scale*facing,drawY+25*scale,drawX-5*scale*facing,drawY+25*scale,drawX+2*scale*facing,drawY+32*scale);
    render.triangle(drawX-8*scale*facing,drawY+25*scale,drawX-1*scale*facing,drawY+32*scale,drawX+2*scale*facing,drawY+32*scale);
    render.triangle(drawX-1*scale*facing,drawY+25*scale,drawX+2*scale*facing,drawY+25*scale,drawX+9*scale*facing,drawY+32*scale);
    render.triangle(drawX-1*scale*facing,drawY+25*scale,drawX+6*scale*facing,drawY+32*scale,drawX+9*scale*facing,drawY+32*scale);
    render.triangle(drawX-8*scale*facing,drawY+40*scale,drawX-5*scale*facing,drawY+40*scale,drawX+2*scale*facing,drawY+32*scale);
    render.triangle(drawX-8*scale*facing,drawY+40*scale,drawX-1*scale*facing,drawY+32*scale,drawX+2*scale*facing,drawY+32*scale);
    render.triangle(drawX-1*scale*facing,drawY+40*scale,drawX+2*scale*facing,drawY+40*scale,drawX+9*scale*facing,drawY+32*scale);
    render.triangle(drawX-1*scale*facing,drawY+40*scale,drawX+6*scale*facing,drawY+32*scale,drawX+9*scale*facing,drawY+32*scale);
    
    //arms
    render.triangle(drawX,drawY-10*scale,drawX,drawY-13*scale,drawX-12*scale*facing,drawY-7*scale);
    render.triangle(drawX,drawY-10*scale,drawX-12*scale*facing,drawY-4*scale,drawX-12*scale*facing,drawY-7*scale);
    render.quad(drawX-12*scale*facing,drawY-4*scale, drawX-18*scale*facing,drawY-4*scale, drawX-18*scale*facing,drawY-7*scale, drawX-12*scale*facing,drawY-7*scale);
    
    render.triangle(drawX+8*scale*facing,drawY-7*scale,drawX+8*scale*facing,drawY-10*scale,drawX-12*scale*facing,drawY-2*scale);
    render.triangle(drawX+8*scale*facing,drawY-7*scale,drawX-12*scale*facing,drawY+1*scale,drawX-12*scale*facing,drawY-2*scale);
    render.quad(drawX-12*scale*facing,drawY+1*scale, drawX-16*scale*facing,drawY+1*scale, drawX-16*scale*facing,drawY-2*scale, drawX-12*scale*facing,drawY-2*scale);
  }
  
  public void draw3D(skiny_mann context,PGraphics render){
    
  }
  
  public void update(EntityAgentContext context){
    
    if(pause > 0){//if pausing then decrease the pause timer and do thing else
      pause -= context.getMspc();
      return;
    }
    
    if(changeDirection){
      facingRight = newDirection;
      changeDirection = false;
    }
    
    float eadjust = context.getMspc() * 0.4f;
    if(!facingRight){
      eadjust *= -3;
    }
    
    if(!chasingPlayer){
      //check for player in "view" area to chase
      for(int i = 0; i<context.getPlayers().length;i++){
        Player p = context.getPlayers()[i];
        float vertRange = Math.abs(p.getY()-getY());
        if(vertRange > 250){//check if this player is whithin vertical tracking range
          continue;
        }
        float horRange = p.getX() - getX();
        if(Math.abs(horRange) > maxWanderDistance*1.7){//check if this player is within horozontal tracking range
          continue;
        }
        //check if the player is in the direction the alien is looking
        if(facingRight == horRange > 0){
          chasingPlayerIndex = i;
          chasingPlayer = true;
          pause = 500;
          break;
        }
      }
    } else {
      //check if we should continue chasing this player
      if(chasingPlayerIndex < context.getPlayers().length){
        Player p = context.getPlayers()[chasingPlayerIndex];
        float vertRange = Math.abs(p.getY()-getY());
        if(vertRange > 250){//check if this player is whithin vertical tracking range
          chasingPlayer = false;
          stopped = false;
        } else {
          float horRange = p.getX() - getX();
          if(Math.abs(horRange) > maxWanderDistance*1.7){//check if this player is within horozontal tracking range
            chasingPlayer = false;
            stopped = false;
          } else {
            //the player is sill wihtin tracking range
            //if the alien is very close to the player posision then stop moving
            if(Math.abs(horRange) < 20){
              stopped = true;
            } else {
              stopped = false;
              //face in the direction of the player
              changeDirection = true;
              newDirection = horRange > 0;
            }
            
          }
        }
      }else{
        chasingPlayer = false;
        stopped = false;
        pause = 500;
      }
    }
    
    
    
    
    //if in 3D do 3D testing thigns here
    
    //check collide with wall
    Collider2D groudLevelBox = getHitBox2D(eadjust, -10);
    boolean collided = false;
    for(Collider2D box: context.get2DCollisions()){
      if(CollisionDetection.collide2D(groudLevelBox,box)){
        collided = true;
        break;
      }
    }
    if(collided){
      if(chasingPlayer){
        stopped = true;
      }else{
        changeDirection = true;
        newDirection = !facingRight;
        pause = 1000;//pause for 1 second when chaning direcion
      }
      return;
    }
    
    //check stand on ground
    Collider2D underGroundBox = getHitBox2D(eadjust, 15);
    collided = false;
    for(Collider2D box: context.get2DCollisions()){
      if(CollisionDetection.collide2D(underGroundBox,box)){
        collided = true;
        break;
      }
    }
    if(!collided){
      if(chasingPlayer){
        stopped = true;
      } else {
        changeDirection = true;
        newDirection = !facingRight;
        pause = 1000;//pause for 1 second when chaning direcion
      }
      return;
    }
    
    float wanderDist = x - respawnX;
    
    if(facingRight){
      if(wanderDist >= maxWanderDistance){
        if(chasingPlayer){
          stopped = true;
        }else{
          changeDirection = true;
          newDirection = false;
          pause = 1000;//pause for 1 second when chaning direcion
        }
      }
    } else {
      if(wanderDist <= -maxWanderDistance){
        if(chasingPlayer){
          stopped = true;
        } else{
          changeDirection = true;
          newDirection = true;
          pause = 1000;//pause for 1 second when chaning direcion
        }
      }
    }
    
  }
  
  public MovementManager getMovementmanager(){
   return new MovementManager(){
     public boolean left(){
       return !facingRight && pause <= 0 && !stopped;
     }
     
     public boolean right(){
       return facingRight && pause <= 0 && !stopped;
     }
     
     public boolean jump(){
       return false;
     }
     
     public boolean in(){
       return false;
     }
     
     public boolean out(){
       return false;
     }
     
     public void reset(){
       
     }
     
     public Identifier id(){
       return null;
     }
     
     public SerializedData serialize(){
       return null;
     }
     
   }; 
  }
  
  public boolean collidesWithEntites(){
    return false;
  }
  
  public Collider3D getHitBox3D(float offsetX, float offsetY, float offsetZ){
    return null;
  }
  
  public Collider2D getHitBox2D(float offsetX, float offsetY){
    float hbx = x-24 + offsetX;
    float hby=y-35 + offsetY;
    return Collider2D.createRectHitbox(hbx,hby,48,70);
    
  }
  
  public boolean in3D(boolean playerIn3D){
    return false;
  }
  
  public Identifier id(){
    return ID;
  }
  
  public void kill(){
    dead = true;
  }
  
  public void respawn(){
    setX(respawnX);
    setY(respawnY);
    setZ(respawnZ);
    dead = false;
  }
  
  public boolean isDead(){
    return dead;
  }
  
  public SerializedData serialize(){
    SerializedData data = serializeInternal();
    data.addInt(maxWanderDistance);
    data.addBool(facingRight);
    data.addBool(dead);
    return data;
  }
  
  public JSONObject save(){
    JSONObject data = saveInternal();
    data.setInt("maxWanderDistance",maxWanderDistance);
    return data;
  }
  
  /**Get the result of the player interacting with this entity in 2D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public PlayerIniteractionResult playerInteraction(Collider2D playerHitBox){
    
    
    
    //if not kill this entity
    float hbx = x- 24 *(facingRight? -1:1);//if facing right then add 24, if facing left then subtact 24. its not perfect positioning but it is good enough
    float hby = y-29;
    Collider2D killBox = Collider2D.createRectHitbox(hbx,hby,4,64);
    //check if the player is contecting the "hands" area in front of the entity
    if(CollisionDetection.collide2D(killBox, playerHitBox)){
      return new PlayerIniteractionResult().setKill();//if so kill the player
    }
    //if not kill this entity
    kill();
    return null;
  }
  /**Get the result of the player interacting with this entity in 3D
  @param playerHitBox The hitbox of the player
  @return The result of the player interaction or null if there is no result
  */
  public PlayerIniteractionResult playerInteraction(Collider3D playerHitBox){
    return null;
  }
  
  @Override
  public Property[] getProperties(){
    return new Property[]{new IntegerProperty(() -> maxWanderDistance, (newValue) -> {if(newValue>0) maxWanderDistance = newValue;},"Max Wander Distance")};
  }
}
