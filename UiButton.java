/**An automaticaly scaling version of the button
*/
public class UiButton extends Button {
  UiFrame ui;
  private float pScale;
  private float iX, iY, iDX, iDY, istroke=3;
  /**Create a button at the given position with the given size
  @param ui The frame to scale to
  @param X The base upper left x position of the button
  @param Y The base upper left y position of the button
  @param DX The base width of the button
  @param DY The base height of the button
  */
  UiButton(UiFrame ui, float X, float Y, float DX, float DY) {
    super(ui.getSource(), ui.topX()+X*ui.scale(), ui.topY()+Y*ui.scale(), DX*ui.scale(), DY*ui.scale());
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
  }
  /**Create a button at the given position with the given size
  @param ui The frame to scale to
  @param X The base upper left x position of the button
  @param Y The base upper left y position of the button
  @param DX The base width of the button
  @param DY The base height of the button
  @param Text the text on the button
  */
  UiButton(UiFrame ui, float X, float Y, float DX, float DY, String Text) {
    super(ui.getSource(), ui.topX()+X*ui.scale(), ui.topY()+Y*ui.scale(), DX*ui.scale(), DY*ui.scale(), Text);
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
  }
  /**Create a button at the given position with the given size
  @param ui The frame to scale to
  @param X The base upper left x position of the button
  @param Y The base upper left y position of the button
  @param DX The base width of the button
  @param DY The base height of the button
  @param c1 The fill color of the button
  @param c2 The outline color of the button
  */
  UiButton(UiFrame ui, float X, float Y, float DX, float DY, int c1, int c2) {
    super(ui.getSource(), ui.topX()+X*ui.scale(), ui.topY()+Y*ui.scale(), DX*ui.scale(), DY*ui.scale(), c1, c2);
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
  }
  /**Create a button at the given position with the given size
  @param ui The frame to scale to
  @param X The base upper left x position of the button
  @param Y The base upper left y position of the button
  @param DX The base width of the button
  @param DY The base height of the button
  @param Text the text on the button
  @param c1 The fill color of the button
  @param c2 The outline color of the button
  */
  UiButton(UiFrame ui, float X, float Y, float DX, float DY, String Text, int c1, int c2) {
    super(ui.getSource(), ui.topX()+X*ui.scale(), ui.topY()+Y*ui.scale(), DX*ui.scale(), DY*ui.scale(), Text, c1, c2);
    this.ui=ui;
    pScale=ui.scale();
    iX=X;
    iY=Y;
    iDX=DX;
    iDY=DY;
  }
  
  /**Render the button on the provided window and adjust the scale and position if nessarry
  @return this
  */
  public Button draw() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      pScale=ui.scale();
      reScale();
    }
    return super.draw();
  }
  /**Set the base thickness of the outline
  @param s The base pixle with of the stroke
  @return this
  */
  public Button setStrokeWeight(float s) {
    istroke=s;
    return super.setStrokeWeight(s*ui.scale());
  }
  
  /**Recalculate the scale and position of this button
  */
  void reScale() {
    x=ui.topX()+iX*ui.scale();
    y=ui.topY()+iY*ui.scale();
    lengthX=iDX*ui.scale();
    lengthY=iDY*ui.scale();
    findTextScale();
    super.setStrokeWeight(istroke*ui.scale());
  }

  /**Test if the mouse is over the button
  @return true if the mouse is over the button
  */
  public boolean isMouseOver() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      pScale=ui.scale();
      reScale();
    }
    return super.isMouseOver();
  }
}
