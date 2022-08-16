class Input_Hand_Left_Right extends Input_Kinect_Hand {

  public Input_Hand_Left_Right(PApplet par, Logger log, Resetter res, KinectPV2 knct) {
    super(par, log, res, knct);
    motionVector = new PVector(1, 0, 0);
    prevPos = new PVector();
    setActionZone();
  }

  @Override
    protected void setActionZone() {
    actionZone = new Cube(new PVector(0.0, -0.2, 0.5), new PVector(0.3, 0.1, 1.6));
  }

  @Override
    public void run() {
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    // lost skeleton
    if (skeletonArray.size() == 0) {
      return;
    }
    // maybe someone left... assume our user is still here
    if (skeletonArray.size() <= activeSkeleton) {
      activeSkeleton--;
      return;
    }
    KJoint[] joints = skeletonArray.get(activeSkeleton).getJoints();
    if (joints[KinectPV2.JointType_HandRight].getState() != KinectPV2.HandState_NotTracked) {
      PVector hand = getRotatedJointPos(joints[KinectPV2.JointType_HandRight].getPosition());
      logger.gestureLog(hand.x, hand.y, hand.z);
      println(hand);
      if (actionZone.inside(hand)) {
        if ((hand.x!=prevPos.x) || (hand.y!=prevPos.y) || (hand.z!=prevPos.z)) {
          PVector motion = PVector.sub(hand, prevPos);
          prevPos.set(hand);
          /*float ang = PVector.angleBetween(motion, motionVector);
          //print(ang, motion.mag());
          if ((abs(ang-HALF_PI) > 3*PI/8) && (motion.mag()>0.01)) {*/
            float x = actionZone.getRelativeX(hand);
            x = map (x, 0.0, 1.0, -0.1, 1.1); // giving chance to zone edges
            x = constrain(x, 0.0, 1.0);
            output = constrain((int)(x*1000), 0, 999);
          //}
          //println();
        }
      }
    }
  }
}
