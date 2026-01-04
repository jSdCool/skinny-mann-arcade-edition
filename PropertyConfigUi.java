import processing.core.*;
/**The UI definitions for editing compoent properties in the toolbox.<br>
NOTE: all sub classes are expected to effectivly be singltons where their only instance is created by the tool box when it opens
@param <R> The return type of the property this config ui is for
@param <T> The property that this ui is designed to configure
*/
public abstract class PropertyConfigUi<R,T extends Property<R,T>>{
  
  public static final int START_CONFIG_Y = 130;
  public static final int SLOT_HEIGHT = 100;
  public static final int TEXT_SIZE = 25;
  
  /**The surface that the UI will be renderd to
  */
  protected PGraphics render;

  /**The Ui frame of the tool box
  */
  protected UiFrame ui;
  
  /**Create a new property config ui
  @param render The surface to render to
  @param toolBoxUi the tool box window
  */
  public PropertyConfigUi(PGraphics render, UiFrame toolBoxUi){
    this.render = render;
    this.ui = toolBoxUi;
  }
  
  /**Render the configuration for this propery at the given slot
  @param slotId The index of the slot to display this property
  @param property The specific property that is being renderd
  @param context The context for the property configuration
  */
  public abstract void draw(int slotId, T property, PropertyConfigEnviormentContext context);
  
  /**Process mouse clicks that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public abstract void mouseClicked(int slotId, T property, PropertyConfigEnviormentContext context);
  
  /**Process mouse pressed events that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void mousePressed(int slotId, T property, PropertyConfigEnviormentContext context){}
  
  /**Process mouse released that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void mouseReleased(int slotId, T property, PropertyConfigEnviormentContext context){}
  
  /**Process key pressed events that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void keyPressed(int slotId, T property, PropertyConfigEnviormentContext context){}
  
  /**Process key released that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void keyReleased(int slotId, T property, PropertyConfigEnviormentContext context){}
  
  /**Process key typed events that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void keyTyped(int slotId, T property, PropertyConfigEnviormentContext context){}
  
  /**A functional interface that represents the constructor for a Property config ui.<br>
  used for where the constructor is needed to be passed in for registratcion
  */
  public interface PropConfigUiFactory{
    /**Create a new property config ui
    @param render The surface to render to
    @param toolBoxUi the tool box window
    */
    PropertyConfigUi<?,?> create(PGraphics render, UiFrame toolBoxUi);
  }
}
