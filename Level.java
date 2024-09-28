import java.io.Serializable;
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;
import java.util.HashMap;

class Level implements Serializable {
  static transient skiny_mann source;
  public ArrayList<Stage> stages=new ArrayList<>();
  public ArrayList<LogicBoard> logicBoards=new ArrayList<>();
  public ArrayList<Boolean> variables=new ArrayList<>();
  public ArrayList<Group> groups=new ArrayList<>();
  public ArrayList<String> groupNames=new ArrayList<>();
  public int mainStage, numOfCoins, levelID, numlogicBoards=0, loadBoard, tickBoard, levelCompleteBoard, multyplayerMode=1, maxPLayers=2, minPlayers=2;
  public String name, createdVersion, author;
  public float SpawnX, SpawnY, RewspawnX, RespawnY;
  public HashMap<String, StageSound> sounds=new HashMap<>();
  transient JSONObject hedObj;


  Level(JSONArray file) {
    System.out.println("loading level");
    JSONObject job =file.getJSONObject(0);
    hedObj=job;
    mainStage=job.getInt("mainStage");
    numOfCoins=job.getInt("coins");
    levelID=job.getInt("level_id");
    SpawnX=job.getFloat("spawnX");
    SpawnY=job.getFloat("spawnY");
    RewspawnX=job.getFloat("spawn pointX");
    RespawnY=job.getFloat("spawn pointY");
    name=job.getString("name");
    createdVersion=job.getString("game version");
    source.author=job.getString("author");
    author=job.getString("author");
    System.out.println("author: "+source.author);
    source.currentStageIndex=mainStage;
    if (job.isNull("number of variable")) {
      System.out.println("setting up variables because none exsisted before");
      variables.add(false);
      variables.add(false);
      variables.add(false);
      variables.add(false);
      variables.add(false);
    } else {
      for (int i=0; i<job.getInt("number of variable"); i++) {
        variables.add(false);
      }
      System.out.println("loaded "+variables.size()+" variables");
    }
    if (!job.isNull("groups")) {
      JSONArray gps= job.getJSONArray("groups");
      for (int i=0; i<gps.size(); i++) {
        groupNames.add(gps.getString(i));
        groups.add(new Group());
      }
      System.out.println("loaded "+groups.size()+" groups");
    } else {
      System.out.println("no groups found, creating default");
      groupNames.add("group 0");
      groups.add(new Group());
    }
    if (!job.isNull("multyplayer mode")) {
      multyplayerMode=job.getInt("multyplayer mode");
    }
    if (!job.isNull("max players")) {
      maxPLayers=job.getInt("max players");
    }
    if (!job.isNull("min players")) {
      minPlayers=job.getInt("min players");
    }
    for (int i=0; i<10; i++) {
      source.players[i].x=SpawnX;
      source.players[i].y=SpawnY;
    }
    source.respawnX=(int)RewspawnX;
    source.respawnY=(int)RespawnY;
    source.respawnStage=source.currentStageIndex;
    System.out.println("checking game version compatablility");
    if (!source.gameVersionCompatibilityCheck(createdVersion)) {
      System.out.println("game version not compatable with the verion of this level");
      throw new RuntimeException("this level is not compatable with this version of the game");
    }
    System.out.println("game version is compatable with this level");
    System.out.println("loading level components");
    for (int i=1; i<file.size(); i++) {
      job=file.getJSONObject(i);
      if (job.getString("type").equals("stage")||job.getString("type").equals("3Dstage")) {
        stages.add(new Stage(source.loadJSONArray(source.rootPath+job.getString("location"))));
        System.out.println("loaded stage: "+stages.get(stages.size()-1).name);
      }
      if (job.getString("type").equals("sound")) {
        sounds.put(job.getString("name"), new StageSound(job));
        System.out.println("loaded sound: "+job.getString("name"));
      }
      if (job.getString("type").equals("logicBoard")) {
        logicBoards.add(new LogicBoard(source.loadJSONArray(source.rootPath+job.getString("location")), this));
        numlogicBoards++;
        System.out.print("loaded logicboard: "+logicBoards.get(logicBoards.size()-1).name);
        if (logicBoards.get(logicBoards.size()-1).name.equals("load")) {
          loadBoard=logicBoards.size()-1;
          System.out.print(" board id set to: "+loadBoard);
        }
        if (logicBoards.get(logicBoards.size()-1).name.equals("tick")) {
          tickBoard=logicBoards.size()-1;
          System.out.print(" board id set to: "+tickBoard);
        }
        if (logicBoards.get(logicBoards.size()-1).name.equals("level complete")) {
          levelCompleteBoard=logicBoards.size()-1;
          System.out.print(" board id set to: "+levelCompleteBoard);
        }
      }
    }
    source.coins=new ArrayList<Boolean>();
    for (int i=0; i<numOfCoins; i++) {
      source.coins.add(false);
    }
    System.out.println("loaded "+source.coins.size()+" coins");

    if (numlogicBoards==0) {
      System.out.println("generating new logic boards as none exsisted");
      logicBoards.add(new LogicBoard("load"));
      logicBoards.add(new LogicBoard("tick"));
      logicBoards.add(new LogicBoard("level complete"));
      loadBoard=0;
      tickBoard=1;
      levelCompleteBoard=2;
    }
    System.out.println("level load complete");
  }//end of constructor

