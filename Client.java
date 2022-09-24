import java.net.Socket;
import java.io.*;
class Client extends Thread {
  static skiny_mann source;
  int playernumber;
  Socket socket;
  ObjectOutputStream output;
  ObjectInputStream input;
  Client(Socket s){
    System.out.println("creating new client");
    try{
      socket=s;
      output=new ObjectOutputStream(socket.getOutputStream());
      input = new ObjectInputStream(socket.getInputStream());
    }catch(IOException i){
      source.networkError(i);
    }
    start();
  }
  Client(Socket s,int num){
    super("client number "+num);
    playernumber=num;
    new Client(s);
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
        output.writeObject("temp");
        output.flush();
        output.reset();
        
        //recieve data from client
        Object rawInput = input.readObject();
        //process input
        
      }
    }catch(IOException i){
      source.networkError(i);
    }
    catch(ClassNotFoundException c){
      source.networkError(c);
    }
  }
  
  void joined(){
    try{
      while (socket.isConnected()&&!socket.isClosed()) {
        //recieve data from server
        Object rawInput = input.readObject();
        //process input
        
        //send data to server
        output.writeObject("temp");
        output.flush();
        output.reset();
      }
    }catch(IOException i){
      source.networkError(i);
    }catch(ClassNotFoundException c){
      source.networkError(c);
    }
  }
  
  void disconnect(){
    try{output.close();}catch(IOException e){}
    try{input.close();}catch(IOException e){}
    try{socket.close();}catch(IOException e){}
  }
}
