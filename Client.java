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
  boolean versionChecked=false;
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
          }
        }
        
        ArrayList<String> names=new ArrayList<>();
        names.add(source.name);
        for(int i=0;i<source.clients.size();i++){
          names.add(source.clients.get(i).name);
        }
        dataToSend.add(new InfoForClient(playernumber,names,source.version));
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
            if(!versionChecked){
              if(source.version.equals(ifc.hostversion)){
                versionChecked=true;
              }else{
                throw new IOException("host and client are not on the same version");
              }
            }
          }
          
        }
        
        //outher misolenous processing 
        dataToSend.add(new ClientInfo(source.name));
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
