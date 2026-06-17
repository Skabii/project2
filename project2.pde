PGraphics gameGraphic;

import java.util.Comparator;

ArrayList<PlayerBall> balls;
ArrayList<Particle> particles;
Bar bar;
TileSet board;
float barY;

float ballMaxSpeed;
float ballSize;

float gameScreenSize;

int currentLevel;
int gameState;

int timeLeft;

int score;

String playerName = "";

JSONObject scoreData;

Comparator<ScoreEntry> compareScore = (s1, s2) -> Integer.compare(s1.score, s2.score);

String getLeaderBoard() {
  String result = "";
  ArrayList<ScoreEntry> sortedScore = new ArrayList<ScoreEntry>();
  for (String name : (java.util.Set<String>) scoreData.keys()) {
    sortedScore.add(new ScoreEntry(name, scoreData.getInt(name)));
  }
  sortedScore.sort(compareScore.reversed());
  for (int rank=0; rank<sortedScore.size(); rank++) {
    result += "[" + (rank+1) + "] " + sortedScore.get(rank) + "\n";
  }
  return result;
}

class ScoreEntry {
  String name;
  int score;
  ScoreEntry(String name, int score) {
    this.name = name;
    this.score = score;
  }
  String toString() {
    return name + " - " + score + " bricks";
  }
}

void setup() {
  pixelDensity(1);
  size(1280, 720, P2D);
  frameRate(60);
  noSmooth();
  windowResizable(true);

  scoreData = loadJSONObject("scoreData.json");

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

  currentLevel = 0;
  loadLevel(currentLevel);

  gameState = -1;
}

void draw() {
  background(127);
  updateScreenSize();

  //init game graphic
  gameGraphic.beginDraw();

  //game logic
  if (gameState == -1) { //leaderboard
    if (keyPulseState.getOrDefault(-1, false)) {
      gameState = 0;
      currentLevel = 0;
      loadLevel(currentLevel);
      score = 0;
    }
  } else if (gameState == 0) { //before game start
    if (keyPulseState.getOrDefault(-1, false)) {
      timeLeft = 60 * 30;
      gameState = 1;
    }
  } else if (gameState == 1) { //in game
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
  } else if (gameState == 2) { //clear
    if (keyPulseState.getOrDefault(-1, false)) {
      gameState = 0;
      currentLevel++;
      if (currentLevel >= levels.size()) {
        gameState = 4;
      } else {
        loadLevel(currentLevel);
      }
    }
  } else if (gameState == 3 || gameState == 4) { //game over / game clear
    if (keyPulseState.getOrDefault(10, false)) {
      scoreData.setInt(playerName,score);
      saveJSONObject(scoreData,"scoreData.json");
      gameState = -1;
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
  if (gameState == -1) { //leaderboard
    String leaderBoardText = getLeaderBoard();
    pushStyle();
    textAlign(CENTER);
    textSize(width*4/100);
    text(leaderBoardText, width/2, width*14/100);


    noStroke();
    rectMode(CORNERS);
    fill(200);
    rect(0, 0, width, width*10/100);
    textSize(width*8/100);
    fill(255);
    text("LEADERBOARD", width/2, width*8/100);
  } else if (gameState == 0) { //before game start
    text("CLICK TO START", width/2, height*3/4);
  } else if (gameState == 1) { //in game
    pushStyle();
    textSize(gameScreenSize/10);
    textAlign(CENTER, TOP);
    text(str(timeLeft/60) + " | score : "+score, width/2, 0);
    popStyle();
  } else if (gameState == 2) { //level clear
    pushStyle();
    noStroke();
    fill(0, 127);
    rect(0, height*1/3, width, height*1/3);
    popStyle();
    text("LEVEL CLEAR\nCLICK TO CONTINUE", width/2, height/2);
  } else if (gameState == 3) { //game over
    pushStyle();
    fill(200, 0, 0);
    textSize(gameScreenSize/20);
    text("GAME OVER\nTYPE NAME AND PRESS ENTER >" + playerName, width/2, height/2);
    popStyle();
  } else if (gameState == 4) { //game clear
    pushStyle();
    fill(200, 200, 127);
    textSize(gameScreenSize/20);
    text("GAME CLEAR!!\nTYPE NAME AND PRESS ENTER >" + playerName, width/2, height/2);
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
