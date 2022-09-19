import java.net.ServerSocket;
import java.net.Socket;
import java.io.*;
class Server extends Thread {
  static skiny_mann source;
  ServerSocket serverSocket;
  Server(int port) {
    try {
      serverSocket = new ServerSocket(port);
      start();
    }
    catch(IOException i) {
    }
  }

  public void run() {
    try {
      serverSocket.setSoTimeout(50);
      while (!serverSocket.isClosed()) {
        try {
          Socket clientSocket=serverSocket.accept();
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
  }
}
