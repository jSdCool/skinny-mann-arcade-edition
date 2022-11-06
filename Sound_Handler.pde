//version 1.0.0
class SoundHandler {
  SoundFile[] music, queue, sounds;
  SoundFile cSound1=null, cSound2=null, cSound3=null, cSound4=null;
  PApplet ggn;
  int musNum=0;
  float masterVolume=1, musicVolume=1, sfxVolume=1, prevVol=1;


  SoundHandler(String[] musicFiles, String[] soundsFiles, PApplet X) {
    music=new SoundFile[musicFiles.length];
    queue = new SoundFile[8];
    sounds=new SoundFile[soundsFiles.length];
    for (int i =0; i<soundsFiles.length; i++) {
      sounds[i]=new SoundFile(X, soundsFiles[i]);
    }
    ggn=X;

    for (int i =0; i<musicFiles.length; i++) {
      music[i]=new SoundFile(X, musicFiles[i]);
    }
  }

  void tick() {
    if (prevVol!=musicVolume) {
      music[musNum].amp(masterVolume*musicVolume);
      prevVol=musicVolume;
    }

    if (!music[musNum].isPlaying()) {
      musNum++;
      if (musNum==music.length)
        musNum=0;
      music[musNum].play(1, masterVolume*musicVolume  );
    }
    //println(" 0: "+queue[0]+" 1: "+queue[1]+" 2: "+queue[2]+" 3: "+queue[3]+" 4: "+queue[4]+" 5: "+queue[5]+" 6: "+queue[6]+" 7: "+queue[7]);
    playSound(cSound1);
    playSound(cSound2);
    playSound(cSound3);
    //playSound(c1);
  }

  void addToQueue(int soundNum) {
    if (queue[0]==null) {
      queue[0]=sounds[soundNum];
      return;
    }
    if (queue[1]==null) {
      queue[1]=sounds[soundNum];
      return;
    }
    if (queue[2]==null) {
      queue[2]=sounds[soundNum];
      return;
    }
    if (queue[3]==null) {
      queue[3]=sounds[soundNum];
      return;
    }
    if (queue[4]==null) {
      queue[4]=sounds[soundNum];
      return;
    }
    if (queue[5]==null) {
      queue[5]=sounds[soundNum];
      return;
    }
    if (queue[6]==null) {
      queue[6]=sounds[soundNum];
      return;
    }
    if (queue[7]==null) {
      queue[7]=sounds[soundNum];
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

  private void playSound(SoundFile R) {
    if (moveUp(R)) {

      R=queue[0];
      if (R!=null)
        R.play(1, masterVolume*sfxVolume);

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
}
