class Slider extends Button {
  boolean grabbed = false;
  int state;
  final int WIDTH = 1015;
  final int BLEED = 20; // touch tolerance around bounding box

  public Slider(int bx, int by, PImage i) {
    super(bx, by, i);
    w = WIDTH;
    h+=20; // tolerate touches on slider bar itself (below triangle)
  }

  @Override
    public void show() {
    state = 0;
    active = true;
  }

  @Override
    public void run() {
    if (active) {
      if (img != null) image (img, x+state, y);
    }
  }

  @Override
    public boolean touched(int mx, int my) {
    if (active && (mx>x-BLEED) && (mx<x+w+BLEED) && (my>y-BLEED) && (my<y+h+BLEED)) {
      grabbed = true;
      state = mx-x-22;
      state = constrain(state,0,WIDTH);
      return true;
    }
    return false;
  }
  
  public void released() {
    grabbed = false;
  }
  
  public void dragged(int mx) {
    if (grabbed) {
      state = mx-x-22;
      state = constrain(state,0,WIDTH);
    }
  }
  
  public int getState() {
    return (state*99)/WIDTH+1;  // 1 - 100
  }
}
