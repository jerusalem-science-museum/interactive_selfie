import KinectPV2.KJoint; //<>//
import KinectPV2.*;
import ch.bildspur.vision.DeepVision;
import ch.bildspur.vision.SingleHumanPoseNetwork;
import ch.bildspur.vision.result.*;
import java.util.List;
import processing.serial.*;

final int max_time_for_calibration = 20000;  // max time until system declares "there is no spoon"


class TSession extends GraphicsDict {
  PApplet parent;
  Logger logger;
  Selfie selfie;
  Resetter res;
  LightPanel lightPanel;

  KinectPV2 kinect;
  DeepVision vision = new DeepVision(parent);
  //vision.setUseDefaultBackend(true);
  SingleHumanPoseNetwork pose;
  Serial lightPort;

  final String graphicsFolder = "../Graphics_";
  String langFolder = "HEBREW/";
  Lang lang;

  PImage img_take_pic;
  PImage img_qst_option_1;
  PImage img_qst_option_2;
  PImage img_qst_option_3;
  PImage img_qst_option_4;
  PImage img_qst_option_5;
  PImage img_slider_pointer;
  PImage img_check_box;
  PImage img_radio_button_empty;
  PImage img_radio_button_selected;

  Button button_hebrew;
  Button button_arabic;
  Button button_english;
  Button button_next;
  Button button_restart;
  Button button_participating;
  Button button_experiencing;
  Checkbox checkbox_participating;
  Checkbox checkbox_quitting;
  Checkbox checkbox_data_collecting;
  Checkbox checkbox_age_18;
  Checkbox checkbox_museum_publications;
  Button button_hand_updown;
  Button button_hand_around;
  Button button_clapping;
  Button button_head_leftright;
  Button button_hand_leftright;
  Text_Input text_get_mail0;
  Text_Input text_get_mail1;
  Text_Input text_further_ideas;
  Text_Input text_get_age;
  Text_Input text_get_profession;
  Button_Select button_sel_question_1;
  Button_Select button_sel_question_2;
  Button_Select button_sel_question_3;
  Button_Select button_sel_question_4;
  Button_Select button_sel_question_5;
  Slider slider_1;
  Slider slider_2;
  Slider slider_3;
  Slider slider_4;
  Slider slider_5;
  Slider slider_6;
  Slider slider_7;
  Slider slider_8;
  Slider slider_9;
  Checkbox checkbox_quest_control_voice;
  Checkbox checkbox_quest_control_touch;
  Checkbox checkbox_quest_control_thought;
  Checkbox checkbox_quest_control_hands_motion;
  Checkbox checkbox_quest_control_eyes_motion;
  Checkbox checkbox_quest_control_moving_around;
  Radio_Button rb_gender_female;
  Radio_Button rb_gender_male;
  Radio_Button rb_education_highschool;
  Radio_Button rb_education_academic;
  Radio_Button rb_education_other;
  Radio_Button rb_handedness_right;
  Radio_Button rb_handedness_left;

  ArrayList<Button> allButtons = new ArrayList<Button>();
  ArrayList<Text_Input> allTexts = new ArrayList<Text_Input>();
  ArrayList<Slider> allSliders = new ArrayList<Slider>();

  boolean participating;
  boolean sessionRunning = false;
  State state;
  int missionNum;

  int globalTimer;
  int missionTimer;

  int globalFlag;

  Hashtable<State, PImage> images = new Hashtable<State, PImage>();

  Input_Clapping input_clapping;
  Input_Hand_Left_Right input_hand_left_right;
  Input_Hand_Up_Down input_hand_up_down;
  Input_Head_Left_Right input_head_left_right;
  Input_Touch input_touch;

  Input activeInput;

