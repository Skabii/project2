class Sprite {
  PVector pos;
  PVector dpos;
  Sprite(float x, float y, float dx, float dy) {
    this.pos = new PVector();
    this.pos.x = x;
    this.pos.y = y;
    this.dpos = new PVector();
    this.dpos.x = dx;
    this.dpos.y = dy;
  }
  Sprite() {
    this.pos = new PVector();
    this.dpos = new PVector();
  }
  void update() {
    pos.add(dpos);
  }
}

class PlayerBall extends Sprite {
  float size, maxSpeed;
  color col;
  boolean active;
  PlayerBall(float x, float y, float dx, float dy, float size, color col, float maxSpeed) {
    super(x, y, dx, dy);
    this.size = size;
    this.col = col;
    this.maxSpeed = maxSpeed;
    this.active = true;
  }
  void update(Bar thisBar) {
    if (pos.y-size/2 >= gameGraphic.height) {
      active = false;
    }
    if (active) {
      if (pos.x+size/2 >= gameGraphic.width || pos.x-size/2 <= 0) {
        dpos.x *= -1;
        pos.x = constrain(pos.x,size/2,gameGraphic.width-size/2);
      }
      if (pos.y-size/2 <= 0) {
        dpos.y *= -1;
        pos.y = max(size/2,pos.y);
      }
    }

    if (thisBar.checkBallHit(this)) {
      bounce.play();
      if (dpos.y > 0) {
        dpos.y *= -1;
      }
      dpos.x = map(pos.x, thisBar.pos.x-thisBar.w/2, thisBar.pos.x+thisBar.w/2, -maxSpeed, maxSpeed);
    }
    if (dpos.x>0) {
      dpos.x += maxSpeed/1000;
    } else {
      dpos.x -= maxSpeed/1000;
    }
    update();
    super.update();
  }
  void render() {

    gameGraphic.pushStyle();
    gameGraphic.fill(col);
    gameGraphic.ellipse(pos.x, pos.y, size, size);
    gameGraphic.popStyle();
  }
}

class Bar extends Sprite {
  float w, h;
  color col;
  Bar(float w, float h, color col) {
    super(gameGraphic.width/2, barY, 0, 0);
    this.w = w;
    this.h = h;
    this.col = col;
  }
  void update() {
    pos.x = lerp(pos.x, map(mouseX, width/2-gameScreenSize/2, width/2+gameScreenSize/2, 0, gameGraphic.width), 0.1);
  }
  void render() {

    gameGraphic.pushStyle();
    gameGraphic.fill(col);
    gameGraphic.rectMode(CENTER);
    gameGraphic.rect(pos.x, pos.y, w, h);
    gameGraphic.popStyle();
  }

  boolean checkBallHit(PlayerBall thisBall) {
    if (inRange(thisBall.pos.x, pos.x-w/2-thisBall.size/2, pos.x+w/2+thisBall.size/2) && inRange(thisBall.pos.y, pos.y-h/2-thisBall.size/2, pos.y+h/2+thisBall.size/2)) {
      return true;
    } else {
      return false;
    }
  }
}

HashMap<String, Tile> tileTable;

Tile[][] parseTile(String tileText) {
  return parseTile(tileText, tileTable);
}

Tile[][] parseTile(String tileText, HashMap<String, Tile> tileTable) {
  String[] tileTextArray = tileText.split("\n");
  int w = tileTextArray[0].length();
  int h = tileTextArray.length;
  Tile[][] tileArray = new Tile[h][w];

  for (int y=0; y<tileTextArray.length; y++) {
    String thisLine = tileTextArray[y];
    for (int x=0; x<thisLine.length(); x++) {
      Tile tileToAdd = tileTable.get(str(thisLine.charAt(x)));
      if (tileToAdd != null) {
        tileArray[y][x] = tileToAdd.copy();
      }
    }
  }
  return tileArray;
}

