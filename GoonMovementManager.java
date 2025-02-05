class GoonMovementManager extends MovementManager{
  
  public static final Identifier ID = new Identifier("goonMovementManager");
  
  GoonMovementManager(Goon goon){
    this.goon=goon;
  }
  
  GoonMovementManager(SerialIterator iterator){
    
  }
  
  Goon goon;
  
  boolean left,right,jump,in,out;
  
  public boolean left(){
    return left;
  }
  
  public boolean right(){
    recalculateMovements();
    return right;
  }
  
  public boolean jump(){
    return jump;
  }
  
  public boolean in(){
    return in;
  }
  
  public boolean out(){
    return out;
  }
  
  public void reset(){
    left=false;
    right=false;
    jump=false;
    in=false;
    out=false;
  }
  
  void recalculateMovements(){
    if(!goon.isDead()){
      if(!goon.in3D){
        if(right){
          //if there is a wall in fron the the entity
          if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(2,0),goon)){
            //and there is sill a wall 9 units up
            if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(2,-6),goon)){
              right=false;
              left=true;
              return;
            }
          }
          //if there is a clif in front of the entity
          if(!StageEntityCollisionManager.level_colide(goon.getHitBox2D(2,11),goon)){
            right=false;
            left=true;
            return;
          }
        }else if(left){
          //if there is a wall in fron the the entity
          if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(-2,0),goon)){
            //and there is sill a wall 9 units up
            if(StageEntityCollisionManager.level_colide(goon.getHitBox2D(-2,-6),goon)){
              right=true;
              left=false;
              return;
            }
          }
          //if there is a clif in front of the entity
          if(!StageEntityCollisionManager.level_colide(goon.getHitBox2D(-2,11),goon)){
            right=true;
            left=false;
            return;
          }
        }else{
          right=true;
        }
      }
    }
    //StageEntityCollisionManager.level_colide(
  }
  
  public SerializedData serialize(){
    SerializedData data = new SerializedData(id());
    
    return data;
  }
  
  public Identifier id(){
    return ID;
  }
  
}
