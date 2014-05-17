/**
 * a Brick being
 */
class BrickBeing extends Being {
  color bgColor;
  int COLOR_NUM = 5;
  color[] colors = { color(#6BCAE2), // light blue
                     color(#E23D80), // dark pink  
                     color(#41924B), // dark green
                     color(#FF9E00), // light orange
                     color(#87E293), // light green 
                   };
                   //  color(#EB77A6), // light pink
                   //  color(#F7D708), // dark yellow
                   //  color(#13A1CB), // dark blue
                   //  color(#FF6600), // dark orange
  boolean isOut = false;
  boolean isAway = false;
                      
  BrickBeing(int x, int y) {
      super(new Rectangle(x, y, BRICK_WIDTH, BRICK_HEIGHT));
      pickColor();
  }

  public void update() {
  }

  public void draw() {
      fill(bgColor);
      noStroke();
      getShape().draw();
  }

  public void moveDown() {
      getPosition().y += MOVE_DOWN_HEIGHT;
  }
  
  private void pickColor() {
    int iColor = int(random(0, COLOR_NUM));
    bgColor = colors[iColor];
  }
}

/**
 * a Animated Brick being
 */
class AnimatedBrickBeing extends BrickBeing  {
  color bgColor;
  float rotationAngle = 0;
  float rotationAngleStep = 0;
  Rectangle playground;

  AnimatedBrickBeing(BrickBeing aBrick, Rectangle aBoundingBox) {
    super(int(aBrick.getPosition().x), int(aBrick.getPosition().y));
    bgColor = aBrick.bgColor;
    playground = aBoundingBox;
    _velocity = new PVector( random(-5,5), random(2,5));
    rotationAngleStep = PI/random(12,48);
    isOut = true;
  }

  public void update() {
    rotationAngle += rotationAngleStep;
    getPosition().x -= _velocity.x;    
    getPosition().y -= _velocity.y;   
    if (! playground.contains(getBoundingBox())) {
      isAway = true;
    }
  }

  public void draw() {
      fill(bgColor);
      noStroke();
      pushMatrix();
      rotate(rotationAngle);
      getShape().draw();
      popMatrix();
  }
}

/**
 * Synchronizes bricks
 */
class BrickGroup extends Group<BrickBeing> implements OscSubscriber {
  Rectangle playground;
  boolean isStarted;
  boolean isMoving;  
  boolean isExploding;  
  int moveInterval;
  int brickTotalCount;

  BrickGroup(Rectangle boardBoundingBox, World w) {
    super(w);
    playground = boardBoundingBox;
    isMoving = MOVING_BRICKS;
    moveInterval = MOVE_DOWN_INTERVAL;
    brickTotalCount = BRICK_ROWS * BRICK_COLS;
  }

  public void update() {
     if (isMoving && frameCount % moveInterval == 0) {
        moveDown();
     }
     if (isExploding) {
       for(BrickBeing brick : getObjects()) {
         if (! brick.isOut) {
            brick.getPosition().x += brick.getVelocity().x;    
            brick.getPosition().y += brick.getVelocity().y;  
         } 
       }
     }
     removeAnimatedBricks();
  }

  void receive(OscMessage message) {
      String address = message.getAddress();
      if (OSC_TOPIC_GAME_STATE.equals(address)) {
        GameStateMessage change = new GameStateMessage(message);
        if (change.state ==  GameState.PLAYING) {
          log(this, "receive Started");
          isStarted = true;
        }
      }
  }

  private void removeAnimatedBricks() {
     for(BrickBeing brick : getObjects()) {
       if (brick.isAway) {
         _world.delete(brick);
       }
     }
  }
    
  public void buildWall() {
    for (int il = 0; il < BRICK_ROWS ; il++) {
      for (int ic = 0; ic < BRICK_COLS ; ic++) {
        addBrick(ic, il);
      }
    } 
  }
  
  public void addBrick(int ic, int il) {
    int x = int(playground.getPosition().x) + BOARD_PADDING + ic * BRICK_WIDTH;
    int y = int(playground.getPosition().y) + BOARD_PADDING + il * BRICK_HEIGHT + BRICK_FREE;
    BrickBeing brick = new BrickBeing(x, y);
    _world.register(brick);
    add(brick);
  }

  
  public void addAnimatedBrick(BrickBeing aBrick) {
    AnimatedBrickBeing brick = new AnimatedBrickBeing(aBrick, playground);
    _world.register(brick);
    add(brick);
  }
  
  public void moveDown() {
    for (BrickBeing b : getObjects()) {
      b.moveDown();
    } 
  }
  
  public void shut() {
      moveInterval = 5;
  }
  
  
  public void explode() {
     isExploding = true;
     for(BrickBeing brick : getObjects()) {
       if (! brick.isOut) {
          brick.getVelocity().x = random(-20,20);    
          brick.getVelocity().y = random(20);   
       } 
     }
}
  
}

/*
 * Helper function : Wall generator
 */
public BrickGroup generateWall(BoardBeing board, GameLevelWorld world) {
  BrickGroup bricks = new BrickGroup(board.getBoundingBox(), world);
  bricks.buildWall();
  return bricks;
}

