void setup() {
    size(500,500,P2D);
}

void draw() {
    ellipse(300,250,200,200);
    println(getPosition(null));
}

// Get the GL window for this sketch
public com.jogamp.newt.opengl.GLWindow getCanvas() {
  return (com.jogamp.newt.opengl.GLWindow) surface.getNative();
}

// Get the window position.
public PVector getPosition(PVector pos) {
  if (pos == null)
    pos = new PVector();
  pos.x = getCanvas().getX();
  pos.y = getCanvas().getY();
  return pos;
}