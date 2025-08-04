/**An automatically scaling user interface slider input component
*/
public class UiSlider {
  UiFrame ui;
  UiButton button;
  float ix, iy, iwidth, iheight, x, y, width, height, pScale, minVal=0, maxVal=100, value=50, istroke=3, stroke=3, round=0;
  boolean displayValue=true,selected=false;
  int fillColor=255, strokeColor=-5592405;
  /**Create a new Ui slider
  @param ui The frame to scale to
  @param x The base upper left x position of the slider
  @param y The base upper left y position of the slider
  @param width The base width of the slider
  @param height The base height of the slider
  */
  public UiSlider(UiFrame ui, float x, float y, float width, float height) {
    this.ui=ui;
    this.ix=x;//save the inital/base unscaled values
    this.iy=y;
    this.iwidth=width;
    this.iheight=height;
    pScale=ui.scale();
    button = new UiButton(ui, x, y, width, height);//create the underlying button
    this.x=ui.topX()+x*ui.scale();//setup the current values
    this.y=ui.topY()+y*ui.scale();
    this.width=width*ui.scale();
    this.height=height*ui.scale();
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
    stroke=istroke*ui.scale();
  }
  /**Render the slider on the provided window and adjust the scale and position if nessarry
  */
  public void draw() {
    if (ui.scale()!=pScale) {//if the scale has changed then recalculate the positions for everything
      reScale();
    }
    float percent = calcPercentValue();//calulcate the current percent of the slider
    float distFromLeft = percent*width;//calculate the position of the knob
    float sliderPosX=x+distFromLeft;
    float slierWidth=20*ui.scale();
    float sliderHeightOffset=10*ui.scale();
    if (displayValue) {//set the text of the button if requested
      button.setText(value+"");
    } else {
      button.setText("");
    }
    button.draw();//draw the underlying button
    ui.getSource().noStroke();
    if(selected){
      ui.getSource().fill(255,0,0);
    }else{
      ui.getSource().fill(strokeColor);
    }
    ui.getSource().rect(sliderPosX-slierWidth/2-stroke, y-sliderHeightOffset-stroke, slierWidth+stroke*2, 2*sliderHeightOffset+height+stroke*2);//draw the knob

    ui.getSource().fill(fillColor);
    ui.getSource().rect(sliderPosX-slierWidth/2, y-sliderHeightOffset, slierWidth, 2*sliderHeightOffset+height);
  }
  
  /**Calculate the total percent of the slider
  @return the distace across the slider as a percent
  */
  public float calcPercentValue() {
    return (value-minVal)/(maxVal-minVal);
  }
  
  /**Set the stroke weight of the slider
  @param s The new base stroke weight
  @return this
  */
  public UiSlider setStrokeWeight(float s) {
    istroke=s;
    stroke=istroke*ui.scale();
    button.setStrokeWeight(s);
    return this;
  }

  /**Process mouse clicks that may happen on this slider
  */
  public void mouseClicked() {
    if (button.isMouseOver()) {
      float relpos = ui.getSource().mouseX-x;
      float percentVal=relpos/width;
      float value=(percentVal*(maxVal-minVal))+minVal;
      if (round>0) {
        value=Math.round(value*(1/round))*round;
      }
      value=Math.min(Math.max(value, minVal), maxVal);//make shure that value is allways inside of the upper and lower boundss
      this.value=value;
    }
  }
  
  /**Process mouse draggs that may happen on this slider
  */
  public void mouseDragged() {
    if (button.isMouseOver()) {
      float relpos = ui.getSource().mouseX-x;
      float percentVal=relpos/width;
      float value=(percentVal*(maxVal-minVal))+minVal;
      if (round>0) {
        value=Math.round(value*(1/round))*round;
      }
      value=Math.min(Math.max(value, minVal), maxVal);//make shure that value is allways inside of the upper and lower boundss
      this.value=value;
    }
  }
  
  /**Get the current value of this slider
  @return The current value of this slider
  */
  public float getValue() {
    return value;
  }
  
  /**Set the value of this slider
  @param v The new value for this slider
  @return this
  */
  public UiSlider setValue(float v) {
    value=v;
    return this;
  }
  
  /**Set the minimum value of this slider
  @param min The new minimum value of the slider
  @return this
  */
  public UiSlider setMin(float min) {
    minVal=min;
    return this;
  }
  /**Set the maximum value of this slider
  @param max The new maximum value of the slider
  @return this
  */
  public UiSlider setMax(float max) {
    maxVal=max;
    return this;
  }

  /**Set what percision to round to
  @param r The new percision to sound to. ex: use 1 to round to whole numbers, 0.5 to sound to halfs, ect...
  @return this
  */
  public UiSlider setRounding(float r) {
    round=r;
    return this;
  }

  /**Set wether to show the current value of the slider on the slider
  @param s wether to show the current slider value or not
  @return this
  */
  public UiSlider showValue(boolean s) {
    displayValue=s;
    return this;
  }

  /**Set the colors of the slider
  @param fillColor The fill color of the button
  @param strokeColor The stroke color of the button
  @return this
  */
  public UiSlider setColors(int fillColor, int strokeColor) {
    this.fillColor=fillColor;
    this.strokeColor=strokeColor;
    button.setColor(fillColor, strokeColor);
    return this;
  }
  
  void setSelecetd(boolean s){
    selected=s;
  }
}
