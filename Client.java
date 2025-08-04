import java.net.Socket;
import java.io.*;
import java.util.ArrayList;
/**Multyplayer client connection and handler
*/
public class Client extends Thread {
  static transient skiny_mann source;
  int playernumber, blockSize=10240, currentDownloadIndex, currentDownloadblock;
  Socket socket;
  ObjectSerializingOutputStream output;
  ObjectDeserializingInputStream input;
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
  long lastContactTime, ping;

  /**Create a new client. This is used when you are the client
  @param s The socket communicate over
  */
  public Client(Socket s) {
    super("Client thread");
    init(s);
  }
  /**Create a new client. This is used by the server to communicate with a client
  @param s The socket to communicate over
  @param num the client player number
  */
  public Client(Socket s, int num) {
    super("Client thread number: "+num);
    playernumber=num;
    init(s);
  }
  
  /**Initilize the common components of this class.<br>
  This exsists because I could not figure out how to call one constructor from another
  @param s The socket
  */
  private void init(Socket s) {
    System.out.println("creating new client");
    try {
      socket=s;
      //get the IO streams
      output=new ObjectSerializingOutputStream(socket.getOutputStream());
      input = new ObjectDeserializingInputStream(socket.getInputStream());
      //set the no response timeout (maximun waing time of 5 seconds before an exception is thrown)
      socket.setSoTimeout(5000);
    } catch(Exception i) {//if an error occors
      disconnect();//disconect the client and display the error
      source.networkError(i);
      return;
    }
    ip=socket.getInetAddress().toString();//save the other sides ip address
    System.out.println(ip);
    start();//start this client's network handling thread
  }

  /**Thread run method. The root function on this thread's stack
  */
  public void run() {
    if (source.isHost) {
      //if this instance is the host of a multyplayer sesscion
      System.out.println("starting client host loop");
      host();
    } else {
      //if this instanmce has joined a multyplayer session
      System.out.println("statring client joined loop");
      joined();
    }
    disconnect();
  }

