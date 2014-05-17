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
