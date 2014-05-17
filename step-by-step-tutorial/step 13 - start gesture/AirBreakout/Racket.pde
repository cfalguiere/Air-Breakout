/**
 * Racket being
 */
class RacketBeing extends Being {
  color bgColor = color(255,255,255);
  Rectangle playground;
  float angle;
    
  RacketBeing(int x, int y, Rectangle boardBoundingBox) {
      super(new Rectangle(x, y, RACKET_WIDTH, RACKET_HEIGHT));
      playground = boardBoundingBox;
  }

  public void update() {
  }

  public void draw() {
      fill(bgColor);
      noStroke();
      pushMatrix();
      rotate(angle);
      translate(getShape().getBoundingBox().getWidth()/2, 0);
      rectMode(CENTER);
      getShape().draw();
      popMatrix();
  }
    
  public void receive(KeyMessage m) {
    int code = m.getKeyCode();
    if (m.isPressed()) {
      if (code == POCodes.Key.LEFT) {
         safeMove(-INITIAL_VELOCITY.x);
      } 
      if (code == POCodes.Key.RIGHT) {
         safeMove(INITIAL_VELOCITY.x);
      } 
    } 
  }
  
  public void safeMove(float dx) {
    PVector memPosition = getPosition().get();
    getPosition().x += dx;
    if (! playground.contains(getBoundingBox())) {
       getPosition().x = memPosition.x;
    }
  }

  void receive(OscMessage message) {
      String address = message.getAddress();
      if (OSC_TOPIC_HAND_MOVEMENT.equals(address)) {
        HandMovementMessage movement = new HandMovementMessage(message);
        //println("receive x=" + movement.x + " y=" + movement.y + " angle=" + angle);
        safeMove2D(movement.x, movement.y, movement.angle);
      }
  }
  
  public void safeMove2D(float x, float y, float anAngle) {
      PVector memPosition = getPosition().get(); 
      //println("current pos x=" + memPosition.x + " y=" + memPosition.y);
      getPosition().x = x;
      getPosition().y = y;
      angle = anAngle;
  
      if (! playground.contains(getBoundingBox())) {
        println("reset pos");
         getPosition().x = memPosition.x;
         getPosition().y = memPosition.y;
      }
  }

}

/*
 * Helper function : Racket generator
 */
public RacketBeing generateRacket(BoardBeing board) {
  int x = int(board.getPosition().x + board.getWidth()/2 - RACKET_WIDTH/2);
  int y = int(board.getPosition().y + board.getHeight() - BOARD_PADDING - RACKET_HEIGHT*6);
  return new RacketBeing( x, y, board.getBoundingBox());
}

