//button class V1.0.5
class Button{
  protected int x,y,lengthX,lengthY,fColor=#FFFFFF,sColor=#AAAAAA,textcolor=0,sw=3;
  private String text="";
  private float textScaleFactor=2.903;
  Button(int X,int Y,int DX,int DY){
  x=X;
  y=Y;
  lengthX=DX;
  lengthY=DY;
  }
  Button(int X,int Y,int DX,int DY,String Text){
  x=X;
  y=Y;
  lengthX=DX;
  lengthY=DY;
  text=Text;
  }
  Button(int X,int Y,int DX,int DY,int c1,int c2){
  x=X;
  y=Y;
  lengthX=DX;
  lengthY=DY;
  fColor=c1;
  sColor=c2;
  }
  Button(int X,int Y,int DX,int DY,String Text,int c1,int c2){
  x=X;
  y=Y;
  lengthX=DX;
  lengthY=DY;
  text=Text;
  fColor=c1;
  sColor=c2;
  }
  
  public Button draw(){
   strokeWeight(0);
   fill(sColor);
   rect(x-sw,y-sw,lengthX+sw*2,lengthY+sw*2);
   fill(fColor);
   rect(x,y,lengthX,lengthY);
   fill(textcolor);
   textAlign(CENTER, CENTER);
   if(!text.equals("")){
   textSize(lengthY/text.length()*textScaleFactor);
   text(text,lengthX/2+x,lengthY/2+y);
   }
    return this;
  }
  
  public Button setText(String t){
   text=t;
    return this;
  }
  public String getText(){
    return text;
  }
  public boolean isMouseOver(){
   return mouseX>=x&&mouseX<=x+lengthX&&mouseY>=y&&mouseY<=y+lengthY; 
  }
  public Button setColor(int c1,int c2){
    fColor=c1;
    sColor=c2;
    return this;
  }
  public int getColor(){
   return fColor; 
  }
  public String toString(){
    return "button at:"+x+" "+y+" length: "+lengthX+" height: "+lengthY+" with text: "+text+" and a color of: "+fColor;
  }
  
  public Button setTextFactor(float factor){
    textScaleFactor=factor;
    return this;
  }
  public Button setTextColor(int c){
   textcolor=c;
    return this;
  }
  public Button setStrokeWeight(float s){
   sw=(int)s;
   return this;
  }
}
