/**
 * Game Level World
 */
class GameLevelWorld extends World implements OscSubscriber {
  GameController gameController;
  BoardBeing board;
  Firework firework;
  
  GameLevelWorld(int portIn, int portOut) {
    super(portIn, portOut);
  }

  void setup() {
    board = generateBoard();
    register(board);
    
    ScorePanelBeing score = generateScorePanel(board);
    register(score);
    subscribe(score, OSC_TOPIC_PROGRESS);
    
    BrickGroup wall = generateWall(board, this);
    register(wall);
    subscribe(wall, OSC_TOPIC_GAME_STATE);
    
    RacketBeing racket = generateRacket(board);
    register(racket);
    subscribe(racket, POCodes.Key.LEFT);
    subscribe(racket, POCodes.Key.RIGHT);    
    subscribe(racket, OSC_TOPIC_HAND_MOVEMENT);
    
    BallGroup balls = generateBalls(board, this);
    register(balls);
    
    gameController = new GameController(board, balls, racket, wall, this);
    subscribe(gameController, POCodes.Key.F);
    // emulation of leap motion
    subscribe(gameController, POCodes.Key.Q);
    subscribe(gameController, POCodes.Key.D);
    subscribe(gameController, POCodes.Key.E);
    subscribe(gameController, POCodes.Key.X);
    subscribe(gameController, POCodes.Key.W);
    
    register(wall, balls, new BrickBallCollider(gameController));
    register(racket, balls, new RacketBallCollider());
    register(wall, racket, new BrickRacketCollider(gameController));
    register(wall, board, new BrickGroundInteractor(gameController));

    subscribe(this, OSC_TOPIC_GAME_STATE);
    
  }
  
  
  void draw() {
      background(0);
      super.draw();
  }

  
  private void sendOscMessage(Message message) {
    getPostOffice().acceptMessage(new Date(), message.toOscMessage());
  }

  void receive(OscMessage message) {
      String address = message.getAddress();
      if (OSC_TOPIC_GAME_STATE.equals(address)) {
        GameStateMessage change = new GameStateMessage(message);
        if (change.state ==  GameState.SUCCESS && firework == null) {
          setupFirework();
        }
      }
  }

  public void setupFirework() {
    println("setting up firework");
    BrickGroup wall2 = generateWall(board, this);
    firework = generateFirework(board, wall2, this);
    register(firework);
    
    register(wall2);
    register(wall2, firework, new BrickBallCollider(gameController));
    register(wall2, board, new BrickGroundInteractor(gameController));
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