  public TSession(PApplet par, Resetter res) {
    parent = par;
    resetter = res;

    kinect = new KinectPV2(parent);
    kinect.enableSkeleton3DMap(true);
    kinect.enableColorImg(true);
    kinect.init();

    logger = new Logger(kinect);

    pose = vision.createSingleHumanPoseEstimation();
    pose.setup();

    selfie = new Selfie(parent, kinect, logger);
    println("Connected COM ports:");
    printArray(Serial.list());
    if (Serial.list().length > 0)
      lightPort = new Serial(parent, Serial.list()[Serial.list().length-1], 115200, 'N', 8, 1);
    lightPanel = new LightPanel(lightPort, logger);

    input_clapping = new Input_Clapping(parent, logger, resetter);
    input_hand_left_right = new Input_Hand_Left_Right(parent, logger, resetter, kinect);
    input_hand_up_down = new Input_Hand_Up_Down(parent, logger, resetter, kinect);
    input_head_left_right = new Input_Head_Left_Right(parent, logger, resetter, kinect, vision, pose);
    input_head_left_right.run();  // need to run once for preloading models
    input_touch = new Input_Touch(parent, logger, resetter, lightPort);  // change if different controller

    img_take_pic = loadImage("../Graphics_Common/Component_button_shoot_selected.png");
    img_slider_pointer = loadImage("../Graphics_Common/Component_slider_triangle.png");
    img_check_box = loadImage("../Graphics_Common/Component_checkbox_check.png");
    img_radio_button_empty = loadImage("../Graphics_Common/Component_radio_unselected.png");
    img_radio_button_selected = loadImage("../Graphics_Common/Component_radio_selected.png");

    button_hebrew = new Button (902, 384, 240, 240);
    button_arabic = new Button (563, 384, 240, 240);
    button_english = new Button (224, 384, 240, 240);
    button_restart = new Button (50, 20, 200, 80);
    button_participating = new Button (712, 264, 500, 240);
    button_experiencing = new Button (155, 264, 500, 240);
    checkbox_participating = new Checkbox(1275, 178, img_check_box);
    checkbox_quitting = new Checkbox(1275, 256, img_check_box);
    checkbox_data_collecting = new Checkbox(1275, 339, img_check_box);
    checkbox_age_18 = new Checkbox(1275, 418, img_check_box);
    checkbox_museum_publications = new Checkbox(645, 401, img_check_box);
    button_hand_updown = new Button(1073, 336, 240, 240);
    button_hand_around = new Button(818, 336, 240, 240);
    button_clapping = new Button(563, 336, 240, 240);
    button_head_leftright = new Button(308, 336, 240, 240);
    button_hand_leftright = new Button(53, 336, 240, 240);
    slider_1 = new Slider(183-20, 423-49, img_slider_pointer);
    slider_2 = new Slider(183-20, 334-49, img_slider_pointer);
    slider_3 = new Slider(183-20, 554-49, img_slider_pointer);
    slider_4 = new Slider(183-20, 305-49, img_slider_pointer);
    slider_5 = new Slider(183-20, 535-49, img_slider_pointer);
    slider_6 = new Slider(183-20, 305-49, img_slider_pointer);
    slider_7 = new Slider(183-20, 574-49, img_slider_pointer);
    slider_8 = new Slider(183-20, 305-49, img_slider_pointer);
    slider_9 = new Slider(183-20, 554-49, img_slider_pointer);
    checkbox_quest_control_voice = new Checkbox(1245, 280, img_check_box);
    checkbox_quest_control_touch = new Checkbox(929, 280, img_check_box);
    checkbox_quest_control_thought = new Checkbox(613, 280, img_check_box);
    checkbox_quest_control_hands_motion = new Checkbox(1245, 377, img_check_box);
    checkbox_quest_control_eyes_motion = new Checkbox(929, 377, img_check_box);
    checkbox_quest_control_moving_around = new Checkbox(613, 377, img_check_box);
    rb_gender_female = new Radio_Button(955, 187, img_radio_button_selected, img_radio_button_empty);
    rb_gender_male = new Radio_Button(738, 187, img_radio_button_selected, img_radio_button_empty);
    rb_education_highschool = new Radio_Button(955, 259, img_radio_button_selected, img_radio_button_empty);
    rb_education_academic = new Radio_Button(738, 259, img_radio_button_selected, img_radio_button_empty);
    rb_education_other = new Radio_Button(480, 259, img_radio_button_selected, img_radio_button_empty);
    rb_handedness_right = new Radio_Button(955, 331, img_radio_button_selected, img_radio_button_empty);
    rb_handedness_left = new Radio_Button(738, 331, img_radio_button_selected, img_radio_button_empty);
    rb_gender_female.assignConnected(new Radio_Button[] {rb_gender_male});
    rb_gender_male.assignConnected(new Radio_Button[] {rb_gender_female});
    rb_education_highschool.assignConnected(new Radio_Button[] {rb_education_academic, rb_education_other});
    rb_education_academic.assignConnected(new Radio_Button[] {rb_education_highschool, rb_education_other});
    rb_education_other.assignConnected(new Radio_Button[] {rb_education_academic, rb_education_highschool});
    rb_handedness_right.assignConnected(new Radio_Button[] {rb_handedness_left});
    rb_handedness_left.assignConnected(new Radio_Button[] {rb_handedness_right});

    allButtons.add(button_hebrew);
    allButtons.add(button_arabic);
    allButtons.add(button_english);
    allButtons.add(button_restart);
    allButtons.add(button_participating);
    allButtons.add(button_experiencing);
    allButtons.add(checkbox_participating);
    allButtons.add(checkbox_quitting);
    allButtons.add(checkbox_data_collecting);
    allButtons.add(checkbox_age_18);
    allButtons.add(checkbox_museum_publications);
    allButtons.add(button_hand_updown);
    allButtons.add(button_hand_around);
    allButtons.add(button_clapping);
    allButtons.add(button_head_leftright);
    allButtons.add(button_hand_leftright);
    allButtons.add(checkbox_quest_control_voice);
    allButtons.add(checkbox_quest_control_touch);
    allButtons.add(checkbox_quest_control_thought);
    allButtons.add(checkbox_quest_control_hands_motion);
    allButtons.add(checkbox_quest_control_eyes_motion);
    allButtons.add(checkbox_quest_control_moving_around);
    allSliders.add(slider_1);
    allSliders.add(slider_2);
    allSliders.add(slider_3);
    allSliders.add(slider_4);
    allSliders.add(slider_5);
    allSliders.add(slider_6);
    allSliders.add(slider_7);
    allSliders.add(slider_8);
    allSliders.add(slider_9);
    allButtons.add(rb_gender_female);
    allButtons.add(rb_gender_male);
    allButtons.add(rb_education_highschool);
    allButtons.add(rb_education_academic);
    allButtons.add(rb_education_other);
    allButtons.add(rb_handedness_right);
    allButtons.add(rb_handedness_left);

    text_get_mail0 = new Text_Input(parent, 99, 243, 240, 1, Lang.ENGLISH);
    text_get_mail1 = new Text_Input(parent, 423, 243, 240, 1, Lang.ENGLISH);
    text_further_ideas = new Text_Input(parent, 197, 281, 1094, 3, Lang.HEBREW);
    text_get_age = new Text_Input(parent, 973, 286, 200, 1, Lang.ENGLISH);
    text_get_profession = new Text_Input(parent, 973, 387, 200, 1, Lang.HEBREW);
    allTexts.add(text_get_mail0);
    allTexts.add(text_get_mail1);
    allTexts.add(text_further_ideas);
    allTexts.add(text_get_age);
    allTexts.add(text_get_profession);
    textFont(createFont("tahoma.ttf", 34, true)); // 36
    textLeading(42);


    loadGraphicsNames();
    images.put (State.INTRO_0, loadImage(graphicsFolder + langFolder + graphicFileName.get(State.INTRO_0)));
  }

