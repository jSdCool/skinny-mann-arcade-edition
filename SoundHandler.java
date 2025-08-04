//version 2.1.0
import processing.core.*;
import processing.sound.*;
import java.util.ArrayList;
/**The game's sound engine and sound loader
*/
public class SoundHandler extends Thread {
  SoundFile[] music[], queue, sounds,narrations;
  ArrayList<SoundFile> levelSounds = new ArrayList<>(),levelNarrations = new ArrayList<>();
  private SoundFile []cSound=new SoundFile[3];//sound queue
  PApplet ggn;
  private int musNum=0, currentMusicTrack=0, trackToSwitchTo=0;
  private float masterVolume=1, musicVolume=1, sfxVolume=1, prevVol=1,narrationVolume=1;
  private boolean switchMusicTrack=false, keepAlive=true, enableSounds=false, startMusic=false;

  /**Create a new sound handler with the given music tracks and global sound and narration files.<br>
  Handles the porcess of actually loading the sound files
  @param musicFiles A 2D array of file paths to the muisc files for each track
  @param soundsFiles An array of file paths to the sound files
  @param narrationFiles An array of file paths to the narration files
  @param X A reffence to the surface the sounds will be played from
  */
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

  /**The thread the sound handler runs on
  */
  public void run() {
    try {
      while (keepAlive) {//while thw sound handler should be running
        tick();
        Thread.sleep(10);//wait 10ms before handling things again. This lowers CPU useage and prevent the audio from being studdery from over interation
      }
    }  catch(Exception i) {
      System.out.println("the sound handler ran into an error");
      i.printStackTrace();
      ((skiny_mann)ggn).handleError(i);
    }
  }
  
  /**Process a single tick of the sound handler, This is what actually handels the sounds
  */
  private void tick() {
    if (enableSounds) {//if sounds are enabled right now
      if (startMusic) {//if the music should be started
        music[currentMusicTrack][musNum].play(1, masterVolume*musicVolume);//play the next music track
        startMusic=false;
      }

      if (prevVol!=masterVolume*musicVolume) {//if the volume changed
        music[currentMusicTrack][musNum].amp(masterVolume*musicVolume);//change the volume of the currently playing music track
        prevVol=masterVolume*musicVolume;
        if (musicVolume*masterVolume==0) {//if the new volume is 0
          music[currentMusicTrack][musNum].stop();//stop the music (so the console does not get spammed with warnings)
        }
      }

      if (!music[currentMusicTrack][musNum].isPlaying()&& musicVolume*masterVolume!=0) {//if the current song has ended
        musNum++;//switch to the next song
        if (musNum==music[currentMusicTrack].length){//if rached the end of the track go back to the start
          musNum=0;
        }
        music[currentMusicTrack][musNum].play(1, masterVolume*musicVolume);//play the music
        //there appears to be a bug in the audio librarie that prevents passing the volume as a parameter in play from working
        //so we will manualy set the volume imedatly after
        music[currentMusicTrack][musNum].amp(masterVolume*musicVolume);
        //what is weird is that play just calls the amp method under the hood 
      }

      playSound(cSound, 0);//do sound slot 1
      playSound(cSound, 1);//do sound slot 2
      playSound(cSound, 2);//do sound slot 3


      //hanle switching music tracks
      //just one of the features of the sound handler we do not currently use, why did i devlop all of this?
      if (switchMusicTrack && trackToSwitchTo != currentMusicTrack) {//if switcing track and the track to switch to is not the current track
        if (trackToSwitchTo>=0 && trackToSwitchTo<music.length) {//bounds check
          music[currentMusicTrack][musNum].stop();//stop the music on the current track
          currentMusicTrack=trackToSwitchTo;//switch the track to the new one
          music[currentMusicTrack][musNum].play(1, masterVolume*musicVolume);//play the music on the other track
          music[currentMusicTrack][musNum].amp(masterVolume*musicVolume);//stupid volume fix
        }
      }
    }
  }

