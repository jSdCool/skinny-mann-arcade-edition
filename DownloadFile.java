import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
/**Utility to download a file from a web url
*/
public class DownloadFile {
  /**Download a file from the provided url and save it to disk
  @param link The URL to download the file from
  @param fileName The file name/path to save the file at
  @param progress An array of length 2 where element 0 is the total ammount to be downloaded and element 1 is how much has been downloaded so far. This parameter acts as an output parameter. Can be null
  @throws IOException yeah it can theow execeptions some times, it does io
  */
  public static void download(String link, String fileName,long[] progress) throws IOException {

    URL url = new URL(link);
    URLConnection c = url.openConnection();//create the connection
    c.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 1.2.30703)");//set the useragent to the server thinks this is a normal web browser
    if(progress!=null && progress.length>=2){//set the total progrss if the passed in array supports it
      progress[0] = c.getContentLengthLong();
    }

    InputStream input;//prepair to start reading the response
    input = c.getInputStream();
    byte[] buffer = new byte[4096];
    int n = -1;

    OutputStream output = new FileOutputStream(new File(fileName));
    while ((n = input.read(buffer)) != -1) {//read in the response 
      if (n > 0) {
        output.write(buffer, 0, n);//write to the file
        if(progress!=null && progress.length>=2){//update the progrss if possible
          progress[1]+=n;
        }
      }
    }
    output.close();
  }
}
