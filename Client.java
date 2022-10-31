import java.net.Socket;
import java.io.*;
import java.util.ArrayList;
class Client extends Thread {
  static skiny_mann source;
  int playernumber;
  Socket socket;
  ObjectOutputStream output;
  ObjectInputStream input;
  String ip="uninitilized",name="uninitilized";
  ArrayList<DataPacket> dataToSend=new ArrayList<>();
  NetworkDataPacket toSend=new NetworkDataPacket(),recieved;
  boolean versionChecked=false,readdy=false,viablePlayers[]=new boolean[10];
  Client(Socket s){
    init(s);
  }
  Client(Socket s,int num){
    super("client number "+num);
    playernumber=num;
    init(s);
  }
  
  void init(Socket s){
    System.out.println("creating new client");
    try{
      socket=s;
      output=new ObjectOutputStream(socket.getOutputStream());
      input = new ObjectInputStream(socket.getInputStream());
      socket.setSoTimeout(5000);
    }catch(Exception i){
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
  
  void host(){
    try{
      while (socket.isConnected()&&!socket.isClosed()) {
        //send data to client
        
        output.writeObject(toSend);
        output.flush();
        output.reset();
        
        //recieve data from client
        Object rawInput = input.readObject();
        //process input
        recieved=(NetworkDataPacket)rawInput;
        for(int i=0;i<recieved.data.size();i++){
          DataPacket di = recieved.data.get(i);
          if(di instanceof ClientInfo){
            ClientInfo ci = (ClientInfo)di;
            this.name = ci.name;
            this.readdy=ci.readdy;
            //System.out.println("c "+readdy);
          }
        }
        
        ArrayList<String> names=new ArrayList<>();
        names.add(source.name);
        for(int i=0;i<source.clients.size();i++){
          names.add(source.clients.get(i).name);
        }
        dataToSend.add(new InfoForClient(playernumber,names,source.version,source.inGame));
        if(source.menue){
           if(source.Menue.equals("multiplayer selection")){
             dataToSend.add(source.multyplayerSelectedLevel);
           }
        }
        if(source.inGame){
          viablePlayers=new boolean[10];
          viablePlayers[0]=true;
          for(int i=0;i<source.clients.size();i++){
            viablePlayers[source.clients.get(i).playernumber]=true;
          }
          dataToSend.add(new PlayerInfo(source.players,viablePlayers));
        }
        //create the next packet to send
        generateSendPacket();
      }
    }catch(java.net.SocketTimeoutException s){
      
    
    }catch(IOException i){
      //source.networkError(i);
    }
    catch(ClassNotFoundException c){
      //source.networkError(c);
    }
  }
  
  void joined(){
    try{
      while (socket.isConnected()&&!socket.isClosed()) {
        //recieve data from server
        Object rawInput = input.readObject();
        //process input
        recieved=(NetworkDataPacket)rawInput;
        for(int i=0;i<recieved.data.size();i++){
          DataPacket di = recieved.data.get(i);
          if(di instanceof InfoForClient){
            InfoForClient ifc = (InfoForClient)di;
            source.playerNames=ifc.playerNames;
            playernumber=ifc.playerNumber;
            source.currentPlayer=playernumber;
            if(!versionChecked){
              if(source.version.equals(ifc.hostVersion)){
                versionChecked=true;
              }else{
                throw new IOException("host and client are not on the same version\nhost is on "+ifc.hostVersion);
              }
            }
            source.inGame=ifc.inGame;
          }
          if(di instanceof SelectedLevelInfo){
            SelectedLevelInfo sli = (SelectedLevelInfo)di;
            source.multyplayerSelectedLevel=sli;
          }
          if(di instanceof LoadLevelRequest){
            LoadLevelRequest llr = (LoadLevelRequest)di;
            if(llr.isBuiltIn){
              source.loadLevel(llr.path);
              readdy=true;
            }
          }
          if(di instanceof CloseMenuRequest){
            source.menue=false;
          }
          if(di instanceof PlayerInfo){
            PlayerInfo pi = (PlayerInfo)di;
            for(int j=0;j<10;j++){
              if(j!=playernumber){
                source.players[j]=pi.players[j];
              }
            }
            viablePlayers=pi.visable;
          }
          
        }
        
        //outher misolenous processing 
        System.out.println(readdy);
        dataToSend.add(new ClientInfo(source.name,readdy));
        //create the next packet to send
        generateSendPacket();
        
        //send data to server
        output.writeObject(toSend);
        output.flush();
        output.reset();
      }
    }catch(java.net.SocketTimeoutException s){
      source.networkError(s);
    }catch(IOException i){
      source.networkError(i);
    }catch(ClassNotFoundException c){
      source.networkError(c);
    }
  }
  
  void disconnect(){
    System.out.println("disconnecting client "+ip);
    try{source.clients.remove(this);}catch(Exception e){}
    try{output.close();}catch(Exception e){System.out.println("output stream close failed");e.printStackTrace();}
    try{input.close();}catch(Exception e){System.out.println("input stream close failed");e.printStackTrace();}
    try{socket.close();}catch(Exception e){System.out.println("socket close failed");e.printStackTrace();}
  }
  
  public String toString(){
    return "client thread "+ip;
  }
  
  void generateSendPacket(){
    toSend=new NetworkDataPacket();
    while(dataToSend.size()>0){
      toSend.data.add(dataToSend.remove(0));
    }
  }

}
