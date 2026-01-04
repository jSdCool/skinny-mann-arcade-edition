import processing.core.*;
/**The UI definitions for editing string compoent properties in the toolbox.<br>
NOTE: This is a singleton class. use getInstace to obtain an insatce
*/
public class StringPropertyConfigUi extends PropertyConfigUi<String,StringProperty>{
  
  /**The singleton instace of this class
  */
  private static StringPropertyConfigUi instace;
  
  /**Get the instace of this class
  */
  public static StringPropertyConfigUi getInstace(){
    return instace;
  }
  
  /**The text that the player is editing
  */
  private UiTextBox text;
  /**The display name of this property
  */
  private UiText title;
  /**The index of the slot that is currently being typed in
  */
  private int activeSlot = -1;
  
  /**The index of the cursor in the selected box
  */
  private int cursorPos = 0;
  
  /**Create a new string property config ui
  @param render The surface to render to
  @param toolboxUi the tool box window
  */
  public StringPropertyConfigUi(PGraphics render, UiFrame toolboxUi){
    super(render,toolboxUi);
    instace = this;
    text = new UiTextBox(ui, 150,10,980,50);
    title = new UiText(ui, "",640,10,TEXT_SIZE,PApplet.CENTER,PApplet.CENTER);
  }
  
  /**Render the configuration for this propery at the given slot
  @param slotId The index of the slot to display this property
  @param property The specific property that is being renderd
  @param context The context for the property configuration
  */
  public void draw(int slotId, StringProperty property, PropertyConfigEnviormentContext context){
    render.fill(0);
    title.setText(property.getName());
    title.setY(START_CONFIG_Y+25+SLOT_HEIGHT*slotId);
    title.draw();
    
    text.setY(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    text.setTyping(activeSlot == slotId);
    text.setContence(property.get(),cursorPos);
    text.draw();
  }
  
  /**Process mouse clicks that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void mouseClicked(int slotId, StringProperty property, PropertyConfigEnviormentContext context){
    text.setY(START_CONFIG_Y+50+SLOT_HEIGHT*slotId);
    text.setTyping(activeSlot == slotId);
    if(activeSlot == slotId){
      text.setContence(property.get(),cursorPos);
    } else {
      text.setContence(property.get());
    }
    text.mouseClicked();
    
    if(activeSlot == slotId && !text.isTyping()){
      activeSlot = -1;
    }else if(activeSlot != slotId && text.isTyping()){
      activeSlot = slotId;
    }
    if(activeSlot == slotId){
      cursorPos = text.getCursorPos();
    }
  }
  
  /**Process key pressed events that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void keyPressed(int slotId, StringProperty property, PropertyConfigEnviormentContext context){
    System.out.println("Key pressed: "+ui.getSource().key+" "+ui.getSource().keyCode);
    text.setTyping(activeSlot == slotId);
    if(activeSlot == slotId){
      text.setContence(property.get(),cursorPos);
      text.keyPressed();
      property.set(text.getContence());
      cursorPos = text.getCursorPos();
    }
  }
  
  /**Process key released that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void keyReleased(int slotId, StringProperty property, PropertyConfigEnviormentContext context){
    text.setTyping(activeSlot == slotId);
    if(activeSlot == slotId){
      text.setContence(property.get(),cursorPos);
      text.keyReleased();
      property.set(text.getContence());
      cursorPos = text.getCursorPos();
    }
  }
  
  /**Process key typed events that happen while a property is being configured.
  @param slotId The index of the slot to display this property
  @param property The specific property that is being procesed
  @param context The context for the property configuration
  */
  public void keyTyped(int slotId, StringProperty property, PropertyConfigEnviormentContext context){
    text.setTyping(activeSlot == slotId);
    if(activeSlot == slotId){
      text.setContence(property.get(),cursorPos);
      text.keyTyped();
      property.set(text.getContence());
      cursorPos = text.getCursorPos();
    }
  }
  
  
}