class TileSet {
  Tile[][] tileArray;
  int w, h;
  float tileW, tileH;
  boolean cleared = false;
  TileSet() {
    this.tileArray = parseTile("xxooxx\nxoooox\nbboobb\nxxooxx\nxxxxxx");
  }
  TileSet(int w, int h) {
    this.tileArray = new Tile[w][h];
  }
  TileSet(String tileText) {
    this.tileArray = parseTile(tileText);
  }
  TileSet(String tileText, HashMap<String, Tile> tileTable) {
    this.tileArray = parseTile(tileText, tileTable);
  }
  void render() {
    updateSize();
    gameGraphic.pushStyle();

    gameGraphic.noStroke();
    gameGraphic.fill(180);
    gameGraphic.rect(0, 0, w, h);
    gameGraphic.popStyle();

    gameGraphic.pushStyle();
    for (int y=0; y<tileArray.length; y++) {
      Tile[] thisLine = tileArray[y];
      for (int x=0; x<thisLine.length; x++) {
        if (thisLine[x] != null) {
          gameGraphic.image(thisLine[x].img, tileW*x, tileH*y, tileW, tileH);
          //gameGraphic.rect(tileW*x,tileH*y,tileW,tileH);
        }
      }
    }

    gameGraphic.popStyle();
  }
  void updateSize() {
    w = gameGraphic.width;
    h = gameGraphic.height*2/3;

    tileW = (float) w/tileArray[0].length;
    tileH = (float) h/tileArray.length;
  }
  Tile getTileOrNull(int x, int y) {
    try {
      return tileArray[y][x];
    }
    catch (IndexOutOfBoundsException e) {
      return null;
    }
  }
  void update(ArrayList<PlayerBall> balls) {
    updateSize();
    cleared = true;
    for (int y=0; y<tileArray.length; y++) {
      Tile[] thisLine = tileArray[y];
      for (int x=0; x<thisLine.length; x++) {
        if (thisLine[x] != null) {
          float tileX = tileW*x;
          float tileY = tileH*y;
          if (thisLine[x].clearRequirement) {
            cleared = false;
          }
          for (int i=balls.size()-1; i>=0; i--) {
            PlayerBall thisBall = balls.get(i);
            // if (inRange(thisBall.pos.x, tileX-thisBall.size/2, tileX+tileW+thisBall.size/2) && inRange(thisBall.pos.y, tileY-thisBall.size/2, tileY+tileH+thisBall.size/2) ) {
            if (inRange(thisBall.pos.x, tileX-thisBall.size/2, tileX+tileW+thisBall.size/2) && inRange(thisBall.pos.y, tileY-thisBall.size/2, tileY+tileH+thisBall.size/2) ) {
              thisLine[x].hit(thisBall);
              PVector displacement = thisBall.pos.copy();
              displacement.sub(tileX+tileW/2., tileY+tileH/2.);
              displacement.x = displacement.x / tileW;
              displacement.y = displacement.y / tileH;
              if (getTileOrNull(x-1, y) != null) {
                displacement.x = max(displacement.x,0);
              } else if (getTileOrNull(x+1, y) != null) {
                displacement.x = min(displacement.x,0);
              } else if (getTileOrNull(x, y-1) != null) {
                displacement.y = max(displacement.y,0);
              } else if (getTileOrNull(x,y+1) != null) {
                displacement.y = min(displacement.y,0);
              }
              if (abs(displacement.x) > abs(displacement.y)) {
                thisBall.dpos.x *= -1;
                if (displacement.x < 0) {
                  thisBall.pos.x = tileX-thisBall.size/2;
                } else {
                  thisBall.pos.x = tileX+tileW+thisBall.size/2;
                }
              } else {
                thisBall.dpos.y *= -1;
                if (displacement.y < 0) {
                  thisBall.pos.y = tileY-thisBall.size/2;
                } else {
                  thisBall.pos.y = tileY+tileH+thisBall.size/2;
                }
              }
            }
          }
          if (!thisLine[x].active) {
            thisLine[x] = null;
          }
        }
      }
    }
  }
}

PImage colorRect(color strokeCol, color fillCol) {
  PGraphics result = createGraphics(256, 256);
  result.beginDraw();
  result.strokeWeight(4);
  result.stroke(strokeCol);
  result.fill(fillCol);
  result.rect(0, 0, result.width, result.height);
  result.endDraw();
  return result;
}

boolean inRange(float x, float min, float max) {
  return (x >= min && x<= max);
}


void addBall() {
  addBall(1);
}

void addBall(int num) {
  addBall(num,ballMaxSpeed, color(255,0,0));
}

void addBall(int num, float maxSpeed, color col) {
  for (int i=0; i<num; i++) {
    if (balls.size() < 1000) {
      balls.add(new PlayerBall(gameGraphic.width/2, barY-bar.h, random(-maxSpeed, maxSpeed), -maxSpeed, ballSize, col,ballMaxSpeed));
    }
  }
}


void multiBall(int num, PlayerBall thisBall) {
  for (int i=0; i<num; i++) {
    if (balls.size() < 1000) {
      balls.add(new PlayerBall(thisBall.pos.x, thisBall.pos.y, random(-thisBall.maxSpeed, thisBall.maxSpeed), thisBall.dpos.y, ballSize, thisBall.col,thisBall.maxSpeed));
    }
  }
}

void updateScreenSize() {
  if (width>height) {
    gameScreenSize = height;
  } else {
    gameScreenSize = width;
  }
}

void loadLevel(int level) {
  board = new TileSet(levels.getString(level));
  balls.clear();
  addBall();
}