  void psudoLoad() {
    System.out.println("psudo loading level");
    source.coins=new ArrayList<Boolean>();
    for (int i=0; i<numOfCoins; i++) {
      source.coins.add(false);
    }
    groups=new ArrayList<>();
    variables=new ArrayList<>();
    if (hedObj.isNull("number of variable")) {
      System.out.println("setting up variables because none exsisted before");
      variables.add(false);
      variables.add(false);
      variables.add(false);
      variables.add(false);
      variables.add(false);
    } else {
      for (int i=0; i<hedObj.getInt("number of variable"); i++) {
        variables.add(false);
      }
      System.out.println("loaded "+variables.size()+" variables");
    }
    if (!hedObj.isNull("groups")) {
      JSONArray gps= hedObj.getJSONArray("groups");
      for (int i=0; i<gps.size(); i++) {
        groupNames.add(gps.getString(i));
        groups.add(new Group());
      }
      System.out.println("loaded "+groups.size()+" groups");
    } else {
      System.out.println("no groups found, creating default");
      groupNames.add("group 0");
      groups.add(new Group());
    }
    source.currentStageIndex=mainStage;
    source.players[source.currentPlayer].x=SpawnX;
    source.players[source.currentPlayer].y=SpawnY;

    source.tpCords[0]=SpawnX;
    source.tpCords[1]=SpawnY;
    source.setPlayerPosTo=true;

    source.respawnX=(int)RewspawnX;
    source.respawnY=(int)RespawnY;
    source.respawnStage=source.currentStageIndex;
    logicBoards.get(loadBoard).superTick();
    respawnEntities();
  }

  void reloadCoins() {
    source.coins=new ArrayList<Boolean>();
    for (int i=0; i<numOfCoins; i++) {
      source.coins.add(false);
    }
  }

  void save() {
    JSONArray index=new JSONArray();
    JSONObject head = new JSONObject();
    head.setInt("mainStage", mainStage);
    head.setInt("coins", numOfCoins);
    head.setInt("level_id", levelID);
    head.setFloat("spawnX", SpawnX);
    head.setFloat("spawnY", SpawnY);
    head.setFloat("spawn pointX", RewspawnX);
    head.setFloat("spawn pointY", RespawnY);
    head.setString("name", name);
    head.setString("game version", createdVersion);//when integrating the level creator make shure this line is changed to reflect the correct version
    head.setString("author", author);
    head.setInt("number of variable", variables.size());
    head.setInt("multyplayer mode", multyplayerMode);
    head.setInt("max players", maxPLayers);
    head.setInt("min players", minPlayers);
    JSONArray grps=new JSONArray();
    for (int i=0; i<groupNames.size(); i++) {
      grps.setString(i, groupNames.get(i));
    }
    head.setJSONArray("groups", grps);
    index.setJSONObject(0, head);
    for (int i=1; i<stages.size()+1; i++) {
      JSONObject stg=new JSONObject();
      stg.setString("name", stages.get(i-1).name);
      stg.setString("type", stages.get(i-1).type);
      stg.setString("location", stages.get(i-1).save());
      index.setJSONObject(i, stg);
    }
    String[] keys=new String[0];
    keys=(String[])sounds.keySet().toArray(keys);
    if (keys.length!=0) {
      for (int i=0; i<keys.length; i++) {
        index.setJSONObject(index.size(), sounds.get(keys[i]).save());
      }
    }
    for (int i=0; i<logicBoards.size(); i++) {
      JSONObject board=new JSONObject();
      board.setString("name", logicBoards.get(i).name);
      board.setString("type", "logicBoard");
      board.setString("location", logicBoards.get(i).save());
      index.setJSONObject(index.size(), board);
    }
    source.saveJSONArray(index, source.rootPath+"/index.json");
  }

  String getHash() {
    String basePath="";
    if (source.rootPath.startsWith("data")) {
      basePath=source.sketchPath()+"/"+source.rootPath;
    } else {
      basePath=source.rootPath;
    }
    String hash="";
    hash+=Hasher.getFileHash(basePath+"/index.json");

    JSONArray file = source.loadJSONArray(basePath+"/index.json");
    JSONObject job;
    for (int i=1; i<file.size(); i++) {
      job=file.getJSONObject(i);
      if (job.getString("type").equals("stage")||job.getString("type").equals("3Dstage")) {
        hash+=Hasher.getFileHash(basePath+job.getString("location"));
        continue;
      }
      if (job.getString("type").equals("sound")) {
        hash+=Hasher.getFileHash(basePath+job.getString("location"));
        continue;
      }
      if (job.getString("type").equals("logicBoard")) {
        hash+=Hasher.getFileHash(basePath+job.getString("location"));
      }
    }
    return hash;
  }

  String[] getOutherFileNames() {

    String[] keys=new String[0];
    keys=(String[])sounds.keySet().toArray(keys);
    String[] names=new String[keys.length];
    if (keys.length!=0) {
      for (int i=0; i<keys.length; i++) {
        names[i]=sounds.get(keys[i]).path;
      }
    }
    return names;
  }
  
  void respawnEntities(){
    for(Stage s : stages){
      s.respawnEntities();
    }
  }
}
