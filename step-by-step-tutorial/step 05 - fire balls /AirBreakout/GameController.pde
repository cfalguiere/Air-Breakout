class GameController implements KeySubscriber { 
  BoardBeing board;
  BallGroup balls;
  
  GameState gameState;
  
  GameController(BoardBeing aBoard, 
                  BallGroup aBallGroup) {
    board = aBoard;
    balls = aBallGroup;
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
          balls.fireBall();
        } else {
          changeState(GameState.GAME_OVER);
          board.setMessage("Game Over !!!");
        }
      } 
    } 
  }
  
}
