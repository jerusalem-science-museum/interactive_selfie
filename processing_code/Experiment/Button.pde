class Button {
  int x, y, w, h;
  PImage img;
  boolean active = false;

  public Button() {
  }
  
  public Button(int bx, int by, String fileName) {
    img = loadImage(fileName);
    x = bx;
    y = by;
    w = img.width;
    h = img.height;
  }

  public Button(int bx, int by, PImage i) {
    img = i;
    x = bx;
    y = by;
    w = img.width;
    h = img.height;
  }

  public Button(int bx, int by, int bw, int bh) {
    x = bx;
    y = by;
    w = bw;
    h = bh;
  }

  public void show() {
    active = true;
  }

  public void hide() {
    active = false;
  }

  public void run() {
    if (active) {
      if (img != null) image (img, x, y);
    }
  }

  public boolean touched(int mx, int my) {
    return (active && (mx>x) && (mx<x+w) && (my>y) && (my<y+h));
  }
}
