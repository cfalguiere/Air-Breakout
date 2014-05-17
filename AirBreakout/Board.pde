/**
 * Board being
 */
class BoardBeing extends Being {
  private color bgColor = color(64,64,64);
  private int width;
  private int height;
  private String message;
  
  BoardBeing(int x, int y, int w, int h) {
      super(new Rectangle(x, y, w, h));
      width = w;
      height = h;
  }
  
  public void draw() {
      fill(bgColor);
      noStroke();
      getShape().draw();
      if (message != null) {
        displayMessage(message);
      }
  }

  
  public int getWidth() {
    return width;
  }
  
  public int getHeight() {
    return height;
  }

  public void setMessage(String aMessage) {
    message = aMessage;
  }
  
  private void displayMessage(String aMessage) {
    fill( color(#13A1CB) );
    textSize(48);
    text(aMessage, getPosition().x, getPosition().y + 100); 
  }

}

/*
 * Helper function : Board generator
 */
public BoardBeing generateBoard() {
  int boardWidth = BRICK_WIDTH * BRICK_COLS + BOARD_PADDING*2;
  int boardHeight = boardWidth * 3 /  4;
  return new BoardBeing(BOARD_X, BOARD_Y, boardWidth, boardHeight);
}
