/**Represents something that can be interacted with
*/
public interface Interactable{//what is this non descriptive abomination? I think this has something to do with the logic button
  /**Processes interactions between the world and this compoenent
  @param stageIndex The index of the stage this component it in
  */
  void worldInteractions(int stageIndex);
}
