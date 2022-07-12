class Level { //<>// //<>//
  ArrayList<Stage> stages=new ArrayList<>();
  ArrayList<LogicBoard> logicBoards=new ArrayList<>();
  ArrayList<Boolean> variables=new ArrayList<>();
  ArrayList<Group> groups=new ArrayList<>();
  ArrayList<String> groupNames=new ArrayList<>();
  public int mainStage, numOfCoins, levelID, numlogicBoards=0, loadBoard, tickBoard, levelCompleteBoard;
  public String name, createdVersion;
  public float SpawnX, SpawnY, RewspawnX, RespawnY;
  public HashMap<String, StageSound> sounds=new HashMap<>();

  Level(JSONArray file) {
    println("loading level");
    JSONObject job =file.getJSONObject(0);
    mainStage=job.getInt("mainStage");
    numOfCoins=job.getInt("coins");
    levelID=job.getInt("level_id");
    SpawnX=job.getFloat("spawnX");
    SpawnY=job.getFloat("spawnY");
    RewspawnX=job.getFloat("spawn pointX");
    RespawnY=job.getFloat("spawn pointY");
    name=job.getString("name");
    createdVersion=job.getString("game version");
    author=job.getString("author");
    currentStageIndex=mainStage;
    if (job.isNull("number of variable")) {
      println("setting up variables because none exsisted before");
      variables.add(false);
      variables.add(false);
      variables.add(false);
      variables.add(false);
      variables.add(false);
    } else {
      for (int i=0; i<job.getInt("number of variable"); i++) {
        variables.add(false);
      }
      println("loaded "+variables.size()+" variables");
    }
    if (!job.isNull("groups")) {
      JSONArray gps= job.getJSONArray("groups");
      for (int i=0; i<gps.size(); i++) {
        groupNames.add(gps.getString(i));
        groups.add(new Group());
      }
      println("loaded "+groups.size()+" groups");
    } else {
      println("no groups found, creating default");
      groupNames.add("group 0");
      groups.add(new Group());
    }
    player1.x=SpawnX;
    player1.y=SpawnY;
    respawnX=(int)RewspawnX;
    respawnY=(int)RespawnY;
    respawnStage=currentStageIndex;
    println("checking game version compatablility");
    if (!gameVersionCompatibilityCheck(createdVersion)) {
      println("game version not compatable with the verion of this level");
      throw new RuntimeException("this level is not compatable with this version of the game");
    }
    println("game version is compatable with this level");
    println("loading level components");
    for (int i=1; i<file.size(); i++) {
      job=file.getJSONObject(i);
      if (job.getString("type").equals("stage")||job.getString("type").equals("3Dstage")) {
        stages.add(new Stage(loadJSONArray(rootPath+job.getString("location"))));
        println("loaded stage: "+stages.get(stages.size()-1).name);
      }
      if (job.getString("type").equals("sound")) {
        sounds.put(job.getString("name"), new StageSound(job));
        println("loaded sound: "+job.getString("name"));
      }
      if (job.getString("type").equals("logicBoard")) {
        logicBoards.add(new LogicBoard(loadJSONArray(rootPath+job.getString("location")), this));
        numlogicBoards++;
        print("loaded logicboard: "+logicBoards.get(logicBoards.size()-1).name);
        if (logicBoards.get(logicBoards.size()-1).name.equals("load")) {
          loadBoard=logicBoards.size()-1;
          print(" board id set to: "+loadBoard);
        }
        if (logicBoards.get(logicBoards.size()-1).name.equals("tick")) {
          tickBoard=logicBoards.size()-1;
          print(" board id set to: "+tickBoard);
        }
        if (logicBoards.get(logicBoards.size()-1).name.equals("level complete")) {
          levelCompleteBoard=logicBoards.size()-1;
          print(" board id set to: "+levelCompleteBoard);
        }
        println("");
      }
    }
    coins=new ArrayList<Boolean>();
    for (int i=0; i<numOfCoins; i++) {
      coins.add(false);
    }
    println("loaded "+coins.size()+" coins");

    if (numlogicBoards==0) {
      println("generating new logic boards as none exsisted");
      logicBoards.add(new LogicBoard("load"));
      logicBoards.add(new LogicBoard("tick"));
      logicBoards.add(new LogicBoard("level complete"));
      loadBoard=0;
      tickBoard=1;
      levelCompleteBoard=2;
    }
    println("level load complete");
  }

  void reloadCoins() {
    coins=new ArrayList<Boolean>();
    for (int i=0; i<numOfCoins; i++) {
      coins.add(false);
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
    head.setString("game version", GAME_version);
    head.setString("author", author);
    head.setInt("number of variable", variables.size());
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
    if (keys.length!=0)
      for (int i=0; i<keys.length; i++) {
        index.setJSONObject(index.size(), sounds.get(keys[i]).save());
      }
    for (int i=0; i<logicBoards.size(); i++) {
      JSONObject board=new JSONObject();
      board.setString("name", logicBoards.get(i).name);
      board.setString("type", "logicBoard");
      board.setString("location", logicBoards.get(i).save());
      index.setJSONObject(index.size(), board);
    }
    saveJSONArray(index, rootPath+"/index.json");
  }
}

class Group {
  boolean visable=true;
  float xOffset=0, yOffset=0, zOffset=0;
}

class Stage {
  public ArrayList<StageComponent> parts = new ArrayList<>();
  public boolean is3D=false;
  public String type, name;
  public int stageID, skyColor=#74ABFF;
  Stage(JSONArray file) {//single varible instance for a stage
    load(file);
  }
  Stage(String Name, String Type) {
    name=Name;
    type=Type;
    is3D=type.equals("3Dstage")||type.equals("3D blueprint");
  }


  void load(JSONArray file) {
    type=file.getJSONObject(0).getString("type");
    name=file.getJSONObject(0).getString("name");
    try {
      skyColor=file.getJSONObject(0).getInt("sky color");
    }
    catch(Throwable e) {
    }

    if (type.equals("stage")||type.equals("3Dstage")||type.equals("blueprint")||type.equals("3D blueprint")) {
      is3D=type.equals("3Dstage");
      for (int i=1; i<file.size(); i++) {
        try {
          JSONObject ob=file.getJSONObject(i);
          String otype=ob.getString("type");
          if (otype.equals("ground")) {
            parts.add(new Ground(ob, is3D));
          }
          if (otype.equals("holo")) {
            parts.add(new Holo(ob, is3D));
          }
          if (otype.equals("dethPlane")) {
            parts.add(new DethPlane(ob, is3D));
          }
          if (otype.equals("check point")) {
            parts.add(new CheckPoint(ob, is3D));
          }
          if (otype.equals("goal")) {
            parts.add(new Goal(ob, is3D));
          }
          if (otype.equals("coin")) {
            parts.add(new Coin(ob, is3D));
          }
          if (otype.equals("interdimentional Portal")) {
            parts.add(new Interdimentional_Portal(ob, is3D));
          }
          if (otype.equals("sloap")) {
            parts.add(new Sloap(ob, is3D));
          }
          if (otype.equals("holoTriangle")) {
            parts.add(new HoloTriangle(ob, is3D));
          }
          if (otype.equals("3DonSW")) {
            parts.add(new SWon3D(ob, is3D));
          }
          if (otype.equals("3DoffSW")) {
            parts.add(new SWoff3D(ob, is3D));
          }
          if (otype.equals("WritableSign")) {
            parts.add(new WritableSign(ob, is3D));
          }
          if (otype.equals("sound box")) {
            parts.add(new SoundBox(ob, is3D));
          }
          if (otype.equals("logic button")) {
            parts.add(new LogicButton(ob, is3D));
          }
        }
        catch(Throwable e) {
        }
      }
    }
  }

  String save() {
    JSONArray staeg = new JSONArray();
    JSONObject head=new JSONObject();
    head.setString("name", name);
    head.setString("type", type);
    head.setInt("sky color", skyColor);
    staeg.setJSONObject(0, head);
    for (int i=0; i<parts.size(); i++) {
      staeg.setJSONObject(i+1, parts.get(i).save(is3D));
    }
    saveJSONArray(staeg, rootPath+"/"+name+".json");
    return "/"+name+".json";
  }
}


abstract class StageComponent {//the base class for all components that exsist inside a stage
  public float x, y, z, dx, dy, dz;
  public int ccolor, group=-1;
  public String type;
  void draw() {
  };
  void draw3D() {
  };
  boolean colide(float x, float y, boolean c) {
    return false;
  };//c= is colideing with click box
  boolean colide(float x, float y, float z, boolean c) {
    return false;
  };
  boolean colideDethPlane(float x, float Y) {
    return false;
  };
  abstract JSONObject save(boolean stage_3D);

  void setData(String data) {
  }
  void setData(int data) {
  }

  String getData() {
    return null;
  }
  int getDataI() {
    return -1;
  }
  abstract StageComponent copy();
  Group getGroup() {
    if (group==-1)
      return new Group();
    return level.groups.get(group);
  }
  void setGroup(int grp) {
    group=grp;
  }
}

class Ground extends StageComponent {//ground component
  Ground(JSONObject data, boolean stage_3D) {
    type="ground";
    x=data.getFloat("x");
    y=data.getFloat("y");
    dx=data.getFloat("dx");
    dy=data.getFloat("dy");
    ccolor=data.getInt("color");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Ground(float X, float Y, float DX, float DY, int fcolor) {
    type="ground";
    x=X;
    y=Y;
    dx=DX;
    dy=DY;
    ccolor=fcolor;
  }
  Ground(float X, float Y, float Z, float DX, float DY, float DZ, int fcolor) {
    type="ground";
    x=X;
    y=Y;
    z=Z;
    dx=DX;
    dy=DY;
    dz=DZ;
    ccolor=fcolor;
  }
  StageComponent copy() {
    return new Ground(x, y, z, dx, dy, dz, ccolor);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setFloat("dx", dx);
    part.setFloat("dy", dy);
    if (stage_3D) {
      part.setFloat("z", z);
      part.setFloat("dz", dz);
    }
    part.setInt("color", ccolor);
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    rect(Scale*((x+group.xOffset)-drawCamPosX)-1, Scale*((y+group.yOffset)+drawCamPosY)-1, Scale*dx+2, Scale*dy+2);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    //strokeWeight(0);
    translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, (z+group.zOffset)+dz/2);
    box(dx, dy, dz);
    translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*((z+group.zOffset)+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy, z2=(this.z+group.zOffset)+dz;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2 && z>=(this.z+group.zOffset) && z<=z2/* terain hit box*/) {
      return true;
    }
    return false;
  }
}

class Holo extends StageComponent {//ground component
  Holo(JSONObject data, boolean stage_3D) {
    type="holo";
    x=data.getFloat("x");
    y=data.getFloat("y");
    dx=data.getFloat("dx");
    dy=data.getFloat("dy");
    ccolor=data.getInt("color");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Holo(float X, float Y, float DX, float DY, int fcolor) {
    type="holo";
    x=X;
    y=Y;
    dx=DX;
    dy=DY;
    ccolor=fcolor;
  }
  Holo(float X, float Y, float Z, float DX, float DY, float DZ, int fcolor) {
    type="holo";
    x=X;
    y=Y;
    z=Z;
    dx=DX;
    dy=DY;
    dz=DZ;
    ccolor=fcolor;
  }
  StageComponent copy() {
    return new Holo(x, y, z, dx, dy, dz, ccolor);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setFloat("dx", dx);
    part.setFloat("dy", dy);
    if (stage_3D) {
      part.setFloat("z", z);
      part.setFloat("dz", dz);
    }
    part.setInt("color", ccolor);
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    rect(Scale*((x+group.xOffset)-drawCamPosX)-1, Scale*((y+group.yOffset)+drawCamPosY)-1, Scale*dx+2, Scale*dy+2);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    //strokeWeight(0);
    translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, (z+group.zOffset)+dz/2);
    box(dx, dy, dz);
    translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*((z+group.zOffset)+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
      if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy, z2=(this.z+group.zOffset)+dz;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2 && z>=(this.z+group.zOffset) && z<=z2/* terain hit box*/) {
      return true;
    }
    return false;
  }
}

class DethPlane extends StageComponent {//ground component
  DethPlane(JSONObject data, boolean stage_3D) {
    type="dethPlane";
    x=data.getFloat("x");
    y=data.getFloat("y");
    dx=data.getFloat("dx");
    dy=data.getFloat("dy");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  DethPlane(float X, float Y, float DX, float DY) {
    type="dethPlane";
    x=X;
    y=Y;
    dx=DX;
    dy=DY;
  }
  StageComponent copy() {
    return new DethPlane(x, y, dx, dy);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setFloat("dx", dx);
    part.setFloat("dy", dy);
    if (stage_3D) {
      part.setFloat("z", z);
      part.setFloat("dz", dz);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(-114431);
    rect(Scale*((x+group.xOffset)-drawCamPosX)-1, Scale*((y+group.yOffset)+drawCamPosY)-1, Scale*dx+2, Scale*dy+2);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(-114431);
    strokeWeight(0);
    translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, (z+group.zOffset)+dz/2);
    box(dx, dy, dz);
    translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*((z+group.zOffset)+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = (this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }

  boolean colideDethPlane(float x, float y) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 =(this.x+group.xOffset)+dx, y2=(this.y+group.yOffset)+dy;
    if (x >= (this.x+group.xOffset) && x <= x2 && y >= (this.y+group.yOffset) && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }
}


class CheckPoint extends StageComponent {//ground component
  CheckPoint(JSONObject data, boolean stage_3D) {
    type="check point";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  CheckPoint(float X, float Y) {
    type="check point";
    x=X;
    y=Y;
  }
  CheckPoint(float X, float Y, float Z) {
    type="check point";
    x=X;
    y=Y;
    z=Z;
  }
  StageComponent copy() {
    return new CheckPoint(x, y, z);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=player1.getX();
    boolean po=false;
    if (playx>=(x+group.xOffset)-5 && playx<= (x+group.xOffset)+5 && (y+group.yOffset)-50 <= player1.getY() && (y+group.yOffset)>=player1.getY()-10) {
      respawnX=(int)x;
      respawnY=(int)y;
      respawnStage=currentStageIndex;
      po=true;
      checkpointIn3DStage=false;
    }

    float x2=(x+group.xOffset)-drawCamPosX;
    float y2=(y+group.yOffset)+drawCamPosY;
    if (po)
      fill(#E5C402);
    else
      fill(#B9B9B9);
    rect((x2-3)*Scale, (y2-60)*Scale, 5*Scale, 60*Scale);
    fill(#EA0202);
    triangle(x2*Scale, (y2-60)*Scale, x2*Scale, (y2-40)*Scale, (x2+30)*Scale, (y2-50)*Scale);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    //noStroke();
    float playx=player1.getX();
    boolean po=false;
    if (playx>=(x+group.xOffset)-20 && playx<= (x+group.xOffset)+20 && (y+group.yOffset)-50 <= player1.getY() && (y+group.yOffset)>=player1.getY()-10 && player1.z >= (z+group.zOffset)-20 && player1.z <= (z+group.zOffset)+20) {
      respawnX=(int)x;
      respawnY=(int)y;
      respawnZ=(int)player1.z;
      respawnStage=stageIndex;
      checkpointIn3DStage=true;
      po=true;
    }


    if (po)
      fill(#E5C402);
    else
      fill(#B9B9B9);
    //strokeWeight(0);
    translate((x+group.xOffset), (y+group.yOffset)-30, (z+group.zOffset));
    box(4, 60, 4);
    translate(-(x+group.xOffset), -((y+group.yOffset)-30), -(z+group.zOffset));
    fill(#EA0202);
    //stroke(#EA0202);
    //strokeWeight(0);
    translate((x+group.xOffset)+10, (y+group.yOffset)-50, (z+group.zOffset));
    box(20, 20, 2);
    translate(-((x+group.xOffset)+10), -((y+group.yOffset)-50), -(z+group.zOffset));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x>=(this.x+group.xOffset)-8 && x<= (this.x+group.xOffset)+8 && y >= (this.y+group.yOffset)-50 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x>=(this.x+group.xOffset)-8 && x<= (this.x+group.xOffset)+8 && y >= (this.y+group.yOffset)-50 && y <= (this.y+group.yOffset) && z>=(this.z+group.zOffset)-8 && z<= (this.z+group.zOffset)+8 ) {
        return true;
      }
    }
    return false;
  }
}


class Goal extends StageComponent {//ground component
  Goal(JSONObject data, boolean stage_3D) {
    type="goal";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Goal(float X, float Y) {
    type="goal";
    x=X;
    y=Y;
  }

  StageComponent copy() {
    return new Goal(x, y);
  }
  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float x2 = (x+group.xOffset)-drawCamPosX, y2 = (y+group.yOffset);
    fill(255);
    rect(Scale*x2, Scale*(y2+drawCamPosY), Scale*50, Scale*50);
    rect(Scale*(x2+100), Scale*(y2+drawCamPosY), Scale*50, Scale*50);
    rect(Scale*(x2+200), Scale*(y2+drawCamPosY), Scale*50, Scale*50);
    fill(0);
    rect(Scale*(x2+50), Scale*(y2+drawCamPosY), Scale*50, Scale*50);
    rect(Scale*(x2+150), Scale*(y2+drawCamPosY), Scale*50, Scale*50);

    float px =player1.getX(), py=player1.getY();

    if (px >= x2+drawCamPosX && px <= x2+drawCamPosX + 250 && py >= y2 - 50 && py <= y2 + 50) {
      if (!level_complete) {
        level.logicBoards.get(level.levelCompleteBoard).superTick();
      }
      level_complete=true;
    }
  }

  void draw3D() {
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= (this.x+group.xOffset) && x <= ((this.x+group.xOffset)) + 250 && y >= ((this.y+group.yOffset)) - 50 && y <= ((this.y+group.yOffset)) + 50) {
        return true;
      }
    }
    return false;
  }
}

class Coin extends StageComponent {//ground component
  int coinId;
  Coin(JSONObject data, boolean stage_3D) {
    type="coin";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    coinId=data.getInt("coin id");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  Coin(float X, float Y, int ind) {
    x=X;
    y=Y;
    coinId=ind;
    type="coin";
  }
  Coin(float X, float Y, float Z, int ind) {
    x=X;
    y=Y;
    coinId=ind;
    type="coin";
    z=Z;
  }
  StageComponent copy() {
    return new Coin(x, y, z, coinId);
  }
  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("coin id", coinId);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=player1.getX(), playy=player1.getY();
    boolean collected;
    if (editingBlueprint) {
      collected=false;
    } else {
      if (coins.size()==0)
        collected=false;
      else
        collected=coins.get(coinId);
    }
    float x2=(x+group.xOffset)-drawCamPosX;
    if (!collected) {
      drawCoin(Scale*x2, Scale*((y+group.yOffset)+drawCamPosY), Scale*3);
      if (Math.sqrt(Math.pow(playx-drawCamPosX-x2, 2)+Math.pow(playy-(y+group.yOffset), 2))<30) {
        coins.set(coinId, true);
        coinCount++;
      }
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=player1.getX(), playy=player1.getY(), playz=player1.z;
    boolean collected=coins.get(coinId);

    if (!collected) {
      translate((x+group.xOffset), (y+group.yOffset), (z+group.zOffset));
      rotateY(radians(coinRotation));
      shape(coin3D);
      rotateY(radians(-coinRotation));
      translate(-(x+group.xOffset), -(y+group.yOffset), -(z+group.zOffset));
      if (Math.sqrt(Math.pow(playx-(x+group.xOffset), 2)+Math.pow(playy-(y+group.yOffset), 2)+Math.pow(playz-(z+group.zOffset), 2))<35) {
        coins.set(coinId, true);
        coinCount++;
      }
    }
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (Math.sqrt(Math.pow(x-(this.x+group.xOffset), 2)+Math.pow(y-(this.y+group.yOffset), 2))<19) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (Math.sqrt(Math.pow(x-(this.x+group.xOffset), 2)+Math.pow(y-(this.y+group.yOffset), 2)+Math.pow(z-(this.z+group.zOffset), 2))<19) {
        return true;
      }
    }
    return false;
  }
}

class Interdimentional_Portal extends StageComponent {//ground component
  float linkX, linkY, linkZ;
  int linkIndex;
  Interdimentional_Portal(JSONObject data, boolean stage_3D) {
    type="interdimentional Portal";
    x=data.getFloat("x");
    y=data.getFloat("y");
    linkX=data.getFloat("linkX");
    linkY=data.getFloat("linkY");
    linkIndex=data.getInt("link Index")-1;
    if (!data.isNull("z")) {
      z=data.getFloat("z");
    }
    if (!data.isNull("linkZ")) {
      linkZ=data.getFloat("linkZ");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  StageComponent copy() {
    return null;
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
      part.setFloat("linkZ", linkZ);
    }
    part.setString("type", type);
    part.setFloat("linkX", linkX);
    part.setFloat("linkY", linkY);
    part.setInt("link Index", linkIndex+1);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=player1.getX(), playy=player1.getY();
    drawPortal(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*1);
    if ((playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60)) {
      fill(255);
      textSize(Scale*20);
      displayText="Press E";
      displayTextUntill=millis()+100;
    }

    if (E_pressed&&(playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60)) {
      E_pressed=false;
      selectedIndex=-1;
      stageIndex=linkIndex;
      currentStageIndex=linkIndex;

      background(0);
      if (linkZ!=-1) {
        setPlayerPosZ=(int)linkZ;
        player1.z=linkZ;
        tpCords[2]=linkZ;
      }
      player1.setX(linkX).setY(linkY);
      setPlayerPosTo=true;
      tpCords[0]=(int)linkX;
      tpCords[1]=(int)linkY;
      gmillis=millis()+850;
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    float playx=player1.getX(), playy=player1.getY();

    translate(0, 0, z);
    drawPortal((x+group.xOffset), (y+group.yOffset), 1);
    translate(0, 0, -z);
    if ((playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60&& player1.z >= z-20 && player1.z <= z+20)) {
      fill(255);
      textSize(20);
      displayText="Press E";
      displayTextUntill=millis()+100;
    }

    if (E_pressed&&(playx>(x+group.xOffset)-25&&playx<(x+group.xOffset)+25&&playy>(y+group.yOffset)-50&&playy<(y+group.yOffset)+60)) {
      E_pressed=false;
      selectedIndex=-1;
      stageIndex=linkIndex;
      currentStageIndex=linkIndex;

      background(0);
      if (linkZ!=-1) {
        setPlayerPosZ=(int)linkZ;
        player1.z=linkZ;
        tpCords[2]=linkZ;
      }
      player1.setX(linkX).setY(linkY);
      setPlayerPosTo=true;
      tpCords[0]=(int)linkX;
      tpCords[1]=(int)linkY;
      gmillis=millis()+850;
    }
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x>(this.x+group.xOffset)-25&&x<(this.x+group.xOffset)+25&&y>(this.y+group.yOffset)-50&&y<(this.y+group.yOffset)+60) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x > (this.x+group.xOffset)-25 && x < (this.x+group.xOffset)+25 && y >(this.y+group.yOffset)-50 && y < (this.y+group.yOffset)+60 && z > (this.z+group.zOffset)-2 && z < (this.z+group.zOffset)+2) {
        return true;
      }
    }
    return false;
  }
}


class Sloap extends StageComponent {//ground component
  int direction;
  Sloap(JSONObject data, boolean stage_3D) {
    type="sloap";
    x=data.getFloat("x1");
    y=data.getFloat("y1");
    dx=data.getFloat("x2");
    dy=data.getFloat("y2");
    ccolor=data.getInt("color");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    direction=data.getInt("rotation");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  Sloap(float x1, float y1, float x2, float y2, int rot, int fcolor) {
    type="sloap";
    x=x1;
    y=y1;
    dx=x2;
    dy=y2;
    direction=rot;
    ccolor=fcolor;
  }
  StageComponent copy() {
    return new Sloap(x, y, dx, dy, direction, ccolor);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x1", x);
    part.setFloat("y1", y);
    part.setFloat("x2", dx);
    part.setFloat("y2", dy);
    part.setInt("color", ccolor);
    part.setString("type", type);
    part.setInt("rotation", direction);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    if (direction==0) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY));
    }
    if (direction==1) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*((x+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY));
    }
    if (direction==2) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((x+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY));
    }
    if (direction==3) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY));
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    strokeWeight(0);
    translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    float x2 = dx+group.xOffset, y2=dy+group.yOffset, y1=(this.y+group.yOffset), x1=(this.x+group.xOffset), rot=direction;
    if (rot==0) {
      if (x<=x2&&y>=y1&&y<=x*((y2-y1)/(x2-x1)) + (y2-(x2*((y2-y1)/(x2-x1))))  ) {
        return true;
      }
      //triangle(X1,Y1,X2,Y2,X2,Y1);
    }
    if (rot==1) {
      if (x>=x1&&y>=y1&&y<=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ) {
        return true;
      }
      //triangle(X1,Y1,X1,Y2,X2,Y1);
    }
    if (rot==2) {
      if (x>=x1&&y<=y2&&y>=x*((y2-y1)/(x2-x1)) + ( y2-(x2*((y2-y1)/(x2-x1))))  ) {
        return true;
      }
      //triangle(X1,Y1,X2,Y2,X1,Y2);
    }
    if (rot==3) {
      if (x<=x2&&y<=y2&&y>=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ) {
        return true;
      }
      //triangle(X1,Y2,X2,Y2,X2,Y1);
    }
    return false;
  }
}

