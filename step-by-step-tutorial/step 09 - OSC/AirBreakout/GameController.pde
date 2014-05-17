/* 
 * delegate for user interaction and game rules
 */ 
class GameController implements KeySubscriber { 
  BoardBeing board;
  BallGroup balls;
  RacketBeing racket; 
  BrickGroup wall; 
  GameLevelWorld world;
  
  GameState gameState;
  int brickCount;
  
  GameController(BoardBeing aBoard, 
                  BallGroup aBallGroup, 
                  RacketBeing aRacket, 
                  BrickGroup aWall, 
                  GameLevelWorld aWorld) {
    board = aBoard;
    balls = aBallGroup;
    racket = aRacket;
    wall = aWall;
    world = aWorld;
    sendProgress();
  }

  public void changeState(GameState aState) {
    gameState = aState;
    log(this, "state changed to " + gameState);
  }
  
  public void receive(KeyMessage m) {
    int code = m.getKeyCode();
    if (m.isPressed()) {
      if (code == POCodes.Key.F) {
        if (balls.hasRemainingBalls()) {
          changeState(GameState.PLAYING);
          balls.fireBall(racket.getBoundingBox().getCenter());
        } else {
          gameOver(); 
        }
      } 
    } 
  }

  public void gameOver() {
    changeState(GameState.GAME_OVER);
    board.setMessage("Game Over !!!");
    wall.shut();
  }
  
  public void breakBrick(BrickBeing brick) {
    brickCount++;
    sendProgress();
    removeBrick(brick);
  }
  
  public void removeBrick(BrickBeing brick) {
    wall.addAnimatedBrick(brick);
    world.delete(brick);
  }
  
  private void sendProgress() {
    log(this, "sending progress " + brickCount);
    ProgressMessage message = new ProgressMessage(brickCount, wall.brickTotalCount);
    world.sendOscMessage(message);
  }
}

/* 
 * progress message
 */
class ProgressMessage extends Message {
  int done;
  int total;
  
  ProgressMessage(int aDone,  int aTotal) {
    done = aDone;
    total = aTotal;
  }
  
  ProgressMessage(OscMessage message) {
    done = message.getAndRemoveInt();
    total = message.getAndRemoveInt();
  }
  
  public com.illposed.osc.OSCMessage toOscMessage() {
    Object[] array = new Object[2];
    array[0] = done;
    array[1] = total;
    com.illposed.osc.OSCMessage message = new com.illposed.osc.OSCMessage(OSC_TOPIC_PROGRESS, array);
    return message;
  }
  
}



