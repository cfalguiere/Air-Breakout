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
  boolean solidGround = SOLID_GROUND;
  
  BallBeing(float x, float y, Rectangle boardBoundingBox) {
      super(new Circle(new PVector(x, y), BALL_RADIUS));
      float angle = random(MIN_FIRE_ANGLE, MAX_FIRE_ANGLE);
      _velocity = PVector.fromAngle(angle);
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
         if ((bounceOnBottom(playground) && !solidGround)) {  
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
      if (bounceOnTop(playground) || (bounceOnBottom(playground) && solidGround)) {  
        _velocity.y = -_velocity.y; 
      }
      if (bounceOnRight(playground) || bounceOnLeft(playground)) {  
        _velocity.x = -_velocity.x; 
      }
      resetEasing();
      move();
  }
  
  
  private boolean bounceOnTop(Rectangle aBoundingBox) {
    return getPosition().y - BALL_RADIUS < aBoundingBox.getPosition().y;
  }

  private boolean bounceOnBottom(Rectangle aBoundingBox) {
    return getPosition().y + BALL_RADIUS > aBoundingBox.getAbsMax().y;
  }

  private boolean bounceOnRight(Rectangle aBoundingBox) {
    return getPosition().x + BALL_RADIUS > aBoundingBox.getAbsMax().x;
  }

  private boolean bounceOnLeft(Rectangle aBoundingBox) {
    return getPosition().x - BALL_RADIUS < aBoundingBox.getPosition().x;
  }

  public void draw() {
      fill(_c);
      noStroke();
      getShape().draw();
  }
  
  public void hitABeing(Rectangle aBeingBoundingBox) {
      if (bounceOnTop(aBeingBoundingBox) || (bounceOnBottom(aBeingBoundingBox) && SOLID_GROUND)) {  
        _velocity.y = -_velocity.y; 
      }
      if (bounceOnRight(aBeingBoundingBox) || bounceOnLeft(aBeingBoundingBox)) {  
        _velocity.x = -_velocity.x; 
      }
      resetEasing();
      easing += BALL_SPEED/2;
      move();
 }
  
    
  public void hitARacket(RacketBeing racket) {
      // always bounce on top and take angle into account
      log(this, "velocity=" + _velocity);   
      float mag = _velocity.mag();
      PVector normalizedIncoming = _velocity.get();
      normalizedIncoming.normalize();
      float incoming = atan2(normalizedIncoming.y, normalizedIncoming.x);
      float normal = racket.angle + HALF_PI;
      float outgoing = ((2 * normal) - PI - incoming + TWO_PI) % TWO_PI;
      _velocity = PVector.fromAngle(outgoing);
      _velocity.setMag(mag);     
      log(this, "new velocity=" + _velocity);
      resetEasing();
      easing += BALL_SPEED/2;
      move();
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
  
  public void fireBall(PVector aPosition) {
    ballCount++;
    log(this, "firing ball " + ballCount);
    BallBeing ball = new BallBeing(aPosition.x, aPosition.y - RACKET_HEIGHT*4, playground);
    gameLevelWorld.register(ball);
    add(ball);
  }
  
  
  public void fireBall() {
    int x = int(playground.getPosition().x + playground.getWidth()/2 - BALL_RADIUS);
    int y = int(playground.getPosition().y + playground.getHeight() - BOARD_PADDING - RACKET_HEIGHT*4);
    fireBall(new PVector(x,y));
  }
  
  public void loseBall(BallBeing ball) {
    remove(ball);
  }

  
}

/* 
 * alternate ball group used to show a firework
 */
class Firework extends BallGroup {
  
  int COLOR_NUM = 5;
  color[] colors = { color(#6BCAE2), // light blue
                     color(#E23D80), // dark pink  
                     color(#41924B), // dark green
                     color(#FF9E00), // light orange
                     color(#87E293) // light green 
  };
  int count;
  static final int MAX = 50;
  BrickGroup wall;

  Firework(BoardBeing board, BrickGroup aWall, GameLevelWorld w) {
    super(board.getBoundingBox(), w);
    wall = aWall;
  }

  public void update() {
    if (count  < MAX  && frameCount % int(random(10, 20)) == 0)  {
      fireBall();
      count++;
    } 
    if (count >= MAX) {
      wall.explode();
      wall.shut();
    }
  }

  public void fireBall() {
    int x = int(playground.getPosition().x + playground.getWidth()/2 - BALL_RADIUS);
    int y = int(playground.getPosition().y + playground.getHeight() - BOARD_PADDING - RACKET_HEIGHT*4);
    ballCount++;
    BallBeing ball = new BallBeing(x, y - RACKET_HEIGHT*4, playground);
    ball._c = pickColor();
    ball.easing *= 2;
    ball.solidGround = true;
    gameLevelWorld.register(ball);
    add(ball);
  }
  
  private color pickColor() {
    int iColor = int(random(0, COLOR_NUM));
    return colors[iColor];
  }

}

/*
 * Helper function : Ball group generator
 */
public BallGroup generateBalls(BoardBeing board, World world) {
  return new BallGroup(board.getBoundingBox(), world);
}


/*
 * Helper function : Firework generator
 */
public Firework generateFirework(BoardBeing board, BrickGroup wall, GameLevelWorld world) {
  return new Firework(board, wall, world);
}
