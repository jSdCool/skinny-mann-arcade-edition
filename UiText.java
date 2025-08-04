/**Automatically scalling Text for user interfaces
*/
public class UiText {
  UiFrame ui;
  String text;
  float x, y, size;
  float ix, iy, isize, pScale;
  int alignX, alignY;
  /**Create a new Ui text
  @param ui The frame to scale to
  @param text The text, what did you think this would be?
  @param X The base x position of the text
  @param Y The base y position of the text
  @param size The base text size
  @param alignX The horozontal alignment mode (LEFT | CENTER | RIGHT)
  @param alignY The vertical alignment mod (TOP | CENTER | BOTTOM)
  */
  public UiText(UiFrame ui, String text, float X, float Y, float size, int alignX, int alignY) {
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

  /**Render the slider on the provided window and adjust the scale and position if nessarry
  */
  public void draw() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      pScale=ui.scale();
      reScale();
    }
    ui.getSource().textSize(size);
    ui.getSource().textAlign(alignX, alignY);
    ui.getSource().text(text, x, y);
  }

  /**Set the text of this text
  @param text The new text
  */
  public void setText(String text) {
    this.text=text;
  }
  
  /**Recalculate the scale after a change in the parent window size
  */
  public void reScale() {
    x=ui.topX()+ix*ui.scale();
    y=ui.topY()+iy*ui.scale();
    size=isize*ui.scale();
  }
  
  String getText(){
    return text;
  }
}
