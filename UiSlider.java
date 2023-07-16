class UiSlider{
  UiFrame ui;
  UiButton button;
  float ix,iy,iwidth,iheight,x,y,width,height,pScale,minVal=0,maxVal=100,value=50,istroke=3,stroke=3,round=0;
  boolean displayValue=true;
  int fillColor=255,strokeColor=-5592405;
  
  UiSlider(UiFrame ui, float x,float y, float width,float height){
    this.ui=ui;
    this.ix=x;
    this.iy=y;
    this.iwidth=width;
    this.iheight=height;
    pScale=ui.scale();
    button = new UiButton(ui,x,y,width,height);
    this.x=ui.topX()+x*ui.scale();
    this.y=ui.topY()+y*ui.scale();
    this.width=width*ui.scale();
    this.height=height*ui.scale();
    
  }
  
  void reScale(){
    x=ui.topX()+ix*ui.scale();
    y=ui.topY()+iy*ui.scale();
    width=iwidth*ui.scale();
    height=iheight*ui.scale();
    button.reScale();
    pScale=ui.scale();
    stroke=istroke*ui.scale();
  }
  
  void draw(){
    if(ui.scale()!=pScale){//if the scale has changed then recalculate the positions for everything
      reScale();
    }
    float percent = calcPercentValue();
    float distFromLeft = percent*width;
    float sliderPosX=x+distFromLeft;
    float slierWidth=20*ui.scale();
    float sliderHeightOffset=10*ui.scale();
    if(displayValue){
      button.setText(value+"");
    }else{
      button.setText("");
    }
    button.draw();
    ui.getSource().noStroke();
    ui.getSource().fill(strokeColor);
    ui.getSource().rect(sliderPosX-slierWidth/2-stroke,y-sliderHeightOffset-stroke,slierWidth+stroke*2,2*sliderHeightOffset+height+stroke*2);
    ui.getSource().fill(fillColor);
    ui.getSource().rect(sliderPosX-slierWidth/2,y-sliderHeightOffset,slierWidth,2*sliderHeightOffset+height);
  }
  
  float calcPercentValue(){
    return (value-minVal)/(maxVal-minVal);
  }
  
  public UiSlider setStrokeWeight(float s) {
    istroke=s;
    stroke=istroke*ui.scale();
    button.setStrokeWeight(s);
    return this;
  }
  
  void mouseClicked(){
    if(button.isMouseOver()){
      float relpos = ui.getSource().mouseX-x;
      float percentVal=relpos/width;
      float value=(percentVal*(maxVal-minVal))+minVal;
      if(round>0){
        value=Math.round(value*(1/round))*round;
      }
      value=Math.min(Math.max(value,minVal),maxVal);//make shure that value is allways inside of the upper and lower boundss
      this.value=value;
    }
  }
  
  void mouseDragged(){
    if(button.isMouseOver()){
      float relpos = ui.getSource().mouseX-x;
      float percentVal=relpos/width;
      float value=(percentVal*(maxVal-minVal))+minVal;
      if(round>0){
        value=Math.round(value*(1/round))*round;
      }
      value=Math.min(Math.max(value,minVal),maxVal);//make shure that value is allways inside of the upper and lower boundss
      this.value=value;
    }
  }
  
  float getValue(){
    return value;
  }
  
  UiSlider setValue(float v){
    value=v;
    return this;
  }
  
  UiSlider setMin(float min){
    minVal=min;
    return this;
  }
  UiSlider setMax(float max){
    maxVal=max;
    return this;
  }
  
  UiSlider setRounding(float r){
    round=r;
    return this;
  }
  
  UiSlider showValue(boolean s){
    displayValue=s;
    return this;
  }
  
  UiSlider setColors(int fillColor,int strokeColor){
    this.fillColor=fillColor;
    this.strokeColor=strokeColor;
    button.setColor(fillColor,strokeColor);
    return this;
  }
}
