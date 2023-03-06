class GraphicsDict {
  Hashtable<State, String> graphicFileName = new Hashtable<State, String>();

  void loadGraphicsNames() {
    graphicFileName.put(State.INTRO_0, "0000_screen_language.png");
    graphicFileName.put(State.INTRO_1, "0001_screen_opening.png");
    graphicFileName.put(State.INTRO_2, "0002_screen_explanation1.png");
    graphicFileName.put(State.APPROVAL_0, "0003A_screen_TermsConditions1.png");
    graphicFileName.put(State.APPROVAL_1, "0003B_screen_TermsConditions2.png");

    graphicFileName.put(State.CALIBRATION_0, "0003C_Feet.png");
    graphicFileName.put(State.CALIBRATION_1, "0003D_calibration.png");
    graphicFileName.put(State.CALIBRATION_FAILED, "0003E_calibration error.png");

    graphicFileName.put(State.MISSION_1_EXPLENATION, "0004_screen_Mission1_Explanation.png");
    graphicFileName.put(State.MISSION_1_SELECT, "0004A_screen_Mission1_Main.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION1, "0006A_screen_Mission1_action_option1.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION2, "0006B_screen_Mission1_action_option2.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION3, "0006C_screen_Mission1_action_option3.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION4, "0006D_screen_Mission1_action_option4.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION5, "0006E_screen_Mission1_action_option5.png");
    graphicFileName.put(State.MISSION_1_SELFIE, "0007_screen_Mission1_shoot.png");

    graphicFileName.put(State.MISSION_2_EXPLENATION, "0009_screen_Mission2_Explanation.png");
    graphicFileName.put(State.MISSION_2_SELECT, "0009A_screen_Mission2_Main.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION1, "0011A_screen_Mission2_action_option1.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION2, "0011B_screen_Mission2_action_option2.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION3, "0011C_screen_Mission2_action_option3.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION4, "0011D_screen_Mission2_action_option4.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION5, "0011E_screen_Mission2_action_option5.png");
    graphicFileName.put(State.MISSION_2_SELFIE, "0012_screen_Mission2_shoot.png");

    graphicFileName.put(State.MISSION_3_EXPLENATION, "0014_screen_Mission3_Explanation.png");
    graphicFileName.put(State.MISSION_3_SELECT, "0014A_screen_Mission3_Main.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION1, "0016A_screen_Mission3_action_option1.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION2, "0016B_screen_Mission3_action_option2.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION3, "0016C_screen_Mission3_action_option3.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION4, "0016D_screen_Mission3_action_option4.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION5, "0016E_screen_Mission3_action_option5.png");
    graphicFileName.put(State.MISSION_3_SELFIE, "0017_screen_Mission3_shoot.png");

    graphicFileName.put(State.MISSION_4_EXPLENATION, "0019_screen_Mission4_Explanation.png");
    graphicFileName.put(State.MISSION_4_SELECT, "0019A_screen_Mission4_Main.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION1, "0021A_screen_Mission4_action_option1.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION2, "0021B_screen_Mission4_action_option2.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION3, "0021C_screen_Mission4_action_option3.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION4, "0021D_screen_Mission4_action_option4.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION5, "0021E_screen_Mission4_action_option5.png");
    graphicFileName.put(State.MISSION_4_SELFIE, "0022_screen_Mission4_shoot.png");

    graphicFileName.put(State.MISSION_5_EXPLENATION, "0024_screen_Mission5_Explanation.png");
    graphicFileName.put(State.MISSION_5_SELECT, "0024A_screen_Mission5_Main.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION1, "0026A_screen_Mission5_action_option1.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION2, "0026B_screen_Mission5_action_option2.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION3, "0026C_screen_Mission5_action_option3.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION4, "0026D_screen_Mission5_action_option4.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION5, "0026E_screen_Mission5_action_option5.png");
    graphicFileName.put(State.MISSION_5_SELFIE, "0027_screen_Mission5_shoot.png");

    graphicFileName.put(State.SHOW_SELECT_ALL_SELFIES, "0029_screen_select selfie.png");
    graphicFileName.put(State.GET_EMAIL, "0030_screen_email.png");
    graphicFileName.put(State.GET_PROFESSION_AGE, "0039_questionnaire_stage3_page1.png");
    graphicFileName.put(State.GET_GENDER_EDUCATION_HANDEDNESS, "0039_questionnaire_stage3_page2.png");
    graphicFileName.put(State.QUESTIONARE_0, "0031_questionnaire_stage1_page1.png");
    graphicFileName.put(State.QUESTIONARE_1, "0032_questionnaire_stage1_page2.png");
    graphicFileName.put(State.QUESTIONARE_2, "0033_questionnaire_stage2_page1.png");
    graphicFileName.put(State.QUESTIONARE_3, "0034_questionnaire_stage2_page2.png");
    graphicFileName.put(State.QUESTIONARE_4, "0035_questionnaire_stage2_page3.png");
    graphicFileName.put(State.QUESTIONARE_5, "0036_questionnaire_stage2_page4.png");
    graphicFileName.put(State.QUESTIONARE_6, "0037_questionnaire_stage2_page5.png");
    graphicFileName.put(State.QUESTIONARE_7, "0038_questionnaire_stage2_page6.png");
    graphicFileName.put(State.QUESTIONARE_8, "0038A_questionnaire_stage2_page6.png");
    graphicFileName.put(State.GOODBYE_THANKS, "0040_screen_thank you.png");
  }
}
