import java.util.Calendar;
import java.util.Date;

class Logger {
  Table table;
  TableRow sessionRow;
  boolean active = false;
  boolean recordingGesture = false;
  String dayTimestamp;
  String sessionTimestamp;
  Table gestureTable;
  String gestureFileName;
  boolean headGesture; // true = head. false = hand.
  Date date;
  Body_Logger body_logger;

  public Logger(KinectPV2 knct) {
    dayTimestamp = timestamp();
    table = new Table();
    table.addColumn("Timestamp");
    table.addColumn("Language");
    table.addColumn("Mission1_Selection");       // selected input (1-5 left to right)
    table.addColumn("Mission1_Selection_Time");  // selection time (milliseconds)
    table.addColumn("Mission1_Input");           // final input number (0-999)
    table.addColumn("Mission1_Input_Time");      // time until "next" was pressed
    table.addColumn("Mission2_Selection");
    table.addColumn("Mission2_Selection_Time");
    table.addColumn("Mission2_Input");
    table.addColumn("Mission2_Input_Time");
    table.addColumn("Mission3_Selection");
    table.addColumn("Mission3_Selection_Time");
    table.addColumn("Mission3_Input");
    table.addColumn("Mission3_Input_Time");
    table.addColumn("Mission4_Selection");
    table.addColumn("Mission4_Selection_Time");
    table.addColumn("Mission4_Input");
    table.addColumn("Mission4_Input_Time");
    table.addColumn("Mission5_Selection");
    table.addColumn("Mission5_Selection_Time");
    table.addColumn("Mission5_Input");
    table.addColumn("Mission5_Input_Time");
    table.addColumn("Selected_Selfie");
    table.addColumn("Summary_Color");            // selected color: 0 = colored, 255 = white
    table.addColumn("Summary_Power");            // selected power: 50 = weakest, 255 = strongest
    table.addColumn("Summary_Y");                // selected vertical pos: 0 = lowest, 999 = highest
    table.addColumn("Summary_X");                // selected horizontal pos: 0 = left, 999 = right
    table.addColumn("Qestion1 (Binary)");                // selection (1-5 left to right)
    table.addColumn("Qestion2 (Binary)");
    table.addColumn("Qestion3 (Binary)");
    table.addColumn("Qestion4 (Binary)");
    table.addColumn("Qestion5 (Binary)");
    table.addColumn("Slider1");                 // (1-1000)
    table.addColumn("Slider2");
    table.addColumn("MultiQuestion3 (Binary)");
    table.addColumn("Slider4");
    table.addColumn("Slider5");
    table.addColumn("Slider6");
    table.addColumn("Slider7");
    table.addColumn("Slider8");
    table.addColumn("Slider9");
    table.addColumn("Further_Ideas");
    table.addColumn("Age");
    table.addColumn("Profession");
    table.addColumn("Gender");
    table.addColumn("Education");
    table.addColumn("Handedness");

    body_logger = new Body_Logger(knct);
  }

  public void begin() {
    if (active) { // previous session not finished correctly
      table.removeRow(table.getRowCount()-1);
    }
    sessionRow = table.addRow();
    sessionTimestamp = timestamp();
    sessionRow.setString("Timestamp", sessionTimestamp);
    active = true;
    body_logger.begin(sessionTimestamp);
    recordingGesture = false;
  }

  public void run() {
    if (active) {
      body_logger.addLine();
    }
  }

  public void end() {
    if (active) {
      saveTable(table, "../logs/"+dayTimestamp+".csv");
      body_logger.end();
      active = false;
    }
  }

  public void off() {
    active = false;
  }

  public void log(String col, int n) {
    if (active) {
      sessionRow.setInt(col, n);
      if (col.startsWith("Mission")) body_logger.addAction(col+"_"+n);
    }
  }

  public void log(String col, String str) {
    if (active) {
      sessionRow.setString(col, str);
      if (col.startsWith("Mission")) body_logger.addAction(col+"_"+str);
    }
  }

  String timestamp() {
    return String.format("%d-%02d-%02d-%02d-%02d-%02d", year(), month(), day(), hour(), minute(), second());
  }

  public void startGestureRecord(String recName, boolean headGes) {  // should be called inside the session state machine. name will be mission num + selected input
    if (active) {
      gestureTable = new Table();
      gestureFileName = "../logs/" + sessionTimestamp + "/" + recName + ".csv";
      recordingGesture = true;
      headGesture = headGes;
      if (headGesture) {
        gestureTable.addColumn("Timestamp");
        gestureTable.addColumn("Pitch");
        gestureTable.addColumn("Yaw");
        gestureTable.addColumn("Roll");
      } else {
        gestureTable.addColumn("Timestamp");
        gestureTable.addColumn("X");
        gestureTable.addColumn("Y");
        gestureTable.addColumn("Z");
      }
    }
  }

  public void gestureLog(float xp, float yy, float zr) {
    if (recordingGesture) {
      TableRow gestureRow = gestureTable.addRow();
      date = new Date();
      //long timeMilli = date.getTime();
      //String ts = timestamp()+String.format("-%03d", timeMilli%1000);
      gestureRow.setString("Timestamp", ""+date.getTime());
      if (headGesture) {
        gestureRow.setFloat("Pitch", xp);
        gestureRow.setFloat("Yaw", yy);
        gestureRow.setFloat("Roll", zr);
      } else {
        gestureRow.setFloat("X", xp);
        gestureRow.setFloat("Y", yy);
        gestureRow.setFloat("Z", zr);
      }
    }
  }

  public void endGesture() {
    if (recordingGesture) {
      saveTable(gestureTable, gestureFileName);
      recordingGesture = false;
    }
  }
}