class HoloTriangle extends StageComponent {//ground component
  int direction;
  HoloTriangle(JSONObject data, boolean stage_3D) {
    type="holoTriangle";
    x=data.getFloat("x1");
    y=data.getFloat("y1");
    dx=data.getFloat("x2");
    dy=data.getFloat("y2");
    ccolor=data.getInt("color");
    if (stage_3D) {
      z=data.getFloat("z");
      dz=data.getFloat("dz");
    }
    direction=data.getInt("rotation");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  HoloTriangle(float x1, float y1, float x2, float y2, int rot, int fcolor) {
    type="holoTriangle";
    x=x1;
    y=y1;
    dx=x2;
    dy=y2;
    direction=rot;
    ccolor=fcolor;
  }
  StageComponent copy() {
    return new HoloTriangle(x, y, dx, dy, direction, ccolor);
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x1", x);
    part.setFloat("y1", y);
    part.setFloat("x2", dx);
    part.setFloat("y2", dy);
    part.setInt("color", ccolor);
    part.setString("type", type);
    part.setInt("rotation", direction);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    if (direction==0) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY));
    }
    if (direction==1) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*((x+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY));
    }
    if (direction==2) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((x+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY));
    }
    if (direction==3) {
      triangle(Scale*((x+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((dy+group.yOffset)+drawCamPosY), Scale*((dx+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY));
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    fill(ccolor);
    strokeWeight(0);
    translate((x+group.xOffset)+dx/2, (y+group.yOffset)+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*((x+group.xOffset)+dx/2), -1*((y+group.yOffset)+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      float x2 = dx+group.xOffset, y2=dy+group.yOffset, y1=(this.y+group.yOffset), x1=(this.x+group.xOffset), rot=direction;
      if (rot==0) {
        if (x<=x2&&y>=y1&&y<=x*((y2-y1)/(x2-x1)) + (y2-(x2*((y2-y1)/(x2-x1))))  ) {
          return true;
        }
        //triangle(X1,Y1,X2,Y2,X2,Y1);
      }
      if (rot==1) {
        if (x>=x1&&y>=y1&&y<=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ) {
          return true;
        }
        //triangle(X1,Y1,X1,Y2,X2,Y1);
      }
      if (rot==2) {
        if (x>=x1&&y<=y2&&y>=x*((y2-y1)/(x2-x1)) + ( y2-(x2*((y2-y1)/(x2-x1))))  ) {
          return true;
        }
        //triangle(X1,Y1,X2,Y2,X1,Y2);
      }
      if (rot==3) {
        if (x<=x2&&y<=y2&&y>=x*((y2-y1)/(x1-x2)) + ( y1-(x2*((y2-y1)/(x1-x2))))  ) {
          return true;
        }
        //triangle(X1,Y2,X2,Y2,X2,Y1);
      }
    }
    return false;
  }
}

class SWon3D extends StageComponent {//ground component
  SWon3D(JSONObject data, boolean stage_3D) {
    type="3DonSW";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  SWon3D(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    type="3DonSW";
  }
  StageComponent copy() {
    return new SWon3D(x, y, z);
  }
  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    draw3DSwitch1(((x+group.xOffset)-drawCamPosX)*Scale, ((y+group.yOffset)+drawCamPosY)*Scale, Scale);
    if (player1.x>=(x+group.xOffset)-10&&player1.x<=(x+group.xOffset)+10&&player1.y >=(y+group.yOffset)-10&&player1.y<= (y+group.yOffset)+2) {
      player1.z=z;
      e3DMode=true;
      gmillis=millis()+1200;
    }
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    draw3DSwitch1((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), Scale);
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset) && z >= ((this.z+group.zOffset)) - 10 && z <= (this.z+group.zOffset)) {
        return true;
      }
    }
    return false;
  }
}

