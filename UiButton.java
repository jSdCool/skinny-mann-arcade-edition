class UiButton extends Button{
  UiFrame ui;
  private float pScale;
  private float iX,iY,iDX,iDY, istroke=3;
  UiButton(UiFrame ui, float X, float Y, float DX, float DY) {
    super(ui.getSource(),ui.topX()+X*ui.scale(),ui.topY()+Y*ui.scale(),DX*ui.scale(),DY*ui.scale());
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
    
  }
  UiButton(UiFrame ui, float X, float Y, float DX, float DY, String Text) {
    super(ui.getSource(),ui.topX()+X*ui.scale(),ui.topY()+Y*ui.scale(),DX*ui.scale(),DY*ui.scale(),Text);
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
    
  }
  UiButton(UiFrame ui, float X, float Y, float DX, float DY, int c1, int c2) {
    super(ui.getSource(),ui.topX()+X*ui.scale(),ui.topY()+Y*ui.scale(),DX*ui.scale(),DY*ui.scale(),c1,c2);
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
  }
  UiButton(UiFrame ui, float X, float Y, float DX, float DY, String Text, int c1, int c2) {
    super(ui.getSource(),ui.topX()+X*ui.scale(),ui.topY()+Y*ui.scale(),DX*ui.scale(),DY*ui.scale(),Text,c1,c2);
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
  }
  
  public Button draw() {
    if(ui.scale()!=pScale){//if the scale has changed then recalculate the positions for everything
      pScale=ui.scale();
      reScale();
    }
    return super.draw();
  }
  
  public Button setStrokeWeight(float s) {
    istroke=s;
    return super.setStrokeWeight(s*ui.scale());
  }
  
  void reScale(){
    x=ui.topX()+iX*ui.scale();
    y=ui.topY()+iY*ui.scale();
    lengthX=iDX*ui.scale();
    lengthY=iDY*ui.scale();
    findTextScale();
    super.setStrokeWeight(istroke*ui.scale());
  }
  
  public boolean isMouseOver() {
    if(ui.scale()!=pScale){//if the scale has changed then recalculate the positions for everything
      pScale=ui.scale();
      reScale();
    }
    return super.isMouseOver();
  }
}
