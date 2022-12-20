import java.util.*;

/* 
Needed libraries:
  Kinect v2 for Processing
  Deep Vision
  Sound

On the language settings of Win, set shortcuts for:
  English: Alt-Shift-0
  Hebrew:  Alt-Shift-1
  Arabic:  Alt-Shift-2
  
AutoHotKey need to be installed and the script in the processing_code folder added to startup folder of the computer (for blocking half-technical users from closing the program).
for quiting the program after running the script - press Alt-q.
*/

// tested on original computer:
// deep vision ver 0.7.1
// nvidia driver 511.79 10.2.2022
// 
// on newer computer worked with latest releases (GeForce RTX-3060 Ti)

TSession session;
Resetter resetter;
 
void setup() {
  fullScreen();
  //size(1366, 800);  // for testing on systems with better screens
  frameRate(30);  // for loggers to not write too much
  resetter = new Resetter();

  session = new TSession(this, resetter);
  session.begin();
  resetter.updateSessionLink(session);
}

void draw() {
  if (!session.running()) {
    session.begin();
  }
  session.run();
  resetter.run();  // whatchdog
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
  if (key==ESC) key = 0;  // REMOVE BEFORE FLIGHT ...
  else
  session.keyPressed(key);
}

void stop() {
  session.stop();
}
