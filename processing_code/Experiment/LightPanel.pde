final color initColor = color(100, 255, 50);  // This is in HSB, but the rest of the sketch uses RGB, so we emulate it
final int initX = 0;
final int initY = 1000;

class LightPanel {
  Serial lightPort;
  color col;
  color targetCol;
  int x, y;
  int targetX, targetY;

  public LightPanel(Serial port) {
    lightPort = port;
  }

  public void reset() {
    col = initColor;
    targetCol = color(0);
    x = -1;
    y = -1;
    targetX = initX;
    targetY = initY;
    if (lightPort != null) lightPort.write("S -4\n");  // set light shape and size. positive number = circle. negative = square.
  }

  public void run() {
    if (lightPort != null) {
      if (targetCol != col) {
        col = targetCol;
        lightPort.write("C " + red(col) + " " + green(col) + " " + blue(col) + "\n");
      }
      if (targetX != x) {
        x = targetX;
        lightPort.write("X " + x + "\n");
      }
      if (targetY != Y) {
        y = targetY;
        lightPort.write("Y " + y + "\n");
      }
    }
  }

  public void setOnOff(int i) {
    if (i==0) {
      targetCol = color(0);
    } else {
      targetCol = initColor;
    }
  }

  public void setColorWhite(int i) {
    targetCol = color(red(col), 255-255*i/1000, blue(col));  // lower saturation to bring closer to white
  }

  public void setPower(int i) {
    targetCol = color(red(col), green(col), 255*i/1000.0);  // raise brightness
  }

  public void setVertical(int i) {
    x = i;
  }

  public void setHorizontal(int i) {
    y = i;
  }
}
