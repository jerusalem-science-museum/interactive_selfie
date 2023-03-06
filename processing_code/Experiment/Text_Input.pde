import java.awt.*;
import java.awt.event.KeyEvent;
import java.io.InputStreamReader;

static class Text_Input {
  static Robot robot;
  int x, y;
  int w;
  int lines;
  int align;
  boolean active;
  boolean showText;
  String txt;
  PApplet parent;
  int cursorC;
  int txtLines;  // lines that have text in them. 0 = none or 1 line
  int scrollL;
  int scrollC;
  //static PFont hebEngFont;
  //static PFont arabEngFont;

  public Text_Input (PApplet par, int tx, int ty, int tw, int tl, Lang ln) {
    x = tx;
    y = ty;
    w = tw;
    lines = tl;
    if (ln == Lang.ENGLISH) align = LEFT;
    else align = RIGHT;
    active = false;
    parent = par;
  }

  public void show() {
    txt = "";
    txtLines = 0;
    cursorC = 0;
    scrollL = 0;
    scrollC = 0;
    showText = true;
  }

  public void hide() {
    showText = false;
  }

  public void begin() {
    active = true;
  }

  public void end() {
    active = false;
  }

  public String getText() {
    return txt;
  }

  public void run() {
    if (showText) {
      parent.fill(0);
      parent.textAlign(align, TOP);

      // display cursor
      if (active && ((parent.millis()/500)%2==0)) {
        parent.stroke(22, 49, 103);
        parent.strokeWeight(1);
        int cx=0;
        int line=0;
        if (lines == 1) {
          if (parent.textWidth(txt) > w) {  // if text too long
            if (cursorC < scrollC) scrollC = cursorC;
            cx = (int)parent.textWidth(txt.substring(scrollC, cursorC));
            while (cx>=w) {
              scrollC++;
              cx = (int)parent.textWidth(txt.substring(scrollC, cursorC));
            }
          } else {  // text not too long
            cx = (int)parent.textWidth(txt.substring(0, cursorC));
          }
        } else {
          int c=0;
          int lineStart=0;
          String txtL = toLines();
          for (; c<cursorC; c++) {
            if (txtL.charAt(c) == '\n')
            {
              line++;
              lineStart = c+1;
            }
          }
          // scroll up or down if needed
          if (line-scrollL > 2) scrollL++;
          if (line<scrollL) scrollL--;

          //println(txt.length(), txtL.length(), cursorL, cursorC, c);
          cx = (int)parent.textWidth(txtL.substring(lineStart, cursorC));
        }
        if (align==RIGHT) cx = w-cx;
        parent.line(x+cx, y+(line-scrollL)*42, x+cx, y+(line+1-scrollL)*42);
      }

      // display text
      if (lines == 1) {
        if (parent.textWidth(txt) > w) {  // if text too long - show only end
          String sTxt = txt.substring(scrollC, txt.length());
          while (parent.textWidth(sTxt) > w) {
            sTxt = sTxt.substring(0, sTxt.length()-1);
          }
          parent.text(sTxt, x, y, w, lines*43);
        } else {
          parent.text(txt, x, y, w, lines*43);
        }
      } else {
        if (txtLines<3) {
          parent.text(toLines(), x, y, w, lines*43);
        } else {
          String txtL = toLines();
          int c=0;
          // skip scrolled lines
          for (int l=0; l<scrollL; l++) {
            do c++;
            while (txtL.charAt(c)!='\n');
            c++;
          }
          String txtF = "";
          // join max 3 lines
          for (int l=0; l<3; l++) {
            do txtF += txtL.charAt(c++);
            while ((c < txtL.length()) && (txtL.charAt(c)!='\n'));
            if (c == txtL.length()) break;
            //c++;
          }
          parent.text(txtF, x, y, w, lines*43);
        }
      }
    }
  }


