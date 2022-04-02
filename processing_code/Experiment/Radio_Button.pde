class Radio_Button extends Checkbox {
  PImage img_non;
  Radio_Button[] connected_RBs;

  public Radio_Button(int bx, int by, PImage i, PImage in) {
    super(bx, by, i);
    img_non = in;
  }

  public void assignConnected(Radio_Button[] rbl) {
    connected_RBs = rbl;
  }

  @Override
    public void run() {
    if (active) {
      if ((img != null) && state) {
        image (img, x, y);
      } else {
        image (img_non, x, y);
      }
    }
  }

  public boolean touched(int mx, int my) {
    if (super.touched(mx, my)) {
      state = true;
      for (int i=0; i<connected_RBs.length; i++) {
        connected_RBs[i].off();
      }
      return true;
    }
    return false;
  }
}
