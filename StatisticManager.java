import processing.data.*;
import processing.core.*;
import java.io.File;
/** class to store and manage statistics 
*/
public class StatisticManager {
  static StatisticManager instace;
  
  final String statsFileName;

  private int coinsColected;
  private int settingsChnaged;
  private int portalsUsed;
  private int buttonsActivated;
  private int gamesQuit;
  private int levelsCompleted;
  private int timesDied;
  private int activated3D;
  private int deactivated3D;
  private int signsRead;
  private int soundBoxesUsed;

  private PApplet source;
  
  /**Create a ststaictics manager and load current stats
  @param fileName The file path of the stats file
  @param source Local context for saving stats
  */
  StatisticManager(String fileName, PApplet source) {
    statsFileName = fileName;
    this.source=source;
    if (new File(fileName).exists()) {//if there is an exsisting stats file
      JSONObject statsObject = source.loadJSONObject(fileName);
      //load stats here
      coinsColected = statsObject.getInt("coins collected");
      settingsChnaged = statsObject.getInt("settings changed");
      portalsUsed = statsObject.getInt("portals used");
      buttonsActivated = statsObject.getInt("buttons activated");
      gamesQuit = statsObject.getInt("games quit");
      levelsCompleted = statsObject.getInt("levels completed");
      timesDied = statsObject.getInt("times died");
      activated3D = statsObject.getInt("3d mode activated");
      deactivated3D = statsObject.getInt("3d mode deactivated");
      signsRead = statsObject.getInt("sings read");
      soundBoxesUsed = statsObject.getInt("sound boxes used");
      
    }
    instace = this;//set this object as the global stats object
  }
  
  /**Get the global instace of the stats manager
  @return The global stats manager
  */
  public static StatisticManager getInstace(){
    return instace;
  } 
  /**Save current statistics to a file
  */
  public void save() {
    JSONObject statsObject = new JSONObject();

    //save stats here
    statsObject.setInt("coins collected", coinsColected);
    statsObject.setInt("settings changed", settingsChnaged);
    statsObject.setInt("portals used", portalsUsed);
    statsObject.setInt("buttons activated", buttonsActivated);
    statsObject.setInt("games quit", gamesQuit);
    statsObject.setInt("levels completed", levelsCompleted);
    statsObject.setInt("times died", timesDied);
    statsObject.setInt("3d mode activated", activated3D);
    statsObject.setInt("3d mode deactivated", deactivated3D);
    statsObject.setInt("sings read",signsRead);
    statsObject.setInt("sound boxes used",soundBoxesUsed);

    source.saveJSONObject(statsObject, statsFileName);
  }

  //functions to handle increasing all the values
  /**Increase the coins collected stat
  */
  public void incrementCollectedCoins() {
    coinsColected++;
  }
  /**Increase the coins collected stat
  */
  public void incrementSettingsChnaged() {
    settingsChnaged++;
  }
  /**Increase the portals used stat
  */
  public void incrementPortalsUsed() {
    portalsUsed++;
  }
  /**Increase the (stage)buttons activated stat
  */
  public void incrementButtonsActivated() {
    buttonsActivated++;
  }
  /**Increase the games quit stat
  */
  public void incrementGamesQuit() {
    gamesQuit++;
  }
  /**Increase the levels completed stat
  */
  public void incrementLevelsCompleted() {
    levelsCompleted++;
  }
  /**Increase the number of deaths stat
  */
  public void incrementTimesDied() {
    timesDied++;
  }
  /**Increase the number of times 3D got activated stat
  */
  public void incrementActivated3D() {
    activated3D++;
  }
  /**Increase the number of times 3D got deactivated stat
  */
  public void incrementDeactivated3D() {
    deactivated3D++;
  }
  /**Increase the signs read stat
  */
  public void incrementSignsRead(){
    signsRead++;
  }
  /**Increase the sound boxes used stat
  */
  public void incrementSoundBoxesUsed(){
    soundBoxesUsed++;
  }
}
