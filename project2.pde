PGraphics gameGraphic;

ArrayList<PlayerBall> balls;
Bar bar;
TileSet board;
float barY;

float ballMaxSpeed;
float ballSize;

float gameScreenSize;

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

  ballMaxSpeed = gameGraphic.width/200;
  ballSize = gameGraphic.width/25;
  addBall();

  currentLevel = 7;
  loadLevel(currentLevel);

  gameState = 0;
}

void draw() {
  background(127);
  updateScreenSize();

  //init game graphic
  gameGraphic.beginDraw();

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
    gameGraphic.background(200);
    board.render();
    for (int i=balls.size()-1; i>=0; i--) {
      balls.get(i).render();
    }
    bar.render();
  }

  //end render
  gameGraphic.endDraw();

  //display game graphic to window
  if (gameState == 0 || gameState == 1 || gameState == 2) {
    imageMode(CENTER);
    image(gameGraphic, width/2, height/2, gameScreenSize, gameScreenSize);
    textSize(64);
    text(frameRate, 10, 64);
  }

  //hud render
  pushStyle();
  textSize(width/16);
  textAlign(CENTER);
  fill(0);
  if (gameState == 0) {
    text("CLICK TO START", width/2, height*3/4);
  } else if (gameState == 1) {
    pushStyle();
    textSize(gameScreenSize/10);
    textAlign(CENTER, TOP);
    text(timeLeft/60, width/2, 0);
    popStyle();
  } else if (gameState == 2) {
    pushStyle();
    noStroke();
    fill(0,127);
    rect(0, height*1/3, width, height*1/3);
    popStyle();
    text("LEVEL CLEAR\nCLICK TO CONTINUE", width/2, height/2);
  } else if (gameState == 3) {
    pushStyle();
    fill(200,0,0);
    text("GAME OVER\nCLICK TO RESTART", width/2, height/2);
    popStyle();
  } else if (gameState == 4) {
    pushStyle();
    fill(200,200,127);
    text("GAME CLEAR!!\nCLICK TO RESTART", width/2, height/2);
    popStyle();
  }
  popStyle();

  //clear key state
  keyPulseState.clear();

  //clear sound state
  hit.activate();
  hit2.activate();
  bounce.activate();
  coin.activate();
  boom.activate();
}
