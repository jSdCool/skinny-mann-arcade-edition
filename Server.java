import java.net.ServerSocket;
import java.net.Socket;
import java.io.*;
class Server extends Thread{
  static skiny_mann source;
  ServerSocket serverSocket;
  Server(int port){
    serverSocket = new ServerSocket(port);
    start();
  }
  
  public void run(){
    serverSocket.setSoTimeout(50);
    while(!serverSocket.isClosed()){
     try{
       Socket clientSocket=serverSocket.accept();
       int clientNumber=1;
       for(int i=0;i<9;i++){
         for(int j =0;j<source.clients.size();j++){
          if(source.clients.get(j).playernumber== clientNumber){
            clientNumber++;
            break;
          }
         }
       }
       if(clientNumber>=10){
         clientSocket.close();
        return; 
       }
       source.clients.add(new Client(clientSocket,clientNumber));
     }catch(java.net.SocketTimeoutException s){
       
     }
    }
  }
}
