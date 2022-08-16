final int touchInputIncrements = 10;
final int TOUCH_IDLE = 2000;
final int TOUCH_LEFT = 2001;  // these are > TOUCH_IDLE for simpler manipulation
final int TOUCH_RIGHT = 2002;

class Input_Touch extends Input {
  Serial touchPort;

  public Input_Touch(PApplet par, Logger log, Resetter res, Serial port) {
    super(par, log, res);
    touchPort = port;
  }

  public boolean begin() {
    output = 0;
    if (touchPort == null) {
      return false;
    } else {
      touchPort.clear();
      return true;
    }
  }

  // only outputs touches momntarily. In the rest of the time - output IDLE
  @Override
    public int getOutput() {
    if (output != TOUCH_IDLE) {
      resetter.resetTimer();
      int temp = output;
      output = TOUCH_IDLE;
      return temp;
    }
    return TOUCH_IDLE;
  }

  public void run() {
    if (touchPort != null) {
      if (touchPort.available() > 0) {
        String in = touchPort.readStringUntil('\n');
        if (in != null) {
          String [] data = splitTokens(in, " ");
          if (data.length == 2) {
            if (data[0].equals("T")) {
              if (data[1].equals("0\n")) {
                output = TOUCH_LEFT;
              } else if (data[1].equals("1\n")) {
                output = TOUCH_RIGHT;
              }
            }
          }
        }
      }
    }
  }
}
