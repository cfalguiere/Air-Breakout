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
 * Synchronizes bricks
 */
class BrickGroup extends Group<BrickBeing> {
  Rectangle playground;
  boolean isMoving;                 

  BrickGroup(Rectangle boardBoundingBox, World w) {
    super(w);
    playground = boardBoundingBox;
    isMoving = MOVING_BRICKS;
  }

  public void update() {
    if (isMoving && frameCount % MOVE_DOWN_INTERVAL == 0) {
      moveDown();
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
  
  public void moveDown() {
    for (BrickBeing b : getObjects()) {
      b.moveDown();
    } 
  }
  
  public void stopMoving() {
      isMoving = false;
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

