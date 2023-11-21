import net.java.games.input.*;
class GamePadWrapper{
  private boolean[] buttons = new boolean[10];//a b x y left right select start leftStick rightStick
  private boolean[] dpad = new boolean[4];//up right down left
  private float[] leftStick = new float[2];
  private float[] rightStick = new float[2];
  private float triggers;
  
  float leftStickX(){
    return leftStick[0];
  }
  
  float leftStickY(){
    return leftStick[1];
  }
  
  float rightStickX(){
    return rightStick[0];
  }
  
  float rightStickY(){
    return rightStick[1];
  }
  
  float triggers(){
    return triggers;
  }
  
  boolean dpadUp(){
    return dpad[0];
  }
  
  boolean dpadRight(){
    return dpad[1];
  }
  
  boolean dpadDown(){
    return dpad[2];
  }
  
  boolean dpadLeft(){
    return dpad[3];
  }
  
  boolean a(){
    return buttons[0];
  }
  
  boolean b(){
    return buttons[1];
  }
  
  boolean x(){
    return buttons[2];
  }
  
  boolean y(){
    return buttons[3];
  }
  
  boolean r(){
    return buttons[5];
  }
  
  boolean l(){
    return buttons[4];
  }
  
  boolean select(){
    return buttons[6];
  }
  
  boolean start(){
    return buttons[7];
  }
  
  boolean leftStick(){
    return buttons[8];
  }
  
  boolean rightStick(){
    return buttons[9];
  }
  
  public void updateComponent(Component.Identifier component,float value){
    if(component.equals(Component.Identifier.Axis.X)){
      leftStick[0]=value;
      return;
    }
    if(component.equals(Component.Identifier.Axis.Y)){
      leftStick[1]=value;
      return;
    }
    if(component.equals(Component.Identifier.Axis.RX)){
      rightStick[0]=value;
      return;
    }
    if(component.equals(Component.Identifier.Axis.RY)){
      rightStick[1]=value;
      return;
    }
    if(component.equals(Component.Identifier.Axis.Z)){
      if(value>-10){
        triggers=value;
      }else{
        triggers=0;
      }
      return;
    }
    if(component.equals(Component.Identifier.Axis.POV)){
      if(value == 0 ){
        dpad[0] = false;
        dpad[1] = false;
        dpad[2] = false;
        dpad[3] = false;
        return;
      }
      if(value == 0.125 ){
        dpad[0] = true;
        dpad[1] = false;
        dpad[2] = false;
        dpad[3] = true;
        return;
      }
      if(value == 0.25 ){
        dpad[0] = true;
        dpad[1] = false;
        dpad[2] = false;
        dpad[3] = false;
        return;
      }
      if(value == 0.375 ){
        dpad[0] = true;
        dpad[1] = true;
        dpad[2] = false;
        dpad[3] = false;
        return;
      }
      if(value == 0.5 ){
        dpad[0] = false;
        dpad[1] = true;
        dpad[2] = false;
        dpad[3] = false;
        return;
      }
      if(value == 0.625 ){
        dpad[0] = false;
        dpad[1] = true;
        dpad[2] = true;
        dpad[3] = false;
        return;
      }
      if(value == 0.75 ){
        dpad[0] = false;
        dpad[1] = false;
        dpad[2] = true;
        dpad[3] = false;
        return;
      }
      if(value == 0.875 ){
        dpad[0] = false;
        dpad[1] = false;
        dpad[2] = true;
        dpad[3] = true;
        return;
      }
      if(value == 1 ){
        dpad[0] = false;
        dpad[1] = false;
        dpad[2] = false;
        dpad[3] = true;
        return;
      }
    }
    
    if(component.equals(Component.Identifier.Button._0)||component.equals(Component.Identifier.Button.A)||component.equals(Component.Identifier.Button.TRIGGER)){
      buttons[0]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._1)||component.equals(Component.Identifier.Button.B)||component.equals(Component.Identifier.Button.THUMB)){
      buttons[1]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._2)||component.equals(Component.Identifier.Button.X)||component.equals(Component.Identifier.Button.TOP)){
      buttons[2]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._3)||component.equals(Component.Identifier.Button.Y)||component.equals(Component.Identifier.Button.TOP2)){
      buttons[3]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._4)||component.equals(Component.Identifier.Button.LEFT_THUMB)||component.equals(Component.Identifier.Button.PINKIE)){
      buttons[4]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._5)||component.equals(Component.Identifier.Button.RIGHT_THUMB)||component.equals(Component.Identifier.Button.BASE)){
      buttons[5]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._6)||component.equals(Component.Identifier.Button.SELECT)){
      buttons[6]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._7)||component.equals(Component.Identifier.Button.START)){
      buttons[7]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._8)||component.equals(Component.Identifier.Button.LEFT_THUMB3)){
      buttons[8]= value==1;
      return;
    }
    if(component.equals(Component.Identifier.Button._9)||component.equals(Component.Identifier.Button.RIGHT_THUMB3)){
      buttons[9]= value==1;
      return;
    }
  }
}