class SWoff3D extends StageComponent {//ground component
  SWoff3D(JSONObject data, boolean stage_3D) {
    type="3DoffSW";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  SWoff3D(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    type="3DoffSW";
  }
  StageComponent copy() {
    return new SWoff3D(x, y, z);
  }
  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("group", group);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    draw3DSwitch2(((x+group.xOffset)-drawCamPosX)*Scale, ((y+group.yOffset)+drawCamPosY)*Scale, Scale);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    draw3DSwitch2((x+group.xOffset), y, (z+group.zOffset), Scale);
    if (player1.x>=(x+group.xOffset)-10&&player1.x<=(x+group.xOffset)+10&&player1.y >=(y+group.yOffset)-10&&player1.y<= (y+group.yOffset)+2 && player1.z >= (z+group.zOffset)-10 && player1.z <= (z+group.zOffset)+10) {
      e3DMode=false;
      WPressed=false;
      SPressed=false;
      gmillis=millis()+1200;
    }
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset) && z >= ((this.z+group.zOffset)) - 10 && z <= (this.z+group.zOffset)) {
        return true;
      }
    }
    return false;
  }
}

class WritableSign extends StageComponent {
  String contents;
  WritableSign(JSONObject data, boolean stage_3D) {
    type="WritableSign";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    contents=data.getString("contents");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }
  WritableSign(float X, float Y) {
    x=X;
    y=Y;
    contents="";
    type="WritableSign";
  }
  WritableSign(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    contents="";
    type="WritableSign";
  }
  StageComponent copy() {
    WritableSign e=new WritableSign(x, y, z);
    e.contents=contents;
    return  e;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    drawSign(Scale*((x+group.xOffset)-drawCamPosX), Scale*((y+group.yOffset)+drawCamPosY), Scale);

    float playx=player1.getX(), playy=player1.getY();
    if (playx>(x+group.xOffset)-35&&playx<(x+group.xOffset)+35&&playy>(y+group.yOffset)-40&&playy<(y+group.yOffset)) {//display the press e message to the player
      fill(255);
      textSize(Scale*20);
      displayText="Press E";
      displayTextUntill=millis()+100;

      if (E_pressed) {
        E_pressed=false;
        viewingItemContents=true;
      }
    }
  }
  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    drawSign((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), Scale);

