import java.net.ServerSocket;
import java.net.Socket;
import java.io.*;
/**Multyplayer Server conncetion handler
*/
public class Server extends Thread {
  static transient skiny_mann source;
  ServerSocket serverSocket;
  /**Create a server on the given port
  @param port The port to host the server on
  */
  Server(int port) {
    System.out.println("starting server");
    try {
      serverSocket = new ServerSocket(port);//create the server socket
      start();//start the server handling thread
    }catch(IOException i) {
    }
  }
  boolean isActive=true;
  /**The server connection handling thread
  */
  public void run() {
    try {
      serverSocket.setSoTimeout(50);//make it move on if no connection happens after 50ms
      while (!serverSocket.isClosed()) {//while the server is running
        try {
          Socket clientSocket = serverSocket.accept();//accept the incoming client, if no conenction happen within 50ms then a SocketTimeoutException will be thrown
          System.out.println("new client connected "+clientSocket.getInetAddress());
          int clientNumber=1;
          //find the next client number to set this one as
          for (int i=0; i<9; i++) {
            for (int j =0; j<source.clients.size(); j++) {
              if (source.clients.get(j).playernumber == clientNumber) {
                clientNumber++;
                break;
              }
            }
          }
          //if there are allready 10 or more people connected then
          if (clientNumber>=10) {
            clientSocket.close();//close the connection
            System.out.println("too many clients are connected disconnecting most recent client");//print an error to the console
            return;
          }
          Client newConnection = new Client(clientSocket, clientNumber);//create the client for this connection
          //System.out.println(newConnection);
          source.clients.add(newConnection);
          //System.out.println(source.clients);
        }catch(java.net.SocketTimeoutException s) {
        }catch(IOException i) {
          i.printStackTrace();
        }
      }
    } catch(java.net.SocketException s) {
    }
    isActive=false;
  }
  
  /**Stop the server
  */
  public void end() {
    System.out.println("disconnecting clients");
    while (source.clients.size()>0) {//disconnect all clients
      source.clients.get(0).disconnect();
    }
    System.out.println("stopping server");
    try {
      serverSocket.close();//close the server
    } catch(IOException e) {
    }
  }
}
