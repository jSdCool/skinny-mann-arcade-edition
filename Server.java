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
          Client newConnection = new Client(clientSocket, clientNumber);
          //System.out.println(newConnection);
          source.clients.add(newConnection);
          //System.out.println(source.clients);
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

  public void end() {
    System.out.println("disconnecting clients");
    while (source.clients.size()>0) {
      source.clients.get(0).disconnect();
    }
    System.out.println("stopping server");
    try {
      serverSocket.close();
    }
    catch(IOException e) {
    }
  }
}
