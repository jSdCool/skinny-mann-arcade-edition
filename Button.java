//button class V1.2.0a
import processing.core.*;
import processing.data.*;
/**A button for a userinterface that contains utitlies for rendering and using a button
*/
public class Button implements Serialization {
  public static final Identifier ID = new Identifier("Button");
  protected float x, y, lengthX, lengthY;
  private int fColor=255, sColor=-5592405, textcolor=0, htFill=200, htStroke=0, htColor=0;
  private String text="", hoverText="";
  private float textScaleFactor=2.903f, strokeWeight=3;
  private transient PApplet window;
  private boolean selected=false;

  /**Create a button at the given position with the given size
  @param window The window this button will be renderd on
  @param X The upper left x position of the button
  @param Y The upper left y position of the button
  @param DX The width of the button
  @param DY The height of the button
  */
  public Button(PApplet window, float X, float Y, float DX, float DY) {
    this.window=window;
    x=X;
    y=Y;
    lengthX=DX;
    lengthY=DY;
    findTextScale();
    strokeWeight=3;
  }
  /**Create a button at the given position with the given size with the given text on it
  @param window The window this button will be renderd on
  @param X The upper left x position of the button
  @param Y The upper left y position of the button
  @param DX The width of the button
  @param DY The height of the button
  @param Text the text on the button
  */
  public Button(PApplet window, float X, float Y, float DX, float DY, String Text) {
    this.window=window;
    x=X;
    y=Y;
    lengthX=DX;
    lengthY=DY;
    text=Text;
    findTextScale();
    strokeWeight=3;
  }
  /**Create a button at the given position with the given size renderded with the given color
  @param window The window this button will be renderd on
  @param X The upper left x position of the button
  @param Y The upper left y position of the button
  @param DX The width of the button
  @param DY The height of the button
  @param c1 The fill color of the button
  @param c2 The outline color of the button
  */
  public Button(PApplet window, float X, float Y, float DX, float DY, int c1, int c2) {
    this.window=window;
    x=X;
    y=Y;
    lengthX=DX;
    lengthY=DY;
    fColor=c1;
    sColor=c2;
    findTextScale();
    strokeWeight=3;
  }
  /**Create a button at the given position with the given size with the given text on it renderded with the given color
  @param window The window this button will be renderd on
  @param X The upper left x position of the button
  @param Y The upper left y position of the button
  @param DX The width of the button
  @param DY The height of the button
  @param Text the text on the button
  @param c1 The fill color of the button
  @param c2 The outline color of the button
  */
  public Button(PApplet window, float X, float Y, float DX, float DY, String Text, int c1, int c2) {
    this.window=window;
    x=X;
    y=Y;
    lengthX=DX;
    lengthY=DY;
    text=Text;
    fColor=c1;
    sColor=c2;
    findTextScale();
    strokeWeight=3;
  }
  /**Recreate a button from serialized data
  @param iterator The button as a binarry representation
  */
  public Button(SerialIterator iterator){
    x = iterator.getFloat();
    y = iterator.getFloat();
    lengthX = iterator.getInt();
    lengthY = iterator.getInt();
    fColor = iterator.getInt();
    sColor = iterator.getInt();
    textcolor = iterator.getInt();
    htFill = iterator.getInt();
    htStroke = iterator.getInt();
    htColor = iterator.getInt();
    text = iterator.getString();
    hoverText = iterator.getString();
    textScaleFactor = iterator.getFloat();
    strokeWeight = iterator.getFloat();
  }
  
  /**Calculate the size the text on the button shoule be.<br>
  This will find the largest size that text can be on this button and set the text size to that
  */
  void findTextScale() {
    for (int i=1; i<300; i++) {
      window.textSize(i);
      if (window.textWidth(text)>lengthX||window.textAscent()+window.textDescent()>lengthY) {
        textScaleFactor=i-1;
        break;
      }
    }
  }
  
