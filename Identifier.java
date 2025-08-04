import java.util.Objects;
import java.util.regex.Pattern;

/**A representation of Identification for a type of object
*/
public class Identifier {
    final String nameSpace;
    final String value;

    /**Create an identifier using seperate namespace and value strings.<br>
    Valid characters for identifiers are: [0-9 A-Z a-z - _] 
    @param namespace The name space of this identifier
    @param value The rest of the value of the identifier
    */
    public Identifier(String namespace,String value){
        //validate chars
        if(!isValidString(namespace)|| ! isValidString(value)){//verify that no illeagle characters exsist in this identifier
            throw new RuntimeException("Invalid char in Identifier! all chars in Identifiers must be [0-9 A-Z a-z - _]\n"+namespace+":"+value);
        }
        this.nameSpace=namespace;
        this.value=value;
    }

    /**Create an identifier using a single string. The name space will be automatically parsed from the input using a colon : as the delimiter between name space and value. If no namespace is inluded then the name space will default to skinny_mann.<br>
    Valid characters for identifiers are: [0-9 A-Z a-z - _] 
    @param id The string form of the identifier with an included name space
    */
    public Identifier(String id){
        String[] parts = id.split(":");//split the input at the name space delimiter
        if(parts.length>2){//if there is more then 1 :
            throw new RuntimeException("Identifier contains too many colon chars");
        }
        //for both parts
        for(String s:parts){
          //check that they only contain valid chars
            if(!isValidString(s)){
                System.err.println("Invalid Identifier: "+id);
                throw new RuntimeException("Invalid char in Identifier! all chars in Identifiers must be [0-9 A-Z a-z - _]\n"+id);
            }
        }
        //if there is only 1 part
        if(parts.length==1){
          //set the namespace to the default and the value to the rest
          nameSpace = "skinny_mann";
          value=id;
        }else{
          //set the namespace and value acordingly
          nameSpace = parts[0];
          value = parts[1];
        }

    }
    
    /**Test if the stting contains valid character for an identifier.<br>
    Valid chars are; [0-9 A-Z a-z - _]
    @param s The string to test
    @return true if the string is valid
    */
    public boolean isValidString(String s){
        String regex = "[a-zA-Z0-9_-]+";
        return Pattern.matches(regex,s);
    }

    /**Convert this identifier to a string
    @return the String verion of this identifier
    */
    @Override
    public String toString() {
        return nameSpace+":"+value;
    }
  
    /**Convert this identifier to a raw bytes representation
    @return An array of bytes that represents this identifier
    */
    public byte[] asBytes(){
        byte[] bytes = toString().getBytes();
        byte[] output = new byte[bytes.length+4];
        byte[] length = Serializers.intToBytes(bytes.length);
        output[0]=length[0];
        output[1]=length[1];
        output[2]=length[2];
        output[3]=length[3];
        System.arraycopy(bytes,0,output,4,bytes.length);
        return output;
    }
    
    /**Test if this identifier is the same as another
    @return true if the identifiers are the same 
    */
    @Override
    public boolean equals(Object o) {
        if (o == null) return false;
        if (this == o) return true;
        if (!(o instanceof Identifier)) return false;
        return Objects.equals(nameSpace, ((Identifier)o).nameSpace) && Objects.equals(value, ((Identifier)o).value);
    }

    /**Generate a hash code for this object
    @return The hash code
    */
    @Override
    public int hashCode() {
        return Objects.hash(nameSpace, value);
    }
    
    /**Utility method to sasnitize string so they can be used to make identifiers
    */
    public static String convertToId(String raw){
      return raw.trim().replaceAll(" ","_");
    }
}
