import processing.core.*;
import processing.data.*;
import java.io.InputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.File;
/**The manager and guardain of all the game's settings
*/
public class Settings {
  //all theese are the default value for theese settings
  private static final int version = 5;

  private int scrollHorozontal = 360;
  private int scrollVertical = 250;
  private float cameraFOV = 60 * PApplet.DEG_TO_RAD;

  private int resolutionHorozontal = 1280;
  private int resolutionVertical = 720;
  private boolean fullScreen = false;
  private int fullScreenScreen = 1;
  private float scale = 1;

  private boolean debugFPS = false;
  private boolean debugInfo = false;

  private float soundMusicVolume = 1;
  private float soundSoundVolume = 1;
  private float soundNarrationVolume = 1;
  private int soundNarrationMode = 0;

  private int shadows = 3;
  private boolean disableMenuTransitions = false;
  private String defaultAuthor = "can't_be_botherd_to_chane_it";


  private String saveFilePath;
  private boolean settingsAfterStart = false;
  
  /**Load settings from the provided settings json file
  @param path The path to the settings file
  */
  public Settings(String path) {
    JSONArray file;

    saveFilePath = path;
    //hmmm apperently try with resources does not properly syntax hilight in processing 4.3.0
    try(InputStream in = new FileInputStream(path)) {
      file = new JSONArray(PApplet.createReader(in));//load the json file
    } catch(IOException e) {//if the file could not be loaded
      settingsAfterStart=true;//make the game go to the settings menu after the logo
      System.out.println("problem loading settings, resetting to defaults");
      save();//save a new settings file
      e.printStackTrace();
      return;
    }

    JSONObject o1 = file.getJSONObject(0);//get the first object in the settigns file
    int inputVersion = o1.getInt("settings version");//get the settings version
    if (inputVersion != version) {//if there is a verison mismatch
      save();//save a new settings file
      settingsAfterStart=true;//make the game go to the settings menu after the logo
      System.out.println("A diffrent settings version was detected. resetting to defult settings");
      //set the go to seeting screen by default value
      return;
    }
    //load each block of the settings file
    loadScrollSettings(file.getJSONObject(1));
    loadResolutionSettings(file.getJSONObject(2));
    loadDebugSettings(file.getJSONObject(3));
    loadSoundSettings(file.getJSONObject(4));
    loadOtherSettings(file.getJSONObject(5));
  }

  //loading functions
  /**Load the scroll settings block of the settings file
  @param data The object with the setting data
  */
  private void loadScrollSettings(JSONObject data) {
    scrollHorozontal = data.getInt("horozontal");
    scrollVertical = data.getInt("vertical");
  }
  /**Load the resolution settings block from the settings file
  @param data The object with the settings data
  */
  private void loadResolutionSettings(JSONObject data) {
    resolutionHorozontal = data.getInt("h-res");
    resolutionVertical = data.getInt("v-res");
    fullScreen = data.getBoolean("full_Screen");
    fullScreenScreen = data.getInt("full_Screen_diplay");
    scale = data.getFloat("scale");
  }
  /**Load the debug settings block from the settings file
  @param data The object with the settings data
  */
  private void loadDebugSettings(JSONObject data) {
    debugFPS = data.getBoolean("fps");
    debugInfo = data.getBoolean("debug info");
  }
  /**Load the sound settings block from the settings file
  @param data The object with th settings data
  */
  private void loadSoundSettings(JSONObject data) {
    soundMusicVolume =  data.getFloat("music volume");
    soundSoundVolume =  data.getFloat("SFX volume");
    soundNarrationVolume =  data.getFloat("narration volume");
    soundNarrationMode = data.getInt("narrationMode");
  }
  /**Load the other settings block from the settings file
  @param data The object with the settings data
  */
  private void loadOtherSettings(JSONObject data) {
    shadows = data.getInt("3D shaows");
    disableMenuTransitions = data.getBoolean("disableMenuTransitions");
    defaultAuthor = data.getString("default author");
    cameraFOV = data.getFloat("FOVY");
  }

