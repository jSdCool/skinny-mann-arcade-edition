class PlayerMovementManager extends MovementManager{
  boolean left,right,in,out,jump;
   public boolean left(){
     return left;
   }
   public boolean right(){
     return right;
   }
   public boolean in(){
     return in;
   }
   public boolean out(){
     return out;
   }
   public boolean jump(){
     return jump;
   }
   public void reset(){
     left=false;
     right=false;
     in=false;
     out=false;
     jump=false;
   }
   public void setLeft(boolean l){
     left=l;
   }
   public void setRight(boolean r){
     right=r;
   }
   public void setIn(boolean i){
     in=i;
   }
   public void setOut(boolean o){
     out=o;
   }
   public void setJump(boolean j){
     jump=j;
   }
}
