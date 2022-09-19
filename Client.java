import java.net.Socket;
import java.io.*;
class Client extends Thread {
  static skiny_mann source;
  int playernumber;
  Socket socket;
  ObjectOutputStream output;
  ObjectInputStream input;
  Client(Socket s){
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
    playernumber=num;
    Client(s);
  }
  
  public void run() {
    if (source.isHost) {
      //if this instance is the host of a multyplayer cession
      host();
    } else {
      //if this instanmce has joined a multyplayer cession
      joined();
    }
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
}