  //saving functions
  /**save all the settings to a file
  */
  public void save() {
    JSONArray file = new JSONArray();
    JSONObject vo = new JSONObject();
    vo.setInt("settings version", version);
    //append all the settings blocks to the file array
    file.append(vo);
    file.append(saveScrolling());
    file.append(saveResolution());
    file.append(saveDebug());
    file.append(saveSoundVolume());
    file.append(saveTheRest());
    file.save(new File(saveFilePath), null);
  }
  /**Create the scroll settings block
  @return The block containing the scroll settings
  */
  private JSONObject saveScrolling() {
    JSONObject data = new JSONObject();
    data.setInt("horozontal", scrollHorozontal);
    data.setInt("vertical", scrollVertical);
    data.setString("label", "scroling location");
    return data;
  }
  /**Create the resolution settings block
  @return The block containing the resolution settings
  */
  private JSONObject saveResolution() {
    JSONObject data = new JSONObject();
    data.setInt("h-res", resolutionHorozontal);
    data.setInt("v-res", resolutionVertical);
    data.setBoolean("full_Screen", fullScreen);
    data.setInt("full_Screen_diplay", fullScreenScreen);
    data.setFloat("scale", scale);
    data.setString("label", "resolution stuff");
    return data;
  }
  /**Create the debug settings block
  @return The block containing the debug settings
  */
  private JSONObject saveDebug() {
    JSONObject data = new JSONObject();
    data.setBoolean("fps", debugFPS);
    data.setBoolean("debug info", debugInfo);
    data.setString("label", "debug stuffs");
    return data;
  }
  /**Create the volume settings block
  @return The block containing the volume settings
  */
  private JSONObject saveSoundVolume() {
    JSONObject data = new JSONObject();
    data.setFloat("music volume", soundMusicVolume);
    data.setFloat("SFX volume", soundSoundVolume);
    data.setFloat("narration volume", soundNarrationVolume);
    data.setInt("narrationMode", soundNarrationMode);
    data.setString("label", "music and sound volume");
    return data;
  }
  /**Create the reset of the settings block
  @return The block containing the reset of the settings
  */
  private JSONObject saveTheRest() {
    JSONObject data = new JSONObject();
    data.setInt("3D shaows", shadows);
    data.setBoolean("disableMenuTransitions", disableMenuTransitions);
    data.setString("default author", defaultAuthor);
    data.setString("label", "outher");
    data.setFloat("FOVY", cameraFOV);
    return data;
  }

  //getters
  /**Get the horozontal scroll value
  @return The horozontal scrolling valule
  */
  public int getScrollHorozontal() {
    return scrollHorozontal;
  }
  /**Get the vertical scroll value
  @return The verical szcrolling value
  */
  public int getSrollVertical() {
    return scrollVertical;
  }
  /**Get the 3D FOV 
  @return The verical field of view for 3D rendering in radians
  */
  public float getFOV() {
    return cameraFOV;
  }
  /**Get the horozontal resolution
  @return The horozontal pixel resolution of the game window
  */
  public int getResolutionHorozontal() {
    return resolutionHorozontal;
  }
  /**Get the vertical resolution
  @return The vertical pixel resolution of the game window
  */
  public int getResolutionVertical() {
    return resolutionVertical;
  }
  /**Get full screen mode
  @return true if the game should start in full screen
  */
  public boolean getFullScreen() {
    return fullScreen;
  }
  /**Get the screen for fullscreen mode
  @return The number of the screen that the full screen window should appear on, or 0 for all screens
  */
  public int getFullScreenScreen() {
    return fullScreenScreen;
  }
  /**Get the display scale
  @return The factor by wich 2D level graphics should be scaled by
  */
  public float getScale() {
    return scale;
  }
  /**Get wether the FPS should be displayed
  @return true if the fps should be drawn on screen
  */
  public boolean getDebugFPS() {
    return debugFPS;
  }
  /**Get wether genreal debug info should be displayed
  @return true if debug info should be drawn on screen
  */
  public boolean getDebugInfo() {
    return debugInfo;
  }
  /**Get the music volume
  @return The current volume of the music
  */
  public float getSoundMusicVolume() {
    return soundMusicVolume;
  }
  /**Get the sound volume
  @return The current volume of the sounds
  */
  public float getSoundSoundVolume() {
    return soundSoundVolume;
  }
  /**Get the narration volume
  @return The current narration volume
  */
  public float getSoundNarrationVolume() {
    return soundNarrationVolume;
  }
  /**Get the narrtaion mode
  @return The type of narration that should be used
  */
  public int getSoundNarrationMode() {
    return soundNarrationMode;
  }
  /**Get the show mode
  @return The mode to use for drawing shadows. 0 = none, 1 = old, 2 = low, 3 = medium, 4 = high, 5 = very high, 6 = ultra. note: 5/6 do not work very well 
  */
  public int getShadows() {
    return shadows;
  }
  /**Get if menu transitions should be played
  @return true if no menu transition animation should be played
  */
  public boolean getDisableMenuTransitions() {
    return disableMenuTransitions;
  }
  /**Get the default author
  @return The configured default author
  */
  public String getDefaultAuthor() {
    return defaultAuthor;
  }
  //setters
  