    float playx=player1.getX(), playy=player1.getY();
    if (playx>(x+group.xOffset)-35&&playx<(x+group.xOffset)+35&&playy>(y+group.yOffset)-40&&playy<(y+group.yOffset)&& player1.z >= (z+group.zOffset)-20 && player1.z <= (z+group.zOffset)+20) {
      fill(255);
      textSize(20);
      displayText="Press E";
      displayTextUntill=millis()+100;
      if (E_pressed) {
        E_pressed=false;
        viewingItemContents=true;
      }
    }
  }
  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-35 && x <= ((this.x+group.xOffset)) + 35 && y >= ((this.y+group.yOffset)) - 65 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-35 && x <= ((this.x+group.xOffset)) + 35 && y >= ((this.y+group.yOffset)) - 65 && y <= (this.y+group.yOffset) && z >= ((this.z+group.yOffset)) - 5 && z <= (this.z+group.zOffset)+5) {
        return true;
      }
    }
    return false;
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setString("contents", contents);
    part.setInt("group", group);
    return part;
  }

  void setData(String data) {
    contents=data;
  }

  String getData() {
    return contents;
  }
}

class SoundBox extends StageComponent {
  String soundKey="";

  SoundBox(float X, float Y) {
    x=X;
    y=Y;
    type = "sound box";
  }
  SoundBox(JSONObject data, boolean stage_3D) {
    type = "sound box";
    x=data.getFloat("x");
    y=data.getFloat("y");
    soundKey=data.getString("sound key");
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    drawSoundBox((x+group.xOffset)-drawCamPosX, (y+group.yOffset)+drawCamPosY);
    if (player1.getX()>=(x+group.xOffset)-30&&player1.getX()<=(x+group.xOffset)+30&&player1.y>=(y+group.yOffset)-30&&player1.getY()<(y+group.yOffset)+30) {
      displayText="Press E";
      displayTextUntill=millis()+100;
      if (E_pressed) {
        try {
          StageSound sound = level.sounds.get(soundKey);
          if (!sound.sound.isPlaying()) {
            sound.sound.play();
          }
        }
        catch(Exception e) {
        }
      }
    }
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-30 && x <= ((this.x+group.xOffset)) + 30 && y >= ((this.y+group.yOffset)) - 30 && y <= (this.y+group.yOffset)+30) {
        return true;
      }
    }
    return false;
  }

  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    part.setString("type", type);
    part.setString("sound key", soundKey);
    part.setInt("group", group);
    return part;
  }

  StageComponent copy() {
    SoundBox e=new SoundBox(x, y);
    e.soundKey=soundKey;
    return  e;
  }

  void setData(String data) {
    soundKey=data;
  }

  String getData() {
    return soundKey;
  }
}

