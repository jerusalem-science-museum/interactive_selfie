final int touchInputIncrements = 10;

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

  public void run() {
    if (touchPort != null) {
      if (touchPort.available() > 0) {
        String in = touchPort.readStringUntil('\n');
        if (in != null) {
          String [] data = splitTokens(in, " ");
          if (data.length == 2) {
            if (data[0].equals("T")) {
              if (data[1].equals("0")) {
                output -= touchInputIncrements;
              } else if (data[1].equals("1")) {
                output += touchInputIncrements;
              }
            }
          }
        }
      }
    }
  }
}
