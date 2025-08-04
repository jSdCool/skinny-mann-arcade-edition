/**Context and utilities for placing a logic component
*/
public class LogicCompoentnPlacementContext{
  
  private float x, y;
  private LogicBoard lb;
  /**Create a placemtn context for a logic component
  @param x The x position of the component
  @param y The y position of the component
  @param lb The logic board the component is being place on
  */
  public LogicCompoentnPlacementContext(float x, float y, LogicBoard lb){
    this.x=x;
    this.y=y;
    this.lb=lb;
  }
  /**Get the x position of the component
  @return The x value of the component
  */
  public float getX(){
    return x;
  }
  /**Get the y position of the component
  @return The y position of the component
  */
  public float getY(){
    return y;
  }
  /**Get the logic board the component is being place on
  @return The logic board the component is being place on
  */
  public LogicBoard getLogicBoard(){
    return lb;
  }
  
}
