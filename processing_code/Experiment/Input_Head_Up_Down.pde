class Input_Head_Up_Down extends Input_Kinect_Head {

  public Input_Head_Up_Down(PApplet par, Logger log, Resetter res, KinectPV2 knct, DeepVision vis, CascadeClassifierNetwork faceNet, FacemarkLBFNetwork facem) {
    super(par, log, res, knct, vis, faceNet, facem);
    filterLength = 3;
    outputArray = new int[filterLength];
  }

  @Override
    public void run() {
    shrinkedCam.copy(kinect.getColorImage(), 0, 0, 1920, 1080, 0, 0, 1920/shrinkRatio, 1080/shrinkRatio);
    detections = faceNetwork.run(shrinkedCam);
    if (detections.size() == 0) {
      return;
    }
    markedFaces = facemark.runByDetections(shrinkedCam, detections);

    List<KeyPointResult> kp = markedFaces.get(0).getKeyPoints();
    float leftPx = kp.get(1).getX();
    float rightPx = kp.get(15).getX();
    float midPx = kp.get(30).getX();
    float yaw = (midPx-leftPx)/(rightPx-leftPx);

    float leftPy = kp.get(0).getY();
    float rightPy = kp.get(16).getY();
    float midPy = kp.get(30).getY();
    float pitch = (midPy-(leftPy+rightPy)/2)/(rightPx-leftPx);
    float pitchOutput = map(pitch, 0.1, 0.35, 1000, 0);
    outputArray[filterIndex++] = (int)constrain(pitchOutput,0,1000);
    filterIndex %= filterLength;
    output = 0;
    for (int i=0; i<filterLength; i++)
      output += outputArray[i];
    output /= filterLength;

    logger.gestureLog(pitch, yaw, 0.0);
  }
}
