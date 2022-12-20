class Input_Kinect_Head extends Input {
  KinectPV2 kinect;
  DeepVision vision;
  ResultList<ObjectDetectionResult> detections;
  ResultList<FacialLandmarkResult> markedFaces;
  SingleHumanPoseNetwork pose;
  HumanPoseResult result;
  
  PImage shrinkedCam;
  final int shrinkRatio = 2;
  final int sourceX = 800;
  final int sourceY = 0;
  final int sourceW = 540;
  final int sourceH = 880;
  int filterLength;
  int outputArray[];
  int filterIndex=0;

  public Input_Kinect_Head(PApplet par, Logger log, Resetter res, KinectPV2 knct, DeepVision vis, SingleHumanPoseNetwork p) {
    super(par, log, res);
    kinect = knct;
    vision = vis;
    pose = p;
    shrinkedCam = createImage(sourceW/shrinkRatio, sourceH/shrinkRatio, RGB);
  }
  
  public boolean begin() {
    for (int i=0; i<filterLength; i++)
      outputArray[i]=500;
    return true;
  }
    
  public void end() {
  }
  
  public void run() {
  }
  
}
