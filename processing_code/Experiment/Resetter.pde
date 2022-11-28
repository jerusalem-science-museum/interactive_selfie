final int no_input_time_to_reset = 30000;  // millis of no user input for resetting the session. Wroks like a watchdog.

class Resetter {
  TSession session;
  int lastResetTime = 0;

  public Resetter() {
  }

  public void run() {
    if (millis() - lastResetTime > no_input_time_to_reset) {
      session.end();
      resetTimer();
    }
  }

  public void resetTimer() {
    lastResetTime = millis();
  }

  public void updateSessionLink(TSession ses) {
    session = ses;
    resetTimer();
  }
}
