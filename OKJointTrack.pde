class OKJointTrack extends OKBehavior {
  ArrayList<Integer> userIDs = new ArrayList();
  ArrayList<Integer> joints = new ArrayList();


  void trackJoint(int j) {
    if(joints.indexOf(j) < 0)
      joints.add(j);
  }
  
  void stopTrackingJoint(int j) {
    int i = joints.indexOf(j);
    if (i>-1)
      joints.remove(i);
  }
  
  PVector getJointVector(int j, int u) {
    PVector p = new PVector(0,0,0);
    context.getJointPositionSkeleton(u, j, p);
    return p;
  }
  
  void bCheckJoint(int j) {
  }
  
  void bRegisterJoint(int j) {
  }
  
  void addParentHotSpot(OKHotSpot o) {
    hotspot = o;
    hotspot.addJointTrack(this);
  }
  
  boolean isJointTrack() {
    return true;
  }
}
