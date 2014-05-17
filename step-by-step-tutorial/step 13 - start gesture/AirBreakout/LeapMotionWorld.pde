/**
 * Leap Motion World
 */
class LeapMotionWorld extends World  {
  PostOffice postOffice;  PApplet pApplet;
  LeapMotion leap;
  long lastCircleFrame = 0;

  LeapMotionWorld(int portIn, int portOut, PostOffice aPostOffice) {
    super(portIn, portOut);
    postOffice = aPostOffice;
  }

  void setup() {
    log(this, "setting up");

    leap = new LeapMotion(Hermes.getPApplet());
    int fps = leap.getFrameRate();
    
    leap.getController().enableGesture(Gesture.Type.TYPE_CIRCLE);
  }
  
  void preUpdate() {
      detectGesture();
      detectHand();
  }
 
  private boolean detectGesture() {
     GestureList gestures = leap.getController().frame().gestures();
     boolean hasGesture = ! gestures.isEmpty();
     if (hasGesture) {
       log(this, "sending circle gesture");
       Gesture gesture = gestures.get(0);
       if (frameCount > lastCircleFrame + 10) {
         Message message = new CircleMessage(0);
         sendOscMessage(message);
         lastCircleFrame = frameCount;
       } 
     }
     return hasGesture;
  }
  
  private boolean detectHand() {  
     boolean hasHands = ! leap.getController().frame().hands().isEmpty();
     if (hasHands) {
       Hand hand = leap.getHands().get(0);
       PVector palmPosition = hand.getPalmPosition();
       float roll = radians(hand.getPitch());
       //println("palmPosition=" + palmPosition + " roll=" + roll);
       Message message = new HandMovementMessage(palmPosition.x, palmPosition.y + 50, roll);
       sendOscMessage(message);
     }
     return hasHands;
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

class CircleMessage extends Message {
  float radius;
  
  CircleMessage(float aRadius) {
    radius = aRadius;
  }
  
  CircleMessage(OscMessage message) {
    radius = message.getAndRemoveFloat();
  }
  
  public com.illposed.osc.OSCMessage toOscMessage() {
    Object[] array = new Object[1];
    array[0] = radius;
    com.illposed.osc.OSCMessage message = new com.illposed.osc.OSCMessage(OSC_TOPIC_GESTURE_CIRCLE, array);
    return message;
  }
  
}