  /**Set the horozontal scrolling value
  @param scrollHorozontal The new horozontal scrolling value
  @param stats Wether or not to update statistics when changeing this value
  */
  public void setScrollHorozontal(int scrollHorozontal, boolean stats) {
    this.scrollHorozontal = scrollHorozontal;
    if (stats){
      adjustStats();
    }
  }
  /**Set the vertical scrolling value
  @param scrollVertical The new vertical scrolling value
  @param stats Wether or not to update statistics when changeing this value 
  */
  public void setScrollVertical(int scrollVertical, boolean stats) {
    this.scrollVertical = scrollVertical;
    if (stats){
      adjustStats();
    }
  }
  /**Set the verical FOV for 3D rendering
  @param fov The new verical field of view in degrees
  @param stats Wether or not to update statistics when changeing this value
  */
  public void setFOV(float fov, boolean stats) {
    cameraFOV = PApplet.radians(fov);
    if (stats) {
      adjustStats();
    }
  }
  /**Set the startup horozontal window resolution
  @param resolutionHorozontal The new startup pixel width of the window
  */
  public void setResolutionHorozontal(int resolutionHorozontal) {
    this.resolutionHorozontal=resolutionHorozontal;
    adjustStats();
  }
  /**Set the startup verical window resolution
  @param resolutionVertical The new startup pixel height of the window
  */
  public void setResolutionVertical(int resolutionVertical) {
    this.resolutionVertical=resolutionVertical;
    adjustStats();
  }
  /**Set the startup startup wibdow resolution
  @param hrez The new startup pixel width of the window
  @param vrez The new startup pixel height of the window
  */
  public void setResolution(int hrez, int vrez) {
    resolutionHorozontal = hrez;
    resolutionVertical = vrez;
    scale = vrez/720.0f;
    adjustStats();
  }
  /**Set startup full screen mode
  @param fullScreen Wether to start the game in fullscreen mode
  */
  public void setFullScreen(boolean fullScreen) {
    this.fullScreen=fullScreen;
    adjustStats();
  }
  /**Set the screen to start a fullscreen window on 
  @param fullScreenScreen The number of the screen to open the full screen window on, or 0 for all screen
  */
  public void setFullScreenScreen(int fullScreenScreen) {
    this.fullScreenScreen=fullScreenScreen;
    adjustStats();
  }
  /**Set the 2D rendering scale
  @param scale The new factor by wich to scale 2D renderd levels
  */
  public void setScale(float scale) {
    this.scale=scale;
    adjustStats();
  }
  /**Set wether the FPS should be displayed 
  @param debugFPS Wether to show the current frame rate
  */
  public void setDebugFPS(boolean debugFPS) {
    this.debugFPS=debugFPS;
    adjustStats();
  }
  /**Set wether the debug info should be displayed
  @param debugInfo Wther to shoe the current debug info on screen
  */
  public void setDebugInfo(boolean debugInfo) {
    this.debugInfo=debugInfo;
    adjustStats();
  }
  /**Set the music volume
  @param soundMusicVolume The new music volume
  @param stats Wether or not to update statistics when changeing this value
  */
  public void setSoundMusicVolume(float soundMusicVolume, boolean stats) {
    this.soundMusicVolume=soundMusicVolume;
    if (stats)
      adjustStats();
  }
  /**Set the sound volume
  @param soundSoundVolume The new sound volume
  @param stats Wether or not to update statistics when changeing this value
  */
  public void setSoundSoundVolume(float soundSoundVolume, boolean stats) {
    this.soundSoundVolume=soundSoundVolume;
    if (stats)
      adjustStats();
  }
  /**Set the narration volume
  @param soundNarrationVolume The new narration volume
  @param stats Wether or not to update statistics when changeing this value
  */
  public void setSoundNarrationVolume(float soundNarrationVolume, boolean stats) {
    this.soundNarrationVolume=soundNarrationVolume;
    if (stats)
      adjustStats();
  }
  /**Set the narraion mode
  @param soundNarrationMode The new mode to use for narration sounds
  */
  public void setSoundNarrationMode(int soundNarrationMode) {
    this.soundNarrationMode=soundNarrationMode;
    adjustStats();
  }
  
  /**Set the shadow mode
  @param shadows The new shadow mode
  */
  public void setShadows(int shadows) {
    this.shadows=shadows;
    adjustStats();
  }
  /**Set wether menu transitions should eb enabled
  @param disableMenuTransitions Wther to disable menu transitions
  */
  public void setDisableMenuTransitions(boolean disableMenuTransitions) {
    this.disableMenuTransitions=disableMenuTransitions;
    adjustStats();
  }
  /**Set the default author name
  @param defaultAuthor The new name of the default author
  */
  public void setDefaultAuthor(String defaultAuthor) {
    this.defaultAuthor=defaultAuthor;
    adjustStats();
  }
  /**Get wether settings should be diaplayed after start
  @return true if the startup menu transition should go to settings instead of the main menu
  */
  public boolean getSettingsAfterStart() {
    return settingsAfterStart;
  }
  /**Increment the statistics for settings adjusted
  */
  private void adjustStats() {
    StatisticManager.getInstace().incrementSettingsChnaged();
  }
}
