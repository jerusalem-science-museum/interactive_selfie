class Input_Head_Left_Right extends Input_Kinect_Head {

  public Input_Head_Left_Right(PApplet par, Logger log, Resetter res, KinectPV2 knct, DeepVision vis, CascadeClassifierNetwork faceNetYP, ULFGFaceDetectionNetwork faceNetR, FacemarkLBFNetwork facem) {
    super(par, log, res, knct, vis, faceNetYP, faceNetR, facem);
    filterLength = 2;
    outputArray = new int[filterLength];
  }

  @Override
    public void run() {
      float yaw = 0, roll = 0, pitch = 0;
      
    shrinkedCam.copy(kinect.getColorImage(), 0, 0, 1920, 1080, 0, 0, 1920/shrinkRatio, 1080/shrinkRatio);
    detections = faceNetworkYawPitch.run(shrinkedCam);
    if (detections.size() > 0) {
      markedFaces = facemark.runByDetections(shrinkedCam, detections);

      // yaw:
      List<KeyPointResult> kp = markedFaces.get(0).getKeyPoints();
      float leftYx = kp.get(1).getX();
      float rightYx = kp.get(15).getX();
      float midYx = kp.get(30).getX();
      float faceWidth = rightYx-leftYx;
      yaw = (midYx-leftYx)/faceWidth;

      // pitch:
      float leftPy = kp.get(0).getY();
      float rightPy = kp.get(16).getY();
      float midPy = kp.get(30).getY();
      pitch = (midPy-(leftPy+rightPy)/2)/faceWidth;
    }

    detections = faceNetworkRoll.run(shrinkedCam);
    if (detections.size() > 0) {
      markedFaces = facemark.runByDetections(shrinkedCam, detections);

      // roll:
      List<KeyPointResult> kp = markedFaces.get(0).getKeyPoints();
      float leftRy = kp.get(1).getY();
      float rightRy = kp.get(15).getY();
      float leftYx = kp.get(1).getX();
      float rightYx = kp.get(15).getX();
      float faceWidth = rightYx-leftYx;
      roll = (rightRy - leftRy)/faceWidth;
      float rollOutput = map(roll, -0.2, 0.2, 0, 999);
      outputArray[filterIndex++] = (int)constrain(rollOutput, 0, 999);
      filterIndex %= filterLength;
      output = 0;
      for (int i=0; i<filterLength; i++)
        output += outputArray[i];
      output /= filterLength;
    }
    //println("roll: "+roll+"\tyaw: "+yaw+"\tpitch: "+pitch);
    logger.gestureLog(pitch, yaw, roll);
  }
}
