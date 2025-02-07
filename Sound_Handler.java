//version 2.1.0
import processing.core.*;
import processing.sound.*;
import java.util.ArrayList;
class SoundHandler extends Thread {
  SoundFile[] music[], queue, sounds,narrations;
  ArrayList<SoundFile> levelSounds = new ArrayList<>(),levelNarrations = new ArrayList<>();
  private SoundFile []cSound=new SoundFile[3];//sound queue
  PApplet ggn;
  private int musNum=0, currentMusicTrack=0, trackToSwitchTo=0;
  private float masterVolume=1, musicVolume=1, sfxVolume=1, prevVol=1,narrationVolume=1;
  private boolean switchMusicTrack=false, keepAlive=true, enableSounds=false, startMusic=false;


  private SoundHandler(String[][] musicFiles, String[] soundsFiles, String[] narrationFiles,PApplet X) {
    music=new SoundFile[musicFiles.length][];
    for (int i=0; i<musicFiles.length; i++) {//set the size of the music tracks
      music[i]=new SoundFile[musicFiles[i].length];
    }
    queue = new SoundFile[8];//create the sound queue
    sounds=new SoundFile[soundsFiles.length];
    for (int i =0; i<soundsFiles.length; i++) {//load the included game sounds
      sounds[i]=new SoundFile(X, soundsFiles[i]);
    }
    ggn=X;//set the parent application to run sounds through

    for (int i =0; i<musicFiles.length; i++) {
      for (int j=0; j<musicFiles[i].length; j++) {
        music[i][j]=new SoundFile(X, musicFiles[i][j]);//load the music files
      }
    }
    narrations = new SoundFile[narrationFiles.length];
    for(int i=0;i<narrations.length;i++){
      narrations[i] = new SoundFile(X,narrationFiles[i]);//load the narrations
    }
    start();//start the independednt sound handler thread
  }

  public void run() {
    try {
      while (keepAlive) {//while thw sound handler should be running
        tick();
        Thread.sleep(10);//wait 10ms before handling things again. this lowers CPU useage and prevent the audio from being studdery from over interation
      }
    }
    catch(Exception i) {
      System.out.println("the sound handler ran into an error");
      i.printStackTrace();
      ((skiny_mann)ggn).handleError(i);
    }
  }

  private void tick() {
    if (enableSounds) {//if sounds are enabled rn
      if (startMusic) {
        music[currentMusicTrack][musNum].play(1, masterVolume*musicVolume);
        startMusic=false;
      }

      if (prevVol!=masterVolume*musicVolume) {//if the volume changed
        music[currentMusicTrack][musNum].amp(masterVolume*musicVolume);//change the volume of the currently playing music track
        prevVol=masterVolume*musicVolume;
        if (musicVolume*masterVolume==0) {
          music[currentMusicTrack][musNum].stop();
        }
      }

      if (!music[currentMusicTrack][musNum].isPlaying()&& musicVolume*masterVolume!=0) {//if the current track has ended
        musNum++;//switch to the next track
        if (musNum==music[currentMusicTrack].length)//if rached the end of the track go back to the start
          musNum=0;
        //System.out.println(musNum+" "+music[currentMusicTrack].length+" "+masterVolume*musicVolume);
        music[currentMusicTrack][musNum].play(1, masterVolume*musicVolume);//play the music
        //there appears to be a bug in the audio librarie that prevents passing the volume as a parameter in play from working
        //so we will manualy set the volume emedialy after
        music[currentMusicTrack][musNum].amp(masterVolume*musicVolume);
        //what is weird is that play just calls the amp method under the hood 
      }

      playSound(cSound, 0);//do sound slot 1
      playSound(cSound, 1);//do sound slot 2
      playSound(cSound, 2);//do sound slot 3



      if (switchMusicTrack&&trackToSwitchTo!=currentMusicTrack) {
        if (trackToSwitchTo>=0 && trackToSwitchTo<music.length) {
          music[currentMusicTrack][musNum].stop();
          currentMusicTrack=trackToSwitchTo;
          music[currentMusicTrack][musNum].play(1, masterVolume*musicVolume);
        }
      }
    }
  }

  void addToQueue(int soundNum) {
    SoundFile sound;
    if (soundNum<sounds.length) {
      sound=sounds[soundNum];
    } else {
      sound=levelSounds.get(soundNum-sounds.length);
    }
    if (queue[0]==null) {
      queue[0]=sound;
      return;
    }
    if (queue[1]==null) {
      queue[1]=sound;
      return;
    }
    if (queue[2]==null) {
      queue[2]=sound;
      return;
    }
    if (queue[3]==null) {
      queue[3]=sound;
      return;
    }
    if (queue[4]==null) {
      queue[4]=sound;
      return;
    }
    if (queue[5]==null) {
      queue[5]=sound;
      return;
    }
    if (queue[6]==null) {
      queue[6]=sound;
      return;
    }
    if (queue[7]==null) {
      queue[7]=sound;
      return;
    }
  }

  private boolean moveUp(SoundFile R) {
    if (R==null)
      return true;
    if (!R.isPlaying())
      return true;

    return false;
  }

  private void playSound(SoundFile[] R, int n) {
    if (moveUp(R[n])) {

      R[n]=queue[0];
      if (R[n]!=null){
        if (masterVolume*sfxVolume!=0)
          R[n].play(1, masterVolume*sfxVolume);
          R[n].amp(masterVolume*sfxVolume);//sound lib is broken so this is nessary to deal with the volume
      }

      for (int i =0; i<7; i++) {
        queue[i]=queue[i+1];
      }
      queue[7]=null;
    }
  }

