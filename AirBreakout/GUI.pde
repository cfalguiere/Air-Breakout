/**
 * Score Panel
 */
class ScorePanelBeing extends Being {
  int bricksDone;
  int bricksTotal;
  
  ScorePanelBeing(int x, int y, int w, int h) {
      super(new Rectangle(x, y, w, h));
  }

  void receive(OscMessage message) {
      String address = message.getAddress();
      if (OSC_TOPIC_PROGRESS.equals(address)) {
        ProgressMessage progress = new ProgressMessage(message);
        log(this, "received progress done=" + progress.done + " total=" + progress.total);
        bricksDone = progress.done;
        bricksTotal = progress.total;
      }
  }

  void draw() {
    fill( color(#13A1CB) );
    textSize(18);
    text("Bricks: " + bricksDone + "/" + bricksTotal, 0, BOARD_Y - 10); 
  }
  
}

/*
 * Helper function : Score panel generator
 */
public ScorePanelBeing generateScorePanel(BoardBeing board) {
  int panelWidth = int(board.getBoundingBox().getWidth());
  int panelHeight = BOARD_Y - BOARD_PADDING;
  return new ScorePanelBeing(BOARD_X, BOARD_PADDING, panelWidth, panelHeight);
}

/**
 * gauge Button
 */
 
class GaugeButtonBeing extends Being {
  private color bgColor = color(#FF9E00);
  private GameLevelWorld world;
  int progress = -1;
  
  GaugeButtonBeing(int x, int y, GameLevelWorld aWorld) {
      super(new Rectangle(x, y, 50, 50));
      world = aWorld;
  }
  
  void update() {
    if (progress >= 0) {
      progress++;
    }
    if (progress>=50) {
      completeButton();
      sendStartGame();
    }
  }

  public void draw() {
    trace(this, "drawing begins");
    if (progress >= 0) {
      fill(bgColor);
      noStroke();
      rect(0,0, progress, 50);
    }
    trace(this, "drawing done");
  }

  
  public void startButton() {
    println("start button");
    progress = 0;
  }
  
  public void completeButton() {
    progress = -1;
  }
  
    
  private void sendStartGame() {
    log(this, "sending start game event");
    GUIMessage message = new GUIMessage(GUIMessage.START);
    world.sendOscMessage(message);
  }

}

/*
 * Helper function : gauge button  generator
 */
 
public GaugeButtonBeing generateGaugeButton(int x, int y, GameLevelWorld w) {
  return new GaugeButtonBeing(x, y, w);
}


