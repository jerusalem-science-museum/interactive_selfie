import java.util.*;

// deep vision ver 7.0.1
// nvidia driver 511.79 10.2.2022

TSession session;
Resetter resetter;

void setup() {
  fullScreen();
  //size(1366, 800);
  frameRate(30);  // for loggers to not write too much
  resetter = new Resetter();

  session = new TSession(this, resetter);
  session.begin();
  resetter.updateSessionLink(session);
}

void draw() {
  session.run();
  resetter.run();  // whatchdog
  if (!session.running()) {
    session.begin();
  }
}

void mousePressed() {
  resetter.resetTimer();
  session.touch(mouseX, mouseY);
}

void mouseReleased() {
  session.released();
}

void mouseDragged() {
  resetter.resetTimer();
  session.dragged(mouseX);
}

void keyPressed() {
  resetter.resetTimer();
  //if (key==ESC) key = 0;  // REMOVE BEFORE FLIGHT ...
  //else
  session.keyPressed(key);
}