  public void setMasterVolume(float volume) {
    masterVolume=volume;
  }
  public void setMusicVolume(float volume) {
    musicVolume=volume;
  }
  public void setSoundsVolume(float volume) {
    sfxVolume=volume;
  }
  
  public void setNarrationVolume(float volume){
    narrationVolume = volume;
  }

  public static Builder builder(PApplet a) {
    return new Builder(a);
  }

  public void setMusicTrack(int track) {
    trackToSwitchTo=track;
    switchMusicTrack=true;
  }

  void startSounds() {
    enableSounds=true;
    startMusic=true;
  }

  void stopSounds() {
    enableSounds=false;
    music[currentMusicTrack][musNum].pause();
  }

  public int registerLevelSound(String path) {
    SoundFile sound = new SoundFile(ggn, path);
    int id =sounds.length+levelSounds.size();
    levelSounds.add(sound);
    return id;
  }
  
  public int registerLevelNarration(String path){
    SoundFile sound = new SoundFile(ggn, path);
    int id = narrations.length+levelNarrations.size();
    levelNarrations.add(sound);
    return id;
  }

  public boolean isPlaying(int n) {
    if (n<sounds.length) {
      return sounds[n].isPlaying();
    } else {
      return levelSounds.get(n-sounds.length).isPlaying();
    }
  }

  public boolean isInQueue(int n) {
    SoundFile s;
    if (n<sounds.length) {
      s= sounds[n];
    } else {
      s= levelSounds.get(n-sounds.length);
    }
    for (int i=0; i<queue.length; i++) {
      if (queue[i]!=null&&s.equals(queue[i])) {
        return true;
      }
    }
    return false;
  }

  public void cancleSound(int n) {
    SoundFile s;
    if (n<sounds.length) {
      s= sounds[n];
    } else {
      s= levelSounds.get(n-sounds.length);
    }

    if (s.isPlaying()) {
      s.stop();
      return;
    }
    for (int i=0; i<queue.length; i++) {
      if (queue[i]!=null&&s.equals(queue[i])) {
        queue[i]=null;
        return;
      }
    }
  }
  
  public void playNarration(int n){
    SoundFile sound;
    if (n<narrations.length) {
      sound=narrations[n];
    } else {
      sound=levelNarrations.get(n-narrations.length);
    }
    sound.play(1, masterVolume*narrationVolume);
    sound.amp(masterVolume*narrationVolume);
    System.out.println(masterVolume*narrationVolume);
  }
  
  public boolean isNarrationPlaying(int n){
    if (n<narrations.length) {
      return narrations[n].isPlaying();
    } else {
      return levelNarrations.get(n-narrations.length).isPlaying();
    }
  }
  
  public boolean anyNarrationPlaying(){
    for(SoundFile s: narrations){
      if(s.isPlaying()){
        return true;
      }
    }
    for(SoundFile s: levelNarrations){
      if(s.isPlaying()){
        return true;
      }
    }
    
    return false;
  }
  
  public void stopNarration(int n){
    SoundFile s;
    if (n<narrations.length) {
      s= narrations[n];
    } else {
      s= levelNarrations.get(n-narrations.length);
    }

    if (s.isPlaying()) {
      s.stop();
      return;
    }
  }

  public void dumpLS() {//dump level sounds and allow them to be garbage collected
    for (int i=0; i<levelSounds.size(); i++) {
      levelSounds.get(i).removeFromCache();
    }
    for(int i=0;i<levelNarrations.size();i++){
      levelNarrations.get(i).removeFromCache();
    }
    levelSounds = new ArrayList<>();
    levelNarrations = new ArrayList<>();
    System.gc();//run garbage collection to remove old uloaded sound files from memory
  }

  //===============================BUILDER===============================

  public static class Builder {
    private Builder(PApplet a) {
      window=a;
      musicPaths.add(new ArrayList<String>());
    }
    PApplet window;
    private ArrayList<ArrayList<String>> musicPaths=new ArrayList<>();
    private ArrayList<String> soundPaths=new ArrayList<>();
    private ArrayList<String> narrationPaths = new ArrayList<>();
    private int numMusicTracks=1;

    public Builder addMusic(String path, int track) {
      if (track>=numMusicTracks||track<0)
        throw new RuntimeException("invalid music track number "+track);
      musicPaths.get(track).add(path);
      return this;
    }

    public Builder addSound(String path) {
      soundPaths.add(path);
      return this;
    }
    
    public Builder addNarration(String path,int[] narrationIdCallBack){
      if(narrationIdCallBack != null && narrationIdCallBack.length >0){
        narrationIdCallBack[0] = narrationPaths.size();
      }
      narrationPaths.add(path);
      return this;
    }
    
     public Builder addNarration(String path){
       return addNarration(path,null);
     }

    public Builder addMusicTrack() {
      numMusicTracks++;
      musicPaths.add(new ArrayList<String>());
      return this;
    }

    public int getNumTracks() {
      return numMusicTracks;
    }

    public SoundHandler build() {
      String[] sounds=soundPaths.toArray(new String[]{});
      String[][] music=new String[numMusicTracks][];
      String[] narrations = narrationPaths.toArray(new String[]{});
      for (int i=0; i<numMusicTracks; i++) {
        music[i]=musicPaths.get(i).toArray(new String[]{});
      }

      return new SoundHandler(music, sounds, narrations, window);
    }
  }
}
