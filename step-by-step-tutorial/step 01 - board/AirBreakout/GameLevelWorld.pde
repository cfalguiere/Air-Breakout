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
  }
  
  void draw() {
      background(0);
      super.draw();
  }

}

