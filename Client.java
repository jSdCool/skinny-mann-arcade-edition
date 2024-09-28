import java.net.Socket;
import java.io.*;
import java.util.ArrayList;
class Client extends Thread {
  static transient skiny_mann source;
  int playernumber, blockSize=10240, currentDownloadIndex, currentDownloadblock;
  Socket socket;
  ObjectOutputStream output;
  ObjectInputStream input;
  String ip="uninitilized", name="uninitilized";
  ArrayList<DataPacket> dataToSend=new ArrayList<>();
  NetworkDataPacket toSend=new NetworkDataPacket(), recieved;
  boolean versionChecked=false, readdy=false, viablePlayers[]=new boolean[10];
  BestScore bestScore=new BestScore("", 0);
  boolean reachedEnd, downloadingLevel=false;
  LevelDownloadInfo ldi;
  String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&()-_=+`~[]{}";
  byte outherFiles[][];
  byte currentDownloadingFile[];

  Client(Socket s) {
    init(s);
  }
  Client(Socket s, int num) {
    super("client number "+num);
    playernumber=num;
    init(s);
  }

  void init(Socket s) {
    System.out.println("creating new client");
    try {
      socket=s;
      output=new ObjectOutputStream(socket.getOutputStream());
      input = new ObjectInputStream(socket.getInputStream());
      socket.setSoTimeout(5000);
    }
    catch(Exception i) {
      disconnect();
      source.networkError(i);
      return;
    }

    ip=socket.getInetAddress().toString();
    System.out.println(ip);
    start();
  }

  public void run() {
    if (source.isHost) {
      //if this instance is the host of a multyplayer cession
      System.out.println("starting client host loop");
      host();
    } else {
      //if this instanmce has joined a multyplayer cession
      System.out.println("statring client joined loop");
      joined();
    }
    disconnect();
  }

  void host() {
    try {
      long sent=0, processStart=0;
      double sr=0, rs=0;
      while (socket.isConnected()&&!socket.isClosed()) {
        //send data to client
        //System.out.println("sending "+source.frameCount);
        output.writeObject(toSend);
        sent=System.nanoTime();
        output.flush();
        output.reset();
        rs=(double)(sent/1000000-processStart/1000000);
        //System.out.println("send to recieve: "+sr+"\nrecieve to send: "+rs);

        //recieve data from client
        Object rawInput = input.readObject();
        processStart=System.nanoTime();
        sr=(double)(processStart/1000000-sent/1000000);
        //System.out.println("recieved "+source.frameCount);
        //process input
        recieved=(NetworkDataPacket)rawInput;
        for (int i=0; i<recieved.data.size(); i++) {
          DataPacket di = recieved.data.get(i);
          if (di instanceof ClientInfo) {
            ClientInfo ci = (ClientInfo)di;
            this.name = ci.name;
            this.readdy=ci.readdy;
            reachedEnd=ci.atEnd;
            if (readdy&&outherFiles!=null&&!downloadingLevel) {
              outherFiles=null;
              ldi=null;
              downloadingLevel=false;
            }
            //System.out.println("c "+readdy);
          }
          if (di instanceof PlayerPositionInfo) {
            PlayerPositionInfo ppi = (PlayerPositionInfo)di;
            source.players[playernumber]=ppi.player;
          }
          if (di instanceof BestScore) {
            bestScore=(BestScore)di;
          }
          if (di instanceof RequestLevel) {
            System.out.println(ip+" requested to download the level");
            downloadingLevel=true;
            String fileNames[] = source.level.getOutherFileNames();
            int fileSizes[]=new int[fileNames.length];
            int realSizes[]=new int[fileNames.length];
            outherFiles=new byte[fileNames.length][];
            for (int j=0; j<fileNames.length; j++) {
              outherFiles[j]=source.loadBytes(source.rootPath+fileNames[j]);//save the contence of the files for later
              fileSizes[j]=outherFiles[j].length/blockSize;//get the file size in hole blocks
              fileSizes[j]+=((outherFiles[j].length%blockSize==0) ? 0 : 1);//if some bites are clipped off by the number of blocks then add 1 more
              realSizes[j]=outherFiles[j].length;
            }
            ldi=new LevelDownloadInfo(source.level, fileNames, fileSizes, blockSize, realSizes);
            dataToSend.add(ldi);
          }
          if (di instanceof RequestLevelFileComponent) {
            RequestLevelFileComponent rlfc = (RequestLevelFileComponent)di;
            System.out.println(ip+" has requested file "+rlfc.file+" block "+rlfc.block);
            byte sendBytes[]=new byte[blockSize];
            for (int j=0; j < blockSize && (j+rlfc.block*blockSize) < outherFiles[rlfc.file].length; j++) {
              sendBytes[j]=outherFiles[rlfc.file][j+rlfc.block*blockSize];
            }
            //respond with the data
            dataToSend.add(new LevelFileComponentData(sendBytes));
          }
          if(di instanceof KillEntityDataPacket){
            KillEntityDataPacket ke = (KillEntityDataPacket)di;
            source.level.stages.get(ke.getStage()).entities.get(ke.getIndex()).kill();
          }
        }

        ArrayList<String> names=new ArrayList<>();
        names.add(source.name);
        for (int j=0; j<source.clients.size(); j++) {
          names.add(source.clients.get(j).name);
        }
        dataToSend.add(new InfoForClient(playernumber, names, source.version, source.inGame||(source.prevousInGame&&source.Menue.equals("settings")), source.sessionTime));
        if (source.menue) {
          if (source.Menue.equals("multiplayer selection")) {
            dataToSend.add(source.multyplayerSelectedLevel);
          }
        }
        if (source.inGame) {
          viablePlayers=new boolean[10];
          viablePlayers[0]=true;
          for (int i=0; i<source.clients.size(); i++) {
            viablePlayers[source.clients.get(i).playernumber]=true;
          }
          dataToSend.add(new PlayerInfo(source.players, viablePlayers));
          if (source.level.multyplayerMode==1) {
            dataToSend.add(source.leaderBoard);
          }
          if (source.level.multyplayerMode==2) {
            dataToSend.add(new CoOpStateInfo(source.level.variables, source.level.groups, source.level_complete));
            
            //send the lient info aboutb all entities in the level                            
            for(int i=0;i<source.level.stages.size();i++){
              for(int j=0;j<source.level.stages.get(i).entities.size();j++){
                dataToSend.add(new MultyPlayerEntityInfo(i,j,source.level.stages.get(i).entities.get(j)));
              }
            }
          }
        }
        //create the next packet to send
        generateSendPacket();
      }
    }
    catch(java.net.SocketTimeoutException s) {
      s.printStackTrace();//for DEBUG ONLY diabled for final build
    }
    catch(IOException i) {
      i.printStackTrace();
      //source.networkError(i);
    }
    catch(ClassNotFoundException c) {
      c.printStackTrace();
      //source.networkError(c);
    }
  }

  void joined() {
    try {
      long sent=0, processStart=0;
      double sr=0, rs=0;
      while (socket.isConnected()&&!socket.isClosed()) {
        //recieve data from server
        Object rawInput = input.readObject();
        processStart=System.nanoTime();
        sr=(double)(processStart/1000000-sent/1000000);
        //process input
        recieved=(NetworkDataPacket)rawInput;
        for (int i=0; i<recieved.data.size(); i++) {
          DataPacket di = recieved.data.get(i);
          if (di instanceof InfoForClient) {
            InfoForClient ifc = (InfoForClient)di;
            source.playerNames=ifc.playerNames;
            playernumber=ifc.playerNumber;
            source.currentPlayer=playernumber;
            if (!versionChecked) {
              if (source.version.equals(ifc.hostVersion)) {
                versionChecked=true;
              } else {
                throw new IOException("host and client are not on the same version\nhost is on "+ifc.hostVersion);
              }
            }
            if (!source.prevousInGame)
              source.inGame=ifc.inGame;
            source.sessionTime=ifc.sessionTime;
          }
          if (di instanceof SelectedLevelInfo) {
            SelectedLevelInfo sli = (SelectedLevelInfo)di;
            source.multyplayerSelectedLevel=sli;
          }
          if (di instanceof LoadLevelRequest) {
            LoadLevelRequest llr = (LoadLevelRequest)di;
            if (llr.isBuiltIn) {//if the level to load is included with the game
              source.loadLevel(llr.path);
              source.bestTime=0;
              dataToSend.add(new BestScore(source.name, source.bestTime));
              readdy=true;
            } else {//if the level to load is UGC
              source.loadUGCList();//load the list of UGC levels on thius device
              boolean foundlevel=false;
              String levelName="";
              ArrayList<String> matchIDs =new ArrayList<>();
              for (int j=0; j<source.UGCNames.size(); j++) {//look through the UGC levels to see if any levels match the ID of the level your trying to load
                int thisLevelId = source.loadJSONArray(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+source.UGCNames.get(j)+"/index.json").getJSONObject(0).getInt("level_id");
                if (thisLevelId == llr.id) {
                  matchIDs.add(source.UGCNames.get(j));
                }
              }
              System.out.println(llr.hash+"\n===");
              for (int j=0; j<matchIDs.size(); j++) {//chek all the ID matches to see if any of them have the same hash as the level requested to load
                System.out.println(source.getLevelHash(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+matchIDs.get(i))+"\n=");
                if (source.getLevelHash(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+matchIDs.get(i)).equals(llr.hash)) {
                  levelName=matchIDs.get(i);
                  foundlevel=true;
                  break;
                }
              }
              if (foundlevel) {//if an exact match was found then load that and be readdy
                System.out.println("found requested level. loading...");
                source.loadLevel(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+levelName);
                source.bestTime=0;
                dataToSend.add(new BestScore(source.name, source.bestTime));
                readdy=true;
              } else {//get the level from the host
                System.out.println("requested level not found. attempting to download from host");
                dataToSend.add(new RequestLevel());
                downloadingLevel=true;
              }
            }
          }
          if (di instanceof CloseMenuRequest) {
            source.menue=false;
            source.bestTime=0;
            source.startTime=source.millis();
            source.timerEndTime=source.sessionTime+source.millis();
          }
          if (di instanceof PlayerInfo) {
            PlayerInfo pi = (PlayerInfo)di;
            for (int j=0; j<10; j++) {
              if (j!=playernumber) {
                source.players[j]=pi.players[j];
              }
            }
            viablePlayers=pi.visable;
          }
          if (di instanceof BackToMenuRequest) {
            source.menue=true;
            source.Menue="multiplayer selection";
            source.prevousInGame=false;
            readdy=false;
          }
          if (di instanceof LeaderBoard) {
            LeaderBoard lb = (LeaderBoard)di;
            source.leaderBoard=lb;
          }
          if (di instanceof CoOpStateInfo) {
            CoOpStateInfo cos = (CoOpStateInfo)di;
            source.level.variables=cos.vars;
            source.level.groups=cos.groups;
            source.level_complete=cos.levelCompleted;
          }
          if (di instanceof LevelDownloadInfo) {
            LevelDownloadInfo ldi = (LevelDownloadInfo)di;
            this.ldi=ldi;
            blockSize=ldi.blockSize;

            source.rootPath=source.appdata+"/CBi-games/skinny mann/UGC/levels/"+ldi.level.name+generateRandomString(20);
            ldi.level.save();
            currentDownloadIndex=-1;
            currentDownloadblock=-1;
            getNextLevelComponent();
          }
          if (di instanceof LevelFileComponentData) {
            LevelFileComponentData lfcd=(LevelFileComponentData)di;
            for (int j=0; j<lfcd.data.length && (j+currentDownloadblock*blockSize) < currentDownloadingFile.length; j++) {
              currentDownloadingFile[j+currentDownloadblock*blockSize] = lfcd.data[j];
            }
            getNextLevelComponent();
          }
          if(di instanceof MultyPlayerEntityInfo){
            MultyPlayerEntityInfo mei = (MultyPlayerEntityInfo)di;
            mei.setPos(source.level.stages.get(mei.getStage()).entities.get(mei.getIndex()));
            mei.setDead(source.level.stages.get(mei.getStage()).entities.get(mei.getIndex()));
          }
        }

        //outher misolenous processing
        //System.out.println(readdy);
        dataToSend.add(new ClientInfo(source.name, readdy, source.reachedEnd));
        if (source.inGame) {
          source.players[playernumber].name=source.name;
          dataToSend.add(new PlayerPositionInfo(source.players[playernumber]));
          if (source.level.multyplayerMode==1) {
            dataToSend.add(new BestScore(source.name, source.bestTime));
          }
        }
        //create the next packet to send
        generateSendPacket();

        //send data to server
        //System.out.println("sending "+source.frameCount);
        output.writeObject(toSend);
        sent=System.nanoTime();
        output.flush();
        output.reset();

        rs=(double)(sent/1000000-processStart/1000000);
        //System.out.println("send to recieve: "+sr+"\nrecieve to send: "+rs);
      }
    }
    catch(java.net.SocketTimeoutException s) {
      source.networkError(s);
    }
    catch(IOException i) {
      source.networkError(i);
    }
    catch(ClassNotFoundException c) {
      source.networkError(c);
    }
  }

  void disconnect() {
    System.out.println("disconnecting client "+ip);
    try {
      source.clients.remove(this);
    }
    catch(Exception e) {
    }
    try {
      output.close();
    }
    catch(Exception e) {
      System.out.println("output stream close failed");
      e.printStackTrace();
    }
    try {
      input.close();
    }
    catch(Exception e) {
      System.out.println("input stream close failed");
      e.printStackTrace();
    }
    try {
      socket.close();
    }
    catch(Exception e) {
      System.out.println("socket close failed");
      e.printStackTrace();
    }
  }

  public String toString() {
    return "client thread "+ip;
  }

  void generateSendPacket() {
    toSend=new NetworkDataPacket();
    while (dataToSend.size()>0) {
      toSend.data.add(dataToSend.remove(0));
    }
  }

  String generateRandomString(int size) {
    String out="";
    for (int i=0; i<size; i++) {
      out+=letters.charAt((int)source.random(0, letters.length()-1));
    }
    return out;
  }

  void getNextLevelComponent() {
    if (currentDownloadIndex==-1) {
      currentDownloadIndex=0;
      currentDownloadblock=0;
      if (ldi.files.length==0) {//if there are no file to download
        source.loadLevel(source.rootPath);
        source.bestTime=0;
        dataToSend.add(new BestScore(source.name, source.bestTime));
        readdy=true;
        downloadingLevel=false;
        return;
      }
      currentDownloadingFile=new byte[ldi.realSize[currentDownloadIndex]];
    } else {
      currentDownloadblock++;
      if (currentDownloadblock==ldi.fileSizes[currentDownloadIndex]) {
        //save that file to the disc
        source.saveBytes(source.rootPath+ldi.files[currentDownloadIndex], currentDownloadingFile);

        currentDownloadblock=0;
        currentDownloadIndex++;
        if (currentDownloadIndex==ldi.fileSizes.length) {
          //your done downloading
          source.loadLevel(source.rootPath);
          source.bestTime=0;
          dataToSend.add(new BestScore(source.name, source.bestTime));
          readdy=true;
          downloadingLevel=false;
          currentDownloadingFile=null;
          ldi=null;
          return;
        }
        currentDownloadingFile=new byte[ldi.realSize[currentDownloadIndex]];
      }
    }
    //you now have the next segemnt to download

    dataToSend.add(new RequestLevelFileComponent(currentDownloadIndex, currentDownloadblock));//request that segment
  }
}
