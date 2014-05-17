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
    
    ScorePanelBeing score = generateScorePanel(board);
    register(score);
    subscribe(score, OSC_TOPIC_PROGRESS);
    
    BrickGroup wall = generateWall(board, this);
    register(wall);
    
    RacketBeing racket = generateRacket(board);
    register(racket);
    subscribe(racket, POCodes.Key.LEFT);
    subscribe(racket, POCodes.Key.RIGHT);    
    
    BallGroup balls = generateBalls(board, this);
    register(balls);
    
    GameController gameController = new GameController(board, balls, racket, wall, this);
    subscribe(gameController, POCodes.Key.F);
    
    register(wall, balls, new BrickBallCollider(gameController));
    register(racket, balls, new RacketBallCollider());
    register(wall, racket, new BrickRacketCollider(gameController));
    register(wall, board, new BrickGroundInteractor(gameController));
    
  }
  
  void draw() {
      background(0);
      super.draw();
  }

  
  private void sendOscMessage(Message message) {
    getPostOffice().acceptMessage(new Date(), message.toOscMessage());
  }

}

/* 
 * base class of OscMessage
 */
class Message {
  public com.illposed.osc.OSCMessage toOscMessage() {
    // should not be here. FIXME abstract class in Processing ?
    Object[] array = new Object[1];
    array[0] = 1;
    com.illposed.osc.OSCMessage message = new com.illposed.osc.OSCMessage(OSC_TOPIC, array);
    return message;
  }
}


