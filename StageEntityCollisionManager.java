class StageEntityCollisionManager{
  private static skiny_mann source;
  
  public static void set(skiny_mann source2){
    source=source2;
  }
  
  public static boolean level_colide(Collider2D hitbox, StageEntity entity){
    return source.level_colide(hitbox,entity.getStage());
  }
  
  public static boolean level_colide(Collider3D hitbox, StageEntity entity){
    return source.level_colide(hitbox,entity.getStage());
  }
}