class LogicButton extends StageComponent {//ground component
  int variable=-1;
  LogicButton(JSONObject data, boolean stage_3D) {
    type="logic button";
    x=data.getFloat("x");
    y=data.getFloat("y");
    if (stage_3D) {
      z=data.getFloat("z");
    }
    if (!data.isNull("group")) {
      group=data.getInt("group");
    }
    variable=data.getInt("variable");
  }

  LogicButton(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
    type="logic button";
  }
  StageComponent copy() {
    return new LogicButton(x, y, z);
  }
  LogicButton(float X, float Y) {
    x=X;
    y=Y;
    type="logic button";
  }
  JSONObject save(boolean stage_3D) {
    JSONObject part=new JSONObject();
    part.setFloat("x", x);
    part.setFloat("y", y);
    if (stage_3D) {
      part.setFloat("z", z);
    }
    part.setString("type", type);
    part.setInt("group", group);
    part.setInt("variable", variable);
    return part;
  }

  void draw() {
    Group group=getGroup();
    if (!group.visable)
      return;
    boolean state=false;
    if (variable!=-1) {
      if (player1.x>=(x+group.xOffset)-10&&player1.x<=(x+group.xOffset)+10&&player1.y >=(y+group.yOffset)-10&&player1.y<= (y+group.yOffset)+2) {
        level.variables.set(variable, true);
      } else {
        level.variables.set(variable, false);
      }
    }
    if (variable!=-1) {
      state=level.variables.get(variable);
    }
    drawLogicButton(primaryWindow, ((x+group.xOffset)-drawCamPosX)*Scale, ((y+group.yOffset)+drawCamPosY)*Scale, Scale, state);
  }

