class Input {
  PApplet parent;
  Logger logger;
  Resetter resetter;
  
  int output;
  int prevOutput;

  public Input(PApplet par, Logger log, Resetter res) {
    parent = par;
    logger = log;
    resetter = res;
    output = 0;
    prevOutput = 0;
  }
  
  public boolean begin() {
    return false;
  }
  
  public void end() {
  }
  
  public void run() {
  }
  
  public int getOutput() {
    if (output != prevOutput) {
      resetter.resetTimer();
    }
    prevOutput = output;
    return output;
  }
}
