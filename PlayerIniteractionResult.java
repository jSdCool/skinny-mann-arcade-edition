/**Represents the result of a player - entity / player - component interacton.<br>
A player - entity interaction occors when a player's hitbox overlaps with an entities.<br>
A player - component interation occors when a player is standing on top of the component in question and presses the USE button.
*/
public class PlayerIniteractionResult{
  private boolean killPlayer;
  
  /**Set that this resault should kill the player
  */
  public PlayerIniteractionResult setKill(){
    killPlayer=true;
    return this;
  }
  
  /**Check if this result should kill the player
  @return true if this result should kill the player
  */
  public boolean isKill(){
    return killPlayer;
  }
}