  void draw3D() {
    Group group=getGroup();
    if (!group.visable)
      return;
    boolean state=false;
    if (variable!=-1) {
      if (player1.x>=(x+group.xOffset)-10&&player1.x<=(x+group.xOffset)+10&&player1.y >=(y+group.yOffset)-10&&player1.y<= (y+group.yOffset)+2 && player1.z >= (z+group.zOffset)-10 && player1.z <= (z+group.zOffset)+10) {
        level.variables.set(variable, true);
      } else {
        level.variables.set(variable, false);
      }
    }
    if (variable!=-1) {
      state=level.variables.get(variable);
    }
    drawLogicButton((x+group.xOffset), (y+group.yOffset), (z+group.zOffset), Scale, state);
  }

  boolean colide(float x, float y, boolean c) {
    Group group=getGroup();
    if (!group.visable)
      return false;
    if (c) {
      if (x >= ((this.x+group.xOffset))-20 && x <= ((this.x+group.xOffset)) + 20 && y >= ((this.y+group.yOffset)) - 10 && y <= (this.y+group.yOffset)) {
        return true;
      }
    }
    return false;
  }

  void setData(int data) {
    variable=data;
  }

  int getDataI() {
    return variable;
  }
}

class GenericStageComponent extends StageComponent {
  StageComponent copy() {
    return this;
  }
  JSONObject save(boolean e) {
    return null;
  }
}

class StageSound {
  String path, name, type="sound";
  protected SoundFile sound;
  StageSound(JSONObject input) {
    name=input.getString("name");
    path=input.getString("location");
    sound= new SoundFile(primaryWindow, rootPath+path);
  }
  StageSound(String Name, String location) {
    name=Name;
    path=location;
    sound= new SoundFile(primaryWindow, rootPath+path);
  }

  JSONObject save() {
    JSONObject out=new JSONObject();
    out.setString("location", path);
    out.setString("name", name);
    out.setString("type", type);
    return out;
  }
}

class LogicBoard {//stores all the logic components
  public String name="eee";//temp name
  public ArrayList<LogicComponent> components=new ArrayList<>();
  LogicBoard(JSONArray file, Level level) {
    JSONObject head=file.getJSONObject(0);
    name=head.getString("name");
    for (int i=1; i<file.size(); i++) {
      JSONObject component=file.getJSONObject(i);
      String type=component.getString("type");
      if (type.equals("generic")) {
        components.add(new GenericLogicComponent(component, this));
      }
      if (type.equals("AND")) {
        components.add(new AndGate(component, this));
      }
      if (type.equals("OR")) {
        components.add(new OrGate(component, this));
      }
      if (type.equals("XOR")) {
        components.add(new XorGate(component, this));
      }
      if (type.equals("NAND")) {
        components.add(new NAndGate(component, this));
      }
      if (type.equals("NOR")) {
        components.add(new NOrGate(component, this));
      }
      if (type.equals("XNOR")) {
        components.add(new XNorGate(component, this));
      }
      if (type.equals("ON")) {
        components.add(new ConstantOnSignal(component, this));
      }
      if (type.equals("read var")) {
        components.add(new ReadVariable(component, this));
      }
      if (type.equals("set var")) {
        components.add(new SetVariable(component, this));
      }
      if (type.equals("set visable")) {
        components.add(new SetVisibility(component, this, level));
      }
      if (type.equals("y-offset")) {
        components.add(new SetYOffset(component, this, level));
      }
      if (type.equals("x-offset")) {
        components.add(new SetXOffset(component, this, level));
      }
      if (type.equals("delay")) {
        components.add(new Delay(component, this));
      }
      if (type.equals("z-offset")) {
        components.add(new SetZOffset(component, this, level));
      }
    }
  }
  LogicBoard(String name) {
    this.name=name;
  }
  String save() {
    JSONArray logicComponents=new JSONArray();
    JSONObject head=new JSONObject();
    head.setString("name", name);
    logicComponents.setJSONObject(0, head);
    for (int i=0; i<components.size(); i++) {
      logicComponents.setJSONObject(i+1, components.get(i).save());
    }
    saveJSONArray(logicComponents, rootPath+"/"+name+".json");
    return "/"+name+".json";
  }

  void remove(int index) {
    if (components.size()<=index||index<0)//check if the porvided index is valid
      return;
    components.remove(index);//remove the object
    for (int i=0; i<components.size(); i++) {//make shure all connects still point to the correct components and remove connects that went to the deleted one
      LogicComponent component=components.get(i);
      for (int j=0; j<component.connections.size(); j++) {
        if (component.connections.get(j)[0]==index) {
          component.connections.remove(j);
          j--;
          continue;
        }
        if (component.connections.get(j)[0]>index)
          component.connections.get(j)[0]--;
      }
    }
  }

  void tick() {//tick each component once
    for (int i=0; i<components.size(); i++) {
      components.get(i).tick();
    }
    for (int i=0; i<components.size(); i++) {
      components.get(i).sendOut();
    }
    for (int i=0; i<components.size(); i++) {
      components.get(i).flushBuffer();
    }
  }
  void superTick() {//ticked the logic board 256 times with no delay inbetween ticks
    for (int i=0; i<256; i++) {
      tick();
    }
  }
}

