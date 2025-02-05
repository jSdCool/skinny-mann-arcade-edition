//Delay
import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class Delay extends LogicComponent {
  
  public static final Identifier ID = new Identifier("Delay");
  
  int time=10;
  ArrayList<Boolean> mem=new ArrayList<>();
  Delay(float x, float y, LogicBoard lb) {
    super(x, y, "delay", lb);
    button.setText("delay "+time+" ticks  ");
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }

  Delay(JSONObject data, LogicBoard lb) {
    super(data.getFloat("x"), data.getFloat("y"), "delay", lb, data.getJSONArray("connections"));
    time=data.getInt("delay");
    button.setText("delay "+time+" ticks  ");
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }
  
  public Delay(SerialIterator iterator){
    super(iterator);
    time = iterator.getInt();
  }

  void draw() {
    super.draw();
    source.fill(0);
    source.textSize(15);
    source.textAlign(source.LEFT, source.CENTER);
    source.text("input", (x+5-source.camPos)*source.Scale, (y+16-source.camPosY)*source.Scale);
    source.text("clear", (x+5-source.camPos)*source.Scale, (y+56-source.camPosY)*source.Scale);
  }

  void tick() {
    if (inputTerminal2) {
      mem=new ArrayList<>();
      for (int i=0; i<time; i++) {
        mem.add(false);
      }
    }
    outputTerminal=mem.remove(0);
    mem.add(inputTerminal1);
    //System.out.println(mem);
  }
  void setData(int data) {
    time=data;
    button.setText("delay "+time+" ticks  ");
    mem=new ArrayList<>();
    for (int i=0; i<time; i++) {
      mem.add(false);
    }
  }
  int getData() {
    return time;
  }

  JSONObject save() {
    JSONObject contence=super.save();
    contence.setInt("delay", time);
    return contence;
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    serialize(data);
    data.addInt(time);
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
