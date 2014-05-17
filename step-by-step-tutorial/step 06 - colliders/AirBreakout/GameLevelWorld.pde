/**
 * Game Level World
 */
class GameLevelWorld extends World {
  
  GameLevelWorld(int portIn, int portOut) {
    super(portIn, portOut);
  }

  void setup() {
    BoardBeing board = generateBoard();
    register(board);
    
    BrickGroup wall = generateWall(board, this);
    register(wall);
    
    RacketBeing racket = generateRacket(board);
    register(racket);
    subscribe(racket, POCodes.Key.LEFT);
    subscribe(racket, POCodes.Key.RIGHT);    
    
    BallGroup balls = generateBalls(board, this);
    register(balls);
    
    GameController gameController = new GameController(board, balls, racket, this);
    subscribe(gameController, POCodes.Key.F);
    
    register(wall, balls, new BrickBallCollider(gameController));
    register(racket, balls, new RacketBallCollider());
    register(wall, racket, new BrickRacketCollider(gameController));
  }
  
  void draw() {
      background(0);
      super.draw();
  }

}

