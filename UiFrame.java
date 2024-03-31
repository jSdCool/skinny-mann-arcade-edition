import processing.core.*;
class UiFrame {
  private PApplet source;
  private int baseWidth, baseHeight;
  private float topX, topY, centerX, centerY, scale;

  public UiFrame(PApplet s, int baseWidth, int baseHeight) {
    source=s;
    this.baseWidth=baseWidth;
    this.baseHeight=baseHeight;
    centerX=source.width/2;
    centerY=source.height/2;
    scale=source.min((float)source.width/baseWidth, (float)source.height/baseHeight);
    topX=centerX-baseWidth*scale/2;
    topY=centerY-baseHeight*scale/2;
  }

  public void reScale() {
    centerX=source.width/2;
    centerY=source.height/2;
    scale=PApplet.min((float)source.width/baseWidth, (float)source.height/baseHeight);
    topX=centerX-baseWidth*scale/2;
    topY=centerY-baseHeight*scale/2;
  }

  public float topX() {
    return topX;
  }

  public float topY() {
    return topY;
  }

  public float centerX() {
    return centerX;
  }

  public float centerY() {
    return centerY;
  }

  public float scale() {
    return scale;
  }

  public PApplet getSource() {
    return source;
  }
}