  public void keyPressed(char key) {
    if (active) {
      if (key == CODED) {
        switch (parent.keyCode) {
        case UP:
          {
            if (lines>1) {
              // get line and cx
              int c=0;
              int line=0;
              int lineStart=0;
              String txtL = toLines();
              for (; c<cursorC; c++) {
                if (txtL.charAt(c) == '\n')
                {
                  line++;
                  lineStart = c+1;
                }
              }
              int cx = (int)parent.textWidth(txtL.substring(lineStart, cursorC));
              if (line>0) {
                line--;
                if (line<scrollL) scrollL--; // scroll down if needed
                if (align==RIGHT) cx = w-cx;
                touched (x+cx, y+30+(line-scrollL)*42); // "touch" at correct x, y to set new cursor location
              }
            }
          }
          break;

        case DOWN:
          {
            if (lines>1) {
              // get line and cx
              int c=0;
              int line=0;
              int lineStart=0;
              String txtL = toLines();
              for (; c<cursorC; c++) {
                if (txtL.charAt(c) == '\n')
                {
                  line++;
                  lineStart = c+1;
                }
              }
              int cx = (int)parent.textWidth(txtL.substring(lineStart, cursorC));
              if (line<txtLines) {
                line++;
                if (line-scrollL>2) scrollL++; // scroll up if needed
                if (align==RIGHT) cx = w-cx;
                touched (x+cx, y+30+(line-scrollL)*42); // "touch" at correct x, y to set new cursor location
                // println(scrollL, line, cursorC, txt.length());
              }
            }
          }
          break;

        case LEFT:
          if (align==RIGHT) {
            if (cursorC < txt.length()) cursorC++;
          } else {
            if (cursorC > 0) cursorC--;
          }
          break;

        case RIGHT:
          if (align==LEFT) {
            if (cursorC < txt.length()) cursorC++;
          } else {
            if (cursorC > 0) cursorC--;
          }
          break;

        default:
          break;
        }
      } else {
        switch (key) {
        case BACKSPACE:
          if (cursorC > 0) {
            txt = txt.substring(0, cursorC - 1) + txt.substring(cursorC, txt.length());
            cursorC--;
          }
          break;

        case DELETE:
          if ((txt.length() > 0) && (cursorC < txt.length())) {
            txt = txt.substring(0, cursorC) + txt.substring(cursorC+1, txt.length());
          }
          break;

        case ENTER:
          if (lines>1) {
            if (cursorC == txt.length()) {
              txt = txt+'\n';
            } else {
              txt = txt.substring(0, cursorC) + '\n' + txt.substring(cursorC, txt.length());
            }
            cursorC++;
            toLines();
          }
          break;

        case TAB:
        case ESC:
          break;

        default:
          if (cursorC == txt.length()) {
            txt = txt+key;
          } else {
            txt = txt.substring(0, cursorC) + key + txt.substring(cursorC, txt.length());
          }
          cursorC++;
        }
      }
    }
  }

  public boolean touched(int mx, int my) {
    if (showText && (mx>=x) && (mx<=x+w) && (my>=y) && (my<=y+(lines*42))) {
      showOSK();
      if (!active) {
        active = true;
      } else {
        if (lines>1) {
          int l = (my-y)/42 + scrollL;
          if (l > txtLines) {
            cursorC = txt.length();
          } else {
            int c=0;
            String txtL = toLines();
            for (int q=0; q<l; q++) {
              do c++;
              while (txtL.charAt(c)!='\n');
              c++;
            }
            cursorC = c;
            if (align==RIGHT) {
              while (((int)parent.textWidth(txtL.substring(c, cursorC)) < w-(mx-x)) && (cursorC < txtL.length()) && (txtL.charAt(cursorC) != '\n')) cursorC++;
              if ((cursorC>0) && (cursorC>c) && abs(parent.textWidth(txtL.substring(c, cursorC-1)) - (w-(mx-x))) < abs(parent.textWidth(txtL.substring(c, cursorC)) - (w-(mx-x)))) cursorC--;
            } else {
              while (((int)parent.textWidth(txtL.substring(c, cursorC)) < mx-x) && (cursorC < txtL.length()) && (txtL.charAt(cursorC) != '\n')) cursorC++;
              if ((cursorC>0) && (cursorC>c) && abs(parent.textWidth(txtL.substring(c, cursorC-1)) - (mx-x)) < abs(parent.textWidth(txtL.substring(c, cursorC)) - (mx-x))) cursorC--;
            }
          }
        } else {
          cursorC = scrollC;
          if (align==RIGHT) {
            while (((int)parent.textWidth(txt.substring(scrollC, cursorC)) < w-(mx-x)) && (cursorC < txt.length())) cursorC++;
            if ((cursorC>0) && (abs(parent.textWidth(txt.substring(scrollC, cursorC-1)) - (w-(mx-x))) < abs(parent.textWidth(txt.substring(scrollC, cursorC)) - (w-(mx-x))))) cursorC--;
          } else {
            while (((int)parent.textWidth(txt.substring(scrollC, cursorC)) < mx-x) && (cursorC < txt.length())) cursorC++;
            if ((cursorC>0) && (abs(parent.textWidth(txt.substring(scrollC, cursorC-1)) - (mx-x)) < abs(parent.textWidth(txt.substring(scrollC, cursorC)) - (mx-x)))) cursorC--;
          }
        }
      }
      return true;
    }
    return false;
  }

