/**a movement manager for an entity that can not move on its own. ex: any player that is not the one currently being played as
*/
class NoMovementManager extends MovementManager{
   boolean left(){return false;}
   boolean right(){return false;}
   boolean in(){return false;}
   boolean out(){return false;}
   boolean jump(){return false;}
   void reset(){};
}