  public void begin() {
    sessionRunning = true;
    button_hebrew.show();
    button_arabic.show();
    //    button_english.show();
    state = State.INTRO_0;
    participating = true;
    selfie.reset();
    lightPanel.reset();
  }

  public boolean running() {
    return sessionRunning;
  }

  public void run() {
    showGraphics();
    switch (state) {
    case INTRO_0:
      resetter.resetTimer();
      break;

    case CALIBRATION_1:
      if (millis() - globalTimer > max_time_for_calibration) {
        globalTimer = millis();
        state = State.CALIBRATION_FAILED;
      }
      if (input_hand_left_right.skeletonGained()) {
        logger.begin();
        button_next.show();
        missionNum = 1;
        logger.log("Language", langFolder.substring(0, langFolder.length()-1));
        state = State.MISSION_1_EXPLENATION;
      }
      break;

    case CALIBRATION_FAILED:
      if (millis() - globalTimer > 5000) end();
      break;

    case MISSION_1_INPUT_OPTION1:
    case MISSION_1_INPUT_OPTION2:
    case MISSION_1_INPUT_OPTION3:
    case MISSION_1_INPUT_OPTION4:
    case MISSION_1_INPUT_OPTION5:
      activeInput.run();
      if (lightPanel.setOnOff(activeInput.getOutput())) {
        //println("on");
        button_next.show();
      } else {
        //println("off");
        button_next.hide();
      }
      break;

    case MISSION_2_INPUT_OPTION1:
    case MISSION_2_INPUT_OPTION2:
    case MISSION_2_INPUT_OPTION3:
    case MISSION_2_INPUT_OPTION4:
    case MISSION_2_INPUT_OPTION5:
      activeInput.run();
      lightPanel.setColorWhite(activeInput.getOutput());
      break;

    case MISSION_3_INPUT_OPTION1:
    case MISSION_3_INPUT_OPTION2:
    case MISSION_3_INPUT_OPTION3:
    case MISSION_3_INPUT_OPTION4:
    case MISSION_3_INPUT_OPTION5:
      activeInput.run();
      lightPanel.setPower(activeInput.getOutput());
      break;

    case MISSION_4_INPUT_OPTION1:
    case MISSION_4_INPUT_OPTION2:
    case MISSION_4_INPUT_OPTION3:
    case MISSION_4_INPUT_OPTION4:
    case MISSION_4_INPUT_OPTION5:
      activeInput.run();
      lightPanel.setVertical(activeInput.getOutput());
      break;

    case MISSION_5_INPUT_OPTION1:
    case MISSION_5_INPUT_OPTION2:
    case MISSION_5_INPUT_OPTION3:
    case MISSION_5_INPUT_OPTION4:
    case MISSION_5_INPUT_OPTION5:
      activeInput.run();
      lightPanel.setHorizontal(activeInput.getOutput());
      break;

    case MISSION_1_SELFIE:
    case MISSION_2_SELFIE:
    case MISSION_3_SELFIE:
    case MISSION_4_SELFIE:
    case MISSION_5_SELFIE:
      selfie.show();
      break;

    case SHOW_SELECT_ALL_SELFIES:
      selfie.showAll();
      break;

    case GET_EMAIL:
      selfie.showSelected();
      break;

    case GOODBYE_THANKS:
      if (millis() - globalTimer > 5000) end();
      break;

    default:
      break;
    }
    lightPanel.run();
    for (Button b : allButtons) b.run();
    for (Text_Input t : allTexts) t.run();
    for (Slider s : allSliders) s.run();
    logger.run();
  }

