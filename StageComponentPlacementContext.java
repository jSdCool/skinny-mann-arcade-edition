/**contextual information about the placement of a stage component of the placeable variety
*/
public class StageComponentPlacementContext{
   
   private float x,y,z;
   private boolean has3D = false;
   private int index = -1;
   /**Create a stage component placement context
   @param x The x position of the placement
   @param y The y position of the placement
   */
   public StageComponentPlacementContext(float x, float y){
     this.x=x;
     this.y=y;
   }
   /**Create a stage component placement context
   @param x The x position of the placement
   @param y The y position of the placement
   @param z The z position of the placement
   */
   public StageComponentPlacementContext(float x, float y, float z){
     has3D = true;
     this.x=x;
     this.y=y;
     this.z=z;
   }
   /**Create a stage component placement context
   @param x The x position of the placement
   @param y The y position of the placement
   @param index The stage index of the placment, I think
   */
   public StageComponentPlacementContext(float x, float y, int index){
     this.x=x;
     this.y=y;
     this.index = index;
   }
   /**Create a stage component placement context
   @param x The x position of the placement
   @param y The y position of the placement
   @param z The z position of the placement
   @param index The stage index of the placment, I think
   */
   public StageComponentPlacementContext(float x, float y, float z, int index){
     has3D = true;
     this.x=x;
     this.y=y;
     this.z=z;
     this.index = index;
   }
   /**Get the x position of the placement
   @return The x position of the placment
   */
   public float getX(){
     return x;
   }
   /**Get the y position of the placement
   @return The y position of the placment
   */
   public float getY(){
     return y;
   }
   /**Get the z position of the placement
   @return The z position of the placment
   */
   public float getZ(){
     return z;
   }
   /**Get if this placement has a 3D context
   @return true if the placmeent has a 3D context
   */
   public boolean has3D(){
     return has3D;
   }
   /**Get the index of the stage of the placement. DO NOT RELAY ON THIS BEING A THING
   @return The index of the stage the placement occored on, prbly.
   */
   public int index(){
     return index;
   }
 }