abstract class LogicComponent {//the base of all logic gam=ts and things
  float x, y;//for visuals only
  String type;
  Button button;
  ArrayList<Integer[]> connections=new ArrayList<>();
  LogicBoard lb;
  boolean outputTerminal=false, inputTerminal1Buffer=false, inputTerminal2Buffer=false, inputTerminal1=false, inputTerminal2=false;
  LogicComponent(float x, float y, String type, LogicBoard board) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(primaryWindow, x, y, 100, 80, "  "+type+"  ");
    lb=board;
  }

  LogicComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    this.x=x;
    this.y=y;
    this.type=type;
    button=new Button(primaryWindow, x, y, 100, 80, "  "+type+"  ");
    lb=board;
    for (int i=0; i<cnects.size(); i++) {
      JSONObject data= cnects.getJSONObject(i);
      connections.add(new Integer[]{data.getInt("index"), data.getInt("terminal")});
    }
  }

  void draw() {
    button.x=x-camPos;
    button.y=y-camPosY;
    button.draw();
    fill(#FF98CF);
    ellipse(x-2-camPos, y+20-camPosY, 20, 20);
    ellipse(x-2-camPos, y+60-camPosY, 20, 20);
    fill(#FA5BD5);
    ellipse(x+102-camPos, y+40-camPosY, 20, 20);
  }

  float[] getTerminalPos(int t) {
    if (t==0) {
      return new float[]{x-2-camPos, y+20-camPosY};
    }
    if (t==1) {
      return new float[]{x-2-camPos, y+60-camPosY};
    }
    if (t==2) {
      return new float[]{x+102-camPos, y+40-camPosY};
    }
    return new float[]{-1000, -1000};
  }

  void connect(int index, int terminal) {
    if (index>=lb.components.size()||index<0)//check if the index is valid
      return;
    if (terminal<0||terminal>1)//check id the terminal attemping to connect to is valid
      return;
    connections.add(new Integer[]{index, terminal});//create the connection
  }

  void drawConnections() {
    for (int i=0; i<connections.size(); i++) {
      stroke(0);
      strokeWeight(5);
      Integer[] connectionInfo =connections.get(i);
      float[] thisTerminal = getTerminalPos(2), toTerminal=lb.components.get(connectionInfo[0]).getTerminalPos(connectionInfo[1]);
      line(thisTerminal[0], thisTerminal[1], toTerminal[0], toTerminal[1]);
    }
  }

  void setPos(float x, float y) {
    this.x=x-button.lengthX/2;
    this.y=y-button.lengthY/2;
    button.setX(this.x).setY(this.y);
  }

  void setTerminal(int terminal, boolean state) {
    if (terminal==0)
      inputTerminal1Buffer=state;
    if (terminal==1)
      inputTerminal2Buffer=state;
  }

  void flushBuffer() {
    inputTerminal1=inputTerminal1Buffer;
    inputTerminal2=inputTerminal2Buffer;
  }

  abstract void tick();

  void sendOut() {
    for (int i=0; i<connections.size(); i++) {
      lb.components.get(connections.get(i)[0]).setTerminal( connections.get(i)[1], outputTerminal);
    }
  }

  JSONObject save() {
    JSONObject component=new JSONObject();
    component.setString("type", type);
    component.setFloat("x", x);
    component.setFloat("y", y);
    JSONArray connections=new JSONArray();
    for (int i=0; i<this.connections.size(); i++) {
      JSONObject connect=new JSONObject();
      connect.setInt("index", this.connections.get(i)[0]);
      connect.setInt("terminal", this.connections.get(i)[1]);
      connections.setJSONObject(i, connect);
    }
    component.setJSONArray("connections", connections);
    return component;
  }

  void setData(int data) {
  }

  int getData() {
    return 0;
  }
}

class GenericLogicComponent extends LogicComponent {
  GenericLogicComponent(float x, float y, LogicBoard lb) {
    super(x, y, "generic", lb);
  }
  GenericLogicComponent(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "generic", lb, data.getJSONArray("connections"));
  }

  void tick() {
  }
}

class AndGate extends LogicComponent {
  AndGate(float x, float y, LogicBoard lb) {
    super(x, y, "AND", lb);
  }

  AndGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "AND", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=inputTerminal1&&inputTerminal2;
  }
}

class OrGate extends LogicComponent {
  OrGate(float x, float y, LogicBoard lb) {
    super(x, y, "OR", lb);
  }
  OrGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "OR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=inputTerminal1||inputTerminal2;
  }
}

class XorGate extends LogicComponent {
  XorGate(float x, float y, LogicBoard lb) {
    super(x, y, "XOR", lb);
  }

  XorGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "XOR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=inputTerminal1!=inputTerminal2;
  }
}

class NAndGate extends LogicComponent {
  NAndGate(float x, float y, LogicBoard lb) {
    super(x, y, "NAND", lb);
  }

  NAndGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "NAND", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=!(inputTerminal1&&inputTerminal2);
  }
}

class NOrGate extends LogicComponent {
  NOrGate(float x, float y, LogicBoard lb) {
    super(x, y, "NOR", lb);
  }
  NOrGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "NOR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=!(inputTerminal1||inputTerminal2);
  }
}

class XNorGate extends LogicComponent {
  XNorGate(float x, float y, LogicBoard lb) {
    super(x, y, "XNOR", lb);
  }

  XNorGate(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "XNOR", lb, data.getJSONArray("connections"));
  }

  void tick() {
    outputTerminal=!(inputTerminal1!=inputTerminal2);
  }
}

class Delay extends LogicComponent {
  int time=10;
  ArrayList<Boolean> mem=new ArrayList<>();
  Delay(float x, float y, LogicBoard lb) {
    super(x, y, "delay", lb);
    button.setText("delay "+time+" ticks  ");
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }

  Delay(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "delay", lb, data.getJSONArray("connections"));
    time=data.getInt("delay");
    button.setText("delay "+time+" ticks  ");
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }

  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("input", x+5-camPos, y+16-camPosY);
    text("clear", x+5-camPos, y+56-camPosY);
  }

  void tick() {
    if (inputTerminal2) {
      mem=new ArrayList<>();
      for (int i=0; i<time; i++) {
        mem.add(false);
      }
    }
    outputTerminal=mem.remove(0);
    mem.add(inputTerminal1);
    //println(mem);
  }
  void setData(int data) {
    time=data;
    button.setText("delay "+time+" ticks  ");
    mem=new ArrayList<>();
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }
  int getData() {
    return time;
  }

  JSONObject save() {
    JSONObject contence=super.save();
    contence.setInt("delay", time);
    return contence;
  }
}

abstract class LogicInputComponent extends LogicComponent {
  LogicInputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(primaryWindow, x, y, 100, 40, "  "+type+"  ");
  }
  LogicInputComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    super(x, y, type, board, cnects);
    button=new Button(primaryWindow, x, y, 100, 40, "  "+type+"  ");
  }
  void draw() {
    button.x=x-camPos;
    button.y=y-camPosY;
    button.draw();
    fill(#FA5BD5);
    ellipse(x+102-camPos, y+20-camPosY, 20, 20);
  }
  float[] getTerminalPos(int t) {
    if (t==2) {
      return new float[]{x+102-camPos, y+20-camPosY};
    }
    return new float[]{-1000, -1000};
  }
}

abstract class LogicOutputComponent extends LogicComponent {
  LogicOutputComponent(float x, float y, String type, LogicBoard board) {
    super(x, y, type, board);
    button=new Button(primaryWindow, x, y, 100, 80, "  "+type+"  ");
  }
  LogicOutputComponent(float x, float y, String type, LogicBoard board, JSONArray cnects) {
    super(x, y, type, board, cnects);
    button=new Button(primaryWindow, x, y, 100, 80, "  "+type+"  ");
  }
  void draw() {
    button.x=x-camPos;
    button.y=y-camPosY;
    button.draw();
    fill(#FF98CF);
    ellipse(x-2-camPos, y+20-camPosY, 20, 20);
    ellipse(x-2-camPos, y+60-camPosY, 20, 20);
  }
  float[] getTerminalPos(int t) {
    if (t==0) {
      return new float[]{x-2-camPos, y+20-camPosY};
    }
    if (t==1) {
      return new float[]{x-2-camPos, y+60-camPosY};
    }
    return new float[]{-1000, -1000};
  }
}

class ConstantOnSignal extends LogicInputComponent {
  ConstantOnSignal(float x, float y, LogicBoard lb) {
    super(x, y, "ON", lb);
    outputTerminal=true;
  }

