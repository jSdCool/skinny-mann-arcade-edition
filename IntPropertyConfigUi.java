import processing.core.*;
/**The UI definitions for editing compoent int properties in the toolbox.
*/
public class IntPropertyConfigUi extends PropertyConfigUi<Integer,IntegerProperty>{
  
  /**The singleton instace of this class
  */
  private static IntPropertyConfigUi instace;
  
  /**Get the instace of this class
  */
  public static IntPropertyConfigUi getInstace(){
    return instace;
  }
  
  /**The display name of this property
  */
  private UiText title;
  
  /**The value adjustments buttons
  */
  private UiButton increase,increaseMore,increaseAlot,decrease,decreaseMore,decreaseAlot;
  
  /**The display for the current property value
  */
  private UiText valueDisplay;
  
  /**Create a new int property config ui
  @param render The surface to render to
  @param toolboxUi the tool box window
  */
  public IntPropertyConfigUi(PGraphics render, UiFrame toolboxUi){
    super(render,toolboxUi);
    title = new UiText(ui, "",640,10,TEXT_SIZE,PApplet.CENTER,PApplet.CENTER);
    increase = (UiButton)new UiButton(ui, 1005, 10, 50, 50, "+", 255, 203).setStrokeWeight(5);
    increaseMore = (UiButton)new UiButton(ui, 1065, 10, 50, 50, "++", 255, 203).setStrokeWeight(5);
    increaseAlot = (UiButton)new UiButton(ui, 1125, 10, 50, 50, "+++", 255, 203).setStrokeWeight(5);
    decrease = (UiButton)new UiButton(ui, 225, 10, 50, 50, "-", 255, 203).setStrokeWeight(5);
    decreaseMore = (UiButton)new UiButton(ui,165, 10, 50, 50, "--", 255, 203).setStrokeWeight(5);
    decreaseAlot = (UiButton)new UiButton(ui, 105, 10, 50, 50, "---", 255, 203).setStrokeWeight(5);
    valueDisplay = new UiText(ui,"",640,10,TEXT_SIZE,PApplet.CENTER,PApplet.CENTER);
    instace = this;
  }
  
  /**Render the configuration for this propery at the given slot
  @param slotId The index of the slot to display this property
  @param property The specific property that is being renderd
  @param context The context for the property configuration
  */
  public void draw(int slotId, IntegerProperty property, PropertyConfigEnviormentContext context){
    render.fill(0);
    title.setText(property.getName());
    title.setY(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    title.draw();
    increase.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    increaseMore.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    increaseAlot.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    decrease.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    decreaseMore.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    decreaseAlot.setIy(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    
    increase.reScale();
    increaseMore.reScale();
    increaseAlot.reScale();
    decrease.reScale();
    decreaseMore.reScale();
    decreaseAlot.reScale();
    
    increase.draw();
    increaseMore.draw();
    increaseAlot.draw();
    decrease.draw();
    decreaseMore.draw();
    decreaseAlot.draw();
    render.fill(0);
    valueDisplay.setY(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    valueDisplay.setText(property.get()+"");
    valueDisplay.draw();
    
  }
  
  /**Process mouse clicks that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void mouseClicked(int slotId, IntegerProperty property, PropertyConfigEnviormentContext context){
    increase.setIy(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    increaseMore.setIy(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    increaseAlot.setIy(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    decrease.setIy(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    decreaseMore.setIy(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    decreaseAlot.setIy(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    if(increase.isMouseOver()){
      property.set(property.get()+1);
    }
    if(increaseMore.isMouseOver()){
      property.set(property.get()+10);
    }
    if(increaseAlot.isMouseOver()){
      property.set(property.get()+100);
    }
    if(decrease.isMouseOver()){
      property.set(property.get()-1);
    }
    if(decreaseMore.isMouseOver()){
      property.set(property.get()-10);
    }
    if(decreaseAlot.isMouseOver()){
      property.set(property.get()-100);
    }
  }
}
