/**
 * Racket being
 */
class RacketBeing extends Being {
  color bgColor = color(255,255,255);
  Rectangle playground;
    
  RacketBeing(int x, int y, Rectangle boardBoundingBox) {
      super(new Rectangle(x, y, RACKET_WIDTH, RACKET_HEIGHT));
      playground = boardBoundingBox;
  }

  public void update() {
  }

  public void draw() {
      fill(bgColor);
      noStroke();
      getShape().draw();
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
}

/*
 * Helper function : Racket generator
 */
public RacketBeing generateRacket(BoardBeing board) {
  int x = int(board.getPosition().x + board.getWidth()/2 - RACKET_WIDTH/2);
  int y = int(board.getPosition().y + board.getHeight() - BOARD_PADDING - RACKET_HEIGHT*3);
  return new RacketBeing( x, y, board.getBoundingBox());
}

