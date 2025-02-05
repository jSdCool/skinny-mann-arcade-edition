//button class V1.2.0a
import processing.core.*;
import processing.data.*;
class Button implements Serialization {
  public static final Identifier ID = new Identifier("Button");
  protected float x, y, lengthX, lengthY;
  private int fColor=255, sColor=-5592405, textcolor=0, htFill=200, htStroke=0, htColor=0;
  private String text="", hoverText="";
  private float textScaleFactor=2.903f, strokeWeight=3;
  private transient PApplet window;
  private boolean selected=false;
  Button(PApplet window, float X, float Y, float DX, float DY) {
    this.window=window;
    x=X;
    y=Y;
    lengthX=DX;
    lengthY=DY;
    findTextScale();
    strokeWeight=3;
  }
  Button(PApplet window, float X, float Y, float DX, float DY, String Text) {
    this.window=window;
    x=X;
    y=Y;
    lengthX=DX;
    lengthY=DY;
    text=Text;
    findTextScale();
    strokeWeight=3;
  }
  Button(PApplet window, float X, float Y, float DX, float DY, int c1, int c2) {
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
  Button(PApplet window, float X, float Y, float DX, float DY, String Text, int c1, int c2) {
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

  void findTextScale() {
    for (int i=1; i<300; i++) {
      window.textSize(i);
      if (window.textWidth(text)>lengthX||window.textAscent()+window.textDescent()>lengthY) {
        textScaleFactor=i-1;
        break;
      }
    }
  }

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

  public Button drawHoverText() {
    if (isMouseOver()) {
      window.textAlign(window.LEFT, window.BOTTOM);
      window.strokeWeight(0);
      window.fill(htStroke);
      window.textSize(15);
      window.rect(window.mouseX-6, window.mouseY-15, window.textWidth(hoverText)+12, 20);
      window.fill(htFill);
      window.rect(window.mouseX-4, window.mouseY-13, window.textWidth(hoverText)+8, 16);
      window.fill(htColor);
      window.text(hoverText, window.mouseX, window.mouseY+5);
    }
    return this;
  }

  public Button setText(String t) {
    text=t;
    findTextScale();
    return this;
  }
  public String getText() {
    return text;
  }
  public boolean isMouseOver() {
    return window.mouseX>=x&&window.mouseX<=x+lengthX&&window.mouseY>=y&&window.mouseY<=y+lengthY;
  }
  public Button setColor(int c1, int c2) {
    fColor=c1;
    sColor=c2;
    return this;
  }
  public int getColor() {
    return fColor;
  }
  public String toString() {
    return "button at:"+x+" "+y+" length: "+lengthX+" height: "+lengthY+" with text: "+text+" and a color of: "+fColor;
  }


  public Button setTextColor(int c) {
    textcolor=c;
    return this;
  }
  public Button setX(float X) {
    x=X;
    return this;
  }
  public Button setY(float Y) {
    y=Y;
    return this;
  }
  public Button setStrokeWeight(float s) {
    strokeWeight=s;
    return this;
  }
  public Button setHoverTextColors(int c1, int c2) {
    htFill=c1;
    htStroke=c2;
    return this;
  }
  public Button setHoverTextColor(int c) {
    htColor=c;
    return this;
  }
  public Button setHoverText(String t) {
    hoverText=t;
    return this;
  }
  

  public void selected(boolean select){
    selected=select;
  }
 
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
  
  @Override
  public Identifier id() {
    return ID;
  }
}
