import myselfie.emailer.SendMail;
import org.apache.commons.validator.routines.EmailValidator;

class Selfie {
  PApplet parent;
  KinectPV2 kinect;
  int currentPic;
  int takingPic;
  boolean picTook;
  PImage croppedPic;
  PImage pictures[];
  int selected;
  PImage frame360;
  PImage frame284;
  PImage frame240;
  SendMail sendMail;

  final String imgFileName = "selfie.jpg";

  public Selfie(PApplet par, KinectPV2 knct) {
    parent = par;
    kinect = knct;
    pictures = new PImage[5];
    for (int i=0; i<5; i++) {
      pictures[i] = createImage(720, 720, RGB);
    }
    croppedPic = createImage(720, 720, RGB);
    sendMail = new SendMail(parent.sketchPath());
    loadFrames();
  }

  void loadFrames() {
    frame360 = loadImage("../Graphics_Common/Selfie frame - regular.png");
    frame284 = loadImage("../Graphics_Common/Selfie frame - screen 0030.png");
    frame240 = loadImage("../Graphics_Common/Selfie frame - screen 0029.png");
  }

  public void begin() {
    takingPic++;
  }

  public void takePic() {
    pictures[currentPic++].copy(croppedPic, 0, 0, 720, 720, 0, 0, 720, 720);
  }

  public void reset() {
    currentPic = 0;
    takingPic = -1;
    selected = -1;
  }

  public void show() {
    if (currentPic == takingPic) {
      croppedPic.copy(kinect.getColorImage(), 600, 180, 720, 720, 0, 0, 720, 720);
    }
    image(croppedPic, 503, 283, 360, 360);
    image(frame360, 503, 283);
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
    croppedPic.save(imgFileName);
  }

  public void sendSelectedPic(String target) {
    if (!EmailValidator.getInstance().isValid(target)) {
      println("Illegal email address: " + target);
      return;
    }

    try {
      sendMail.send(target);
    }
    catch (NoSuchMethodError er) {
      println(er.toString());
    }
    catch (Exception ex) {
      println("Error sending mail to "+target);
      println(ex.toString());
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
