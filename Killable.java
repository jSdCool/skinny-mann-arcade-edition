/**Makes an entity able to be killed
*/
public interface Killable{
  /**Kill this entity
  */
  public void kill();
  /**Check if this entity is dead
  @return true if the endity is dead
  */
  public boolean isDead();
  /**Respawn this entity
  */
  public void respawn();
}
