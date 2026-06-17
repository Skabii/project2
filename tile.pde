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
  tileTable.put("1", new TileRed());
  tileTable.put("2", new TileGreen());
  tileTable.put("3", new TileBlack());
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
    void hit(PlayerBall thisBall, int x, int y) {
    score++;
    hit.play();
    active = false;
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
  }
  void hit(PlayerBall thisBall, int x, int y) { //공이 닿았을때 행동, thisBall은 닿은 공 객체, x/y는 이 타일의 좌표
    if (active) { //활성화 (파괴 전) 상태면
      score++;
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
      active = false;
      for (int boomX=-1; boomX<=1; boomX++) {
        for (int boomY=-1; boomY<=1; boomY++) {
          Tile boomTile = board.getTileOrNull(x+boomX,y+boomY);
          if (boomTile != null) {
            boomTile.hit(thisBall,x+boomX,y+boomY);
          }
        }
      }
    }
  }

  TileBoom copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileBoom();
  }
}

<<<<<<< HEAD
//한국어로 된 부분들 바꾸면 됨
class TileRed extends Tile {
  TileRed() {
    tileInit(colorRed); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = true; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }
  void hit(PlayerBall thisBall) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
    if (active) { //활성화 (파괴 전) 상태면
      //무언가 일어남
      active = false; //이 타일을 파괴
    }
  }
  TileRed copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileRed();
  }
}
//한국어로 된 부분들 바꾸면 됨
class TileGreen extends Tile {
  TileGreen() {
    tileInit(colorGreen); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = true; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }
  void hit(PlayerBall thisBall) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
    if (active) { //활성화 (파괴 전) 상태면
      //무언가 일어남
      active = false; //이 타일을 파괴
    }
  }
  TileGreen copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileGreen();
  }
}
//한국어로 된 부분들 바꾸면 됨
class TileBlack extends Tile {
  TileBlack() {
    tileInit(colorBlack); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
    this.clearRequirement = true; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
  }
  void hit(PlayerBall thisBall) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
    if (active) { //활성화 (파괴 전) 상태면
      //무언가 일어남
      active = false; //이 타일을 파괴
    }
  }
  TileBlack copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
    return new TileBlack();
  }
}
=======
// class TileBoom extends Tile {
//   TileBoom() {
//     tileInit(BoomImg); //brickImg를 다른 PImage로 바꾸면 외형이 그 이미지로 나타남
//     this.clearRequirement = false; //true면 이 타일을 깨야 클리어 판정, false면 이 타일은 안깨도 클리어 판정
//   }

//   void hit(PlayerBall thisBall) { //공이 닿았을때 행동, thisBall은 닿은 공 객체
//     boom.play();
//     if (active) { //활성화 (파괴 전) 상태면
//       score++;
//       for (int y=0; y<board.tileArray.length; y++) {
//         if (!active){return;}
//         Tile[] thisLine = board.tileArray[y];
//         for (int x=0; x<thisLine.length; x++) {
//           if (!active){return;}
//           if (thisLine[x] != null) {
//             //자기자신 찾기
//             if (thisLine[x]== this) {
//               //
//               println(thisLine[x]);
//               active = false;
//               if(y-1>=0&&board.tileArray[y-1]!=null){
//                 thisLine =board.tileArray[y-1];
//                 if(x-1>=0&&thisLine[x-1]!=null){
//                   thisLine[x-1].hit(thisBall);
//                 }
//                 if(thisLine[x]!=null){
//                   thisLine[x].hit(thisBall);
//                 }
//                 if(x+1<thisLine.length&&thisLine[x+1]!=null){
//                   thisLine[x+1].hit(thisBall);
//                 }
//               }
//               //
//               if(board.tileArray[y]!=null){
//                 thisLine =board.tileArray[y];
//                 if(x-1>=0&&thisLine[x-1]!=null){
//                   thisLine[x-1].hit(thisBall);
//                 }
//                 if(thisLine[x]!=null){
//                   thisLine[x].hit(thisBall);
//                 }
//                 if(x+1<thisLine.length&&thisLine[x+1]!=null){
//                   thisLine[x+1].hit(thisBall);
//                 }
//               }
//               //
//               if(y+1<board.tileArray.length&&board.tileArray[y+1]!=null){
//                 thisLine =board.tileArray[y+1];
//                 if(x-1>=0&&thisLine[x-1]!=null){
//                   thisLine[x-1].hit(thisBall);
//                 }
//                 if(thisLine[x]!=null){
//                   thisLine[x].hit(thisBall);
//                 }
//                 if(x+1<thisLine.length&&thisLine[x+1]!=null){
//                   thisLine[x+1].hit(thisBall);
//                 }
//               }
//               break;
//             }
//             //실행
//           }
//           //null확인
//         }
//         //for문x
//     }
//     //for문 y
//     active = false;
//   }
//   //active
//  //이 타일을 파괴
//   }
//   TileBoom copy() { //맨 처음에 맵 생성할때 쓰이는 함수, 타일이름이 클래스에서의 이름이랑 같아야 함
//     return new TileBoom();
//   }
// }
>>>>>>> a2b6379857943e47516b19f844c708d9b90b989f
