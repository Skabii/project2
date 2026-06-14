void assetSetup() {
  brickImg = loadImage("brick.png");
  addBallImg = loadImage("addBall.png");
  multiBallImg = loadImage("multiBall.png");

  tileTableSetup();

  levels = loadJSONArray("levels.json");
}
