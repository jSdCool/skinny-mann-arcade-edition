class StageEntityCollisionManager{
  private static skiny_mann source;
  
  public static void set(skiny_mann source2){
    source=source2;
  }
  
  //TODO: this needs to be changed to be fore effishent
  public static boolean level_colide(Collider2D hitbox, StageEntity entity){
    return source.level_colide(hitbox,source.generateLevel2DComboBox((entity.getStage())));
  }
  
  public static boolean level_colide(Collider3D hitbox, StageEntity entity){
    return source.level_colide(hitbox,source.generateLevel3DComboBox((entity.getStage())));
  }
}
