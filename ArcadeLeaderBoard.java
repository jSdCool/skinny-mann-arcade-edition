import processing.core.*;

class ArcadeLeaderBoard{
  LeaderBoard[] leaderBoards = new LeaderBoard[12];
  
  ArcadeLeaderBoard(String file,PApplet source){
    String[] rawCSV = source.loadStrings(file);
    for(int i=0;i<rawCSV.length;i++){
      leaderBoards[i] = new LeaderBoard(rawCSV[i]);
    }
  }
  
  void save(String fileName,PApplet source){
    String[] output = new String[leaderBoards.length];
    for(int i=0;i<leaderBoards.length;i++){
      output[i]=leaderBoards[i].toString();
    }
    source.saveStrings(fileName,output);
  }
  
  boolean checkScore(String levelName,String score){
    LeaderBoard lb = getleaderBoard(levelName);
    Score[] scores = lb.getScores();
    for(int i=0;i<scores.length;i++){
      if(!scoreGreater(score,scores[i].getValue())){
        return true;
      }
    }
    return false;
  }
  
  String[][] getScores(String levelName){
    String[][] output = new String[10][2];
    
    LeaderBoard lb = getleaderBoard(levelName);
    
    Score[] scores = lb.getScores();
    for(int i=0;i<10;i++){
      output[i][0] = scores[i].getName();
      output[i][1] = scores[i].getValue();
    }
    
    return output;
  }
  
  void addScore(String levelName,String score,String playerName){
    LeaderBoard lb = getleaderBoard(levelName);
    Score[] scores = lb.getScores();
    int r = 0;
    for(;r<scores.length;r++){
      if(!scoreGreater(score,scores[r].getValue())){
        break;
      }
    }
    if(r==scores.length){
      return;
    }
    for(int i=scores.length-1;i>r;i--){
      scores[i]=scores[i-1];
    }
    scores[r] = new Score(playerName,score);
  }
  
  LeaderBoard getleaderBoard(String levelName){
    LeaderBoard lb = null;
    for(int i=0;i<leaderBoards.length;i++){
      if(leaderBoards[i].getName().equals(levelName)){
        lb=leaderBoards[i];
        break;
      }
    }
    if(lb==null){
      throw new RuntimeException("lb was null");
    }
    return lb;
  }
  
  boolean scoreGreater(String scoreA,String scoreB){
    if(scoreA.equals(scoreB)){//if they are the same then they are not greater
      return false;
    }
    String[] aParts= scoreA.split(":");
    String[] bParts= scoreB.split(":");
    int[] aints=new int[3],bints = new int[3];
    aints[0] = Integer.parseInt(aParts[0]);
    aints[1] = Integer.parseInt(aParts[1]);
    aints[2] = Integer.parseInt(aParts[2]);
    bints[0] = Integer.parseInt(bParts[0]);
    bints[1] = Integer.parseInt(bParts[1]);
    bints[2] = Integer.parseInt(bParts[2]);
    
    if(aints[0] == 0 && aints[1] == 0 && aints[2] == 0){//if it is 0 then it is greater. zero is greater then everything
      return true;
    }
    if(bints[0] == 0 && bints[1] == 0 && bints[2] == 0){//if it is 0 then it is greater. zero is greater then everything
      return false;
    }
    
    if(aints[0]>bints[0]){//if a part 1 is greater then b part 1
      return true;//return true
    } else if(aints[0] == bints[0]){//else if a part 1 is equal to b part 1
      if(aints[1]>bints[1]){//if a part 2 is greater then b part 2
        return true;//return true
      } else if(aints[1] == bints[1]){//else id a part 2 is equal to b part 2
        if(aints[2]>bints[2]){
          return true;
        }
      }
    }
    
    return false;
  }
  
  
  public String toString(){
    String out="";
    for(int i=0;i<leaderBoards.length;i++){
      out+=leaderBoards[i].toString()+"\n";
    }
    return out;
  }
  class LeaderBoard{
    String levelName;
    Score[] scores = new Score[10];
    LeaderBoard(String raw){
      String[] parts = raw.split(",");
      levelName=parts[0];
      
      if(parts.length==1){//if only a level name exsists
        for(int i=0;i<scores.length;i++){
          scores[i]=new Score("---","0:0:0");
        }
        return;
      }
      
      for(int i=0;i<scores.length&& (2*i+2) <parts.length;i++){
        scores[i]=new Score(parts[2*i+1],parts[2*i+2]);
      }
      for(int i=0;i<scores.length;i++){
        if(scores[i]==null)
          scores[i]=new Score("---","0:0:0");
      }
      
    }
    
    public String toString(){
      String out = levelName;
      for(int i=0;i<scores.length;i++){
        out+=","+scores[i].toString();
      }
      return out;
    }
    
    public String getName(){
      return levelName;
    }
    
    public Score[] getScores(){
      return scores;
    }
    
  }
  
  class Score{
    String name,value;
    Score(String name,String value){
      this.name=name;
      this.value=value;
    }
    
    public String toString(){
      return name+","+value;
    }
    
    public String getName(){
      return name;
    }
    
    public String getValue(){
      return value;
    }
  }
}
