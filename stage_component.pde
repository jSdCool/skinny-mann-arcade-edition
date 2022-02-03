class Level {
  ArrayList<Stage> stages=new ArrayList<>();
  public int mainStage, numOfCoins, levelID;
  public String name, createdVersion;
  public float SpawnX, SpawnY, RewspawnX, RespawnY;
  public HashMap<String, StageSound> sounds=new HashMap<>();

  Level(JSONArray file) {
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
    player1.x=SpawnX;
    player1.y=SpawnY;
    respawnX=(int)RewspawnX;
    respawnY=(int)RespawnY;
    respawnStage=currentStageIndex;
    if (!gameVersionCompatibilityCheck(createdVersion)) {
      return;
    }

    for (int i=1; i<file.size(); i++) {
      job=file.getJSONObject(i);
      if (job.getString("type").equals("stage")||job.getString("type").equals("3Dstage"))
        stages.add(new Stage(loadJSONArray(rootPath+job.getString("location"))));
      if (job.getString("type").equals("sound")) {
        sounds.put(job.getString("name"), new StageSound(job));
      }
    }

    coins=new ArrayList<Boolean>();
    for (int i=0; i<numOfCoins; i++) {
      coins.add(false);
    }
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
    head.setString("game version", version);
    head.setString("author", author);
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
    if(keys.length!=0)
    for (int i=0; i<keys.length; i++) {
      index.setJSONObject(index.size(), sounds.get(keys[i]).save());
    }
    saveJSONArray(index, rootPath+"/index.json");
  }
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
  public int ccolor;
  public String type;
  void draw() {
  };
  void draw3D() {
  };
  boolean colide(float x, float y, boolean c) {
    return false;
  };//c= is colideing with click box
  boolean colide(float x, float y, float z) {
    return false;
  };
  boolean colideDethPlane(float x, float Y) {
    return false;
  };
  abstract JSONObject save(boolean stage_3D);

  void setData(String data) {
  }

  String getData() {
    return null;
  }
  abstract StageComponent copy();
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
    return part;
  }

  void draw() {
    fill(ccolor);
    rect(Scale*(x-camPos)-1, Scale*(y+camPosY)-1, Scale*dx+2, Scale*dy+2);
  }

  void draw3D() {
    fill(ccolor);
    strokeWeight(0);
    translate(x+dx/2, y+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*(x+dx/2), -1*(y+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    float x2 = this.x+dx, y2=this.y+dy;
    if (x >= this.x && x <= x2 && y >= this.y && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }

  boolean colide(float x, float y, float z) {
    float x2 = this.x+dx, y2=this.y+dy, z2=this.z+dz;
    if (x >= this.x && x <= x2 && y >= this.y && y <= y2 && z>=this.z && z<=z2/* terain hit box*/) {
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
    return part;
  }

  void draw() {
    fill(ccolor);
    rect(Scale*(x-camPos)-1, Scale*(y+camPosY)-1, Scale*dx+2, Scale*dy+2);
  }

  void draw3D() {
    fill(ccolor);
    strokeWeight(0);
    translate(x+dx/2, y+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*(x+dx/2), -1*(y+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      float x2 = this.x+dx, y2=this.y+dy;
      if (x >= this.x && x <= x2 && y >= this.y && y <= y2/* terain hit box*/) {
        return true;
      }
    }
    return false;
  }

  boolean colide(float x, float y, float z) {
    float x2 = this.x+dx, y2=this.y+dy, z2=this.z+dz;
    if (x >= this.x && x <= x2 && y >= this.y && y <= y2 && z>=this.z && z<=z2/* terain hit box*/) {
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
    return part;
  }

  void draw() {
    fill(-114431);
    rect(Scale*(x-camPos)-1, Scale*(y+camPosY)-1, Scale*dx+2, Scale*dy+2);
  }

  void draw3D() {
    fill(-114431);
    strokeWeight(0);
    translate(x+dx/2, y+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*(x+dx/2), -1*(y+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    float x2 = this.x+dx, y2=this.y+dy;
    if (x >= this.x && x <= x2 && y >= this.y && y <= y2/* terain hit box*/) {
      return true;
    }
    return false;
  }

  boolean colideDethPlane(float x, float y) {
    float x2 =this. x+dx, y2=this.y+dy;
    if (x >= this.x && x <= x2 && y >= this.y && y <= y2/* terain hit box*/) {
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
    return part;
  }

  void draw() {
    float playx=player1.getX();
    boolean po=false;
    if (playx>=x-5 && playx<= x+5 && y-50 <= player1.getY() && y>=player1.getY()-10) {
      respawnX=(int)x;
      respawnY=(int)y;
      respawnStage=currentStageIndex;
      po=true;
      checkpointIn3DStage=false;
    }

    float x2=x-camPos;
    float y2=y+camPosY;
    if (po)
      fill(#E5C402);
    else
      fill(#B9B9B9);
    rect((x2-3)*Scale, (y2-60)*Scale, 5*Scale, 60*Scale);
    fill(#EA0202);
    triangle(x2*Scale, (y2-60)*Scale, x2*Scale, (y2-40)*Scale, (x2+30)*Scale, (y2-50)*Scale);
  }

  void draw3D() {
    noStroke();
    float playx=player1.getX();
    boolean po=false;
    if (playx>=x-20 && playx<= x+20 && y-50 <= player1.getY() && y>=player1.getY()-10 && player1.z >= z-20 && player1.z <= z+20) {
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
    strokeWeight(0);
    translate(x, y-30, z);
    box(4, 60, 4);
    translate(-x, -(y-30), -z);
    fill(#EA0202);
    stroke(#EA0202);
    strokeWeight(0);
    translate(x+10, y-50, z);
    box(20, 20, 2);
    translate(-(x+10), -(y-50), -z);
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      if (x>=this.x-8 && x<= this.x+8 && y >= this.y-50 && y <= this.y) {
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
    return part;
  }

  void draw() {
    float x2 = x-camPos, y2 = y;
    fill(255);
    rect(Scale*x2, Scale*(y2+camPosY), Scale*50, Scale*50);
    rect(Scale*(x2+100), Scale*(y2+camPosY), Scale*50, Scale*50);
    rect(Scale*(x2+200), Scale*(y2+camPosY), Scale*50, Scale*50);
    fill(0);
    rect(Scale*(x2+50), Scale*(y2+camPosY), Scale*50, Scale*50);
    rect(Scale*(x2+150), Scale*(y2+camPosY), Scale*50, Scale*50);

    float px =player1.getX(), py=player1.getY();

    if (px >= x2+camPos && px <= x2+camPos + 250 && py >= y2 - 50 && py <= y2 + 50) {
      level_complete=true;
    }
  }

  void draw3D() {
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      if (x >= this.x && x <= (this.x) + 250 && y >= (this.y) - 50 && y <= (this.y) + 50) {
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
    return part;
  }

  void draw() {
    float playx=player1.getX(), playy=player1.getY();
    boolean collected;
    if (editingBlueprint) {
      collected=false;
    } else {
      collected=coins.get(coinId);
    }
    float x2=x-camPos;
    if (!collected) {
      drawCoin(Scale*x2, Scale*(y+camPosY), Scale*3);
      if (Math.sqrt(Math.pow(playx-camPos-x2, 2)+Math.pow(playy-y, 2))<30) {
        coins.set(coinId, true);
        coinCount++;
      }
    }
  }

  void draw3D() {
    float playx=player1.getX(), playy=player1.getY(), playz=player1.z;
    boolean collected=coins.get(coinId);

    if (!collected) {
      translate(x, y, z);
      rotateY(radians(coinRotation));
      shape(coin3D);
      rotateY(radians(-coinRotation));
      translate(-x, -y, -z);
      if (Math.sqrt(Math.pow(playx-x, 2)+Math.pow(playy-y, 2)+Math.pow(playz-z, 2))<35) {
        coins.set(coinId, true);
        coinCount++;
      }
    }
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      if (Math.sqrt(Math.pow(x-this.x, 2)+Math.pow(y-this.y, 2))<19) {
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
    if (stage_3D) {
    }
    try {
      z=data.getFloat("z");
      linkZ=data.getFloat("linkZ");
    }
    catch(Throwable e) {
      linkZ=-1;
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
    return part;
  }

  void draw() {
    float playx=player1.getX(), playy=player1.getY();
    drawPortal(Scale*(x-camPos), Scale*(y+camPosY), Scale*1);
    if ((playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)) {
      fill(255);
      textSize(Scale*20);
      displayText="Press E";
      displayTextUntill=millis()+100;
    }

    if (E_pressed&&(playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)) {
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
    float playx=player1.getX(), playy=player1.getY();

    translate(0, 0, z);
    drawPortal(x, y, 1);
    translate(0, 0, -z);
    if ((playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60&& player1.z >= z-20 && player1.z <= z+20)) {
      fill(255);
      textSize(20);
      displayText="Press E";
      displayTextUntill=millis()+100;
    }

    if (E_pressed&&(playx>x-25&&playx<x+25&&playy>y-50&&playy<y+60)) {
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
    if (c) {
      if (x>this.x-25&&x<this.x+25&&y>this.y-50&&y<this.y+60) {
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
    return part;
  }

  void draw() {
    fill(ccolor);
    if (direction==0) {
      triangle(Scale*(x-camPos), Scale*(y+camPosY), Scale*(dx-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(y+camPosY));
    }
    if (direction==1) {
      triangle(Scale*(x-camPos), Scale*(y+camPosY), Scale*(x-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(y+camPosY));
    }
    if (direction==2) {
      triangle(Scale*(x-camPos), Scale*(y+camPosY), Scale*(dx-camPos), Scale*(dy+camPosY), Scale*(x-camPos), Scale*(dy+camPosY));
    }
    if (direction==3) {
      triangle(Scale*(x-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(y+camPosY));
    }
  }

  void draw3D() {
    fill(ccolor);
    strokeWeight(0);
    translate(x+dx/2, y+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*(x+dx/2), -1*(y+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    float x2 = dx, y2=dy, y1=this.y, x1=this.x, rot=direction;
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
    return part;
  }

  void draw() {
    fill(ccolor);
    if (direction==0) {
      triangle(Scale*(x-camPos), Scale*(y+camPosY), Scale*(dx-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(y+camPosY));
    }
    if (direction==1) {
      triangle(Scale*(x-camPos), Scale*(y+camPosY), Scale*(x-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(y+camPosY));
    }
    if (direction==2) {
      triangle(Scale*(x-camPos), Scale*(y+camPosY), Scale*(dx-camPos), Scale*(dy+camPosY), Scale*(x-camPos), Scale*(dy+camPosY));
    }
    if (direction==3) {
      triangle(Scale*(x-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(dy+camPosY), Scale*(dx-camPos), Scale*(y+camPosY));
    }
  }

  void draw3D() {
    fill(ccolor);
    strokeWeight(0);
    translate(x+dx/2, y+dy/2, z+dz/2);
    box(dx, dy, dz);
    translate(-1*(x+dx/2), -1*(y+dy/2), -1*(z+dz/2));
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      float x2 = dx, y2=dy, y1=this.y, x1=this.x, rot=direction;
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
    return part;
  }

  void draw() {
    draw3DSwitch1((x-camPos)*Scale, (y+camPosY)*Scale, Scale);
    if (player1.x>=x-10&&player1.x<=x+10&&player1.y >=y-10&&player1.y<= y+2) {
      player1.z=z;
      e3DMode=true;
      gmillis=millis()+1200;
    }
  }

  void draw3D() {
    draw3DSwitch1(x, y, z, Scale);
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      if (x >= (this.x)-20 && x <= (this.x) + 20 && y >= (this.y) - 10 && y <= this.y) {
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
    return part;
  }

  void draw() {
    draw3DSwitch2((x-camPos)*Scale, (y+camPosY)*Scale, Scale);
  }

  void draw3D() {
    draw3DSwitch2(x, y, z, Scale);
    if (player1.x>=x-10&&player1.x<=x+10&&player1.y >=y-10&&player1.y<= y+2 && player1.z >= z-10 && player1.z <= z+10) {
      e3DMode=false;
      WPressed=false;
      SPressed=false;
      gmillis=millis()+1200;
    }
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      if (x >= (this.x)-20 && x <= (this.x) + 20 && y >= (this.y) - 10 && y <= this.y) {
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
    drawSign(Scale*(x-camPos), Scale*(y+camPosY), Scale);

    float playx=player1.getX(), playy=player1.getY();
    if (playx>x-35&&playx<x+35&&playy>y-40&&playy<y) {//display the press e message to the player
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
    drawSign(x, y, z, Scale);

    float playx=player1.getX(), playy=player1.getY();
    if (playx>x-35&&playx<x+35&&playy>y-40&&playy<y&& player1.z >= z-20 && player1.z <= z+20) {
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
    if (c) {
      if (x >= (this.x)-35 && x <= (this.x) + 35 && y >= (this.y) - 65 && y <= this.y) {
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
  SoundBox(JSONObject data,boolean stage_3D) {
    type = "sound box";
    x=data.getFloat("x");
    y=data.getFloat("y");
    soundKey=data.getString("sound key");
  }

  void draw() {
    drawSoundBox(x-camPos, y+camPosY);
    if (player1.getX()>=x-30&&player1.getX()<=x+30&&player1.y>=y-30&&player1.getY()<y+30) {
      displayText="Press E";
      displayTextUntill=millis()+100;
      if(E_pressed){
      try {
        StageSound sound = level.sounds.get(soundKey);
        if (!sound.sound.isPlaying()) {
          sound.sound.play();
        }
      }catch(Exception e) {}
    }}
  }

  boolean colide(float x, float y, boolean c) {
    if (c) {
      if (x >= (this.x)-30 && x <= (this.x) + 30 && y >= (this.y) - 30 && y <= this.y+30) {
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

class StageSound {
  String path, name, type="sound";
  protected SoundFile sound;
  StageSound(JSONObject input) {
    name=input.getString("name");
    path=input.getString("location");
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
