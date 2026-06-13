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
  float size;
  color col;
  boolean active;
  PlayerBall(float x, float y, float dx, float dy, float size, color col) {
    super(x,y,dx,dy);
    this.size = size;
    this.col = col;
  }
  void update() {
    if (pos.x+size/2 >= width || pos.x-size/2 <= 0) {
      dpos.x *= -1;
    }
    if (pos.y+size/2 >= height || pos.y-size/2 <= 0) {
      dpos.y *= -1;
    }
    super.update();
  }
  void update(Bar thisBar) {
    if (thisBar.checkBallHit(this)) {
      dpos.y *= -1;
    }
    update();
    super.update();
  }
  void render() {
    pushStyle();
    fill(col);
    ellipse(pos.x,pos.y,size,size);
    popStyle();
  }
}

class Bar extends Sprite {
  float w, h;
  color col;
  Bar(float w, float h, color col) {
    super(width/2,barY,0,0);
    this.w = w;
    this.h = h;
    this.col = col;
  }
  void update() {
    pos.x = mouseX;
  }
  void render() {
    pushStyle();
    fill(col);
    rectMode(CENTER);
    rect(pos.x,pos.y,w,h);
    popStyle();
  }

  boolean checkBallHit(PlayerBall thisBall) {
    if (inRange(thisBall.pos.x, pos.x-w/2-thisBall.size/2,pos.x+w/2+thisBall.size/2) && inRange(thisBall.pos.y, pos.y-h/2-thisBall.size/2,pos.y+h/2+thisBall.size/2)) {
      return true;
    } else {
      return false;
    }
  }
}

boolean inRange(float x, float min, float max) {
  return (x >= min && x<= max);
}

ArrayList<PlayerBall> balls;
Bar bar;
float barY;


void setup() {
    size(700,700,P2D);
    surface.setResizable(false);
    balls = new ArrayList<PlayerBall>();
    balls.add(new PlayerBall(width/2,height*3/4,width/320,-width/320,width/20,color(255,0,0)));

    barY = height*5/6;
    bar = new Bar(width/4,height/16,color(100));
}

void draw() {
    background(200);
    for (int i=balls.size()-1;i>=0;i--) {
      PlayerBall thisBall = balls.get(i);
      thisBall.update(bar);
      thisBall.render();
    }
    bar.update();
    bar.render();
}