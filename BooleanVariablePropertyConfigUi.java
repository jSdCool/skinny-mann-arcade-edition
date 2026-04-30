import processing.core.*;
/**The UI definitions for editing boolean varaible compoent properties in the toolbox.
*/
public class BooleanVariablePropertyConfigUi extends PropertyConfigUi<Integer, IntegerProperty>{

  
  /**The singleton instace of this class
  */
  private static BooleanVariablePropertyConfigUi instace;
  
  /**The display name of this property
  */
  private UiText title;
  
  /**Get the instace of this class
  @return the singleton instace of this class
  */
  public static BooleanVariablePropertyConfigUi getInstace(){
    return instace;
  }
  
  /**The buttons to change the currently selcted variable
  */
  private UiButton nextvar, prevVar;
  
  /**The display for the current property value
  */
  private UiText valueDisplay;
  
  /**Create a new int property config ui
  @param render The surface to render to
  @param toolboxUi the tool box window
  */
  public BooleanVariablePropertyConfigUi(PGraphics render, UiFrame toolboxUi){
    super(render,toolboxUi);
    
    nextvar = (UiButton)new UiButton(ui, 1125, 10, 50, 50, ">", 255, 203).setStrokeWeight(5);
    prevVar = (UiButton)new UiButton(ui, 105, 10, 50, 50, "<", 255, 203).setStrokeWeight(5);
    title = new UiText(ui, "",640,10,TEXT_SIZE,PApplet.CENTER,PApplet.CENTER);
    valueDisplay = new UiText(ui,"",640,10,TEXT_SIZE,PApplet.CENTER,PApplet.CENTER);
    
    instace = this;
  }
  
  /**Render the configuration for this propery at the given slot
  @param slotId The index of the slot to display this property
  @param property The specific property that is being renderd
  @param context The context for the property configuration
  */
  public void draw(int slotId, IntegerProperty property, PropertyConfigEnviormentContext context){
    int value = property.get();
    
    render.fill(0);
    title.setText(property.getName());
    title.setY(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    title.draw();
    
    if(value > 0){
      prevVar.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
      prevVar.reScale();
      prevVar.draw();
    }
    
    if(value <context.getNumberOfBooleanVars()-1){
      nextvar.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
      nextvar.reScale();
      nextvar.draw();
    }
    
    render.fill(0);
    valueDisplay.setY(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    if(value >= 0){
      valueDisplay.setText("b"+value);
    } else {
      valueDisplay.setText("None");
    }
    valueDisplay.draw();
  }
  
  /**Process mouse clicks that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void mouseClicked(int slotId, IntegerProperty property, PropertyConfigEnviormentContext context){
    int value = property.get();
    if(value > 0){
      prevVar.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
      prevVar.reScale();
      if(prevVar.isMouseOver()){
        property.set(value-1);
      }
    }
    
    if(value < context.getNumberOfBooleanVars()-1){
      nextvar.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
      nextvar.reScale();
      if(nextvar.isMouseOver()){
        property.set(value+1);
      }
    }
  }
}
