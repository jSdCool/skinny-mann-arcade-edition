import java.net.ServerSocket;
import java.net.Socket;
import java.io.*;
class Server extends Thread {
  static skiny_mann source;
  ServerSocket serverSocket;
  Server(int port) {
    System.out.println("starting server");
    try {
      serverSocket = new ServerSocket(port);
      start();
    }
    catch(IOException i) {
    }
  }
  boolean isActive=true;
  public void run() {
    try {
      serverSocket.setSoTimeout(50);
      while (!serverSocket.isClosed()) {
        try {
          Socket clientSocket=serverSocket.accept();
          System.out.println("new client connected "+clientSocket.getInetAddress());
          int clientNumber=1;
          for (int i=0; i<9; i++) {
            for (int j =0; j<source.clients.size(); j++) {
              if (source.clients.get(j).playernumber== clientNumber) {
                clientNumber++;
                break;
              }
            }
          }
          if (clientNumber>=10) {
            clientSocket.close();
            System.out.println("too many clients are connected disconnecting most recent client");
            return;
          }
          source.clients.add(new Client(clientSocket, clientNumber));
        }
        catch(java.net.SocketTimeoutException s) {
        }
        catch(IOException i) {
        }
      }
    }
    catch(java.net.SocketException s) {
    }
    isActive=false;
  }
  
  public void end(){
    for(int i=0;i<source.clients.size();i++){
      source.clients.get(i).disconnect();
    }
    try{serverSocket.close();}catch(IOException e){}
  }
}
