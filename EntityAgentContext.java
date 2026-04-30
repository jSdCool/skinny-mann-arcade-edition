import java.util.ArrayList;
/**Contains context information for AI entitiy agent progams.<br>
Basicaly anything an enitties AI might need for each time it proceeses exsisting
*/
public class EntityAgentContext{
  //float mspc, ArrayList<Collider2D> stageCollisions
  final float mspc;
  final ArrayList<Collider2D> stageCollision2D;
  final ArrayList<Collider3D> stageCollision3D;
  final Player[] players;
  final ArrayList<StageEntity> entities;
  
  /**Create a context object for an entity on a stage
  @param mspc The number of milliseconds sins the last physics update
  @param stageCollision2D The 2D Colliders of the stage the entity is in
  @param stageCollision3D The 3D Colliders of the stage the entity is in if the stage is a 3D stage. If the stage is not a 3D stage then this will be null
  @param players The relivant players to this entity. Only contains players on the same stage as this entity. Will have at most 1 player unless the multyplayer mode is co-op
  @param entities The entities on the same stage as this one. This does include this entity
  */
  public EntityAgentContext(float mspc, ArrayList<Collider2D> stageCollision2D, ArrayList<Collider3D> stageCollision3D, Player[] players, ArrayList<StageEntity> entities){
    //note it may be wise to make theese collections immutable
    this.mspc = mspc;
    this.stageCollision2D = stageCollision2D;
    this.stageCollision3D = stageCollision3D;
    this. players = players;
    this.entities = entities;
  }
  
  /**Get the number of milliseconds since the last physics tick
  @return The number of milliseconds sinc the last tick
  */
  public float getMspc(){
    return mspc;
  }
  
  /**Get the 2D collision boxes for the stage the entity is in
  @return The 2D Colliders for the stage the entitiy is in
  */
  public ArrayList<Collider2D> get2DCollisions(){
    return stageCollision2D;
  }
  
  /**Get the 3D collision boxes for the stage the entity is in if the stage is 3D
  @return The 3D Colliders for the stage the entitiy is in. will return null if in a 2D stage!
  */
  public ArrayList<Collider3D> get3DCollisions(){
    return stageCollision3D;
  } 
  
  /**Get the relivant players to this entity
  @return An array of players in the same stage as this entity. Unless in a co-op stage this will almost always contian a single player
  */
  public Player[] getPlayers(){
    return players;
  }
  
  /**Get the entities that are in the same stage as this entity.
  @return The entities in this entities' stage includeing its self.
  */
  public ArrayList<StageEntity> getEntities(){
    return entities;
  }
  
}
