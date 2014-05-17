/* 
 * delegate for user interaction and game rules
 */ 
class GameController implements KeySubscriber, OscSubscriber { 
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
    sendCompleted();
  }

  void receive(OscMessage message) {
      String address = message.getAddress();
      if (OSC_TOPIC_GUI.equals(address)) {
        GUIMessage event = new GUIMessage(message);
        log(this, "receiving start game event");
        if (GUIMessage.START.equals(event.status)) {
          changeState(GameState.PLAYING);
          fireNewBall();
        }
      }
  }
  
  public void receive(KeyMessage m) {
    int code = m.getKeyCode();
    if (m.isPressed()) {
      if (code == POCodes.Key.F) {
        fireNewBall();
      } 
      if (code == POCodes.Key.S) {
        world.setupStartButton();
      } 
      leapMotionEmulation(code); 
    } 
  }
  
  private void leapMotionEmulation(int code) {
    // emulation of leap motion
    if (code == POCodes.Key.Q) { // move left
      float x = racket.getPosition().x - 40;
      float y = racket.getPosition().y;
      float angle = racket.angle;
      sendHandMovement(x, y, angle);
    } 
    if (code == POCodes.Key.D) { // move right
      float x = racket.getPosition().x + 40;
      float y = racket.getPosition().y;
      float angle = racket.angle;
      sendHandMovement(x, y, angle);
    } 
    if (code == POCodes.Key.E) { // angle decreased by 0.2
      float x = racket.getPosition().x;
      float y = racket.getPosition().y;
      float angle = racket.angle - 0.2;
      sendHandMovement(x, y, angle);
    } 
    if (code == POCodes.Key.X) { // angle increased by 0.2
      float x = racket.getPosition().x;
      float y = racket.getPosition().y;
      float angle = racket.angle + 0.2;
      sendHandMovement(x, y, angle);
    } 
    if (code == POCodes.Key.W) { // win
      success();
    } 
  }
  
  private void fireNewBall() {
    if (balls.hasRemainingBalls()) {
      balls.fireBall(racket.getBoundingBox().getCenter());
    } else {
      gameOver(); 
    }
  }

  public void gameOver() {
    if (gameState != GameState.SUCCESS) {
      changeState(GameState.GAME_OVER);
      board.setMessage("Game Over !!!");
      wall.shut();
    }
  }
  
  public void success() {
    changeState(GameState.SUCCESS);
    board.setMessage("You Win !!!");
    wall.explode();
  }
  
  public boolean acceptSuccess() {
    return brickCount >= wall.brickTotalCount;
  }

  
  public void breakBrick(BrickBeing brick) {
    brickCount++;
    sendProgress();
    removeBrick(brick);
    if (acceptSuccess()) {
      success();
    }
  }
  
  public void removeBrick(BrickBeing brick) {
    wall.addAnimatedBrick(brick);
    world.delete(brick);
  }
  
  private void sendProgress() {
    log(this, "sending progress " + brickCount);
    if (gameState != GameState.SUCCESS) {
      ProgressMessage message = new ProgressMessage(brickCount, wall.brickTotalCount);
      world.sendOscMessage(message);
    }
  }
  
  private void sendCompleted() {
    GameStateMessage message = new GameStateMessage(gameState);
    world.sendOscMessage(message);
  }
    
  private void sendHandMovement(float x, float y, float angle) {
    trace(this, "sending hand movement ");
    HandMovementMessage message = new HandMovementMessage(x, y, angle);
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

/* 
 * game state message
 */
class GameStateMessage extends Message {
  GameState state ;

  GameStateMessage(GameState aState) {
    state = aState;
  }
  
  GameStateMessage(OscMessage message) {
    if (message.hasRemainingArguments()) {
      int value = message.getAndRemoveInt();
      state = GameState.values()[value];
    }
  }
  
  public com.illposed.osc.OSCMessage toOscMessage() {
    Object[] array = new Object[1];
    array[0] = state.ordinal();
    com.illposed.osc.OSCMessage message = new com.illposed.osc.OSCMessage(OSC_TOPIC_GAME_STATE, array);
    return message;
  }
  
}



/* 
 * GUI message
 */
 
class GUIMessage extends Message {
  static final String START = "START";
  String status ;

  GUIMessage(String aStatus) {
    status = aStatus;
  }
  
  GUIMessage(OscMessage message) {
    status = message.getAndRemoveString();
  }
  
  public com.illposed.osc.OSCMessage toOscMessage() {
    Object[] array = new Object[1];
    array[0] = status;
    com.illposed.osc.OSCMessage message = new com.illposed.osc.OSCMessage(OSC_TOPIC_GUI, array);
    return message;
  }
  
}


