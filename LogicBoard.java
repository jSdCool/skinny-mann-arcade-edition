import processing.core.*;
import processing.data.*;
import java.util.ArrayList;

class LogicBoard implements Serialization {//stores all the logic components

  public static final Identifier ID = new Identifier("LogicBoard");

  static transient skiny_mann source;
  public String name="eee";//temp name
  public ArrayList<LogicComponent> components=new ArrayList<>();
  LogicBoard(JSONArray file, Level level) {
    JSONObject head=file.getJSONObject(0);
    name=head.getString("name");
    for (int i=1; i<file.size(); i++) {
      JSONObject component=file.getJSONObject(i);
      String type=component.getString("type");
      if (type.equals("generic")) {
        components.add(new GenericLogicComponent(component, this));
      } else if (type.equals("AND")) {
        components.add(new AndGate(component, this));
      } else if (type.equals("OR")) {
        components.add(new OrGate(component, this));
      } else if (type.equals("XOR")) {
        components.add(new XorGate(component, this));
      } else if (type.equals("NAND")) {
        components.add(new NAndGate(component, this));
      } else if (type.equals("NOR")) {
        components.add(new NOrGate(component, this));
      } else if (type.equals("XNOR")) {
        components.add(new XNorGate(component, this));
      } else if (type.equals("ON")) {
        components.add(new ConstantOnSignal(component, this));
      } else if (type.equals("read var")) {
        components.add(new ReadVariable(component, this));
      } else if (type.equals("set var")) {
        components.add(new SetVariable(component, this));
      } else if (type.equals("set visable")) {
        components.add(new SetVisibility(component, this, level));
      } else if (type.equals("y-offset")) {
        components.add(new SetYOffset(component, this, level));
      } else if (type.equals("x-offset")) {
        components.add(new SetXOffset(component, this, level));
      } else if (type.equals("delay")) {
        components.add(new Delay(component, this));
      } else if (type.equals("z-offset")) {
        components.add(new SetZOffset(component, this, level));
      } else if ( type.equals("play sound")) {
        components.add(new LogicPlaySound(component, this, level));
      } else if (type.equals("pulse")) {
        components.add(new Pulse(component, this));
      } else if (type.equals("read 3D ")) {
        components.add(new Read3DMode(component, this));
      } else if (type.equals("  set 3D  ")) {
        components.add(new Set3DMode(component, this));
      } else if (type.equals(" random ")) {
        components.add(new Random(component, this));
      }
    }
  }
  
  LogicBoard(String name) {
    this.name=name;
  }

  public LogicBoard(SerialIterator iterator){
    name = iterator.getString();
    components = iterator.getArrayList();
  }
  
  String save() {
    JSONArray logicComponents=new JSONArray();
    JSONObject head=new JSONObject();
    head.setString("name", name);
    logicComponents.setJSONObject(0, head);
    for (int i=0; i<components.size(); i++) {
      logicComponents.setJSONObject(i+1, components.get(i).save());
    }
    source.saveJSONArray(logicComponents, source.rootPath+"/"+name+".json");
    return "/"+name+".json";
  }

  void remove(int index) {
    if (components.size()<=index||index<0)//check if the porvided index is valid
      return;
    components.remove(index);//remove the object
    for (int i=0; i<components.size(); i++) {//make shure all connects still point to the correct components and remove connects that went to the deleted one
      LogicComponent component=components.get(i);
      for (int j=0; j<component.connections.size(); j++) {
        if (component.connections.get(j)[0]==index) {
          component.connections.remove(j);
          j--;
          continue;
        }
        if (component.connections.get(j)[0]>index)
          component.connections.get(j)[0]--;
      }
    }
  }

  void tick() {//tick each component once
    for (int i=0; i<components.size(); i++) {
      components.get(i).tick();
    }
    for (int i=0; i<components.size(); i++) {
      components.get(i).sendOut();
    }
    for (int i=0; i<components.size(); i++) {
      components.get(i).flushBuffer();
    }
  }
  
  void superTick() {//ticked the logic board 256 times with no delay inbetween ticks
    for (int i=0; i<256; i++) {
      tick();
    }
  }
  
  @Override
  public SerializedData serialize() {
    SerializedData data = new SerializedData(id());
    data.addObject(SerializedData.ofString(name));
    data.addObject(SerializedData.ofArrayList(components,new Identifier("LogicComponent")));
    return data;
  }
  
  @Override
  public Identifier id() {
    return ID;
  }
}
