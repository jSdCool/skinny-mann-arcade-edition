//LogicInputComponent
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
/**A special varient of the logic component that only has inputs
*/
public abstract class LogicInputComponent extends LogicComponent {
  /**Create a logic component at the provided position with the given type
  @param x the visual x position
  @param y the visual y position
  @param type The type name to display on the component
  @param board The logic board the component is on
  */
  public LogicInputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(source, x, y, 100*source.Scale, 40*source.Scale, "  "+type+"  ");
  }
  /**Creates a logic compoennet at the proviede position with the provided connections
  @param x the visual x position
  @param y the visual y position
  @param type The type name to display on the component
  @param cnects JSONArray containing a list of connections consisting of an index and terminal integers
  */
  public LogicInputComponent(float x, float y, String type, JSONArray cnects) {
    super(x, y, type, cnects);
    button=new Button(source, x, y, 100*source.Scale, 40*source.Scale, "  "+type+"  ");
  }
  /**Creates a logic component from serialized data
  @param iterator The source of the data
  */
  public LogicInputComponent(SerialIterator iterator){
    super(iterator);
  }
  /**renders the logic component a long with its I/O terminals
  */
  public void draw() {
    button.x=(x-source.camPos)*source.Scale;
    button.y=(y-source.camPosY)*source.Scale;
    button.draw();
    source.fill(-369706);
    source.ellipse((x+102-source.camPos)*source.Scale, (y+20-source.camPosY)*source.Scale, 20*source.Scale, 20*source.Scale);
  }
  /**Get the position of a I/O terminal
  @param t The index of the terminal to get
  @return A float array containg 2 elemts represeting the on screen x,y coords of the terminal. NOTE: theese have allready been camera adjusted
  */
  public float[] getTerminalPos(int t) {
    if (t==2) {
      return new float[]{x+102-source.camPos, y+20-source.camPosY};
    }
    return new float[]{-1000, -1000};
  }
}
