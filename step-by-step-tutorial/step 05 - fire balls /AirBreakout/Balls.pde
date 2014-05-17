/**
 * Ball being
 */
class BallBeing extends Being {
  color _c = color(255,0,0);
  float easing;
  static final float MIN_FIRE_ANGLE = HALF_PI * 0.7;
  static final float MAX_FIRE_ANGLE = HALF_PI * 1.3;
  Rectangle playground;
  boolean isLost;
  
  BallBeing(float x, float y, Rectangle boardBoundingBox) {
      super(new Circle(new PVector(x, y), BALL_RADIUS));
      _velocity = PVector.fromAngle(random(MIN_FIRE_ANGLE, MAX_FIRE_ANGLE));
      playground = boardBoundingBox;
      resetEasing();
      isLost = false;
  }

  public void update() {
     easing *= 0.999;
     safeMove();
  }

  private void safeMove() {
    PVector memPosition = getPosition().get();
    move();
    if (! playground.contains(getBoundingBox())) {
       if ((bounceOnBottom() && !SOLID_GROUND)) {  
          isLost = true;
       } else {
          getPosition().x = memPosition.x;
          getPosition().y = memPosition.y;
          bounce();
       }
    }
  }
  
  private void move() {
    getPosition().x -= _velocity.x * easing;    
    getPosition().y -= _velocity.y * easing;   
  }

  private void resetEasing() {
    easing = BALL_SPEED;
  }
  
  private void bounce() {
      if (bounceOnTop() || (bounceOnBottom() && SOLID_GROUND)) {  
        _velocity.y = -_velocity.y; 
      }
      if (bounceOnRight() || bounceOnLeft()) {  
        _velocity.x = -_velocity.x; 
      }
      resetEasing();
      move();
  }
  
  
  private boolean bounceOnTop() {
    return getPosition().y - BALL_RADIUS < playground.getPosition().y;
  }

  private boolean bounceOnBottom() {
    return getPosition().y + BALL_RADIUS > playground.getAbsMax().y;
  }

  private boolean bounceOnRight() {
    return getPosition().x + BALL_RADIUS > playground.getAbsMax().x;
  }

  private boolean bounceOnLeft() {
    return getPosition().x - BALL_RADIUS < playground.getPosition().x;
  }

  public void draw() {
      fill(_c);
      noStroke();
      getShape().draw();
  }
}

/**
 * Balls generator
 * player is allowed a given number of balls
 */
class BallGroup extends Group<BallBeing> {
  World gameLevelWorld;
  Rectangle playground;
  int ballCount = 0;

  BallGroup(Rectangle boardBoundingBox, World w) {
    super(w);
    gameLevelWorld = w;
    playground = boardBoundingBox;
  }

  public void update() {
     for(BallBeing ball : getObjects()) {
       if (ball.isLost) {
         _world.delete(ball);
       }
     }
  }

  public boolean hasRemainingBalls() {
    return ballCount < BALLS_NUM;
  }
  
  public void fireBall() {
    ballCount++;
    log(this, "firing ball " + ballCount);
    int x = int(playground.getPosition().x + playground.getWidth()/2 - BALL_RADIUS);
    int y = int(playground.getPosition().y + playground.getHeight() - BOARD_PADDING - RACKET_HEIGHT*4);
    BallBeing ball = new BallBeing(x, y, playground);
    gameLevelWorld.register(ball);
    add(ball);
  }
  
  public void loseBall(BallBeing ball) {
    remove(ball);
  }

}

/*
 * Helper function : Racket generator
 */
public BallGroup generateBalls(BoardBeing board, World world) {
  return new BallGroup(board.getBoundingBox(), world);
}