  /**Add a sound to the sound queue
  @param soundNum The numberical Id of the sound to play
  */
  public void addToQueue(int soundNum) {
    SoundFile sound;
    if (soundNum<sounds.length) {//if the id is in the range of the global sunds
      sound=sounds[soundNum];//set the sound to the global sound
    } else {//if the id was in the grane of level specific sounds
      sound=levelSounds.get(soundNum-sounds.length);//set the sound to the specific level sound
    }
    //find the correct place in the queue to put the sound
    //note to self, use an actual queue structure for this in the future
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
    //if no place in the queue was found then lets just pretend that was never queued
  }
  
  /**Check if a sound is done in the currently playing slot
  @param R The sound to check
  */
  private boolean moveUp(SoundFile R) {
    if (R==null){//if the sound is null then return true, null can be moved up
      return true;
    }
    if (!R.isPlaying()){//if the sound is not playing then return true, it can be moved up
      return true;
    }
    //if it is playing then it can not be moved up
    return false;
  }
  
  /**Try to play a sound
  @param R The list of currently playing sounds
  @param n The index of the slot to process playing for
  */
  private void playSound(SoundFile[] R, int n) {
    if (moveUp(R[n])) {//if this slot is readdy to get the next sound

      R[n]=queue[0];//grab the first element from the queue
      if (R[n]!=null){//if something was grabbed
        if (masterVolume*sfxVolume!=0){//if the sound is turned on
          R[n].play(1, masterVolume*sfxVolume);//play the sound
          R[n].amp(masterVolume*sfxVolume);//sound lib is broken so this is nessary to deal with the volume
        }
      }
      //move all items in the queue up by 1
      for (int i =0; i<7; i++) {
        queue[i]=queue[i+1];
      }
      queue[7]=null;//empty the last slot in the queue
    }
  }
  /**Set the master volume.<br>
  For some reason I have been too lazy to implment a setting to adjust this
  @param volume The new master volume
  */
  public void setMasterVolume(float volume) {
    masterVolume=volume;
  }
  /**Set the music volume
  @param volume The new music volume
  */
  public void setMusicVolume(float volume) {
    musicVolume=volume;
  }
  /**Set the sound volume
  @param volume The new sound volume
  */
  public void setSoundsVolume(float volume) {
    sfxVolume=volume;
  }
  /**Set the narration volume
  @param volume the new narration volume
  */
  public void setNarrationVolume(float volume){
    narrationVolume = volume;
  }
  
  /**Create a new sound handler builder
  @param a The surface to build the sound handler for
  */
  public static Builder builder(PApplet a) {
    return new Builder(a);
  }
  
  /**Change the music track to a diffrent one
  @param track The new music track index to switch to
  */
  public void setMusicTrack(int track) {
    trackToSwitchTo=track;
    switchMusicTrack=true;
  }
  /**Start the sound handler, this must be done after creating the soud hander
  */
  public void startSounds() {
    enableSounds=true;
    startMusic=true;
  }
  /**Stop the sound handler from playing any new sounds and pause any currenly playing music
  */
  public void stopSounds() {
    enableSounds=false;
    music[currentMusicTrack][musNum].pause();
  }
  /**Register a new level sound
  @param path The path to the sound file
  @return The id of the newly registered sound
  */
  public int registerLevelSound(String path) {
    SoundFile sound = new SoundFile(ggn, path);
    int id =sounds.length+levelSounds.size();
    levelSounds.add(sound);
    return id;
  }
  /**Register a new level narration sound
  @param path The path to the sound file
  @return The id of the newly registered narration
  */
  public int registerLevelNarration(String path){
    SoundFile sound = new SoundFile(ggn, path);
    int id = narrations.length+levelNarrations.size();
    levelNarrations.add(sound);
    return id;
  }
  /**Check if a sound is currently playing
  @param n The id of the sound to check
  @return true if the specified sound is playing
  */
  public boolean isPlaying(int n) {
    if (n<sounds.length) {//check for the global sound range
      return sounds[n].isPlaying();
    } else {
      return levelSounds.get(n-sounds.length).isPlaying();
    }
  }
  /**Check if a sound is currently in the sound queue
  @param n The id of the sound to check
  @return true if the specified sound is in the sound queue
  */
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
  /**Remove a sound from the queue before it is played
  @param n The id of the sound to remove
  */
  public void cancleSound(int n) {
    SoundFile s;
    //get the sound
    if (n<sounds.length) {
      s = sounds[n];
    } else {
      s= levelSounds.get(n-sounds.length);
    }
    //check if it is currently playing
    if (s.isPlaying()) {
      //if so stop it
      s.stop();
      return;
    }
    //go through the queue and check for the sounds
    for (int i=0; i<queue.length; i++) {
      if (queue[i]!=null&&s.equals(queue[i])) {
        //removeing it if it is found
        queue[i]=null;
        return;
      }
    }
  }
  
