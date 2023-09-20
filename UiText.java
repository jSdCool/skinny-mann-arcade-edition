class UiText {
  UiFrame ui;
  String text;
  float x, y, size;
  float ix, iy, isize, pScale;
  int alignX, alignY;
  UiText(UiFrame ui, String text, float X, float Y, float size, int alignX, int alignY) {
    this.ui=ui;
    this.text=text;
    ix=X;
    iy=Y;
    isize=size;
    this.x=ui.topX()+X*ui.scale();
    this.y=ui.topY()+Y*ui.scale();
    this.size=size*ui.scale();
    this.alignX=alignX;
    this.alignY=alignY;
    pScale=ui.scale();
  }

  void draw() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      pScale=ui.scale();
      reScale();
    }
    ui.getSource().textSize(size);
    ui.getSource().textAlign(alignX, alignY);
    ui.getSource().text(text, x, y);
  }

  void setText(String text) {
    this.text=text;
  }

  void reScale() {
    x=ui.topX()+ix*ui.scale();
    y=ui.topY()+iy*ui.scale();
    size=isize*ui.scale();
  }
  
  String getText(){
    return text;
  }
}
