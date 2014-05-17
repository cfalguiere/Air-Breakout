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
  }
  
  void draw() {
      background(0);
      super.draw();
  }

}