  public void touch(int x, int y) {
    switch (state) {
    case INTRO_0:
      if (button_hebrew.touched(x, y)) {
        langFolder = "Hebrew/";
        lang = Lang.HEBREW;
        loadImages();
        state = State.INTRO_1;
        button_hebrew.hide();
        button_arabic.hide();
        button_english.hide();
        button_next.show();
      }
      if (button_arabic.touched(x, y)) {
        langFolder = "Arabic/";
        lang = Lang.ARABIC;
        loadImages();
        state = State.INTRO_1;
        button_hebrew.hide();
        button_arabic.hide();
        button_english.hide();
        button_next.show();
      }
      if (button_english.touched(x, y)) {
        langFolder = "English/";
        lang = Lang.ENGLISH;
        loadImages();
        state = State.INTRO_1;
        button_hebrew.hide();
        button_arabic.hide();
        button_english.hide();
        button_next.show();
      }

      break;

    case INTRO_1:
      if (button_next.touched(x, y)) {
        state = State.INTRO_2;
        /*
        Text_Input.showOSK(Lang.ENGLISH);
         text_get_mail0.show();
         text_get_mail0.begin();
         text_get_mail1.show();
         checkbox_museum_publications.show();
         state = State.GET_EMAIL;
        /**/
      }
      break;

    case INTRO_2:
      if (button_next.touched(x, y)) {
        if (lang == Lang.ENGLISH) {
          participating = false;
          logger.off();
          state = State.CALIBRATION_0;
        } else {
          state = State.APPROVAL_0;
          button_next.hide();
          button_participating.show();
          button_experiencing.show();
        }
      }
      break;

    case APPROVAL_0:
      if (button_experiencing.touched(x, y)) {
        participating = false;
        logger.off();
        button_restart.show();
        button_next.show();
        state = State.CALIBRATION_0;
      }
      if (button_participating.touched(x, y)) {
        participating = true;
        state = State.APPROVAL_1;
        button_participating.hide();
        button_experiencing.hide();
        button_restart.show();
        checkbox_participating.show();
        checkbox_quitting.show();
        checkbox_data_collecting.show();
        checkbox_age_18.show();
      }
      break;

    case APPROVAL_1:
      checkbox_participating.touched(x, y); // pass a touch if applicable, to switch checkbox on state
      checkbox_quitting.touched(x, y);
      checkbox_data_collecting.touched(x, y);
      checkbox_age_18.touched(x, y);
      // checkboxes logic
      if (checkbox_participating.getState() && checkbox_quitting.getState() && checkbox_data_collecting.getState() && checkbox_age_18.getState()) button_next.show();
      else button_next.hide();

      if (button_next.touched(x, y)) {
        checkbox_participating.hide();
        checkbox_quitting.hide();
        checkbox_data_collecting.hide();
        checkbox_age_18.hide();
        state = State.CALIBRATION_0;
      }
      break;

    case CALIBRATION_0:
      if (button_next.touched(x, y)) {
        globalTimer = millis();
        button_next.hide();
        resetter.resetTimer();
        state = State.CALIBRATION_1;
      }
      break;

    case MISSION_1_EXPLENATION:
    case MISSION_2_EXPLENATION:
    case MISSION_3_EXPLENATION:
    case MISSION_4_EXPLENATION:
    case MISSION_5_EXPLENATION:
      if (button_next.touched(x, y)) {
        button_next.hide();
        button_hand_updown.show();
        button_hand_around.show();
        button_clapping.show();
        button_head_leftright.show();
        button_hand_leftright.show();
        missionTimer = millis();
        state = State.valueOf("MISSION_"+missionNum+"_SELECT");
      }
      break;

    case MISSION_1_SELECT:
    case MISSION_2_SELECT:
    case MISSION_3_SELECT:
    case MISSION_4_SELECT:
    case MISSION_5_SELECT:
      if (button_hand_updown.touched(x, y)) {
        if (missionNum>1) button_next.show();
        button_hand_updown.hide();
        button_hand_around.hide();
        button_clapping.hide();
        button_head_leftright.hide();
        button_hand_leftright.hide();
        activeInput = input_hand_up_down;
        input_hand_up_down.begin();
        logger.log("Mission"+missionNum+"_Selection", 5);
        logger.log("Mission"+missionNum+"_Selection_Time", millis()-missionTimer);
        logger.startGestureRecord("Mission"+missionNum+"_Hand_UpDown", false);
        missionTimer = millis();
        state = State.valueOf("MISSION_"+missionNum+"_INPUT_OPTION1");
      }
      if (button_hand_around.touched(x, y)) {
        if (missionNum>1) button_next.show();
        button_hand_updown.hide();
        button_hand_around.hide();
        button_clapping.hide();
        button_head_leftright.hide();
        button_hand_leftright.hide();
        activeInput=input_touch;
        input_touch.begin();
        logger.log("Mission"+missionNum+"_Selection", 4);
        logger.log("Mission"+missionNum+"_Selection_Time", millis()-missionTimer);
        missionTimer = millis();
        state = State.valueOf("MISSION_"+missionNum+"_INPUT_OPTION2");
      }
      if (button_clapping.touched(x, y)) {
        if (missionNum>1) button_next.show();
        button_hand_updown.hide();
        button_hand_around.hide();
        button_clapping.hide();
        button_head_leftright.hide();
        button_hand_leftright.hide();
        activeInput = input_clapping;
        input_clapping.begin();
        logger.log("Mission"+missionNum+"_Selection", 3);
        logger.log("Mission"+missionNum+"_Selection_Time", millis()-missionTimer);
        missionTimer = millis();
        state = State.valueOf("MISSION_"+missionNum+"_INPUT_OPTION3");
      }
      if (button_head_leftright.touched(x, y)) {
        if (missionNum>1) button_next.show();
        button_hand_updown.hide();
        button_hand_around.hide();
        button_clapping.hide();
        button_head_leftright.hide();
        button_hand_leftright.hide();
        activeInput = input_head_left_right;
        input_head_left_right.begin();
        logger.log("Mission"+missionNum+"_Selection", 2);
        logger.log("Mission"+missionNum+"_Selection_Time", millis()-missionTimer);
        logger.startGestureRecord("Mission"+missionNum+"_Head_LeftRight", true);
        missionTimer = millis();
        state = State.valueOf("MISSION_"+missionNum+"_INPUT_OPTION4");
      }
      if (button_hand_leftright.touched(x, y)) {
        if (missionNum>1) button_next.show();
        button_hand_updown.hide();
        button_hand_around.hide();
        button_clapping.hide();
        button_head_leftright.hide();
        button_hand_leftright.hide();
        activeInput = input_hand_left_right;
        input_hand_left_right.begin();
        logger.log("Mission"+missionNum+"_Selection", 1);
        logger.log("Mission"+missionNum+"_Selection_Time", millis()-missionTimer);
        logger.startGestureRecord("Mission"+missionNum+"_Hand_LeftRight", false);
        missionTimer = millis();
        state = State.valueOf("MISSION_"+missionNum+"_INPUT_OPTION5");
      }
      break;

    case MISSION_1_INPUT_OPTION1:
    case MISSION_2_INPUT_OPTION1:
    case MISSION_3_INPUT_OPTION1:
    case MISSION_4_INPUT_OPTION1:
    case MISSION_5_INPUT_OPTION1:
    case MISSION_1_INPUT_OPTION2:
    case MISSION_2_INPUT_OPTION2:
    case MISSION_3_INPUT_OPTION2:
    case MISSION_4_INPUT_OPTION2:
    case MISSION_5_INPUT_OPTION2:
    case MISSION_1_INPUT_OPTION3:
    case MISSION_2_INPUT_OPTION3:
    case MISSION_3_INPUT_OPTION3:
    case MISSION_4_INPUT_OPTION3:
    case MISSION_5_INPUT_OPTION3:
    case MISSION_1_INPUT_OPTION4:
    case MISSION_2_INPUT_OPTION4:
    case MISSION_3_INPUT_OPTION4:
    case MISSION_4_INPUT_OPTION4:
    case MISSION_5_INPUT_OPTION4:
    case MISSION_1_INPUT_OPTION5:
    case MISSION_2_INPUT_OPTION5:
    case MISSION_3_INPUT_OPTION5:
    case MISSION_4_INPUT_OPTION5:
    case MISSION_5_INPUT_OPTION5:
      if (button_next.touched(x, y)) {
        logger.endGesture();
        activeInput.end();
        logger.log("Mission"+missionNum+"_Input", activeInput.getOutput());
        logger.log("Mission"+missionNum+"_Input_Time", millis()-missionTimer);
        button_next.hide();
        selfie.begin();
        state = State.valueOf("MISSION_"+missionNum+"_SELFIE");
        globalFlag = 0;  // used in next step for checking if retaking selfie
      }
      break;

    case MISSION_1_SELFIE:
    case MISSION_2_SELFIE:
    case MISSION_3_SELFIE:
    case MISSION_4_SELFIE:
    case MISSION_5_SELFIE:
      if (button_next.touched(x, y)) {
        missionNum++;
        if (missionNum <= 5) {
          missionTimer = millis();
          state = State.valueOf("MISSION_"+missionNum+"_EXPLENATION");
        } else {
          lightPanel.logSummary();
          state = State.SHOW_SELECT_ALL_SELFIES;
          button_next.hide();
        }
      } else { // touch anywhere else - take picture again
        if (globalFlag == 0) {  // first time taking the picture - freeze it
          selfie.takePic();
          button_next.show();
          globalFlag = 1;
        } else {
          selfie.takePicAgain();
        }
      }
      break;

    case SHOW_SELECT_ALL_SELFIES:
      if ((x>53) && (x<1313) && (y>318) && (y<558)) {
        int p = 4 - (x-53) / 252;
        p = constrain(p, 0, 4); // just making sure...
        selfie.savePic(p, participating);
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Selected_Selfie", selfie.getSelectedNum()+1);
        Text_Input.showOSK(Lang.ENGLISH);
        text_get_mail0.show();
        text_get_mail0.begin();
        text_get_mail1.show();
        checkbox_museum_publications.show();
        state = State.GET_EMAIL;
      }
      break;

    case GET_EMAIL:
      checkbox_museum_publications.touched(x, y);
      if (text_get_mail0.touched(x, y)) {
        text_get_mail1.end();
      }
      if (text_get_mail1.touched(x, y)) {
        text_get_mail0.end();
      }
      if (button_next.touched(x, y)) {
        text_get_mail0.hide();
        text_get_mail0.end();
        text_get_mail1.hide();
        text_get_mail1.end();
        if (checkbox_museum_publications.getState()) {
          // add participant to museum mailbox
        }
        checkbox_museum_publications.hide();
        button_next.hide();
        selfie.setMailAddress(text_get_mail0.getText()+"@"+text_get_mail1.getText(), checkbox_museum_publications.getState());
        try {
          new Thread(selfie).start(); //selfie.start();
        }
        catch(IllegalThreadStateException ex) {
          println(ex);
        }
        if (participating) {
          Text_Input.showOSK(lang);
          text_get_age.show();
          text_get_age.begin();
          text_get_profession.show();
          state = State.GET_PROFESSION_AGE;
        } else {
          Text_Input.hideOSK();
          globalTimer = millis();
          state = State.GOODBYE_THANKS;
        }
      }
      break;

    case GET_PROFESSION_AGE:
      if (text_get_age.touched(x, y)) {
        text_get_profession.end();
      }
      if (text_get_profession.touched(x, y)) {
        text_get_age.end();
      }
      if (button_next.touched(x, y)) {
        logger.log("Age", int(text_get_age.getText()));
        logger.log("Profession", text_get_profession.getText());
        Text_Input.hideOSK();
        text_get_age.hide();
        text_get_age.end();
        text_get_profession.hide();
        text_get_profession.end();
        rb_gender_female.show();
        rb_gender_male.show();
        rb_education_highschool.show();
        rb_education_academic.show();
        rb_education_other.show();
        rb_handedness_right.show();
        rb_handedness_left.show();
        button_next.hide();
        globalFlag = 0;
        state = State.GET_GENDER_EDUCATION_HANDEDNESS;
      }
      break;

    case GET_GENDER_EDUCATION_HANDEDNESS:
      if (rb_gender_female.touched(x, y) || rb_gender_male.touched(x, y)) {
        globalFlag |= 1;
      }
      if (rb_education_highschool.touched(x, y) || rb_education_academic.touched(x, y) || rb_education_other.touched(x, y)) {
        globalFlag |= 2;
      }
      if (rb_handedness_right.touched(x, y) || rb_handedness_left.touched(x, y)) {
        globalFlag |= 4;
      }
      if (globalFlag == 7) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Gender", rb_gender_female.getState() ? "Female" : "Male");
        logger.log("Education", rb_education_highschool.getState() ? "Highschool" : (rb_education_academic.getState() ? "Academic" : "Other"));
        logger.log("Handedness", rb_handedness_right.getState() ? "Right" : "Left");
        rb_gender_female.hide();
        rb_gender_male.hide();
        rb_education_highschool.hide();
        rb_education_academic.hide();
        rb_education_other.hide();
        rb_handedness_right.hide();
        rb_handedness_left.hide();
        button_next.hide();
        button_sel_question_1.show();
        button_sel_question_2.show();
        state = State.QUESTIONARE_0;
      }
      break;

    case QUESTIONARE_0:
      button_sel_question_1.touched(x, y);
      button_sel_question_2.touched(x, y);
      if (button_sel_question_1.getState() && button_sel_question_2.getState()) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Question1 (Binary)", button_sel_question_1.getSelected());
        logger.log("Question2 (Binary)", button_sel_question_2.getSelected());
        button_sel_question_1.hide();
        button_sel_question_2.hide();
        button_sel_question_3.show();
        button_sel_question_4.show();
        button_sel_question_5.show();
        button_next.hide();
        state = State.QUESTIONARE_1;
      }
      break;

