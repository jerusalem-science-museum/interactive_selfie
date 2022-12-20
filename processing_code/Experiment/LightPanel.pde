final color initColor = color(100, 255, 50);  // This is in HSB, but the rest of the sketch uses RGB, so we emulate it
final int initX = 220;
final int initY = 999; //0;
final int resetTime = 5000;
final int minDelayBetCmds = 100;
final int colorWhiteClapJumpVal = 50;
final int colorWhiteTouchJumpVal = 25;
final int powerClapJumpVal = 50;
final int powerTouchJumpVal = 15;
final int verticalClapJumpVal = 200;
final int verticalTouchJumpVal = 100; //50;
final int horizontalClapJumpVal = 56;
final int horizontalTouchJumpVal = 12;
final int maxPower = 100;

final boolean LightPanelDebug = false;

class LightPanel {
  Serial lightPort;
  Logger logger;
  color col;
  color targetCol;
  int x, y;
  int targetX, targetY;
  boolean resetFinished = false;
  int resetTimer;
  int rateTimer;
  int vertClapDir, horClapDir;

  public LightPanel(Serial port, Logger log) {
    lightPort = port;
    logger = log;
    resetTimer = millis();
  }

  public void reset() {
    col = initColor;
    targetCol = color(0);
    x = -1;
    y = -1;
    targetX = initX;
    targetY = initY;
    vertClapDir = -1;
    horClapDir = 1;
    //resetFinished = false;
    //resetTimer = millis();
  }

  public void run() {
    // next line reads everything from the arduino, so may disable it as input.
    /*    while (lightPort.available()>0) print((char)lightPort.read());  */
    if (resetFinished) {
      if (millis() >= rateTimer) {
        rateTimer = millis() + minDelayBetCmds;
        if (targetCol != col) {
          col = targetCol;
          write("C " + (int)red(col) + " " + (int)green(col) + " " + (int)blue(col) + "\n");
        }
        if (targetX != x) {
          x = targetX;
          write("X " + x + "\n");
        }
        if (targetY != y) {
          y = targetY;
          write("Y " + y + "\n");
        }
      }
    } else {
      if (millis() > resetTimer + resetTime) {
        resetFinished = true;
        write("S -5\n");  // set light shape and size. positive number = circle. negative = square.
        rateTimer = millis() + minDelayBetCmds;
      }
    }
  }

  public boolean setOnOff(int i) {
    boolean on = false;
    if (i <= CLAP_IDLE) {  // clapping - switch between on/off
      if (i == CLAP_CLAPPING) {
        if (targetCol == color(0)) on= true;
      } else {
        on = (targetCol == initColor);
      }
    } else if (i >= TOUCH_IDLE) {  // touching - switch by direction
      if (i == TOUCH_RIGHT) on = true;
      else if (i == TOUCH_IDLE) on = (targetCol == initColor);
    } else if (i>500) {
      on = true;
    }

    if (on) {
      targetCol = initColor;
    } else {
      targetCol = color(0);
    }
    return on;
  }

  public void setColorWhite(int i) {
    if (i <= CLAP_IDLE) {  // clapping - rotate netween values
      if (i == CLAP_CLAPPING) {
        float sat = green(col)-colorWhiteClapJumpVal;
        if (sat < 0) sat = 255;
        targetCol = color(red(col), sat, blue(col));
      }
    } else if (i >= TOUCH_IDLE) {  // touching - change by direction
      if (i == TOUCH_RIGHT) {
        float sat = green(col) - colorWhiteTouchJumpVal;
        if (sat < 0) sat = 0;
        targetCol = color(red(col), sat, blue(col));
      } else if (i == TOUCH_LEFT) {
        float sat = green(col) + colorWhiteTouchJumpVal;
        if (sat > 255) sat = 255;
        targetCol = color(red(col), sat, blue(col));
      }
    } else {
      targetCol = color(red(col), 255-256*i/1000, blue(col));  // lower saturation to bring closer to white
    }
  }

  public void setPower(int i) {
    if (i <= CLAP_IDLE) {  // clapping - rotate netween values
      if (i == CLAP_CLAPPING) {
        float pow = blue(col) + powerClapJumpVal;
        if (pow > maxPower) pow = 50;
        targetCol = color(red(col), green(col), pow);
      }
    } else if (i >= TOUCH_IDLE) {  // touching - switch by direction
      if (i == TOUCH_RIGHT) {
        float pow = blue(col) + powerTouchJumpVal;
        if (pow > maxPower) pow = maxPower;
        targetCol = color(red(col), green(col), pow);
      } else if (i == TOUCH_LEFT) {
        float pow = blue(col) - powerTouchJumpVal;
        if (pow < 50) pow = 50;
        targetCol = color(red(col), green(col), pow);
      }
    } else {
      targetCol = color(red(col), green(col), constrain(maxPower*i/1000, 50, maxPower));  // raise brightness
    }
  }

  public void setVertical(int i) {
    if (i <= CLAP_IDLE) {  // clapping - rotate netween values
      if (i == CLAP_CLAPPING) {
        targetY = y + verticalClapJumpVal * vertClapDir;
        if (targetY >= 999) {
          targetY = 999;
          vertClapDir = -1;
        } else if (targetY <= 0) {
          targetY = 0;
          vertClapDir = 1;
        }
      }
    } else if (i >= TOUCH_IDLE) {  // touching - switch by direction
      if (i == TOUCH_RIGHT) {
        targetY = constrain(y - verticalTouchJumpVal, 0, 999);
      } else if (i == TOUCH_LEFT) {
        targetY = constrain(y + verticalTouchJumpVal, 0, 999);
      }
    } else {
      targetY = 999 - i;
    }
  }

  public void setHorizontal(int i) {
    if (i <= CLAP_IDLE) {  // clapping - rotate netween values
      if (i == CLAP_CLAPPING) {
        targetX = x + horizontalClapJumpVal * horClapDir;
        if (targetX >= 999) {
          targetX = 999;
          horClapDir = -1;
        } else if (targetX <= 0) {
          targetX = 0;
          horClapDir = 1;
        }
      }
    } else if (i >= TOUCH_IDLE) {  // touching - switch by direction
      if (i == TOUCH_RIGHT) {
        targetX = constrain(x + horizontalTouchJumpVal, 0, 999);
      } else if (i == TOUCH_LEFT) {
        targetX = constrain(x - horizontalTouchJumpVal, 0, 999);
      }
    } else {
      targetX = i;
    }
  }

  private void write(String cmd) {
    if (lightPort != null) {
      lightPort.write(cmd);
    } else {
      print("NO COMM TO LIGHTPANEL! ");
    }
    if (LightPanelDebug) println("LightPanel cmd: " + cmd);
  }

  public void logSummary() {
    logger.log("Summary_Color", 255 - (int)green(col));
    logger.log("Summary_Power", (int)blue(col));
    logger.log("Summary_Y", y);
    logger.log("Summary_X", x);
  }
  
  public void stop() {
    println("Turning light off...");
    write("C 0 0 0\n");
  }
}
