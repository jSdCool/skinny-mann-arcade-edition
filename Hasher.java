import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
/**Utility class that contains methods to generate file hashes
*/
public class Hasher {
  
  /**Generate a checksum for a given file.<br>
  Refrece from <a href = "https://howtodoinjava.com/java/java-security/sha-md5-file-checksum-hash/"> here </a>
  @param digest The check sum algorythem to use
  @param file The file to generate the check sum of
  @return The check sum of the file
  */
  private static String getFileChecksum(MessageDigest digest, File file) throws IOException {//
    //Get file input stream for reading the file content
    FileInputStream fis = new FileInputStream(file);

    //Create byte array to read data in chunks
    byte[] byteArray = new byte[1024];
    int bytesCount = 0;

    //Read file data and update in message digest
    while ((bytesCount = fis.read(byteArray)) != -1) {
      digest.update(byteArray, 0, bytesCount);
    };

    //close the stream; We don't need it now.
    fis.close();

    //Get the hash's bytes
    byte[] bytes = digest.digest();

    //This bytes[] has bytes in decimal format;
    //Convert it to hexadecimal format
    StringBuilder sb = new StringBuilder();
    for (int i=0; i< bytes.length; i++)
    {
      sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
    }

    //return complete hash
    return sb.toString();
  }
  
  /**Genrate the SHA-256 hash of the given file
  @param filePath The path to the file to hash
  @return The SHA-256 hash of the file
  */
  public static String getFileHash(String filePath) {
    File file = new File(filePath);
    //Use SHA-256 algorithm
    MessageDigest shaDigest;
    try {
      shaDigest = MessageDigest.getInstance("SHA-256");
      //generate the check sum
      return getFileChecksum(shaDigest, file);
    }
    catch (NoSuchAlgorithmException | IOException e) {
      e.printStackTrace();
      return null;
    }
  }
}
