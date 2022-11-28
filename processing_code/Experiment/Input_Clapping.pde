import processing.sound.*;

final int CLAP_IDLE = -1;
final int CLAP_CLAPPING = -2;  // must be < CLAP_IDLE for easier manipulation by output

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
    output = CLAP_IDLE;
    return true;
  }

  public void end() {
    //    input.stop();
    active = false;
  }

  // only outputs positive (999) for a single request per clapping. Outputs -1 or -2 for letting recieving module know it is momentary change
  @Override
    public int getOutput() {
    if (output == CLAP_CLAPPING) {
      resetter.resetTimer();
      output = 0;
      return CLAP_CLAPPING;
    }
    return CLAP_IDLE;
  }

  @Override
    public void run() {
    if (active) {
      float volume = loudness.analyze();
      //println(volume);
      if (firstMeasure) {
        firstMeasure = false;
      } else {
        if (volume - prevVol > threshold) {
          output = CLAP_CLAPPING;
        }
      }
      prevVol = volume;
    }
  }
}
