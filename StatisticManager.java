import processing.data.*;
import processing.core.*;
import java.io.File;
/** class to store and manage statistics 

*/
class StatisticManager {
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

  PApplet source;

  StatisticManager(String fileName, PApplet source) {
    statsFileName = fileName;
    this.source=source;
    if (new File(fileName).exists()) {
      JSONObject statsObject = source.loadJSONObject(fileName);

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
      //load stats here
    }
  }

  void save() {
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
  void incrementCollectedCoins() {
    coinsColected++;
  }
  void incrementSettingsChnaged() {
    settingsChnaged++;
  }
  void incrementPortalsUsed() {
    portalsUsed++;
  }
  void incrementButtonsActivated() {
    buttonsActivated++;
  }
  void incrementGamesQuit() {
    gamesQuit++;
  }
  void incrementLevelsCompleted() {
    levelsCompleted++;
  }
  void incrementTimesDied() {
    timesDied++;
  }
  void incrementActivated3D() {
    activated3D++;
  }
  void incrementDeactivated3D() {
    deactivated3D++;
  }
  void incrementSignsRead(){
    signsRead++;
  }
  void incrementSoundBoxesUsed(){
    soundBoxesUsed++;
  }
}
