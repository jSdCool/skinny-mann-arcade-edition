import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Hasher {

  private static String getFileChecksum(MessageDigest digest, File file) throws IOException {//https://howtodoinjava.com/java/java-security/sha-md5-file-checksum-hash/
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

  public static String getFileHash(String filePath) {
    File file = new File(filePath);
    //Use SHA-1 algorithm
    MessageDigest shaDigest;
    try {
      shaDigest = MessageDigest.getInstance("SHA-256");
      //SHA-1 checksum
      return getFileChecksum(shaDigest, file);
    }
    catch (NoSuchAlgorithmException | IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      return null;
    }
  }
}
