PGraphics gameGraphic;

ArrayList<PlayerBall> balls;
Bar bar;
TileSet board;
float barY;

float ballMaxSpeed;
float ballSize;

float gameScreenSize;

PImage brickImg;
PImage addBallImg;
PImage multiBallImg;

JSONArray levels;
int currentLevel;
int gameState;

int timeLeft;

void setup() {
  pixelDensity(1);
  size(1280, 720, P2D);
  frameRate(60);
  noSmooth();
  windowResizable(true);

  gameGraphic = createGraphics(1000, 1000, P2D);
  gameGraphic.noSmooth();
  updateScreenSize();

  assetSetup();

  barY = gameGraphic.height*15/16;
  bar = new Bar(gameGraphic.width/4, gameGraphic.height/16, color(100));

  balls = new ArrayList<PlayerBall>();

  ballMaxSpeed = gameGraphic.width/320;
  ballSize = gameGraphic.width/20;
  addBall();

  currentLevel = 0;
  loadLevel(currentLevel);

  gameState = 0;
}

void draw() {
  background(127);
  updateScreenSize();

  //init game graphic
  gameGraphic.beginDraw();
  gameGraphic.background(200);

  //game logic
  if (gameState == 0) {
    if (keyPulseState.getOrDefault(-1, false)) {
      timeLeft = 60 * 30;
      gameState = 1;
    }
  } else if (gameState == 1) {
    board.update(balls);
    bar.update();
    for (int i=balls.size()-1; i>=0; i--) {
      PlayerBall thisBall = balls.get(i);
      thisBall.update(bar);
      if (!thisBall.active) {
        balls.remove(i);
      }
    }

    if (timeLeft-- < 0 || balls.isEmpty()) {
      gameState = 3;
    } else if (board.cleared) {
      gameState = 2;
    }
  } else if (gameState == 2) {
    if (keyPulseState.getOrDefault(-1, false)) {
      gameState = 0;
      currentLevel++;
      if (currentLevel >= levels.size()) {
        gameState = 4;
      } else {
        loadLevel(currentLevel);
      }
    }
  } else if (gameState == 3 || gameState == 4) {
    if (keyPulseState.getOrDefault(-1, false)) {
      gameState = 0;
      currentLevel = 0;
      loadLevel(currentLevel);
    }
  }

  //render
  if (gameState == 0 || gameState == 1) {
    board.render();
    for (int i=balls.size()-1; i>=0; i--) {
      balls.get(i).render();
    }
    bar.render();
  }

  //end render
  gameGraphic.endDraw();

  //display game graphic to window
  imageMode(CENTER);
  image(gameGraphic, width/2, height/2, gameScreenSize, gameScreenSize);
  textSize(64);
  text(frameRate, 10, 64);

  //hud render
  pushStyle();
  textSize(width/10);
  textAlign(CENTER);
  fill(16, 200, 16);
  if (gameState == 0) {
    text("CLICK TO START", width/2, height/2);
  } else if (gameState == 1) {
    pushStyle();
    textSize(gameScreenSize/10);
    textAlign(CENTER, BOTTOM);
    text(timeLeft/60, width/2, height);
    popStyle();
  } else if (gameState == 2) {
    text("LEVEL CLEAR\nCLICK TO CONTINUE", width/2, height/2);
  } else if (gameState == 3) {
    text("GAME OVER\nCLICK TO RESTART", width/2, height/2);
  } else if (gameState == 4) {
    text("GAME CLEAR!!\nCLICK TO RESTART", width/2, height/2);
  }
  popStyle();

  //clear key state
  keyPulseState.clear();
}