  /**The host side network functions 
  */
  private void host() {
    try {
      //untill the connection closes
      while (socket.isConnected()&&!socket.isClosed()) {
        //send data to client
        
        output.write(toSend);//send bufferd send data to the client
        output.flush();
        
        //calculate Ping
        ping = System.nanoTime() - lastContactTime;
        lastContactTime = System.nanoTime();

        //recieve data from client
        Object rawInput = input.readSerializedObject();

        
        //process input data from client
        recieved=(NetworkDataPacket)rawInput;//cast to custom data type
        for (int i=0; i<recieved.data.size(); i++) {//for each peice of data recieved from the client
          DataPacket di = recieved.data.get(i);//get the data packet
          if (di instanceof ClientInfo) {//if the packet is a client info
            ClientInfo ci = (ClientInfo)di;//extract the info
            this.name = ci.name;
            this.readdy=ci.readdy;
            reachedEnd=ci.atEnd;
            if (readdy&&outherFiles!=null&&!downloadingLevel) {//reset level downloading status if nessarry
              outherFiles=null;
              ldi=null;
              downloadingLevel=false;
            }
            //System.out.println("c "+readdy);
          }
          if (di instanceof PlayerPositionInfo) {//if the packet is player position info
            PlayerPositionInfo ppi = (PlayerPositionInfo)di;
            source.players[playernumber]=ppi.player;//replce that player with the version sent over by the client
          }
          if (di instanceof BestScore) {//if the packet is a best score, store that locally
            bestScore=(BestScore)di;
          }
          if (di instanceof RequestLevel) {//if the packet is request level
            System.out.println(ip+" requested to download the level");
            downloadingLevel=true;
            //collect data about the level files
            String fileNames[] = source.level.getOutherFileNames();
            int fileSizes[]=new int[fileNames.length];
            int realSizes[]=new int[fileNames.length];
            outherFiles=new byte[fileNames.length][];
            //for each file
            for (int j=0; j<fileNames.length; j++) {
              outherFiles[j]=source.loadBytes(source.rootPath+fileNames[j]);//save the contence of the files for later
              fileSizes[j]=outherFiles[j].length/blockSize;//get the file size in hole blocks
              fileSizes[j]+=((outherFiles[j].length%blockSize==0) ? 0 : 1);//if some bites are clipped off by the number of blocks then add 1 more
              realSizes[j]=outherFiles[j].length;
            }
            //create a level download info packet and send it
            ldi=new LevelDownloadInfo(source.level, fileNames, fileSizes, blockSize, realSizes);
            dataToSend.add(ldi);
          }
          
          if (di instanceof RequestLevelFileComponent) {//if the packet is requesting a file component from a level
            RequestLevelFileComponent rlfc = (RequestLevelFileComponent)di;
            System.out.println(ip+" has requested file "+rlfc.file+" block "+rlfc.block);
            byte sendBytes[]=new byte[blockSize];
            //get that chunk of data and package its bytes into an array then send it
            for (int j=0; j < blockSize && (j+rlfc.block*blockSize) < outherFiles[rlfc.file].length; j++) {
              sendBytes[j]=outherFiles[rlfc.file][j+rlfc.block*blockSize];
            }
            //respond with the data
            dataToSend.add(new LevelFileComponentData(sendBytes));
          }
          
          if(di instanceof KillEntityDataPacket){//if the packet is a kill entity packet
            KillEntityDataPacket ke = (KillEntityDataPacket)di;//kill the entity in question
            source.level.stages.get(ke.getStage()).entities.get(ke.getIndex()).kill();
          }
        }
        
        //prepair data to send to client
        
        //create a name list of the players in the session
        ArrayList<String> names=new ArrayList<>();
        names.add(source.name);
        for (int j=0; j<source.clients.size(); j++) {
          names.add(source.clients.get(j).name);
        }
        //send that along with other basic session info to the client
        dataToSend.add(new InfoForClient(playernumber, names, source.version, source.inGame||(source.prevousInGame&&source.Menue.equals("settings")), source.sessionTime));
        //if the host is in the menu
        if (source.menue) {
          //if the menu is the level select screen
          if (source.Menue.equals("multiplayer selection")) {
            //send the information about the currently selected level to the client
            dataToSend.add(source.multyplayerSelectedLevel);
          }
        }
        //if the host is currently in a game
        if (source.inGame) {
          //collect info about which shirt colors are currenly in use
          viablePlayers=new boolean[10];
          viablePlayers[0]=true;
          for (int i=0; i<source.clients.size(); i++) {
            viablePlayers[source.clients.get(i).playernumber]=true;
          }
          //send the general info about all the players in the session
          dataToSend.add(new PlayerInfo(source.players, viablePlayers));
          //if the level is in speedrun mode
          if (source.level.multyplayerMode==1) {
            //send the leaderboard to the clients
            dataToSend.add(source.leaderBoard);
          }
          //if the level is in co op mode
          if (source.level.multyplayerMode==2) {
            //send co op information to the client
            dataToSend.add(new CoOpStateInfo(source.level.variables, source.level.groups, source.level_complete));
            
            //send the client info about all entities in the level                            
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
    } catch(java.net.SocketTimeoutException s) {//if a timeout occors then just do nothing and go on to the next network frame
      if(source.dev_mode){
        s.printStackTrace();//for DEBUG ONLY diabled for final build
      }
    } catch(IOException i) {//if a random io excption occors then just do nothing and skip to the next network frame
      i.printStackTrace();
      //source.networkError(i);
    } catch(Exception e) {//if a reanomd exception occors then jsut do nothing and skip to the next network frame
      e.printStackTrace();
    }
  }

  /**Client side networking functions
  */
  private void joined() {
    try {
      //untill the connection closes
      while (socket.isConnected()&&!socket.isClosed()) {
        //calculate Ping
        ping = System.nanoTime() - lastContactTime;
        lastContactTime = System.nanoTime();
        
        //recieve data from server
        Object rawInput = input.readSerializedObject();

        //process data from server
        recieved=(NetworkDataPacket)rawInput;
        //for each peice of data from the server
        for (int i=0; i<recieved.data.size(); i++) {
          DataPacket di = recieved.data.get(i);//get the data packet
          if (di instanceof InfoForClient) {//if the packet is info for the client
            InfoForClient ifc = (InfoForClient)di;//extract the fino
            source.playerNames=ifc.playerNames;
            playernumber=ifc.playerNumber;
            source.currentPlayer=playernumber;
            //if the version has not been checked then
            if (!versionChecked) {
              //check to make sure that the client and server on the same version of the game
              if (source.version.equals(ifc.hostVersion)) {
                versionChecked=true;
              } else {//if they are not on the same version of the game
                throw new IOException("host and client are not on the same version\nhost is on "+ifc.hostVersion);// throw an error because who knows what could go wrong
              }
            }
            if (!source.prevousInGame){//if not in the settings menu
              source.inGame=ifc.inGame;//set wether currently in the game
            }
            source.sessionTime=ifc.sessionTime;//load the current ammount of time left
          }
          if (di instanceof SelectedLevelInfo) {//if the packet is selecetd level info
            SelectedLevelInfo sli = (SelectedLevelInfo)di;
            source.multyplayerSelectedLevel=sli;
          }
          if (di instanceof LoadLevelRequest) {//if the packer is a request to load a level
            LoadLevelRequest llr = (LoadLevelRequest)di;
            if (llr.isBuiltIn) {//if the level to load is included with the game
              source.loadLevel(llr.path);//load the level 
              source.bestTime=0;
              dataToSend.add(new BestScore(source.name, source.bestTime));//send the initial best score to the server
              readdy=true;
            } else {//if the level to load is UGC
              source.loadUGCList();//load the list of UGC levels on this device
              boolean foundlevel=false;
              String levelName="";
              ArrayList<String> matchIDs =new ArrayList<>();
              for (int j=0; j<source.UGCNames.size(); j++) {//look through all the UGC levels to see if any levels match the ID of the level your trying to load
                int thisLevelId = source.loadJSONArray(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+source.UGCNames.get(j)+"/index.json").getJSONObject(0).getInt("level_id");
                if (thisLevelId == llr.id) {
                  matchIDs.add(source.UGCNames.get(j));
                }
              }
              System.out.println(llr.hash+"\n===");
              //now we have a list of levels whos ids match the id of the level we want to load
              for (int j=0; j<matchIDs.size(); j++) {//chek all the ID matches to see if any of them have the same hash as the level requested to load
                System.out.println(source.getLevelHash(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+matchIDs.get(i))+"\n=");
                if (source.getLevelHash(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+matchIDs.get(i)).equals(llr.hash)) {//if the hashes match
                  levelName=matchIDs.get(i);//set the level to found
                  foundlevel=true;
                  break;
                }
              }
              if (foundlevel) {//if an exact match was found then load that and be readdy
                System.out.println("found requested level. loading...");
                source.loadLevel(source.appdata+"/CBi-games/skinny mann/UGC/levels/"+levelName);//load the level
                source.bestTime=0;
                dataToSend.add(new BestScore(source.name, source.bestTime));//send the initial best score to the server
                readdy=true;
              } else {//no match was found so get the level from the host
                System.out.println("requested level not found. attempting to download from host");
                dataToSend.add(new RequestLevel());//send a request to the server to download the level in question 
                downloadingLevel=true;
              }
            }
          }
          if (di instanceof CloseMenuRequest) { //if the packet is a request to close the menu
            source.menue=false;//turn menu mode off
            source.bestTime=0;//reset the best time
            source.startTime=source.millis();//reset the level start time
            source.timerEndTime=source.sessionTime+source.millis();//set the level timer end time
          }
          if (di instanceof PlayerInfo) { // if the packet is player info
            PlayerInfo pi = (PlayerInfo)di;
            for (int j=0; j<10; j++) {//for each of the posible player slots
              if (j!=playernumber) {//if this player slot is the slot representing this player, then skip it
                source.players[j]=pi.players[j];//assign the version of the player from the packet to what will be renderd
              }
            }
            viablePlayers=pi.visable;//extract the visable players list
          }
          if (di instanceof BackToMenuRequest) {//if the packet is a request to go back to the menu
            source.menue=true;//turn menu mode on
            source.Menue="multiplayer selection";//set the menu to the multyplayer menue
            source.prevousInGame=false;//take you out of the setting menu if you were in it
            readdy=false;//make sure to diable readdy
          }
          if (di instanceof LeaderBoard) {//if the packet is the leadrboard
            LeaderBoard lb = (LeaderBoard)di;
            source.leaderBoard=lb;//extract the leaderboard
          }
          if (di instanceof CoOpStateInfo) {//if the packet is co op state information
            CoOpStateInfo cos = (CoOpStateInfo)di;//extract the info
            source.level.variables=cos.vars;
            source.level.groups=cos.groups;
            source.level_complete=cos.levelCompleted;
          }
          if (di instanceof LevelDownloadInfo) {//if the packet is level download info
            LevelDownloadInfo ldi = (LevelDownloadInfo)di;
            this.ldi=ldi;
            blockSize=ldi.blockSize;//get the block size this level is going to be downloaded with

            source.rootPath=source.appdata+"/CBi-games/skinny mann/UGC/levels/"+ldi.level.name+generateRandomString(20);//create the folder to download the level to. The name being <level name>+<random string> this is to ensure it does not overrite an exsising level with that name
            source.level = ldi.level;//extract the serialized level data
            ldi.level.save(false);//save that level data to disk
            source.level = null;//clear the content of the level so we dont acedentaly use a potentiallty borken level causeing other errors
            currentDownloadIndex=-1;//set the index of the file component to download to -1
            currentDownloadblock=-1;
            getNextLevelComponent();//activate the logic to request the next file component or finish the process of downloading a level
          }
          if (di instanceof LevelFileComponentData) {//if the packet is level file component data
            LevelFileComponentData lfcd=(LevelFileComponentData)di;
            for (int j=0; j<lfcd.data.length && (j+currentDownloadblock*blockSize) < currentDownloadingFile.length; j++) {//for each byte of file data in the packet that is not over the length of the file
              currentDownloadingFile[j+currentDownloadblock*blockSize] = lfcd.data[j];//copy the byte to the file's data
            }
            getNextLevelComponent();//ask for the next file component or finsih the level download process
          }
          if(di instanceof MultyPlayerEntityInfo){ // if the packet is multyplayer entity info
            MultyPlayerEntityInfo mei = (MultyPlayerEntityInfo)di;//extract the data and send it to the correct place
            mei.setPos(source.level.stages.get(mei.getStage()).entities.get(mei.getIndex()));//here we pass in the entity and the object will do all the setting up for us
            mei.setDead(source.level.stages.get(mei.getStage()).entities.get(mei.getIndex()));
          }
        }

        //prepair data to send to the server
        dataToSend.add(new ClientInfo(source.name, readdy, source.reachedEnd));//send basic info about this client to the server
        if (source.inGame) {//if in game
          source.players[playernumber].name=source.name;//set your player's name to your name
          dataToSend.add(new PlayerPositionInfo(source.players[playernumber]));//send your player data to the server
          if (source.level.multyplayerMode==1) {//if in speedrun mode
            dataToSend.add(new BestScore(source.name, source.bestTime));//send your best score to the server
          }
        }
        //create the next packet to send
        generateSendPacket();

        //send data to server
        output.write(toSend);
        output.flush();

      }
    } catch(java.net.SocketTimeoutException s) {//if a read times out
      source.networkError(s);//show the error closeing the connetion
    } catch(IOException i) {//if an IO exception happens
      source.networkError(i);//show the error and close the connection
    } catch(Exception e){//if any other exeception occors
      source.networkError(e);//show the error and close the connection
    }
  }

  /**Properly and safley disconnect the client fully closing the connection
  */
  public void disconnect() {
    System.out.println("disconnecting client "+ip);
    try {
      source.clients.remove(this);//remove this client from the list of clients
    } catch(Exception e) { }
    try {
      output.close();//close the output stream
    } catch(Exception e) {
      System.out.println("output stream close failed");
      e.printStackTrace();
    }
    try {
      input.close();//lose the input stream
    } catch(Exception e) {
      System.out.println("input stream close failed");
      e.printStackTrace();
    }
    try {
      socket.close();//finally, close the connection overall
    } catch(Exception e) {
      System.out.println("socket close failed");
      e.printStackTrace();
    }
  }

  /**get an info string of this client
  */
  public String toString() {
    return "client thread "+ip;
  }

  /**genrate the finall packet that will be sent to the other side
  */
  private void generateSendPacket() {
    toSend=new NetworkDataPacket();
    while (dataToSend.size()>0) {
      toSend.data.add(dataToSend.remove(0));//take eveyhting in the to send buffer and add it to the to send data packet
    }
  }

  /**Generate a random string of the proviede length
  @param size How many charater to generate
  @return a string of the given length continaing random characters
  */
  public String generateRandomString(int size) {
    String out="";
    for (int i=0; i<size; i++) {
      out+=letters.charAt((int)source.random(0, letters.length()-1));
    }
    return out;
  }

  /**called by the client to initiate requesting the next level component from the server
  */
  private void getNextLevelComponent() {
    //if this is the first thing to be rquested
    if (currentDownloadIndex==-1) {
      
      currentDownloadIndex=0;
      currentDownloadblock=0;
      if (ldi.files.length==0) {//if there are no files to download
        //load the level that was downloaded and send the ready signal to the server
        source.loadLevel(source.rootPath);
        source.bestTime=0;
        dataToSend.add(new BestScore(source.name, source.bestTime));
        readdy=true;
        downloadingLevel=false;
        return;
      }
      //alocate the memory for the file to be downloaded into
      currentDownloadingFile=new byte[ldi.realSize[currentDownloadIndex]];
    } else {//if this is not the first time this method was called
      //set the block to download to the next one
      currentDownloadblock++;
      //if the next block is outside the number of blocks that file has
      if (currentDownloadblock==ldi.fileSizes[currentDownloadIndex]) {
        //save that file to the disc
        source.saveBytes(source.rootPath+ldi.files[currentDownloadIndex], currentDownloadingFile);

        //reset the block index to 0 and increase the file index
        currentDownloadblock=0;
        currentDownloadIndex++;
        //if the file index is the same the the number of total files to download
        if (currentDownloadIndex==ldi.fileSizes.length) {
          //your done downloading
          //load the level and send the ready signal to the server
          source.loadLevel(source.rootPath);
          source.bestTime=0;
          dataToSend.add(new BestScore(source.name, source.bestTime));
          readdy=true;
          downloadingLevel=false;
          currentDownloadingFile=null;
          ldi=null;
          return;
        }
        //allocate the space for the next file to be downloaded
        currentDownloadingFile=new byte[ldi.realSize[currentDownloadIndex]];
      }
    }
    //you now have the next segemnt to download
    //request that block from the server
    dataToSend.add(new RequestLevelFileComponent(currentDownloadIndex, currentDownloadblock));//request that segment
  }
}
