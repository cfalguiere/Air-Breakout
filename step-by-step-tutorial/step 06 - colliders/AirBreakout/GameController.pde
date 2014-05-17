class GameController implements KeySubscriber { 
  BoardBeing board;
  BallGroup balls;
  RacketBeing racket; 
  World world;
  
  GameState gameState;
  
  GameController(BoardBeing aBoard, 
                  BallGroup aBallGroup, 
                  RacketBeing aRacket, 
                  World aWorld) {
    board = aBoard;
    balls = aBallGroup;
    racket = aRacket;
    world = aWorld;
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
  }
  
  public void removeBrick(BrickBeing brick) {
    world.delete(brick);
  }
}
