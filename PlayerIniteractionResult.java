/**Represents the result of a plyer entity interacton
*/
public class PlayerIniteractionResult{
  boolean killPlayer;
  
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
