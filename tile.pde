void tileTableSetup() {
  tileTable = new HashMap<String, Tile>();
  tileTable.put("x", null);
  tileTable.put("o", new Tile());
  tileTable.put("b", new TileBedrock());
  tileTable.put("+", new TileAddBall());
  tileTable.put("*", new TileMultiBall());

  //tileTable.put("?", new Tile타일이름()); //?를 아무 글자 한글자로 교체
}

class Tile {
  PImage img;
  boolean active;
  boolean clearRequirement;
  Tile() {
    tileInit(brickImg);
    this.clearRequirement = true;
  }
  void tileInit(PImage img) {
    this.img = img;
    this.active = true;
  }

  @SuppressWarnings("unused")
    void hit(PlayerBall thisBall) {
    active = false;
  }
  Tile copy() {
    return new Tile();
  }
}

//한국어로 된 부분들 바꾸면 됨
class Tile타일이름 extends Tile {
  Tile타일이름() {
    tileInit(brickImg); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = false; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }
  void hit(PlayerBall thisBall) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
    if (active) { //활성화 (파괴 전) 상태면
      //무언가 일어남
      active = false; //이 타일을 파괴
    }
  }
  Tile타일이름 copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new Tile타일이름();
  }
}


class TileBedrock extends Tile {
  TileBedrock() {
    tileInit(colorRect(color(200), color(200)));
    clearRequirement = false;
  }
  void hit(PlayerBall thisBall) {
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
  void hit(PlayerBall thisBall) {
    if (active) {
      addBall(3);
      active = false;
    }
  }
  TileAddBall copy() {
    return new TileAddBall();
  }
}

class TileMultiBall extends Tile {
  TileMultiBall() {
    tileInit(addBallImg);
    this.clearRequirement = true;
  }
  void hit(PlayerBall thisBall) {
    if (active) {
      multiBall(2, thisBall);
      active = false;
    }
  }
  TileMultiBall copy() {
    return new TileMultiBall();
  }
}
