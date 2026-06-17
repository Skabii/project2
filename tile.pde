void tileTableSetup() {
  tileTable = new HashMap<String, Tile>();
  tileTable.put("x", null);
  tileTable.put("o", new Tile());
  tileTable.put("b", new TileBedrock());
  tileTable.put("+", new TileAddBall());
  tileTable.put("*", new TileMultiBall());
  tileTable.put("s", new TileShield());
  tileTable.put(">", new TileSpeedBall());
  tileTable.put("i", new TileBoom());
  tileTable.put("j", new TileBoomOnly());
  //tileTable.put("?", new Tile타일이름()); //?를 아무 글자 한글자로 교체
}

class Tile {
  PImage img;
  boolean active;
  boolean clearRequirement;
  color particleCol;
  Tile() {
    tileInit(brickImg);
    this.clearRequirement = true;
    particleCol = color(#707070);
  }
  void tileInit(PImage img) {
    this.img = img;
    this.active = true;
  }

  @SuppressWarnings("unused")
    void hit(PlayerBall thisBall, int x, int y) {
    score++;
    hit.play();
    particle(x, y);
    active = false;
  }

  void boom(PlayerBall thisBall, int x, int y) {
    hit(thisBall, x, y);
  }

  void particle(int x, int y) {
    for (int i=0; i<4; i++) {
      particles.add(new Particle((x+0.5)*board.tileW, (y+0.5)*board.tileH, random(-gameScreenSize/100, gameScreenSize/100), random(-gameScreenSize/100, gameScreenSize/100), particleCol));
    }
  }
  Tile copy() {
    return new Tile();
  }
}

//한국어로 된 부분들 바꾸면 됨
//board.getTileOrNull(x,y); 보드에 있는 타일 불러울때는 이걸로
class Tile타일이름 extends Tile {
  Tile타일이름() {
    tileInit(brickImg); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = false; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
    particleCol = color(#707070); //파티클 색
  }
  void hit(PlayerBall thisBall, int x, int y) { //공이 닿았을때 행동, thisBall은 닿은 공 객체, x/y는 이 타일의 좌표
    if (active) { //활성화 (파괴 전) 상태면
      score++;
      //무언가 일어남
      particle(x, y); //파티클 추가
      active = false; //이 타일을 파괴
    }
  }
  Tile타일이름 copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new Tile타일이름();
  }
}


class TileBedrock extends Tile {
  TileBedrock() {
    tileInit(colorRect(color(200), color(127)));
    clearRequirement = false;
  }
  void hit(PlayerBall thisBall, int x, int y) {
  }
  TileBedrock copy() {
    return new TileBedrock();
  }
}

class TileAddBall extends Tile {
  TileAddBall() {
    tileInit(addBallImg);
    this.clearRequirement = true;
  }
  void hit(PlayerBall thisBall, int x, int y) {
    if (active) {
      score++;
      coin.play();
      addBall(3);
      particle(x, y); //파티클 추가
      active = false;
    }
  }
  TileAddBall copy() {
    return new TileAddBall();
  }
}

class TileMultiBall extends Tile {
  TileMultiBall() {
    tileInit(multiBallImg);
    this.clearRequirement = true;
  }
  void hit(PlayerBall thisBall, int x, int y) {
    if (active) {
      score++;
      coin.play();
      multiBall(2);
      particle(x, y); //파티클 추가
      active = false;
    }
  }
  TileMultiBall copy() {
    return new TileMultiBall();
  }
}

class TileShield extends Tile {
  boolean shield;
  int hitFrame;
  TileShield() {
    tileInit(shieldImg);
    this.shield = true;
    this.clearRequirement = true;
  }
  void hit(PlayerBall thisBall, int x, int y) {
    if (active) {
      if (shield) {
        hit2.play();
        shield = false;
        img = brickImg;
        hitFrame = frameCount;
      } else if (hitFrame != frameCount) {
        score++;
        hit.play();
        particle(x, y); //파티클 추가
        active = false;
      }
    }
  }
  TileShield copy() {
    return new TileShield();
  }
}


class TileSpeedBall extends Tile {
  TileSpeedBall() {
    tileInit(sppedBallImg); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = true; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }
  void hit(PlayerBall thisBall, int x, int y) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
    if (active) { //활성화 (파괴 전) 상태면
      score++;
      coin.play();
      addBall(2, 2*ballMaxSpeed, color(255, 255, 0));
      particle(x, y); //파티클 추가
      active = false; //이 타일을 파괴
    }
  }
  TileSpeedBall copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileSpeedBall();
  }
}

class TileBoom extends Tile {
  TileBoom() {
    tileInit(BoomImg); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = true; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }

  void hit(PlayerBall thisBall, int x, int y) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
    if (active) { //활성화 (파괴 전) 상태면
      score++;
      boom.play();
      particle(x, y); //파티클 추가
      active = false;
      for (int boomX=-1; boomX<=1; boomX++) {
        for (int boomY=-1; boomY<=1; boomY++) {
          Tile boomTile = board.getTileOrNull(x+boomX, y+boomY);
          if (boomTile != null) {
            boomTile.boom(thisBall, x+boomX, y+boomY);
          }
        }
      }
    }
  }

  TileBoom copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileBoom();
  }
}

class TileBoomOnly extends Tile {
  TileBoomOnly() {
    tileInit(brickGrayImg); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = false; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }
  void hit(PlayerBall thisBall, int x, int y) { //공이 닿았을때 행동, thisBall은 닿은 공 객체, x/y는 이 타일의 좌표
  }
  void boom(PlayerBall thisBall, int x, int y) { //공이 닿았을때 행동, thisBall은 닿은 공 객체, x/y는 이 타일의 좌표
    if (active) { //활성화 (파괴 전) 상태면
      score++;
      //무언가 일어남
      particle(x, y); //파티클 추가
      active = false; //이 타일을 파괴
    }
  }
  TileBoomOnly copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileBoomOnly();
  }
}
