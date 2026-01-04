/**Continas various useful bits of context for compoennt property configuration
*/
public class PropertyConfigEnviormentContext{
  
  private final int numberOfBooleanVars;
  private final String[] groupNames;
  private final String[] soundKeys;
  
  /**Create a new context for component property configuration
  @param numBooleanVars The number of boolean vars in this level
  @param groupNames The names of the groups in this level
  @param soundKeys The keys for each stage sound in this level
  */
  public PropertyConfigEnviormentContext(int numBooleanVars, String[] groupNames, String[] soundKeys){
    numberOfBooleanVars = numBooleanVars;
    this.groupNames = groupNames;
    this.soundKeys = soundKeys;
  }
  
  /**Get the number of boolean variables the current level has
  @return the nubmber of boolean variables that currently exsist
  */
  public int getNumberOfBooleanVars(){
    return numberOfBooleanVars;
  }
  
  /**Get the names of groups in the current level
  @return an array containing the names of each group in this level
  */
  public String[] getGroupNames(){
    return groupNames;
  }
  
  /**Get the names/keys for all the currently loaded stage sounds
  @return the kes for stage sounds
  */
  public String[] soundKeys(){
    return soundKeys;
  }
}
