/**
 * A template to get you started
 * Define your beings, groups, interactors and worlds in separate tabs
 * Put the pieces together in this top-level file!
 *
 * See the tutorial for details:
 * https://github.com/rdlester/hermes/wiki/Tutorial-Pt.-1:-Worlds-and-Beings
 */

import hermes.*;
import hermes.hshape.*;
import hermes.animation.*;
import hermes.physics.*;
import hermes.postoffice.*;

import java.util.Date;

import de.voidplus.leapmotion.*;

///////////////////////////////////////////////////
// CONSTANTS
///////////////////////////////////////////////////
/**
 * Constants should go up here
 * Making more things constants makes them easier to adjust and play with!
 */
static final int WINDOW_WIDTH = 600;
static final int WINDOW_HEIGHT = 400;
static final int BASE_PORT_IN = 8080;
static final int BASE_PORT_OUT = 8000; 

// Bricks
static final int BRICK_FREE = 60;
static final int BRICK_WIDTH = 25;
static final int BRICK_HEIGHT = 15;
static final int BRICK_COLS = 15;
static final int BRICK_ROWS = 4;
static final boolean MOVING_BRICKS = true;
static final int MOVE_DOWN_INTERVAL = 200;
static final int MOVE_DOWN_HEIGHT = 4;

// Board
static final int BOARD_X = 20;
static final int BOARD_Y = 50;
static final int BOARD_PADDING = 5;


// Racket
static final int RACKET_WIDTH = 50;
static final int RACKET_HEIGHT = 5;
static final PVector INITIAL_VELOCITY = new PVector(40,0);

// Balls
static final int BALLS_NUM = 10;
static final int BALL_RADIUS = 10;
static final float BALL_SPEED = 4;
static final boolean SOLID_GROUND = false;

// OSC
static final String OSC_TOPIC_PROGRESS = "Progress";
static final String OSC_TOPIC_GAME_STATE = "Game State";
static final String OSC_TOPIC_HAND_MOVEMENT = "Hand Movement";
static final String OSC_TOPIC = "Default";

GameLevelWorld gameLevelWorld;
LeapMotionWorld leapMotionWorld;

///////////////////////////////////////////////////
// PAPPLET
///////////////////////////////////////////////////

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT); 
  Hermes.setPApplet(this);

  frameRate(60);

  gameLevelWorld = new GameLevelWorld(BASE_PORT_IN, BASE_PORT_OUT);       
  leapMotionWorld = new LeapMotionWorld(BASE_PORT_IN +1, BASE_PORT_OUT +1, 
                            gameLevelWorld.getPostOffice());       

  //Important: don't forget to add setup to TemplateWorld!

  leapMotionWorld.start(); // this should be the last line in setup() method
  gameLevelWorld.start(); // this should be the last line in setup() method
}


void draw() {
    gameLevelWorld.draw();
}
