import processing.sound.*;

class Input_Clapping extends Input {
  AudioIn input;
  Amplitude loudness;
  boolean active = false;
  float prevVol = 0;
  boolean firstMeasure;
  
  final float threshold = 0.1;

  public Input_Clapping(PApplet par, Logger log, Resetter res) {
    super(par, log, res);
    input = new AudioIn(parent, 0);
    loudness = new Amplitude(parent);
    loudness.input(input);
    output = 0;
/**/    input.start();
  }

  public boolean begin() {
//    input.start();
    firstMeasure = true;
    active = true;
    output = 0;
    return true;
  }

  public void end() {
//    input.stop();
    active = false;
  }

  public void run() {
    if (active) {
      float volume = loudness.analyze();
      //println(volume);
      if (firstMeasure) {
        firstMeasure = false;
      }
      else {
        if (volume - prevVol > threshold) {
          output = 1000 - output;
        }
      }
      prevVol = volume;
    }
  }
}
