import processing.core.*;
import processing.data.*;
import java.io.InputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.File;
class Settings{
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
  
  Settings(String path){
    JSONArray file;
    
    saveFilePath = path;
    try(InputStream in = new FileInputStream(path)){
      file = new JSONArray(PApplet.createReader(in));
    }catch(IOException e){
      settingsAfterStart=true;
      System.out.println("problem loading settings, resetting to defaults");
      save();
      e.printStackTrace();
      return;
    }
    
    
    JSONObject o1 = file.getJSONObject(0);
    int inputVersion = o1.getInt("settings version");
    if(inputVersion != version){
      save();
      settingsAfterStart=true;
      System.out.println("A duffrent settings version was detected. resetting to defult settings");
      //set the go to seeting screen by default value
      return;
    }
    
    loadScrollSettings(file.getJSONObject(1));
    loadResolutionSettings(file.getJSONObject(2));
    loadDebugSettings(file.getJSONObject(3));
    loadSoundSettings(file.getJSONObject(4));
    loadOtherSettings(file.getJSONObject(5));
    
  }
  
  //loading functions
  private void loadScrollSettings(JSONObject data){
    scrollHorozontal = data.getInt("horozontal");
    scrollVertical = data.getInt("vertical");
  }
  
  private void loadResolutionSettings(JSONObject data){
    resolutionHorozontal = data.getInt("h-res");
    resolutionVertical = data.getInt("v-res");
    fullScreen = data.getBoolean("full_Screen");
    fullScreenScreen = data.getInt("full_Screen_diplay");
    scale = data.getFloat("scale");
  }
  
  private void loadDebugSettings(JSONObject data){
    debugFPS = data.getBoolean("fps");
    debugInfo = data.getBoolean("debug info");
  }
  
  private void loadSoundSettings(JSONObject data){
    soundMusicVolume =  data.getFloat("music volume");
    soundSoundVolume =  data.getFloat("SFX volume");
    soundNarrationVolume =  data.getFloat("narration volume");
    soundNarrationMode = data.getInt("narrationMode");
  }
  
  private void loadOtherSettings(JSONObject data){
    shadows = data.getInt("3D shaows");
    disableMenuTransitions = data.getBoolean("disableMenuTransitions");
    defaultAuthor = data.getString("default author");
    cameraFOV = data.getFloat("FOVY");
  }
  
  //saving functions
  void save(){
    JSONArray file = new JSONArray();
    JSONObject vo = new JSONObject();
    vo.setInt("settings version",version);
    file.append(vo);
    file.append(saveScrolling());
    file.append(saveResolution());
    file.append(saveDebug());
    file.append(saveSoundVolume());
    file.append(saveTheRest());
    file.save(new File(saveFilePath),null);
  }
  
  private JSONObject saveScrolling(){
    JSONObject data = new JSONObject();
    data.setInt("horozontal",scrollHorozontal);
    data.setInt("vertical",scrollVertical);
    data.setString("label","scroling location");
    return data;
  }
  
  private JSONObject saveResolution(){
    JSONObject data = new JSONObject();
    data.setInt("h-res",resolutionHorozontal);
    data.setInt("v-res",resolutionVertical);
    data.setBoolean("full_Screen",fullScreen);
    data.setInt("full_Screen_diplay",fullScreenScreen);
    data.setFloat("scale",scale);
    data.setString("label","resolution stuff");
    return data;
  }
  
  private JSONObject saveDebug(){
    JSONObject data = new JSONObject();
    data.setBoolean("fps",debugFPS);
    data.setBoolean("debug info",debugInfo);
    data.setString("label","debug stuffs");
    return data;
  }
  
  private JSONObject saveSoundVolume(){
    JSONObject data = new JSONObject();
    data.setFloat("music volume",soundMusicVolume);
    data.setFloat("SFX volume",soundSoundVolume);
    data.setFloat("narration volume",soundNarrationVolume);
    data.setInt("narrationMode",soundNarrationMode);
    data.setString("label","music and sound volume");
    return data;
  }
  
  private JSONObject saveTheRest(){
    JSONObject data = new JSONObject();
    data.setInt("3D shaows",shadows);
    data.setBoolean("disableMenuTransitions",disableMenuTransitions);
    data.setString("default author",defaultAuthor);
    data.setString("label","outher");
    data.setFloat("FOVY",cameraFOV);
    return data;
  }
  
