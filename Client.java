import java.net.Socket;
import java.io.*;
import java.util.ArrayList;
class Client extends Thread {
  static skiny_mann source;
  int playernumber;
  Socket socket;
  ObjectOutputStream output;
  ObjectInputStream input;
  String ip="uninitilized", name="uninitilized";
  ArrayList<DataPacket> dataToSend=new ArrayList<>();
  NetworkDataPacket toSend=new NetworkDataPacket(), recieved;
  boolean versionChecked=false, readdy=false, viablePlayers[]=new boolean[10];
  BestScore bestScore=new BestScore("", 0);
  boolean reachedEnd;
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
            //System.out.println("c "+readdy);
          }
          if (di instanceof PlayerPositionInfo) {
            PlayerPositionInfo ppi = (PlayerPositionInfo)di;
            source.players[playernumber]=ppi.player;
          }
          if (di instanceof BestScore) {
            bestScore=(BestScore)di;
          }
        }

        ArrayList<String> names=new ArrayList<>();
        names.add(source.name);
        for (int i=0; i<source.clients.size(); i++) {
          names.add(source.clients.get(i).name);
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
          if(source.level.multyplayerMode==2){
            dataToSend.add(new CoOpStateInfo(source.level.variables,source.level.groups,source.level_complete));
          }
        }
        //create the next packet to send
        generateSendPacket();
      }
    }
    catch(java.net.SocketTimeoutException s) {
    }
    catch(IOException i) {
      //source.networkError(i);
    }
    catch(ClassNotFoundException c) {
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
            if (llr.isBuiltIn) {
              source.loadLevel(llr.path);
              source.bestTime=0;
              dataToSend.add(new BestScore(source.name, source.bestTime));
              readdy=true;
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
          }
          if (di instanceof LeaderBoard) {
            LeaderBoard lb = (LeaderBoard)di;
            source.leaderBoard=lb;
          }
          if(di instanceof CoOpStateInfo){
            CoOpStateInfo cos = (CoOpStateInfo)di;
            source.level.variables=cos.vars;
            source.level.groups=cos.groups;
            source.level_complete=cos.levelCompleted;
          }
        }

        //outher misolenous processing
        //System.out.println(readdy);
        dataToSend.add(new ClientInfo(source.name, readdy,source.reachedEnd));
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
}
