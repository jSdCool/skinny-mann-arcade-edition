/**Catches any errors that do not get cought by in code try catch bclocks so that they be presented to the user and reported as bugs.<br>
Note: This only works in release builds of the game and not during development in the PDE
*/
public class UniversalErrorManager{
  /**Initilize the universal error handler setting it as the default error handler in this jvm
  @param source The object that contains the actual error handling code, this just catches the error
  */
  public static void init(skiny_mann source){
    Thread.setDefaultUncaughtExceptionHandler( new Thread.UncaughtExceptionHandler() {
      public void uncaughtException(Thread t, Throwable e)//catch execeotiosn from any thread
          {
            System.err.println("UniversalErrorManager has cought an error in thread: "+t.toString());
            source.handleError(e);//hand them back to the game to display the error window then crash
          }
      });
  }
}
