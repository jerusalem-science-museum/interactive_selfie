class GraphicsDict {
  Hashtable<State, String> graphicFileName = new Hashtable<State, String>();

  void loadGraphicsNames() {
    graphicFileName.put(State.INTRO_0, "0000_screen_language.png");
    graphicFileName.put(State.INTRO_1, "0001_screen_opening.png");
    graphicFileName.put(State.INTRO_2, "0002_screen_explanation1.png");
    graphicFileName.put(State.INTRO_3, "0002A_screen_explanation2.png");
    graphicFileName.put(State.APPROVAL, "0003_screen_TermsConditions.png");

    graphicFileName.put(State.MISSION_1_SELECT, "0004_screen_Mission1_Main.png");
    graphicFileName.put(State.MISSION_1_SELECT_OPTION1, "0005A_screen_Mission1_select_option1.png");
    graphicFileName.put(State.MISSION_1_SELECT_OPTION2, "0005B_screen_Mission1_select_option2.png");
    graphicFileName.put(State.MISSION_1_SELECT_OPTION3, "0005C_screen_Mission1_select_option3.png");
    graphicFileName.put(State.MISSION_1_SELECT_OPTION4, "0005D_screen_Mission1_select_option4.png");
    graphicFileName.put(State.MISSION_1_SELECT_OPTION5, "0005E_screen_Mission1_select_option5.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION1, "0006A_screen_Mission1_action_option1.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION2, "0006B_screen_Mission1_action_option2.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION3, "0006C_screen_Mission1_action_option3.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION4, "0006D_screen_Mission1_action_option4.png");
    graphicFileName.put(State.MISSION_1_INPUT_OPTION5, "0006E_screen_Mission1_action_option5.png");
    graphicFileName.put(State.MISSION_1_SELFIE, "0007_screen_Mission1_shoot.png");
    graphicFileName.put(State.MISSION_1_SAVE_SELFIE, "0008_screen_Mission1_saved.png");

    graphicFileName.put(State.MISSION_2_SELECT, "0009_screen_Mission2_Main.png");
    graphicFileName.put(State.MISSION_2_SELECT_OPTION1, "0010A_screen_Mission2_select_option1.png");
    graphicFileName.put(State.MISSION_2_SELECT_OPTION2, "0010B_screen_Mission2_select_option2.png");
    graphicFileName.put(State.MISSION_2_SELECT_OPTION3, "0010C_screen_Mission2_select_option3.png");
    graphicFileName.put(State.MISSION_2_SELECT_OPTION4, "0010D_screen_Mission2_select_option4.png");
    graphicFileName.put(State.MISSION_2_SELECT_OPTION5, "0010E_screen_Mission2_select_option5.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION1, "0011A_screen_Mission2_action_option1.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION2, "0011B_screen_Mission2_action_option2.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION3, "0011C_screen_Mission2_action_option3.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION4, "0011D_screen_Mission2_action_option4.png");
    graphicFileName.put(State.MISSION_2_INPUT_OPTION5, "0011E_screen_Mission2_action_option5.png");
    graphicFileName.put(State.MISSION_2_SELFIE, "0012_screen_Mission2_shoot.png");
    graphicFileName.put(State.MISSION_2_SAVE_SELFIE, "0013_screen_Mission2_saved.png");

    graphicFileName.put(State.MISSION_3_SELECT, "0014_screen_Mission3_Main.png");
    graphicFileName.put(State.MISSION_3_SELECT_OPTION1, "0015A_screen_Mission3_select_option1.png");
    graphicFileName.put(State.MISSION_3_SELECT_OPTION2, "0015B_screen_Mission3_select_option2.png");
    graphicFileName.put(State.MISSION_3_SELECT_OPTION3, "0015C_screen_Mission3_select_option3.png");
    graphicFileName.put(State.MISSION_3_SELECT_OPTION4, "0015D_screen_Mission3_select_option4.png");
    graphicFileName.put(State.MISSION_3_SELECT_OPTION5, "0015E_screen_Mission3_select_option5.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION1, "0016A_screen_Mission3_action_option1.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION2, "0016B_screen_Mission3_action_option2.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION3, "0016C_screen_Mission3_action_option3.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION4, "0016D_screen_Mission3_action_option4.png");
    graphicFileName.put(State.MISSION_3_INPUT_OPTION5, "0016E_screen_Mission3_action_option5.png");
    graphicFileName.put(State.MISSION_3_SELFIE, "0017_screen_Mission3_shoot.png");
    graphicFileName.put(State.MISSION_3_SAVE_SELFIE, "0018_screen_Mission3_saved.png");

    graphicFileName.put(State.MISSION_4_SELECT, "0019_screen_Mission4_Main.png");
    graphicFileName.put(State.MISSION_4_SELECT_OPTION1, "0020A_screen_Mission4_select_option1.png");
    graphicFileName.put(State.MISSION_4_SELECT_OPTION2, "0020B_screen_Mission4_select_option2.png");
    graphicFileName.put(State.MISSION_4_SELECT_OPTION3, "0020C_screen_Mission4_select_option3.png");
    graphicFileName.put(State.MISSION_4_SELECT_OPTION4, "0020D_screen_Mission4_select_option4.png");
    graphicFileName.put(State.MISSION_4_SELECT_OPTION5, "0020E_screen_Mission4_select_option5.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION1, "0021A_screen_Mission4_action_option1.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION2, "0021B_screen_Mission4_action_option2.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION3, "0021C_screen_Mission4_action_option3.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION4, "0021D_screen_Mission4_action_option4.png");
    graphicFileName.put(State.MISSION_4_INPUT_OPTION5, "0021E_screen_Mission4_action_option5.png");
    graphicFileName.put(State.MISSION_4_SELFIE, "0022_screen_Mission4_shoot.png");
    graphicFileName.put(State.MISSION_4_SAVE_SELFIE, "0023_screen_Mission4_saved.png");

    graphicFileName.put(State.MISSION_5_SELECT, "0024_screen_Mission5_Main.png");
    graphicFileName.put(State.MISSION_5_SELECT_OPTION1, "0025A_screen_Mission5_select_option1.png");
    graphicFileName.put(State.MISSION_5_SELECT_OPTION2, "0025B_screen_Mission5_select_option2.png");
    graphicFileName.put(State.MISSION_5_SELECT_OPTION3, "0025C_screen_Mission5_select_option3.png");
    graphicFileName.put(State.MISSION_5_SELECT_OPTION4, "0025D_screen_Mission5_select_option4.png");
    graphicFileName.put(State.MISSION_5_SELECT_OPTION5, "0025E_screen_Mission5_select_option5.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION1, "0026A_screen_Mission5_action_option1.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION2, "0026B_screen_Mission5_action_option2.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION3, "0026C_screen_Mission5_action_option3.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION4, "0026D_screen_Mission5_action_option4.png");
    graphicFileName.put(State.MISSION_5_INPUT_OPTION5, "0026E_screen_Mission5_action_option5.png");
    graphicFileName.put(State.MISSION_5_SELFIE, "0027_screen_Mission5_shoot.png");
    graphicFileName.put(State.MISSION_5_SAVE_SELFIE, "0028_screen_Mission5_saved.png");

    graphicFileName.put(State.SHOW_SELECT_ALL_SELFIES, "0029_screen_select selfie.png");
    graphicFileName.put(State.GET_EMAIL, "0030_screen_email.png");
    graphicFileName.put(State.QUESTIONARE_0, "0031_questionnaire_stage1_page1.png");
    graphicFileName.put(State.QUESTIONARE_1, "0032_questionnaire_stage1_page2.png");
    graphicFileName.put(State.QUESTIONARE_2, "0033_questionnaire_stage2_page1.png");
    graphicFileName.put(State.QUESTIONARE_3, "0034_questionnaire_stage2_page2.png");
    graphicFileName.put(State.QUESTIONARE_4, "0035_questionnaire_stage2_page3.png");
    graphicFileName.put(State.QUESTIONARE_5, "0036_questionnaire_stage2_page4.png");
    graphicFileName.put(State.QUESTIONARE_6, "0037_questionnaire_stage2_page5.png");
    graphicFileName.put(State.QUESTIONARE_7, "0038_questionnaire_stage2_page6.png");
    graphicFileName.put(State.QUESTIONARE_8, "0039_questionnaire_stage3_page1.png");
    graphicFileName.put(State.QUESTIONARE_9, "0039_questionnaire_stage3_page2.png");
    graphicFileName.put(State.GOODBYE_THANKS, "0040_screen_thank you.png");
  }
}
