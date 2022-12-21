import myselfie.emailer.SendMail;
import org.apache.commons.validator.routines.EmailValidator;
import java.io.FileWriter;
import java.io.BufferedWriter;

class Selfie implements Runnable { //extends Thread {
  PApplet parent;
  KinectPV2 kinect;
  int currentPic;
  int takingPic;
  boolean picTook;
  PImage croppedPic;
  PImage pictures[];
  int selected;
  PImage frame382;
  PImage frame284;
  PImage frame240;
  PImage frameMask;
  PGraphics mailPicPG;

  String mailAddress;
  boolean addvertise;
  SendMail sendMail;

  final String mailLogFilename = "maillog.txt";
  File file;
  FileWriter fw;
  BufferedWriter bw;

  final String imgFileName = "selfie.png";

  public Selfie(PApplet par, KinectPV2 knct) {
    parent = par;
    kinect = knct;
    pictures = new PImage[5];
    for (int i=0; i<5; i++) {
      pictures[i] = createImage(720, 720, RGB);
    }
    croppedPic = createImage(720, 720, RGB);
    mailPicPG = createGraphics(382, 382);
    sendMail = new SendMail(parent.sketchPath());
    loadFrames();
    try {
      file = new File(sketchPath(mailLogFilename));
      fw = new FileWriter(file, true);
      bw = new BufferedWriter(fw);
    }
    catch (IOException e) {
      println(e.toString());
    }
  }

  void loadFrames() {
    frame382 = loadImage("../Graphics_Common/Selfie frame - regular.png");
    frame284 = loadImage("../Graphics_Common/Selfie frame - screen 0030.png");
    frame240 = loadImage("../Graphics_Common/Selfie frame - screen 0029.png");
    frameMask = loadImage("../Graphics_Common/Selfie frame - mask.png");
  }

  public void begin() {
    takingPic++;
  }

  public void takePic() {
    pictures[currentPic++].copy(croppedPic, 0, 0, 720, 720, 0, 0, 720, 720);
  }

  public void takePicAgain() {
    currentPic--;
    show();
    takePic();
  }

  public void reset() {
    currentPic = 0;
    takingPic = -1;
    selected = -1;
  }

  public void show() {
    if (currentPic == takingPic) {
      croppedPic.copy(kinect.getColorImage(), 600, 0, 720, 720, 0, 0, 720, 720);
    }
    image(croppedPic, 492, 317, 382, 382);
    image(frame382, 492, 317);
  }

  public void showAll() {
    for (int i=0; i<5; i++) {
      image(pictures[4-i], 53 + i*255, 318, 240, 240);
      image(frame240, 53 + i*255, 318);
    }
    if (selected > -1) {
      // add nicer border for selected one
      strokeWeight(5);
      noFill();
      stroke (49, 99, 197);
      rect (53 + (4-selected)*255, 318, 240, 240, 5);
    }
  }

  public void savePic(int p) {
    croppedPic.copy(pictures[p], 0, 0, 720, 720, 0, 0, 720, 720);
    selected = p;
    mailPicPG.beginDraw();
    mailPicPG.image(croppedPic, 0, 0, 382, 382);
    mailPicPG.image(frame382, 0, 0);
    mailPicPG.mask(frameMask);
    mailPicPG.endDraw();
    mailPicPG.save(imgFileName);
  }

  public void setMailAddress(String target, boolean ad) {
    mailAddress = target;
    addvertise = ad;
  }

  // sending the mail
  public void run() {
    if (!EmailValidator.getInstance().isValid(mailAddress)) {
      println("Illegal email address: " + mailAddress);
      logMail(mailAddress, false, false, false);
      return;
    }
    try {
      sendMail.send(mailAddress);
      logMail(mailAddress, addvertise, true, true);
    }
    catch (NoSuchMethodError er) {
      println(er.toString());
      logMail(mailAddress, addvertise, true, false);
    }
    catch (Exception ex) {
      println("Error sending mail to "+mailAddress);
      println(ex.toString());
      logMail(mailAddress, addvertise, true, false);
    }
  }

  void logMail(String mailAddress, boolean addvertise, boolean valid, boolean success) {
    try {
      bw.write(mailAddress + "\tAddvertise: " + (addvertise ? "OK":"NO") + "\tValid: " + (valid ? "OK" : "NO") + "\tSuccess: " + (success ? "Y" : "N") + "\n");
    }
    catch (IOException e) {
      println(e.toString());
    }
    finally {
      try {
        if (bw != null) bw.flush();
      }
      catch (IOException e) {
        println(e.toString());
      }
    }
  }

  public void showSelected() {
    image (croppedPic, 837, 164, 284, 284);
    image (frame284, 837, 164);
  }

  public int getSelectedNum() {
    return selected;
  }
}
