import processing.core.*;
import java.awt.*;
import java.awt.datatransfer.*;
class UiTextBox{
  UiFrame ui;
  UiButton button;
  private float ix, iy, iwidth, iheight, x, y, width, height, pScale, iTextSize = 20,textSize;
  private String contence = "" , placeHolder = "Text Here", allowList = "";
  private int textColor = 0, placeHolderColor = 0xFFA6A6A6, cursorPos = 0 , highLightStart,highLightEnd , highLightColor = 0x8000D7FF;
  private boolean typing =false, highLighting = false, shiftPressed =false , controlPressed = false, useAllowList =false;
  
  UiTextBox(UiFrame ui, float x, float y, float width, float height) {
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
  
  void reScale() {
    x=ui.topX()+ix*ui.scale();
    y=ui.topY()+iy*ui.scale();
    width=iwidth*ui.scale();
    height=iheight*ui.scale();
    button.reScale();
    pScale=ui.scale();
    textSize = iTextSize*ui.scale();
  }
  
  void draw() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      reScale();
    }
    button.draw();
    ui.getSource().clip(x,y,width,height);
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
      if(typing){
        boolean showCursor = ui.getSource().millis() % 1000 > 500;
        float maxTextWidth = width - ui.getSource().textWidth("|");
        float cursorOffset = ui.getSource().textWidth(contence.substring(0,cursorPos));
        if(cursorOffset>maxTextWidth){//if the width of the text extends outside of the box, then move the text so you can see what your typing
          ui.getSource().text(contence,x-cursorOffset+maxTextWidth,y+height/2);
          if(showCursor)
            ui.getSource().rect(x+maxTextWidth,y+height*0.1f,2*ui.scale(),height*0.8f);//cursor
            
          if(highLighting){
            ui.getSource().fill(highLightColor);
            ui.getSource().rect(x + ui.getSource().textWidth(contence.substring(0,highLightStart))-cursorOffset+maxTextWidth, y+height*0.1f, ui.getSource().textWidth(contence.substring(highLightStart,highLightEnd)),height*0.8f);
          }
        }else{
          ui.getSource().text(contence,x,y+height/2);
          if(showCursor)
            ui.getSource().rect(x+cursorOffset,y+height*0.1f,2*ui.scale(),height*0.8f);//cursor
          
          if(highLighting){
            ui.getSource().fill(highLightColor);
            ui.getSource().rect(x + ui.getSource().textWidth(contence.substring(0,highLightStart)), y+height*0.1f, ui.getSource().textWidth(contence.substring(highLightStart,highLightEnd)),height*0.8f);
          }
        }
      }else{
        ui.getSource().text(contence,x,y+height/2);
      }
    }
    
    ui.getSource().noClip();
  }
  
  void mouseClicked(){
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
  
  void keyPressed(){
    if(typing){
      int keyCode = ui.getSource().keyCode;
      char key =  ui.getSource().key;
      if(keyCode == PApplet.LEFT && cursorPos > 0){
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
      if(keyCode == PApplet.RIGHT && cursorPos<contence.length()){
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
      if(keyCode == PApplet.SHIFT){
        shiftPressed = true;
      }
      
      if(keyCode == PApplet.CONTROL){
        controlPressed = true;
      }
      boolean pasting =false;
      if(controlPressed){
        //apperently while holding controll the letters on they keyboard report themsefs as their possiotn in the alphabet.
        if(key == 'c' || key == 'C' || key == (char)3 || keyCode == 67){//copy hilighted text
          if(highLighting){
            setClipBoard(contence.substring(highLightStart,highLightEnd));
            //System.out.println("copying to clipbaord !");
          }
        }
        
        if(key == 'a' || key == 'A' || key == (char)1 || keyCode == 65){
          highLighting=true;
          highLightEnd = contence.length();
          highLightStart = 0;
          cursorPos = contence.length();
        }
        
        if(key == 'v' || key == 'V' || key == (char) 22 || keyCode == 86){
          pasting=true;
        }else
          return;
      }
      
      if(pasting){
          if(highLighting){
            contence = contence.substring(0,highLightStart) + contence.substring(highLightEnd,contence.length());
            cursorPos = highLightStart;
            highLighting=false;
          }
          String pasteTence = getTextFromClipboard();
          if(useAllowList){
            StringBuilder sb = new StringBuilder();
            for(int i=0;i<pasteTence.length();i++){
              if(allowList.contains(pasteTence.charAt(i)+"")){
                sb.append(pasteTence.charAt(i));
              }
            }
            pasteTence = sb.toString();
          }
          
          if(cursorPos == contence.length()){//if the cursor is at the end of the contence
            contence += pasteTence;
          } else if(cursorPos == 0){//if the cursor it at the start of the contence
            contence = pasteTence + contence;
          } else {//if the cursor is in the middle of the contence
            contence = contence.substring(0,cursorPos) + pasteTence + contence.substring(cursorPos,contence.length());
          }
          
          cursorPos += pasteTence.length();
          return;
      }
      
      if(highLighting && (key == PApplet.BACKSPACE || key == PApplet.DELETE)){
        contence = contence.substring(0,highLightStart) + contence.substring(highLightEnd,contence.length());
        cursorPos = highLightStart;
        highLighting=false;
        return;
      }
      
      if(key == PApplet.BACKSPACE){
        if(cursorPos!=0){
          contence = contence.substring(0,cursorPos-1) + contence.substring(cursorPos,contence.length());
          cursorPos--;
        }
        return;
      }
      if(key == PApplet.DELETE){
        if(cursorPos!=contence.length()){
          contence = contence.substring(0,cursorPos) + contence.substring(cursorPos+1,contence.length());
        }
        return;
      }
      
      
    }
    
  }
  
  void keyReleased(){
    if(typing){
      int keyCode = ui.getSource().keyCode;
      if(keyCode == PApplet.SHIFT){
        shiftPressed = false;
      }
      if(keyCode == PApplet.CONTROL){
        controlPressed = false;
      }
    }
  }
  
  void keyTyped(){
    if(typing){
      char key =  ui.getSource().key;
      //System.out.println(key +" "+ (int)key);
      if(controlPressed){
        return;
      }
      
      if(highLighting){
        contence = contence.substring(0,highLightStart) + contence.substring(highLightEnd,contence.length());
        cursorPos = highLightStart;
        highLighting=false;
        if(key == PApplet.BACKSPACE || key == PApplet.DELETE)
          return;
      }
      
      
      if(key == PApplet.BACKSPACE){
        
        return;
      }
      if(key == PApplet.DELETE){
        
        return;
      }
      if(useAllowList){
        if(!allowList.contains(key+"")){
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
  
  public UiTextBox setStrokeWeight(float s) {
    button.setStrokeWeight(s);
    return this;
  }
  
  public UiTextBox setColors(int fillColor, int strokeColor) {
    button.setColor(fillColor, strokeColor);
    return this;
  }
  
  public UiTextBox setTextSize(int size){
    iTextSize = size;
    textSize = size * ui.scale();
    return this;
  }
  
  public UiTextBox setPlaceHolder(String text){
    placeHolder = text;
    return this;
  }
  
  public UiTextBox setContence(String text){
    contence = text;
    cursorPos = contence.length();
    return this;
  }
  
  public UiTextBox setAllowList(String list){
    allowList = list;
    useAllowList = true;
    return this;
  }
  
  public UiTextBox useAllowList(boolean use){
    useAllowList = use;
    return this;
  }
  
  public String getContence(){
    return contence;
  }
  
  public UiTextBox clearContence(){
   contence = "";
   cursorPos =0;
   return this;
  }
  
  
  
  private String getTextFromClipboard (){
    Object clipboardRawContent = getFromClipboard(DataFlavor.stringFlavor);
    if(clipboardRawContent == null)
      return "";
    String text = (String) clipboardRawContent;
    return text;
  }
  
  private void setClipBoard(String text) {
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    StringSelection stringSelection = new StringSelection(text);
    clipboard.setContents(stringSelection, null);
  }
  
  private Object getFromClipboard (DataFlavor flavor) {
  
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard(); 
    Transferable contents = clipboard.getContents(null);
    Object object = null;
  
    if (contents != null && contents.isDataFlavorSupported(flavor))
    {
      try
      {
        object = contents.getTransferData(flavor);
      }
      catch (UnsupportedFlavorException e1){}
      catch (java.io.IOException e2) {}
    }
  
    return object;
  }
  
  public void resetState(){
    typing =false;
    highLighting = false;
    shiftPressed =false;
    controlPressed = false;
  }
  
}
