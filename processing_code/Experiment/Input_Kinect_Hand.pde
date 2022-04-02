float KINECT_X_ROTATION = 0;// -15*DEG_TO_RAD;

class Input_Kinect_Hand extends Input {
  KinectPV2 kinect;

  Cube actionZone;
  PVector motionVector;
  PVector prevPos;
  
  int activeSkeleton;
  
  public Input_Kinect_Hand(PApplet par, Logger log, Resetter res, KinectPV2 knct) {
    super(par, log, res);
    kinect = knct;
  }
  
  public boolean begin() {
    // get user's torso position and define action zone accordingly
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    if (skeletonArray.size() == 0) {
      return false;
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
    return true;
  }
  
  protected void setActionZone() {
  }
  
  public void end() {
  }
  
  public void run() {
  }
  
  protected PVector getRotatedJointPos(PVector v) {
  PVector r = new PVector();
  r.x = v.x;
  r.y = v.y*cos(KINECT_X_ROTATION) - v.z*sin(KINECT_X_ROTATION);
  r.z = v.y*sin(KINECT_X_ROTATION) + v.z*cos(KINECT_X_ROTATION);

  return r;    
  }
}


class Cube {
  PVector vec1, vec2;
  
  Cube(PVector v1, PVector v2) {
    if (v1.x>v2.x) {
      float t=v1.x;
      v1 = new PVector(v2.x, v1.y, v1.z);
      v2 = new PVector(t,    v2.y, v2.z);
    }
    if (v1.y>v2.y) {
      float t=v1.y;
      v1 = new PVector(v1.x, v2.y, v1.z);
      v2 = new PVector(v2.x, t,    v2.z);
    }
    if (v1.z>v2.z) {
      float t=v1.z;
      v1 = new PVector(v1.x, v1.y, v2.z);
      v2 = new PVector(v2.x, v2.y, t   );
    }
    
    vec1 = v1;
    vec2 = v2;
  }
  
  public boolean inside(PVector v) {
    return ((v.x >= vec1.x)
         && (v.y >= vec1.y)
         && (v.z >= vec1.z)
         && (v.x <= vec2.x)
         && (v.y <= vec2.y)
         && (v.z <= vec2.z));
  }
  
  float getRelativeX(PVector v) {
    return (v.x-vec1.x)/(vec2.x-vec1.x);
  }

  float getRelativeY(PVector v) {
    return (v.y-vec1.y)/(vec2.y-vec1.y);
  }
}