    case QUESTIONARE_1:
      button_sel_question_3.touched(x, y);
      button_sel_question_4.touched(x, y);
      button_sel_question_5.touched(x, y);
      if (button_sel_question_3.getState() && button_sel_question_4.getState() && button_sel_question_5.getState()) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Question3 (Binary)", button_sel_question_3.getSelected());
        logger.log("Question4 (Binary)", button_sel_question_4.getSelected());
        logger.log("Question5 (Binary)", button_sel_question_5.getSelected());
        button_sel_question_3.hide();
        button_sel_question_4.hide();
        button_sel_question_5.hide();
        checkbox_quest_control_voice.show();
        checkbox_quest_control_touch.show();
        checkbox_quest_control_thought.show();
        checkbox_quest_control_hands_motion.show();
        checkbox_quest_control_eyes_motion.show();
        checkbox_quest_control_moving_around.show();
        button_next.hide();
        state = State.QUESTIONARE_2;
      }
      break;

    case QUESTIONARE_2:
      checkbox_quest_control_voice.touched(x, y);
      checkbox_quest_control_touch.touched(x, y);
      checkbox_quest_control_thought.touched(x, y);
      checkbox_quest_control_hands_motion.touched(x, y);
      checkbox_quest_control_eyes_motion.touched(x, y);
      checkbox_quest_control_moving_around.touched(x, y);
      if (
        checkbox_quest_control_voice.getState() ||
        checkbox_quest_control_touch.getState() ||
        checkbox_quest_control_thought.getState() ||
        checkbox_quest_control_hands_motion.getState() ||
        checkbox_quest_control_eyes_motion.getState() ||
        checkbox_quest_control_moving_around.getState()
        )
      {
        button_next.show();
      } else {
        button_next.hide();
      }
      if (button_next.touched(x, y)) {
        logger.log("Question6 (Binary)",
          (checkbox_quest_control_voice.getState() ? 1 : 0) +
          (checkbox_quest_control_touch.getState() ? 2 : 0) +
          (checkbox_quest_control_thought.getState() ? 4 : 0) +
          (checkbox_quest_control_hands_motion.getState() ? 8 : 0) +
          (checkbox_quest_control_eyes_motion.getState() ? 16 : 0) +
          (checkbox_quest_control_moving_around.getState() ? 32 : 0)
          );
        checkbox_quest_control_voice.hide();
        checkbox_quest_control_touch.hide();
        checkbox_quest_control_thought.hide();
        checkbox_quest_control_hands_motion.hide();
        checkbox_quest_control_eyes_motion.hide();
        checkbox_quest_control_moving_around.hide();
        slider_1.show();
        button_next.hide();
        state = State.QUESTIONARE_3;
      }
      break;

    case QUESTIONARE_3:
      if (slider_1.touched(x, y)) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Slider1", slider_1.getState());
        slider_1.hide();
        slider_2.show();
        slider_3.show();
        globalFlag = 0;
        button_next.hide();
        state = State.QUESTIONARE_4;
      }
      break;

    case QUESTIONARE_4:
      if (slider_2.touched(x, y)) {
        globalFlag |= 1;
      }
      if (slider_3.touched(x, y)) {
        globalFlag |= 2;
      }
      if (globalFlag == 3) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Slider2", slider_2.getState());
        logger.log("Slider3", slider_3.getState());
        slider_2.hide();
        slider_3.hide();
        slider_4.show();
        slider_5.show();
        globalFlag = 0;
        button_next.hide();
        state = State.QUESTIONARE_5;
      }
      break;

    case QUESTIONARE_5:
      if (slider_4.touched(x, y)) {
        globalFlag |= 1;
      }
      if (slider_5.touched(x, y)) {
        globalFlag |= 2;
      }
      if (globalFlag == 3) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Slider4", slider_4.getState());
        logger.log("Slider5", slider_5.getState());
        slider_4.hide();
        slider_5.hide();
        slider_6.show();
        slider_7.show();
        globalFlag = 0;
        button_next.hide();
        state = State.QUESTIONARE_6;
      }
      break;

    case QUESTIONARE_6:
      if (slider_6.touched(x, y)) {
        globalFlag |= 1;
      }
      if (slider_7.touched(x, y)) {
        globalFlag |= 2;
      }
      if (globalFlag == 3) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Slider6", slider_6.getState());
        logger.log("Slider7", slider_7.getState());
        slider_6.hide();
        slider_7.hide();
        slider_8.show();
        slider_9.show();
        globalFlag = 0;
        button_next.hide();
        state = State.QUESTIONARE_7;
      }
      break;

    case QUESTIONARE_7:
      if (slider_8.touched(x, y)) {
        globalFlag |= 1;
      }
      if (slider_9.touched(x, y)) {
        globalFlag |= 2;
      }
      if (globalFlag == 3) {
        button_next.show();
      }
      if (button_next.touched(x, y)) {
        logger.log("Slider8", slider_8.getState());
        logger.log("Slider9", slider_9.getState());
        slider_8.hide();
        slider_9.hide();
        Text_Input.showOSK(lang);
        text_further_ideas.show();
        text_further_ideas.begin();
        state = State.QUESTIONARE_8;
      }
      break;

    case QUESTIONARE_8:
      text_further_ideas.touched(x, y);
      if (button_next.touched(x, y)) {
        logger.log("Further_Ideas", text_further_ideas.getText());
        Text_Input.hideOSK();
        text_further_ideas.hide();
        text_further_ideas.end();
        button_next.hide();
        globalTimer = millis();
        state = State.GOODBYE_THANKS;
      }
      break;

    case GOODBYE_THANKS:
      break;

    default:
      break;
    }

    if (button_restart.touched(x, y)) {
      Text_Input.hideOSK();
      end();
    }
  }

  public void end() {
    logger.end();
    for (Button b : allButtons) b.hide();
    for (Text_Input t : allTexts) t.hide();
    for (Slider s : allSliders) s.hide();
    Text_Input.hideOSK();
    sessionRunning = false;
  }

  private void showGraphics() {
    image (images.get (state), 0, 0);
  }

  private void loadImages() {
    // loading buttons with words
    println("Loading Buttons");
    if (button_next != null) button_next.hide();
    button_next = new Button(50, 657, graphicsFolder + langFolder +"Component_button_continue_default.png");
    img_qst_option_1 = loadImage(graphicsFolder + langFolder + "Component_button_option1_selected_small.png");
    img_qst_option_2 = loadImage(graphicsFolder + langFolder + "Component_button_option2_selected_small.png");
    img_qst_option_3 = loadImage(graphicsFolder + langFolder + "Component_button_option3_selected_small.png");
    img_qst_option_4 = loadImage(graphicsFolder + langFolder + "Component_button_option4_selected_small.png");
    img_qst_option_5 = loadImage(graphicsFolder + langFolder + "Component_button_option5_selected_small.png");
    PImage[] qstImages = {img_qst_option_1, img_qst_option_2, img_qst_option_3, img_qst_option_4, img_qst_option_5};

    button_sel_question_1 = new Button_Select(400, qstImages);
    button_sel_question_2 = new Button_Select(565, qstImages);
    button_sel_question_3 = new Button_Select(275, qstImages);
    button_sel_question_4 = new Button_Select(440, qstImages);
    button_sel_question_5 = new Button_Select(605, qstImages);
    allButtons.add(button_next);
    allButtons.add(button_sel_question_1);
    allButtons.add(button_sel_question_2);
    allButtons.add(button_sel_question_3);
    allButtons.add(button_sel_question_4);
    allButtons.add(button_sel_question_5);

    println("Laoding Screens");
    // loading all slides asynchronuously
    for (State st : State.values()) {
      images.put (st, requestImage(graphicsFolder + langFolder + graphicFileName.get(st)));
    }
    delay(100); // for making sure first images are loaded in time
    println("Screens Loaded");
  }

  public void keyPressed(char key) {
    for (Text_Input t : allTexts) t.keyPressed(key);
    if (state == State.GET_PROFESSION_AGE) {
      if ((text_get_age.getText().length()>0) && (text_get_profession.getText().length()>0)) {
        button_next.show();
      }
    }
  }

  public void released() {
    for (Slider s : allSliders) s.released();

    /*    switch (state) {
     case QUESTIONARE_2:
     slider_1.getState();
     break;
     
     case QUESTIONARE_3:
     case QUESTIONARE_4:
     case QUESTIONARE_5:
     case QUESTIONARE_6:
     case QUESTIONARE_7:
     case QUESTIONARE_8:
     default:
     break;
     }
     */
  }

  public void dragged(int mx) {
    for (Slider s : allSliders) s.dragged(mx);
  }

  public void stop() {
    lightPanel.stop();
  }
}

