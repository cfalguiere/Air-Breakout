/**
 * interactor between a Brick and the ball
 * Brick vanish when it's hit by the ball
 */
class BrickBallCollider extends Collider<BrickBeing, BallBeing> {
  private GameController gameController; 
  
  BrickBallCollider(GameController aGameController) {
    super();
    gameController = aGameController;
  }
  
  void handle(BrickBeing brick, BallBeing ball) {
    ball.hitABeing(brick.getBoundingBox());
    gameController.removeBrick(brick);
  }
}

/**
 * interactor between a Racket and the ball
 * ball bounce on the racket
 */
class RacketBallCollider extends Collider<RacketBeing, BallBeing> {
  void handle(RacketBeing racket, BallBeing ball) {
    ball.hitABeing(racket.getBoundingBox());
  }
}

/**
 * interactor between a Brick and the racket
 * game over
 */
class BrickRacketCollider extends Collider<BrickBeing, RacketBeing> {
  private GameController gameController; 
  
  BrickRacketCollider(GameController aGameController) {
    super();
    gameController = aGameController;
  }

  void handle(BrickBeing brick, RacketBeing racket) {
    gameController.gameOver();
  }
}

/**
 * interactor between a Bricks and the ground
 * Ball bounce over the wall
 */
class BrickGroundInteractor extends Interactor<BrickBeing, BoardBeing> {
  private GameController gameController; 
  
  BrickGroundInteractor(GameController aGameController) {
    super();
    gameController = aGameController;
  }

  boolean detect(BrickBeing brick, BoardBeing board) {
    return ! board.getBoundingBox().contains(brick.getBoundingBox());
  }

  void handle(BrickBeing brick, BoardBeing board) {
    gameController.removeBrick(brick);
    gameController.gameOver();
  }
}
