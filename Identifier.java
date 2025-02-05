import java.util.Objects;
import java.util.regex.Pattern;

public class Identifier {
    final String nameSpace;
    final String value;

    public Identifier(String namespace,String value){
        //validate chars
        if(!isValidString(namespace)|| ! isValidString(value))
            throw new RuntimeException("Invalid char in Identifier! all chars in Identifiers must be [0-9 A-Z a-z - _]");
        this.nameSpace=namespace;
        this.value=value;
    }

    public Identifier(String id){
        String[] parts = id.split(":");
        if(parts.length>2)
            throw new RuntimeException("Identifier contains too many colon chars");
        for(String s:parts){
            if(!isValidString(s)){
                System.err.println("Invalid Identifier: "+id);
                throw new RuntimeException("Invalid char in Identifier! all chars in Identifiers must be [0-9 A-Z a-z - _]\n"+id);
            }
        }

        if(parts.length==1){
            nameSpace = "skinny_mann";
            value=id;
        }else{
            nameSpace = parts[0];
            value = parts[1];
        }

    }

    public boolean isValidString(String s){
        String regex = "[a-zA-Z0-9_-]+";
        return Pattern.matches(regex,s);
    }

    @Override
    public String toString() {
        return nameSpace+":"+value;
    }

    public byte[] asBytes(){
        byte[] bytes =toString().getBytes();
        byte[] output = new byte[bytes.length+4];
        byte[] length = Serializers.intToBytes(bytes.length);
        output[0]=length[0];
        output[1]=length[1];
        output[2]=length[2];
        output[3]=length[3];
        System.arraycopy(bytes,0,output,4,bytes.length);
        return output;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Identifier)) return false;
        return Objects.equals(nameSpace, ((Identifier)o).nameSpace) && Objects.equals(value, ((Identifier)o).value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(nameSpace, value);
    }
}
