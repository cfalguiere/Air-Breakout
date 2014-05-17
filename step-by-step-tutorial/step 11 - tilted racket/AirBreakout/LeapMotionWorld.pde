/**
 * Leap Motion World
 */
class LeapMotionWorld extends World  {
  PostOffice postOffice;  PApplet pApplet;
  LeapMotion leap;

  LeapMotionWorld(int portIn, int portOut, PostOffice aPostOffice) {
    super(portIn, portOut);
    postOffice = aPostOffice;
  }

  void setup() {
    leap = new LeapMotion(Hermes.getPApplet());
    int fps = leap.getFrameRate();
  }
  

  void preUpdate() {
     if (leap.getHands().size() > 0) {
       Hand hand = leap.getHands().get(0);
       PVector palmPosition = hand.getPalmPosition();
       float roll = radians(hand.getPitch());
       //println("palmPosition=" + palmPosition + " roll=" + roll);
       Message message = new HandMovementMessage(palmPosition.x, palmPosition.y + 50, roll);
       sendOscMessage(message);
     }
  }
  
  private void sendOscMessage(Message message) {
      postOffice.acceptMessage(new Date(), message.toOscMessage());
  }
}


class HandMovementMessage extends Message {
  float x;
  float y;
  float angle;
  
  HandMovementMessage(float ax, float ay, float anAngle) {
    x = ax;
    y = ay;
    angle = anAngle;
  }
  
  HandMovementMessage(OscMessage message) {
    x = message.getAndRemoveFloat();
    y = message.getAndRemoveFloat();
    angle = message.getAndRemoveFloat();
  }
  
  public com.illposed.osc.OSCMessage toOscMessage() {
    Object[] array = new Object[3];
    array[0] = x;
    array[1] = y;
    array[2] = angle;
    com.illposed.osc.OSCMessage message = new com.illposed.osc.OSCMessage(OSC_TOPIC_HAND_MOVEMENT, array);
    return message;
  }
  
}


