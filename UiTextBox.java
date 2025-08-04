import processing.core.*;
import java.awt.*;
import java.awt.datatransfer.*;
/**An automatically scalling user interface text input box.
This input box inplments features like: movable cursor, text hilighting (with keyboard), copy/pasting
*/
public class UiTextBox{
  UiFrame ui;
  UiButton button;
  private float ix, iy, iwidth, iheight, x, y, width, height, pScale, iTextSize = 20,textSize;
  private String contence = "" , placeHolder = "Text Here", allowList = "";
  private int textColor = 0, placeHolderColor = 0xFFA6A6A6, cursorPos = 0 , highLightStart,highLightEnd , highLightColor = 0x8000D7FF;
  private boolean typing =false, highLighting = false, shiftPressed =false , controlPressed = false, useAllowList =false;
  
  /**Create a new text box
  @param ui The frame to scale to
  @param x The base upper left x position of the text box
  @param y The base upper left y position of the text box
  @param width The base width of the text box
  @param height The base height of the text box
  */
  public UiTextBox(UiFrame ui, float x, float y, float width, float height) {
    this.ui=ui;
    this.ix=x;
    this.iy=y;
    this.iwidth=width;
    this.iheight=height;
    pScale=ui.scale();
    button = new UiButton(ui, x, y, width, height);
    this.x=ui.topX()+x*ui.scale();
    this.y=ui.topY()+y*ui.scale();
    this.width=width*ui.scale();
    this.height=height*ui.scale();
    textSize = iTextSize*ui.scale();
  }
  /**Recalculate the scale after a change in the parent window size
  */
  public void reScale() {
    x=ui.topX()+ix*ui.scale();
    y=ui.topY()+iy*ui.scale();
    width=iwidth*ui.scale();
    height=iheight*ui.scale();
    button.reScale();
    pScale=ui.scale();
    textSize = iTextSize*ui.scale();
  }
  /**Render the slider on the provided window and adjust the scale and position if nessarry
  */
  public void draw() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      reScale();
    }
    button.draw();
    //ui.getSource().clip(x,y,width,height);//this breaks the text apperently
    //if there is no text
    if(contence.isEmpty() && ! typing){
      ui.getSource().fill(placeHolderColor);
      ui.getSource().textAlign(PApplet.LEFT,PApplet.CENTER);
      ui.getSource().textSize(textSize);
      ui.getSource().text(placeHolder,x,y+height/2);
    }else{
      //if there is entered text
      ui.getSource().fill(textColor);
      ui.getSource().textAlign(PApplet.LEFT,PApplet.CENTER);
      ui.getSource().textSize(textSize);
      
      float maxTextWidth = width - ui.getSource().textWidth("|");//l;ave space for the cursor on the end
      if(typing){
        boolean showCursor = ui.getSource().millis() % 1000 > 500;//should the cursor be shown
        float cursorOffset = ui.getSource().textWidth(contence.substring(0,cursorPos));//figure out where the cursor should be
        if(cursorOffset>maxTextWidth){//if the width of the text extends outside of the box, then move the text so you can see what your typing
        
          for(int i=0;i<cursorPos;i++){
            float tw = ui.getSource().textWidth(contence.substring(i,cursorPos));
            if( tw < maxTextWidth){//
               ui.getSource().text(contence.substring(i,Math.min(cursorPos+1,contence.length())),x+(maxTextWidth-tw),y+height/2);
               break;
            }
          }
          
          if(showCursor){
            ui.getSource().rect(x+maxTextWidth,y+height*0.1f,2*ui.scale(),height*0.8f);//draw the cursor
          }
            
          if(highLighting){//if text is being hilighted
            ui.getSource().fill(highLightColor);//redner the visable section of the hilight
            float highX = x + ui.getSource().textWidth(contence.substring(0,highLightStart))-cursorOffset+maxTextWidth;
            highX = Math.max(x,highX);
            float highWidth = ui.getSource().textWidth(contence.substring(highLightStart,highLightEnd));
            if( (highX - x +  highWidth) > width){
              highWidth = width - (highX - x);
            }
            ui.getSource().rect(highX, y+height*0.1f, highWidth,height*0.8f);
          }
        }else{//if the width of the text with the cursor does not extend outside of the text box
          
          if(ui.getSource().textWidth(contence)> maxTextWidth){
            //if the text is longer then the width of the box figure out how much can be rednerd
            //verry ineffshent
            boolean rednerd = false;
            for(int i=0;i<contence.length();i++){
              if(ui.getSource().textWidth(contence.substring(0,i)) > maxTextWidth){
                ui.getSource().text(contence.substring(0,i-1),x,y+height/2);
                rednerd = true;
                break;
              }
            }
            //if the edge case of the loop not rendering it happens, then just render the whole thing
            if(!rednerd){
              ui.getSource().text(contence,x,y+height/2);
            }
          }else{
            ui.getSource().text(contence,x,y+height/2);
          }
          
          
          if(showCursor){
            ui.getSource().rect(x+cursorOffset,y+height*0.1f,2*ui.scale(),height*0.8f);//cursor
          }
          if(highLighting){
            ui.getSource().fill(highLightColor);
            float highX = x + ui.getSource().textWidth(contence.substring(0,highLightStart));
            float highWidth = ui.getSource().textWidth(contence.substring(highLightStart,highLightEnd));
            if( (highX - x +  highWidth) > width){
              highWidth = width - (highX - x);
            }
            ui.getSource().rect(highX, y+height*0.1f, highWidth,height*0.8f);
          }
        }
      }else{
        //only reder text inside of the box
        if(ui.getSource().textWidth(contence)> maxTextWidth){
          //if the text is longer then the width of the box figure out how much can be rednerd
          //verry ineffshent
          boolean rednerd = false;
          for(int i=0;i<contence.length();i++){
            if(ui.getSource().textWidth(contence.substring(0,i)) > maxTextWidth){
              ui.getSource().text(contence.substring(0,i-1),x,y+height/2);
              rednerd = true;
              break;
            }
          }
          //if the edge case of the loop not rendering it happens, then just render the whole thing
          if(!rednerd){
            ui.getSource().text(contence,x,y+height/2);
          }
        }else{
          //if the text is shorter then the width of the box just render the next
          ui.getSource().text(contence,x,y+height/2);
        }
      }
    }
    
    //ui.getSource().noClip();
  }
  /**Process mouse clicks that may or may not happen on this text box
  */
  public void mouseClicked(){
    if(button.isMouseOver()){
      
      float relMousePos = ui.getSource().mouseX - x;
      ui.getSource().textSize(textSize);
      float maxTextWidth = width - ui.getSource().textWidth("|");
      float cursorOffset = ui.getSource().textWidth(contence.substring(0,cursorPos));
      if(typing && cursorOffset>maxTextWidth){
        for(int i=0;i<contence.length();i++){
          if(ui.getSource().textWidth(contence.substring(0,i))-cursorOffset+maxTextWidth>=relMousePos){
            cursorPos = i -1;
            break;
          }
        }
      }else{
        cursorPos = contence.length();
        for(int i=0;i<contence.length();i++){
          if(ui.getSource().textWidth(contence.substring(0,i))>=relMousePos){
            cursorPos = i -1;
            break;
          }
        }
      }
      
      typing=true;
    }else{
      typing=false;
      shiftPressed = false;
      controlPressed = false;
    }
      
  }
  
  /**Process key pressing input
  */
  public void keyPressed(){
    if(typing){
      int keyCode = ui.getSource().keyCode;
      char key =  ui.getSource().key;
      if(keyCode == PApplet.LEFT && cursorPos > 0){//if the left arrow button is pressed and the cursor can be moved left
        cursorPos--;
        //hilight stuff
        if(shiftPressed){
          if(!highLighting){
            highLighting=true;
            highLightStart = cursorPos;
            highLightEnd = cursorPos+1;
          }else{
            if(highLightStart == cursorPos+1){
              highLightStart = cursorPos;
            }else{
              highLightEnd = cursorPos;
            }
          }
        }else{
          highLighting = false;
        }
      }
      if(keyCode == PApplet.RIGHT && cursorPos<contence.length()){//if the right arrow is pressed and the cursor is not at the end of the text
        cursorPos++;
        //hilight stuff
        if(shiftPressed){
          if(!highLighting){
            highLighting=true;
            highLightStart = cursorPos-1;
            highLightEnd = cursorPos;
          }else{
            if(highLightEnd == cursorPos-1){
              highLightEnd = cursorPos;
            }else{
              highLightStart = cursorPos;
            }
          }
        }else{
          highLighting = false;
        }
      }
      if(keyCode == PApplet.SHIFT){//shift
        shiftPressed = true;
      }
      
      if(keyCode == PApplet.CONTROL){//the ctrl key is pressed
        controlPressed = true;
      }
      boolean pasting =false;
      if(controlPressed){//if the ctrl key is pressed
        //apperently while holding controll the letters on the keyboard report them sefs as their possiotn in the alphabet.
        if(key == 'c' || key == 'C' || key == (char)3 || keyCode == 67){//copy hilighted text
          if(highLighting){
            setClipBoard(contence.substring(highLightStart,highLightEnd));//copy the content of the hilight to the text box
            //System.out.println("copying to clipbaord !");
          }
        }
        
        if(key == 'a' || key == 'A' || key == (char)1 || keyCode == 65){//ctrl + A
          highLighting=true;//select everything
          highLightEnd = contence.length();
          highLightStart = 0;
          cursorPos = contence.length();
        }
        
        if(key == 'v' || key == 'V' || key == (char) 22 || keyCode == 86){//ctrl + V
          pasting=true;//set pasting to true
        }else{
          return;
        }
      }
      
      if(pasting){//if pasting
        if(highLighting){//and hilighting 
          contence = contence.substring(0,highLightStart) + contence.substring(highLightEnd,contence.length());//remove the currently selected part
          cursorPos = highLightStart;
          highLighting=false;
        }
        String pasteTence = getTextFromClipboard();//get the content of the clopboard
        if(useAllowList){//if there is a restriction on what charaters are allowed in this text box
          StringBuilder sb = new StringBuilder();
          for(int i=0;i<pasteTence.length();i++){//go through the clioboard content and remove any chars that are not on the allow list
            if(allowList.contains(pasteTence.charAt(i)+"")){
              sb.append(pasteTence.charAt(i));
            }
          }
          pasteTence = sb.toString();
        }
        
        if(cursorPos == contence.length()){//if the cursor is at the end of the content
          contence += pasteTence;//add the clipboard content to the end of the content
        } else if(cursorPos == 0){//if the cursor it at the start of the contence
          contence = pasteTence + contence;//prepend the clipboard content to the start of the content
        } else {//if the cursor is in the middle of the contence
          contence = contence.substring(0,cursorPos) + pasteTence + contence.substring(cursorPos,contence.length());//add the clipboard content to the location of the cursor
        }
        
        cursorPos += pasteTence.length();//advance the cursor to the end of the pasted content
        return;
      }
      
      if(highLighting && (key == PApplet.BACKSPACE || key == PApplet.DELETE)){//backspace / delete and hilighting
        contence = contence.substring(0,highLightStart) + contence.substring(highLightEnd,contence.length());//remove the hilighted content
        cursorPos = highLightStart;
        highLighting=false;
        return;
      }
      
      if(key == PApplet.BACKSPACE){//if backspace
        if(cursorPos!=0){//and the cursor is not at the start of the content
          contence = contence.substring(0,cursorPos-1) + contence.substring(cursorPos,contence.length());//remove the char before the cursor
          cursorPos--;//move the cursor back 1
        }
        return;
      }
      if(key == PApplet.DELETE){//if delete
        if(cursorPos!=contence.length()){//if not at the end of the content
          contence = contence.substring(0,cursorPos) + contence.substring(cursorPos+1,contence.length());//remove the char after the cursor
        }
        return;
      }
      
      
    }
    
  }
  
  /**Process key releasing input
  */
  public void keyReleased(){
    if(typing){
      int keyCode = ui.getSource().keyCode;
      if(keyCode == PApplet.SHIFT){// if shift
        shiftPressed = false;
      }
      if(keyCode == PApplet.CONTROL){//if ctrl
        controlPressed = false;
      }
    }
  }
  
  /**When a visable character (and space) are pressed
  */
  public void keyTyped(){
    if(typing){//if the text box is active
      char key =  ui.getSource().key;
      //System.out.println(key +" "+ (int)key);
      if(controlPressed){//if ctrl is pressed then 
        return;//no typing
      }
      
      if(highLighting){//if hilighting
        contence = contence.substring(0,highLightStart) + contence.substring(highLightEnd,contence.length());//remove the hilighted text
        cursorPos = highLightStart;//move the cursor
        highLighting=false;
        if(key == PApplet.BACKSPACE || key == PApplet.DELETE){
          return;
        }
      }
      
      //un used but still here just in case
      if(key == PApplet.BACKSPACE){
        return;
      }
      if(key == PApplet.DELETE){
        return;
      }
      
      if(useAllowList){//if the allow list is in use
        if(!allowList.contains(key+"")){//chech this letter is not on the allow list
          return;
        }
      }
      
      if(cursorPos == contence.length()){//if the cursor is at the end of the contence
        contence += key;
      } else if(cursorPos == 0){//if the cursor it at the start of the contence
        contence = key + contence;
      } else {//if the cursor is in the middle of the contence
        contence = contence.substring(0,cursorPos) + key + contence.substring(cursorPos,contence.length());
      }
      cursorPos++;
    }
  }
  /**Set the stroke weight of the text box
  @param s The new base stroke weight
  @return this
  */
  public UiTextBox setStrokeWeight(float s) {
    button.setStrokeWeight(s);
    return this;
  }
  /**Set the colors of the text box
  @param fillColor The fill color of the button
  @param strokeColor The stroke color of the button
  @return this
  */
  public UiTextBox setColors(int fillColor, int strokeColor) {
    button.setColor(fillColor, strokeColor);
    return this;
  }
  /**Set the base size of the text in the text box
  @param size The new base text size
  @return this
  */
  public UiTextBox setTextSize(int size){
    iTextSize = size;
    textSize = size * ui.scale();
    return this;
  }
  
  /**Set the place holder text for when no text has been typed in the text box
  @param text The new place holder text
  @return this
  */
  public UiTextBox setPlaceHolder(String text){
    placeHolder = text;
    return this;
  }
  
  /**Set the content of the text box
  @param text The new content of the text box
  @return this
  */
  public UiTextBox setContence(String text){
    contence = text;
    cursorPos = contence.length();
    return this;
  }
  
  /**Set the list of allowed charaters. Automtaiaclly enables use of the allow list
  @param list The list of characters to allow in the text box
  @return this
  */
  public UiTextBox setAllowList(String list){
    allowList = list;
    useAllowList = true;
    return this;
  }
  
  /**Set wther the allow list should be used
  @param use Wether to restrict what characters can be used in the text box
  @return this
  */
  public UiTextBox useAllowList(boolean use){
    useAllowList = use;
    return this;
  }
  
  /**Get the current content of the text box
  @return The current content of the text box
  */
  public String getContence(){
    return contence;
  }
  
  /**Clear the content of the text box
  @return this
  */
  public UiTextBox clearContence(){
   contence = "";
   cursorPos =0;
   return this;
  }
  
  
  /**Get the text currently on the system clipboard
  @return The text content of the system clipboard
  */
  private String getTextFromClipboard (){
    Object clipboardRawContent = getFromClipboard(DataFlavor.stringFlavor);
    if(clipboardRawContent == null)
      return "";
    String text = (String) clipboardRawContent;
    return text;
  }
  
  /**Set the content of the system clipboard
  @param text The text to put on the system clipboard
  */
  private void setClipBoard(String text) {
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    StringSelection stringSelection = new StringSelection(text);
    clipboard.setContents(stringSelection, null);
  }
  
  /**Get the content of the system clip board
  @param flavor The specific type of data to try and get from the clipboard 
  @return The content of the clipboard
  */
  private Object getFromClipboard (DataFlavor flavor) {
  
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard(); 
    Transferable contents = clipboard.getContents(null);
    Object object = null;
  
    if (contents != null && contents.isDataFlavorSupported(flavor)) {
      try {
        object = contents.getTransferData(flavor);
      }catch (UnsupportedFlavorException e1){}
      catch (java.io.IOException e2) {}
    }
  
    return object;
  }
  
  /**Reset the state of this clipboard. Removing any hilight as well as stopping typing
  */
  public void resetState(){
    typing = false;
    highLighting = false;
    shiftPressed =false;
    controlPressed = false;
  }
  
  /**Set this text box to activly typing
  */
  public void activate(){
    typing = true;
  }
  
}
