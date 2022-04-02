class Checkbox extends Button {
  boolean state;

  public Checkbox(int bx, int by, PImage i) {
    super(bx, by, i);
  }

  @Override
    public void run() {
    if (active) {
      if ((img != null) && state) {
        image (img, x, y);
      }
    }
  }

  @Override
    public boolean touched(int mx, int my) {
    if (active && (mx>x) && (mx<x+w) && (my>y) && (my<y+h)) {
      state = !state;
      return true;
    }
    return false;
  }

  @Override
  public void show() {
    active = true;
    state = false;
  }

  boolean getState() {
    return state;
  }

  public void on() {
    state = true;
  }

  public void off() {
    state = false;
  }
}
