class OKJoint {
  PVector jointv;
  int userID;
  int jointID;
  float confidence;
  boolean nulled = true;
  
  public OKJoint() {
  }
  
  public OKJoint(PVector j, int u, int ji, float c) {
    jointv = j;
    userID = u;
    confidence = c;
    jointID = ji;
    nulled = false;
  }

  public OKJoint(int u, int ji) {
    jointv = null;
    userID = u;
    confidence = 0;
    jointID = ji;
    nulled = false;
  }
  
  OKJoint get() {
    if (jointv != null) {
      return new OKJoint(jointv.get(),userID,jointID,confidence);
    } else {
      return null;
    }
  }
  
  PVector getVector() {
    return jointv;
  }
  
  void setVector(PVector v) {
    jointv = v;
  }
  
  int getUserID() {
    return userID;
  }
  
  int getJointID() {
    return jointID;
  }
  
  float getConfidence() {
    return confidence;
  }

  boolean isNull() {
    return nulled;
  }
  
  
}