  /**Play the given narration
  @param n The id of the narration to play
  */
  public void playNarration(int n){
    SoundFile sound;
    //get the narration
    if (n<narrations.length) {
      sound=narrations[n];
    } else {
      sound=levelNarrations.get(n-narrations.length);
    }
    //play it
    sound.play(1, masterVolume*narrationVolume);
    sound.amp(masterVolume*narrationVolume);
    //System.out.println(masterVolume*narrationVolume);
  }
  /**Check if a narration is currently playing
  @param n The id of the narration to check
  @return true if the specified narration is playing
  */
  public boolean isNarrationPlaying(int n){
    if (n<narrations.length) {
      return narrations[n].isPlaying();
    } else {
      return levelNarrations.get(n-narrations.length).isPlaying();
    }
  }
  /**check if any narrations are playing
  @return true if any narration is playing
  */
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
  /**Stops the given narrtation if it is playing
  @param n The id of the narration to stop
  */
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
  
  /**Unload all registerd level sounds and narrations. Removing them from the cashe allowing them to be grabage collected.<br>
  Also runs the grabage collector afterwards
  */
  public void dumpLS() {//dump level sounds and allow them to be garbage collected
    for (int i=0; i<levelSounds.size(); i++) {//go through the level sounds
      levelSounds.get(i).removeFromCache();
    }
    for(int i=0;i<levelNarrations.size();i++){//go through the level narrations
      levelNarrations.get(i).removeFromCache();
    }
    //reset both of the array
    levelSounds = new ArrayList<>();
    levelNarrations = new ArrayList<>();
    System.gc();//run garbage collection to remove old unloaded sound files from memory
  }

  //===============================BUILDER===============================
  
  /**Builder class used to create a new sound handler. Also used to be able to progrmaitaclly add global sounds to the sound handler
  */
  public static class Builder {
    /**Create a new sound hander builder
    @param a The surface to play the sounds on
    */
    private Builder(PApplet a) {
      window=a;
      musicPaths.add(new ArrayList<String>());
    }
    PApplet window;
    private ArrayList<ArrayList<String>> musicPaths=new ArrayList<>();
    private ArrayList<String> soundPaths=new ArrayList<>();
    private ArrayList<String> narrationPaths = new ArrayList<>();
    private int numMusicTracks=1;
    /**Add a music file to the builder
    @param path The path of the sound file
    @param track The track to put this song in
    @return this
    */
    public Builder addMusic(String path, int track) {
      if (track>=numMusicTracks||track<0)
        throw new RuntimeException("invalid music track number "+track);
      musicPaths.get(track).add(path);
      return this;
    }
    /**Add a sound file to the builder
    @param path The path of the sound file
    @return this
    */
    public Builder addSound(String path) {
      soundPaths.add(path);
      return this;
    }
    /**Add a narration file to the builder
    @param path The path of the sound file
    @param narrationIdCallBack An array of size 1 where the first element will be set the the numberical id of the registerd narration
    @return this
    */
    public Builder addNarration(String path,int[] narrationIdCallBack){
      if(narrationIdCallBack != null && narrationIdCallBack.length >0){
        narrationIdCallBack[0] = narrationPaths.size();
      }
      narrationPaths.add(path);
      return this;
    }
    /**Add a narration file to the builder
    @param path The path of the sound file
    @return this
    */
    public Builder addNarration(String path){
      return addNarration(path,null);
    }
    /**Add a new music track to the builfer
    @return this
    */
    public Builder addMusicTrack() {
      numMusicTracks++;
      musicPaths.add(new ArrayList<String>());
      return this;
    }
    /**Get the number of tracks in this builder
    */
    public int getNumTracks() {
      return numMusicTracks;
    }
    /**Build the sound handler from the provided information\
    @return The new sound hander object
    */
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
