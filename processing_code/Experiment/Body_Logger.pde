class Body_Logger {
  KinectPV2 kinect;
  Table session;
  String sessionTimestamp;
  int activeSkeleton;
  Date date;

  public Body_Logger(KinectPV2 knct) {
    kinect = knct;
  }

  public void begin(String sts) {
    sessionTimestamp = sts;

    session = new Table();
    session.addColumn("Action");
    session.addColumn("Timestamp");
    session.addColumn("SpineBaseX");
    session.addColumn("SpineBaseY");
    session.addColumn("SpineBaseZ");
    session.addColumn("SpineMidX");
    session.addColumn("SpineMidY");
    session.addColumn("SpineMidZ");
    session.addColumn("NeckX");
    session.addColumn("NeckY");
    session.addColumn("NeckZ");
    session.addColumn("HeadX");
    session.addColumn("HeadY");
    session.addColumn("HeadZ");
    session.addColumn("ShoulderLeftX");
    session.addColumn("ShoulderLeftY");
    session.addColumn("ShoulderLeftZ");
    session.addColumn("ElbowLeftX");
    session.addColumn("ElbowLeftY");
    session.addColumn("ElbowLeftZ");
    session.addColumn("WristLeftX");
    session.addColumn("WristLeftY");
    session.addColumn("WristLeftZ");
    session.addColumn("HandLeftX");
    session.addColumn("HandLeftY");
    session.addColumn("HandLeftZ");
    session.addColumn("ShoulderRightX");
    session.addColumn("ShoulderRightY");
    session.addColumn("ShoulderRightZ");
    session.addColumn("ElbowRightX");
    session.addColumn("ElbowRightY");
    session.addColumn("ElbowRightZ");
    session.addColumn("WristRightX");
    session.addColumn("WristRightY");
    session.addColumn("WristRightZ");
    session.addColumn("HandRightX");
    session.addColumn("HandRightY");
    session.addColumn("HandRightZ");
    session.addColumn("HipLeftX");
    session.addColumn("HipLeftY");
    session.addColumn("HipLeftZ");
    session.addColumn("HipRightX");
    session.addColumn("HipRightY");
    session.addColumn("HipRightZ");
    session.addColumn("SpineShoulderX");
    session.addColumn("SpineShoulderY");
    session.addColumn("SpineShoulderZ");
    session.addColumn("HandTipLeftX");
    session.addColumn("HandTipLeftY");
    session.addColumn("HandTipLeftZ");
    session.addColumn("ThumbLeftX");
    session.addColumn("ThumbLeftY");
    session.addColumn("ThumbLeftZ");
    session.addColumn("HandTipRightX");
    session.addColumn("HandTipRightY");
    session.addColumn("HandTipRightZ");
    session.addColumn("ThumbRightX");
    session.addColumn("ThumbRightY");
    session.addColumn("ThumbRightZ");

    // get closest tracked person
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    if (skeletonArray.size() == 0) {
      return;
    }
    if (skeletonArray.size() > 1) { // more than 1 person - find the closest
      float closestSkelDist = 10000;
      int closestSkel = 0;
      for (int i=0; i<skeletonArray.size(); i++) {
        float dist = ((KSkeleton)skeletonArray.get(i)).getJoints()[KinectPV2.JointType_SpineBase].getPosition().mag();
        if (dist < closestSkelDist) {
          closestSkelDist = dist;
          closestSkel = i;
        }
      }
      activeSkeleton = closestSkel;
    } else {
      activeSkeleton = 0;
    }
  }

  public void addLine() {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    if (skeletonArray.size() == 0) {
      return;
    }
    // maybe someone left... assume our user is still here, but skip a line
    if (skeletonArray.size() <= activeSkeleton) {
      activeSkeleton--;
      return;
    }

    KJoint[] joints = skeletonArray.get(activeSkeleton).getJoints();
    TableRow newRow = session.addRow();
    date = new Date();
    newRow.setString("Timestamp", ""+date.getTime());
    newRow.setFloat("SpineBaseX", joints[KinectPV2.JointType_SpineBase].getX());
    newRow.setFloat("SpineBaseY", joints[KinectPV2.JointType_SpineBase].getY());
    newRow.setFloat("SpineBaseZ", joints[KinectPV2.JointType_SpineBase].getZ());
    newRow.setFloat("SpineMidX", joints[KinectPV2.JointType_SpineMid].getX());
    newRow.setFloat("SpineMidY", joints[KinectPV2.JointType_SpineMid].getY());
    newRow.setFloat("SpineMidZ", joints[KinectPV2.JointType_SpineMid].getZ());
    newRow.setFloat("NeckX", joints[KinectPV2.JointType_Neck].getX());
    newRow.setFloat("NeckY", joints[KinectPV2.JointType_Neck].getY());
    newRow.setFloat("NeckZ", joints[KinectPV2.JointType_Neck].getZ());
    newRow.setFloat("HeadX", joints[KinectPV2.JointType_Head].getX());
    newRow.setFloat("HeadY", joints[KinectPV2.JointType_Head].getY());
    newRow.setFloat("HeadZ", joints[KinectPV2.JointType_Head].getZ());
    newRow.setFloat("ShoulderLeftX", joints[KinectPV2.JointType_ShoulderLeft].getX());
    newRow.setFloat("ShoulderLeftY", joints[KinectPV2.JointType_ShoulderLeft].getY());
    newRow.setFloat("ShoulderLeftZ", joints[KinectPV2.JointType_ShoulderLeft].getZ());
    newRow.setFloat("ElbowLeftX", joints[KinectPV2.JointType_ElbowLeft].getX());
    newRow.setFloat("ElbowLeftY", joints[KinectPV2.JointType_ElbowLeft].getY());
    newRow.setFloat("ElbowLeftZ", joints[KinectPV2.JointType_ElbowLeft].getZ());
    newRow.setFloat("WristLeftX", joints[KinectPV2.JointType_WristLeft].getX());
    newRow.setFloat("WristLeftY", joints[KinectPV2.JointType_WristLeft].getY());
    newRow.setFloat("WristLeftZ", joints[KinectPV2.JointType_WristLeft].getZ());
    newRow.setFloat("HandLeftX", joints[KinectPV2.JointType_HandLeft].getX());
    newRow.setFloat("HandLeftY", joints[KinectPV2.JointType_HandLeft].getY());
    newRow.setFloat("HandLeftZ", joints[KinectPV2.JointType_HandLeft].getZ());
    newRow.setFloat("ShoulderRightX", joints[KinectPV2.JointType_ShoulderRight].getX());
    newRow.setFloat("ShoulderRightY", joints[KinectPV2.JointType_ShoulderRight].getY());
    newRow.setFloat("ShoulderRightZ", joints[KinectPV2.JointType_ShoulderRight].getZ());
    newRow.setFloat("ElbowRightX", joints[KinectPV2.JointType_ElbowRight].getX());
    newRow.setFloat("ElbowRightY", joints[KinectPV2.JointType_ElbowRight].getY());
    newRow.setFloat("ElbowRightZ", joints[KinectPV2.JointType_ElbowRight].getZ());
    newRow.setFloat("WristRightX", joints[KinectPV2.JointType_WristRight].getX());
    newRow.setFloat("WristRightY", joints[KinectPV2.JointType_WristRight].getY());
    newRow.setFloat("WristRightZ", joints[KinectPV2.JointType_WristRight].getZ());
    newRow.setFloat("HandRightX", joints[KinectPV2.JointType_HandRight].getX());
    newRow.setFloat("HandRightY", joints[KinectPV2.JointType_HandRight].getY());
    newRow.setFloat("HandRightZ", joints[KinectPV2.JointType_HandRight].getZ());
    newRow.setFloat("HipLeftX", joints[KinectPV2.JointType_HipLeft].getX());
    newRow.setFloat("HipLeftY", joints[KinectPV2.JointType_HipLeft].getY());
    newRow.setFloat("HipLeftZ", joints[KinectPV2.JointType_HipLeft].getZ());
    newRow.setFloat("HipRightX", joints[KinectPV2.JointType_HipRight].getX());
    newRow.setFloat("HipRightY", joints[KinectPV2.JointType_HipRight].getY());
    newRow.setFloat("HipRightZ", joints[KinectPV2.JointType_HipRight].getZ());
    newRow.setFloat("SpineShoulderX", joints[KinectPV2.JointType_SpineShoulder].getX());
    newRow.setFloat("SpineShoulderY", joints[KinectPV2.JointType_SpineShoulder].getY());
    newRow.setFloat("SpineShoulderZ", joints[KinectPV2.JointType_SpineShoulder].getZ());
    newRow.setFloat("HandTipLeftX", joints[KinectPV2.JointType_HandTipLeft].getX());
    newRow.setFloat("HandTipLeftY", joints[KinectPV2.JointType_HandTipLeft].getY());
    newRow.setFloat("HandTipLeftZ", joints[KinectPV2.JointType_HandTipLeft].getZ());
    newRow.setFloat("ThumbLeftX", joints[KinectPV2.JointType_ThumbLeft].getX());
    newRow.setFloat("ThumbLeftY", joints[KinectPV2.JointType_ThumbLeft].getY());
    newRow.setFloat("ThumbLeftZ", joints[KinectPV2.JointType_ThumbLeft].getZ());
    newRow.setFloat("HandTipRightX", joints[KinectPV2.JointType_HandTipRight].getX());
    newRow.setFloat("HandTipRightY", joints[KinectPV2.JointType_HandTipRight].getY());
    newRow.setFloat("HandTipRightZ", joints[KinectPV2.JointType_HandTipRight].getZ());
    newRow.setFloat("ThumbRightX", joints[KinectPV2.JointType_ThumbRight].getX());
    newRow.setFloat("ThumbRightY", joints[KinectPV2.JointType_ThumbRight].getY());
    newRow.setFloat("ThumbRightZ", joints[KinectPV2.JointType_ThumbRight].getZ());
  }

  public void addAction(String action) {
    println("action added: "+action);
    TableRow newRow = session.addRow();
    newRow.setString("Action", action);
  }

  public void end() {
    saveTable(session, "../logs/" + sessionTimestamp + "/BodyLog.csv");
  }
}
