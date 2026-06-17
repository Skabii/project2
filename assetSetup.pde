import processing.sound.*;

PImage brickImg;
PImage addBallImg;
PImage multiBallImg;
PImage shieldImg;
PImage sppedBallImg;
PImage BoomImg;
<<<<<<< HEAD
PImage colorRed;
PImage colorGreen;
PImage colorBlack;


=======
PImage brickBlueImg;
PImage brickGrayImg;
PImage brickGreenImg;
PImage brickPurpleImg;
PImage brickRedImg;
PImage brickYellowImg;
>>>>>>> a2b6379857943e47516b19f844c708d9b90b989f
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
<<<<<<< HEAD
    brickImg = loadImage("brick.png");
    addBallImg = loadImage("addBall.png");
    multiBallImg = loadImage("multiBall.png");
    shieldImg = loadImage("shield.png");
    sppedBallImg= loadImage("Yellow.png");
    BoomImg= loadImage("Boom.png");
=======
  brickImg = loadImage("brick.png");
  addBallImg = loadImage("addBall.png");
  multiBallImg = loadImage("multiBall.png");
  shieldImg = loadImage("shield.png");
  sppedBallImg= loadImage("Yellow.png");
  BoomImg= loadImage("Boom.png");
  brickBlueImg = loadImage("brick-blue.png");
  brickGrayImg = loadImage("brick-gray.png");
  brickGreenImg = loadImage("brick-green.png");
  brickPurpleImg = loadImage("brick-purple.png");
  brickRedImg = loadImage("brick-red.png");
  brickYellowImg = loadImage("brick-yellow.png");
  tileTableSetup();
>>>>>>> a2b6379857943e47516b19f844c708d9b90b989f


    colorRed= loadImage("Red.png");
    colorGreen= loadImage("Green.png");
    colorBlack= loadImage("Black.png");

<<<<<<< HEAD
    tileTableSetup();

    levels = loadJSONArray("levels.json");

    myFont = createFont("bitcountsingle.ttf",displayWidth/8);
    textFont(myFont);

    hit = new GameSoundEffect(new SoundFile(this,"hit.wav"));
    hit2 = new GameSoundEffect(new SoundFile(this,"hit2.wav"));
    bounce = new GameSoundEffect(new SoundFile(this,"bounce.wav"));
    coin = new GameSoundEffect(new SoundFile(this,"coin.wav"));
=======
  hit = new GameSoundEffect(new SoundFile(this,"hit.wav"));
  hit2 = new GameSoundEffect(new SoundFile(this,"hit2.wav"));
  bounce = new GameSoundEffect(new SoundFile(this,"bounce.wav"));
  coin = new GameSoundEffect(new SoundFile(this,"coin.wav"));
  boom = new GameSoundEffect(new SoundFile(this,"boom.wav"));
>>>>>>> a2b6379857943e47516b19f844c708d9b90b989f
}