enum Lang {
  ENGLISH,
    HEBREW,
    ARABIC
}

enum State {
  INTRO_0,
    INTRO_1,
    INTRO_2,
    APPROVAL_0,
    APPROVAL_1,
    CALIBRATION_0,
    CALIBRATION_1,
    CALIBRATION_FAILED,
    MISSION_1_EXPLENATION,
    MISSION_1_SELECT,
    MISSION_1_INPUT_OPTION1,
    MISSION_1_INPUT_OPTION2,
    MISSION_1_INPUT_OPTION3,
    MISSION_1_INPUT_OPTION4,
    MISSION_1_INPUT_OPTION5,
    MISSION_1_SELFIE,
    MISSION_2_EXPLENATION,
    MISSION_2_SELECT,
    MISSION_2_INPUT_OPTION1,
    MISSION_2_INPUT_OPTION2,
    MISSION_2_INPUT_OPTION3,
    MISSION_2_INPUT_OPTION4,
    MISSION_2_INPUT_OPTION5,
    MISSION_2_SELFIE,
    MISSION_3_EXPLENATION,
    MISSION_3_SELECT,
    MISSION_3_INPUT_OPTION1,
    MISSION_3_INPUT_OPTION2,
    MISSION_3_INPUT_OPTION3,
    MISSION_3_INPUT_OPTION4,
    MISSION_3_INPUT_OPTION5,
    MISSION_3_SELFIE,
    MISSION_4_EXPLENATION,
    MISSION_4_SELECT,
    MISSION_4_INPUT_OPTION1,
    MISSION_4_INPUT_OPTION2,
    MISSION_4_INPUT_OPTION3,
    MISSION_4_INPUT_OPTION4,
    MISSION_4_INPUT_OPTION5,
    MISSION_4_SELFIE,
    MISSION_5_EXPLENATION,
    MISSION_5_SELECT,
    MISSION_5_INPUT_OPTION1,
    MISSION_5_INPUT_OPTION2,
    MISSION_5_INPUT_OPTION3,
    MISSION_5_INPUT_OPTION4,
    MISSION_5_INPUT_OPTION5,
    MISSION_5_SELFIE,
    SHOW_SELECT_ALL_SELFIES,
    GET_EMAIL,
    GET_PROFESSION_AGE,
    GET_GENDER_EDUCATION_HANDEDNESS,
    QUESTIONARE_0,
    QUESTIONARE_1,
    QUESTIONARE_2,
    QUESTIONARE_3,
    QUESTIONARE_4,
    QUESTIONARE_5,
    QUESTIONARE_6,
    QUESTIONARE_7,
    QUESTIONARE_8,
    GOODBYE_THANKS
}