  ConstantOnSignal(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "ON", lb, data.getJSONArray("connections"));
    outputTerminal=true;
  }
  void tick() {
    outputTerminal=true;
  }
}

class ReadVariable extends LogicInputComponent {
  int variableNumber=0;
  ReadVariable(float x, float y, LogicBoard lb) {
    super(x, y, "read var", lb);
    button.setText("read var b"+variableNumber+"  ");
  }

  ReadVariable(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "read var", lb, data.getJSONArray("connections"));
    variableNumber=data.getInt("variable number");
    button.setText("read var b"+variableNumber+"  ");
  }
  void tick() {
    outputTerminal=level.variables.get(variableNumber);
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("variable number", variableNumber);
    return component;
  }
  void setData(int data) {
    variableNumber=data;
    button.setText("read var b"+variableNumber+"  ");
  }
  int getData() {
    return variableNumber;
  }
}

class SetVariable extends LogicOutputComponent {
  int variableNumber=0;
  SetVariable(float x, float y, LogicBoard lb) {
    super(x, y, "set var", lb);
    button.setText("  set var b"+variableNumber);
  }

  SetVariable(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "set var", lb, data.getJSONArray("connections"));
    variableNumber=data.getInt("variable number");
    button.setText("  set var b"+variableNumber);
  }
  void tick() {
    if (inputTerminal2)
      level.variables.set(variableNumber, inputTerminal1);
  }
  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("data", x+5-camPos, y+16-camPosY);
    text("set", x+5-camPos, y+56-camPosY);
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("variable number", variableNumber);
    return component;
  }
  void setData(int data) {
    variableNumber=data;
    button.setText("  set var b"+variableNumber);
  }
  int getData() {
    return variableNumber;
  }
}

class SetVisibility extends LogicOutputComponent {
  int groupNumber=0;
  SetVisibility(float x, float y, LogicBoard lb) {
    super(x, y, "set visable", lb);
    button.setText("  visibility of "+level.groupNames.get(groupNumber));
  }

  SetVisibility(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "set visable", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    button.setText("  visibility of "+level.groupNames.get(groupNumber));
  }
  void tick() {
    if (inputTerminal1) {
      level.groups.get(groupNumber).visable=true;
    }
    if (inputTerminal2) {
      level.groups.get(groupNumber).visable=false;
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    return component;
  }
  void setData(int data) {
    groupNumber=data;
    button.setText("  visibility of "+level.groupNames.get(groupNumber));
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("true", x+5-camPos, y+16-camPosY);
    text("false", x+5-camPos, y+56-camPosY);
  }
}

class SetXOffset extends LogicOutputComponent {
  int groupNumber=0;
  float offset=0;
  SetXOffset(float x, float y, LogicBoard lb) {
    super(x, y, "x-offset", lb);
    button.setText("x-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }

  SetXOffset(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "x-offset", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    offset=data.getFloat("offset");
    button.setText("x-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  void tick() {
    if (inputTerminal1) {
      level.groups.get(groupNumber).xOffset=offset;
    }
    if (inputTerminal2) {
      level.groups.get(groupNumber).xOffset=0;
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    component.setFloat("offset", offset);
    return component;
  }
  void setData(int data) {
    groupNumber=data;
    button.setText("x-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("set", x+5-camPos, y+16-camPosY);
    text("reset", x+5-camPos, y+56-camPosY);
  }
  void setOffset(float of) {
    offset=of;
    button.setText("x-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  float getOffset() {
    return offset;
  }
}

class SetYOffset extends LogicOutputComponent {
  int groupNumber=0;
  float offset=0;
  SetYOffset(float x, float y, LogicBoard lb) {
    super(x, y, "y-offset", lb);
    button.setText("y-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }

  SetYOffset(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "y-offset", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    offset=data.getFloat("offset");
    button.setText("y-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  void tick() {
    if (inputTerminal1) {
      level.groups.get(groupNumber).yOffset=-offset;
    }
    if (inputTerminal2) {
      level.groups.get(groupNumber).yOffset=0;
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    component.setFloat("offset", offset);
    return component;
  }
  void setData(int data) {
    groupNumber=data;
    button.setText("y-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("set", x+5-camPos, y+16-camPosY);
    text("reset", x+5-camPos, y+56-camPosY);
  }
  void setOffset(float of) {
    offset=of;
    button.setText("y-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  float getOffset() {
    return offset;
  }
}

class SetZOffset extends LogicOutputComponent {
  int groupNumber=0;
  float offset=0;
  SetZOffset(float x, float y, LogicBoard lb) {
    super(x, y, "z-offset", lb);
    button.setText("z-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }

  SetZOffset(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "z-offset", lb, data.getJSONArray("connections"));
    groupNumber=data.getInt("group number");
    offset=data.getFloat("offset");
    button.setText("z-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  void tick() {
    if (inputTerminal1) {
      level.groups.get(groupNumber).zOffset=offset;
    }
    if (inputTerminal2) {
      level.groups.get(groupNumber).zOffset=0;
    }
  }
  JSONObject save() {
    JSONObject component=super.save();
    component.setInt("group number", groupNumber);
    component.setFloat("offset", offset);
    return component;
  }
  void setData(int data) {
    groupNumber=data;
    button.setText("z-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  int getData() {
    return groupNumber;
  }

  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("set", x+5-camPos, y+16-camPosY);
    text("reset", x+5-camPos, y+56-camPosY);
  }
  void setOffset(float of) {
    offset=of;
    button.setText("z-offset "+level.groupNames.get(groupNumber)+" by "+offset);
  }
  float getOffset() {
    return offset;
  }
}

class Set3DMode extends LogicOutputComponent {
  int groupNumber=0;
  float offset=0;
  Set3DMode(float x, float y, LogicBoard lb) {
    super(x, y, "  set 3D  ", lb);
  }

  Set3DMode(JSONObject data, LogicBoard lb, Level level) {
    super(data.getFloat("x"), data.getFloat("y"), "  set 3D  ", lb, data.getJSONArray("connections"));
  }
  void tick() {
    if (inputTerminal1) {
      e3DMode=true;
    }
    if (inputTerminal2) {
      e3DMode=false;
    }
  }

  void draw() {
    super.draw();
    fill(0);
    textSize(15);
    textAlign(LEFT, CENTER);
    text("true", x+5-camPos, y+16-camPosY);
    text("false", x+5-camPos, y+56-camPosY);
  }
}

class Read3DMode extends LogicInputComponent {
  int variableNumber=0;
  Read3DMode(float x, float y, LogicBoard lb) {
    super(x, y, "read 3D ", lb);
  }

  Read3DMode(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "read 3D ", lb, data.getJSONArray("connections"));
  }
  void tick() {
    outputTerminal=e3DMode;
  }
}
