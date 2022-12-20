class Input_Head_Left_Right extends Input_Kinect_Head {

  public Input_Head_Left_Right(PApplet par, Logger log, Resetter res, KinectPV2 knct, DeepVision vis, SingleHumanPoseNetwork p) {
    super(par, log, res, knct, vis, p);
    filterLength = 3;
    outputArray = new int[filterLength];
  }

  @Override
    public void run() {
    float yaw = 0, roll = 0, pitch = 0;
    shrinkedCam.copy(kinect.getColorImage(), sourceX, sourceY, sourceW, sourceH, 0, 0, sourceW/shrinkRatio, sourceH/shrinkRatio);
 //   image(shrinkedCam, 0, 0);
    result = pose.run(shrinkedCam);

    // yaw:
    List<KeyPointResult> kp = result.getKeyPoints();
    float leftEyeX = kp.get(1).getX();
    float rightEyeX = kp.get(2).getX();
    float NoseX = kp.get(0).getX();
    float faceWidth = rightEyeX-leftEyeX;
    yaw = (NoseX-leftEyeX)/faceWidth;

    // pitch:
    float leftEyeY = kp.get(1).getY();
    float rightEyeY = kp.get(2).getY();
    float leftEarY = kp.get(3).getY();
    float rightEarY = kp.get(4).getY();
    pitch = (leftEarY+rightEarY)/2 - (leftEyeY+rightEyeY)/2;

    // roll
    roll = (rightEyeY - leftEyeY)/faceWidth;
    
    float rollOutput = map(roll, -0.25, 0.25, 0, 999);
    outputArray[filterIndex++] = (int)constrain(rollOutput, 0, 999);
    filterIndex %= filterLength;
    output = 0;
    for (int i=0; i<filterLength; i++)
      output += outputArray[i];
    output /= filterLength;

 //   println("output: "+output);
    logger.gestureLog(pitch, yaw, roll);
  }
}
