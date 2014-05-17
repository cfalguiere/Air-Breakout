/**
 * Board being
 */
class BoardBeing extends Being {
  private color bgColor = color(64,64,64);
  private int width;
  private int height;
  
  BoardBeing(int x, int y, int w, int h) {
      super(new Rectangle(x, y, w, h));
      width = w;
      height = h;
  }
  
  public void draw() {
      fill(bgColor);
      noStroke();
      getShape().draw();
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