  private String toLines() {
    String t = txt;
    String outTxt = "";
    while (parent.textWidth(t) > w) {
      // find first character beyond width
      int f=0;
      while (parent.textWidth(t.substring(0, f)) <= w) f++;
      f--;
      // go backwards to first space
      while ((f>0) && (t.charAt(f) != ' ')) f--;
      // split text
      outTxt += t.substring(0, f) + '\n';
      t = t.substring(f+1);
    }
    outTxt += t;
    // cout text lines
    txtLines = 0;
    for (int c=0; c<outTxt.length(); c++) {
      if (outTxt.charAt(c)=='\n') txtLines++;
    }
    return outTxt;
  }

  static {
    try {
      robot = new Robot();
      //proc = Runtime.getRuntime().exec("osk");
    }
    catch (AWTException e) {
      println(e.toString());
    }
  }

  static void setLang(Lang lng) {
    robot.keyPress(java.awt.event.KeyEvent.VK_ALT);
    robot.keyPress(java.awt.event.KeyEvent.VK_SHIFT);
    switch (lng) {
    case ENGLISH:
      robot.keyPress(java.awt.event.KeyEvent.VK_0);
      robot.keyRelease(java.awt.event.KeyEvent.VK_0);
      break;
    case HEBREW:
      robot.keyPress(java.awt.event.KeyEvent.VK_1);
      robot.keyRelease(java.awt.event.KeyEvent.VK_1);
      break;
    case ARABIC:
      robot.keyPress(java.awt.event.KeyEvent.VK_2);
      robot.keyRelease(java.awt.event.KeyEvent.VK_2);
      break;
    }
    robot.keyRelease(java.awt.event.KeyEvent.VK_SHIFT);
    robot.keyRelease(java.awt.event.KeyEvent.VK_ALT);
  }

  static void showOSK(Lang ln) {
    try {
      setLang(ln);
      showOSK();
    }
    catch (Exception err) {
      err.printStackTrace();
    }
  }

  static void showOSK() {
    try {
      StringList list = new StringList();
      StringList err = new StringList();
      shell(list, err, "tasklist|findstr/C:osk");
      if (list.size()==0) {
        robot.keyPress(java.awt.event.KeyEvent.VK_ALT);
        robot.keyPress(java.awt.event.KeyEvent.VK_K);
        robot.keyRelease(java.awt.event.KeyEvent.VK_K);
        robot.keyRelease(java.awt.event.KeyEvent.VK_ALT);
      }
    }
    catch (Exception err) {
      err.printStackTrace();
    }
  }

  static void hideOSK() {
    try {
      StringList list = new StringList();
      StringList err = new StringList();
      shell(list, err, "tasklist|findstr/C:osk");
      if (list.size()>0) {
        robot.keyPress(java.awt.event.KeyEvent.VK_ALT);
        robot.keyPress(java.awt.event.KeyEvent.VK_K);
        robot.keyRelease(java.awt.event.KeyEvent.VK_K);
        robot.keyRelease(java.awt.event.KeyEvent.VK_ALT);
        //robot.keyPress(java.awt.event.KeyEvent.VK_WINDOWS);
        //robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);
        //robot.keyPress(java.awt.event.KeyEvent.VK_O);
        //robot.keyRelease(java.awt.event.KeyEvent.VK_O);
        //robot.keyRelease(java.awt.event.KeyEvent.VK_WINDOWS);
        //robot.keyRelease(java.awt.event.KeyEvent.VK_CONTROL);
      }
    }
    catch (Exception err) {
      err.printStackTrace();
    }
  }
}
