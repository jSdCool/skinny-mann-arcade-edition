import net.java.games.input.*;

class ReadController{
  static void read(GamePadWrapper gp){
    /* Get the available controllers */
      Controller[] controllers = ControllerEnvironment
          .getDefaultEnvironment().getControllers();
      if (controllers.length == 0) {
        System.out.println("Found no controllers.");
        System.exit(0);
      }

      for (int i = 0; i < controllers.length; i++) {
        if(!controllers[i].getType().equals(Controller.Type.GAMEPAD)&&!controllers[i].getType().equals(Controller.Type.STICK)) {
          continue;
        }
        /* Remember to poll each one */
        controllers[i].poll();
        
        

        /* Get the controllers event queue */
        EventQueue queue = controllers[i].getEventQueue();
        
        /* Create an event object for the underlying plugin to populate */
        Event event = new Event();
        
        /* For each object in the queue */
        while (queue.getNextEvent(event)) {

          //StringBuffer buffer = new StringBuffer(controllers[i].getName());
          //buffer.append(" at ");
         // buffer.append(event.getNanos()).append(", ");
          Component comp = event.getComponent();
          //buffer.append(comp.getName()).append(" changed to ");
          float value = event.getValue();
          gp.updateComponent(comp.getIdentifier(),value);
          /*
           * Check the type of the component and display an
           * appropriate value
           */
          //if (comp.isAnalog()) {
          //  buffer.append(value);
          //} else {
          //  if (value == 1.0f) {
          //    buffer.append("On");
          //  } else {
          //    buffer.append("Off");
          //  }
          //}
          ////System.out.println(buffer.toString());
          //System.out.println(event+" "+comp.getIdentifier());
        }
        
      }

      /*
       * Sleep for 20 milliseconds, in here only so the example doesn't
       * thrash the system.
       */
      //try {
      //  Thread.sleep(20);
      //} catch (InterruptedException e) {
      //  // TODO Auto-generated catch block
      //  e.printStackTrace();
      //}
  }
}
