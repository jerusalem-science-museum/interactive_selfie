class Input_Kinect_Head extends Input {
  KinectPV2 kinect;
  DeepVision vision;
  ResultList<ObjectDetectionResult> detections;
  ResultList<FacialLandmarkResult> markedFaces;
  CascadeClassifierNetwork faceNetworkYawPitch;  // this network works better for yaw and pitch
  ULFGFaceDetectionNetwork faceNetworkRoll;      // this network works better for roll (at least in shrink ratio 3...)

  FacemarkLBFNetwork facemark;
  PImage shrinkedCam;
  final int shrinkRatio = 2;
  final int sourceX = 640;
  final int sourceY = 0;
  final int sourceW = 640;
  final int sourceH = 1080;
  int filterLength;
  int outputArray[];
  int filterIndex=0;

  public Input_Kinect_Head(PApplet par, Logger log, Resetter res, KinectPV2 knct, DeepVision vis, CascadeClassifierNetwork faceNetYP, ULFGFaceDetectionNetwork faceNetR, FacemarkLBFNetwork facem) {
    super(par, log, res);
    kinect = knct;
    vision = vis;
    faceNetworkYawPitch = faceNetYP;
    faceNetworkRoll = faceNetR;
    facemark = facem;
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
