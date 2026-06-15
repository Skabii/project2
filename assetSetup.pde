import processing.sound.*;

PImage brickImg;
PImage addBallImg;
PImage multiBallImg;
PImage shieldImg;
PImage sppedBallImg;
PImage BoomImg;
JSONArray levels;

PFont myFont;

class GameSoundEffect {
    SoundFile sound;
    boolean disabled;
    GameSoundEffect(SoundFile sound) {
        this.sound = sound;
        this.disabled = false;
    }
    void play() {
        if (!disabled) {
            sound.play();
            disabled = true;
        }
    }
    void activate() {
        disabled = false;
    }
}
GameSoundEffect hit;
GameSoundEffect hit2;
GameSoundEffect bounce;
GameSoundEffect coin;
GameSoundEffect boom;


void assetSetup() {
  brickImg = loadImage("brick.png");
  addBallImg = loadImage("addBall.png");
  multiBallImg = loadImage("multiBall.png");
  shieldImg = loadImage("shield.png");
  sppedBallImg= loadImage("Yellow.png");
  BoomImg= loadImage("Boom.png");
  tileTableSetup();

  levels = loadJSONArray("levels.json");

  myFont = createFont("bitcountsingle.ttf",displayWidth/8);
  textFont(myFont);

  hit = new GameSoundEffect(new SoundFile(this,"hit.wav"));
  hit2 = new GameSoundEffect(new SoundFile(this,"hit2.wav"));
  bounce = new GameSoundEffect(new SoundFile(this,"bounce.wav"));
  coin = new GameSoundEffect(new SoundFile(this,"coin.wav"));
  boom = new GameSoundEffect(new SoundFile(this,"boom.wav"));
}