  /**Render the button on the provided window
  @return this
  */
  public Button draw() {
    window.strokeWeight(0);
    if(selected){
      window.fill(1,0,183);
    }else{
      window.fill(sColor);
    }
    window.rect(x-strokeWeight, y-strokeWeight, lengthX+strokeWeight*2, lengthY+strokeWeight*2);
    window.fill(fColor);
    window.rect(x, y, lengthX, lengthY);
    window.fill(textcolor);
    window.textAlign(window.CENTER, window.CENTER);
    if (!text.equals("")) {
      window.textSize(textScaleFactor);
      window.text(text, lengthX/2+x, lengthY/2+y);
    }
    return this;
  }

  /**Render the hover text if the mouse is over the button and hover text is configured
  @return this
  */
  public Button drawHoverText() {
    if (isMouseOver()) {
      window.textAlign(window.LEFT, window.BOTTOM);
      window.strokeWeight(0);
      window.fill(htStroke);
      window.textSize(15);
      //the box behind the text
      window.rect(window.mouseX-6, window.mouseY-15, window.textWidth(hoverText)+12, 20);
      window.fill(htFill);
      window.rect(window.mouseX-4, window.mouseY-13, window.textWidth(hoverText)+8, 16);
      window.fill(htColor);
      //the text
      window.text(hoverText, window.mouseX, window.mouseY+5);
    }
    return this;
  }
  
  /**Set the text on the button
  @param t The text to put on the button
  @return this
  */
  public Button setText(String t) {
    text=t;
    findTextScale();
    return this;
  }
  /**Get the current text on the button
  @return The current text on the button
  */
  public String getText() {
    return text;
  }
  /**Test if the mouse is over the button
  @return true if the mouse is over the button
  */
  public boolean isMouseOver() {
    return window.mouseX>=x&&window.mouseX<=x+lengthX&&window.mouseY>=y&&window.mouseY<=y+lengthY;
  }
  /**Set the colors of this button
  @param c1 The new fill color
  @param c2 The new outline color
  @return this
  */
  public Button setColor(int c1, int c2) {
    fColor=c1;
    sColor=c2;
    return this;
  }
  /**Get the current fill color
  @return The curren fill color
  */
  public int getColor() {
    return fColor;
  }
  /**Get an information string of the button
  @return An information string of the button
  */
  public String toString() {
    return "button at:"+x+" "+y+" length: "+lengthX+" height: "+lengthY+" with text: "+text+" and a color of: "+fColor;
  }
  /**Set the color of the text on the button
  @param c The new color
  @return this
  */
  public Button setTextColor(int c) {
    textcolor=c;
    return this;
  }
  /**Set the upper left x position of the button
  @param X the new x position
  @return this
  */
  public Button setX(float X) {
    x=X;
    return this;
  }
  /**Set the upper left y position of the button
  @param Y the new y position
  @return this
  */
  public Button setY(float Y) {
    y=Y;
    return this;
  }
  /**Set the thickness of the outline
  @param s The pixle with of the stroke
  @return this
  */
  public Button setStrokeWeight(float s) {
    strokeWeight=s;
    return this;
  }
  /**Set the background colors of the hover text
  @param c1 The hover text background fill color
  @param c2 The hover text outline color
  @return this
  */
  public Button setHoverTextColors(int c1, int c2) {
    htFill=c1;
    htStroke=c2;
    return this;
  }
  /**Set the color of the hover text
  @param c The new color of the hover text
  @return this
  */
  public Button setHoverTextColor(int c) {
    htColor=c;
    return this;
  }
  /**Set the content of the hover text
  @param t The hover text
  @return this
  */
  public Button setHoverText(String t) {
    hoverText=t;
    return this;
  }

  public void selected(boolean select){
    selected=select;
  }
 
  /**Convert this button to a byte representation that can be sent over the network or saved to a file.<br>
  @return This button as a binarry representation
  */
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addFloat(x);
    data.addFloat(y);
    data.addFloat(lengthX);
    data.addFloat(lengthY);
    data.addInt(fColor);
    data.addInt(sColor);
    data.addInt(textcolor);
    data.addInt(htFill);
    data.addInt(htStroke);
    data.addInt(htColor);
    data.addObject(SerializedData.ofString(text));
    data.addObject(SerializedData.ofString(hoverText));
    data.addFloat(textScaleFactor);
    data.addFloat(strokeWeight);
    return data;
  }
  
  /**Get the id of this objet
  @return The Identifier representing this object
  */
  @Override
  public Identifier id() {
    return ID;
  }
}