  //getters
  public int getScrollHorozontal(){
    return scrollHorozontal;
  }
  public int getSrollVertical(){
    return scrollVertical;
  }
  
  public float getFOV(){
    return cameraFOV;
  }
  
  public int getResolutionHorozontal(){
    return resolutionHorozontal;
  }
  public int getResolutionVertical(){
    return resolutionVertical;
  }
  public boolean getFullScreen(){
    return fullScreen;
  }
  public int getFullScreenScreen(){
    return fullScreenScreen;
  }
  public float getScale(){
    return scale;
  }
  
  public boolean getDebugFPS(){
    return debugFPS;
  }
  public boolean getDebugInfo(){
    return debugInfo;
  }
  
  public float getSoundMusicVolume(){
    return soundMusicVolume;
  }
  public float getSoundSoundVolume(){
    return soundSoundVolume;
  }
  public float getSoundNarrationVolume(){
    return soundNarrationVolume;
  }
  public int getSoundNarrationMode(){
    return soundNarrationMode;
  }
  
  public int getShadows(){
    return shadows;
  }
  public boolean getDisableMenuTransitions(){
    return disableMenuTransitions;
  }
  public String getDefaultAuthor(){
    return defaultAuthor;
  }
  
   public void setScrollHorozontal(int scrollHorozontal, boolean stats){
     this.scrollHorozontal = scrollHorozontal;
     if(stats)
     adjustStats();
   }
   public void setScrollVertical(int scrollVertical, boolean stats){
     this.scrollVertical = scrollVertical;
     if(stats)
     adjustStats();
   }
   public void setFOV(float fov,boolean stats){
     cameraFOV = PApplet.radians(fov);
     if(stats){
       adjustStats();
     }
   }
  
   public void setResolutionHorozontal(int resolutionHorozontal){
     this.resolutionHorozontal=resolutionHorozontal;
     adjustStats();
   }
   public void setResolutionVertical(int resolutionVertical){
     this.resolutionVertical=resolutionVertical;
     adjustStats();
   }
   
   public void setResolution(int hrez,int vrez){
     resolutionHorozontal = hrez;
     resolutionVertical = vrez;
     scale = vrez/720.0f;
     adjustStats();
     
   }
   public void setFullScreen(boolean fullScreen){
     this.fullScreen=fullScreen;
     adjustStats();
   }
   public void setFullScreenScreen(int fullScreenScreen){
     this.fullScreenScreen=fullScreenScreen;
     adjustStats();
   }
   public void setScale(float scale){
     this.scale=scale;
     adjustStats();
   }
  
   public void setDebugFPS(boolean debugFPS){
     this.debugFPS=debugFPS;
     adjustStats();
   }
   public void setDebugInfo(boolean debugInfo){
     this.debugInfo=debugInfo;
     adjustStats();
   }
  
   public void setSoundMusicVolume(float soundMusicVolume, boolean stats){
     this.soundMusicVolume=soundMusicVolume;
     if(stats)
     adjustStats();
   }
   public void setSoundSoundVolume(float soundSoundVolume, boolean stats){
     this.soundSoundVolume=soundSoundVolume;
     if(stats)
     adjustStats();
   }
   public void setSoundNarrationVolume(float soundNarrationVolume, boolean stats){
     this.soundNarrationVolume=soundNarrationVolume;
     if(stats)
     adjustStats();
   }
   public void setSoundNarrationMode(int soundNarrationMode){
     this.soundNarrationMode=soundNarrationMode;
     adjustStats();
   }
  
   public void setShadows(int shadows){
     this.shadows=shadows;
     adjustStats();
   }
   public void setDisableMenuTransitions(boolean disableMenuTransitions){
     this.disableMenuTransitions=disableMenuTransitions;
     adjustStats();
   }
   public void setDefaultAuthor(String defaultAuthor){
     this.defaultAuthor=defaultAuthor;
     adjustStats();
   }
   
   public boolean getSettingsAfterStart(){
     return settingsAfterStart;
   }
   
   private void adjustStats(){
     StatisticManager.getInstace().incrementSettingsChnaged();
   }
  
  
}
