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


class OKJointTrack extends OKBehavior {
  //ArrayList<Integer> userIDs = new ArrayList();
  //ArrayList<Integer> joints = new ArrayList();
  //int[] userID = {0};
  //int[] jointID = {OKHotSpotContext.SKEL_RIGHT_HAND};
  ArrayList<OKJoint> jointSearch = new ArrayList();
  ArrayList<OKJoint> joints = new ArrayList();
  //ArrayList<OKJointMessager> messages = new ArrayList();
  String symbol = "JointTrack";

  public OKJointTrack() {
  }

  public OKJointTrack(String s, int u, int j) {
    symbol = s;
    addJoint(u,j);
  }
  
  OKJoint findJoint(OKJoint j) {
    return findJoint(j.getUserID(), j.getJointID());
  }
  
  OKJoint findJoint(int u, int j) {
    for (OKJoint f : joints) {
      if (f.getUserID() == u && f.getJointID() == j) {
        return f;
      }
    }
    return null;
  }
  
  OKMessager findJointMessager(int u, int j) {
    String s = getSymbol(u,j);
    //println("searching for " + s);
    for (OKMessager m : messages) {
      if (m.matchMessage(s)) {
        return m;
      }
    }
    return null;
  }
  
  String getSymbol(int u, int j) {
    return symbol + "/User" + Integer.toString(u) + "/Joint" + Integer.toString(j);
  }
  
  void addJoint(int u, int j) {
    OKJoint jt = new OKJoint(u,j);
    addMessage(new OKJointMessager(getSymbol(u,j)));
    jointSearch.add(jt);
  }
  
  void addJoint(OKJoint j) {
    jointSearch.add(j);
  }
  
  void stopTrackingJoint(int j) {
    /*int i = joints.indexOf(j);
    if (i>-1)
      joints.remove(i);*/
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
  
  void update() {
    trackJoints();
  }
  
  void updateJoint(int userID, int jointID) {
    if(context.isTrackingSkeleton(userID)) {
      PVector j = new PVector();
      float confidence = context.getJointPositionSkeleton(userID, jointID, j);
      j = hotspot.translateToModel(j);
      OKJointMessager m = (OKJointMessager) findJointMessager(userID, jointID);
      if (m != null) {
       if (hotspot.isPointWithin(j)) {
        OKJoint okj = new OKJoint(j, userID, jointID, confidence);
        joints.add(okj);
        if (m != null) { 
          m.update(okj);
        };
        return;
        } else {
          //OKJoint okj = new OKJoint(null, userID, jointID, confidence);
          m.update(null);
        }
      }
    }  
  }
  
  void trackJoints() {
    joints.clear();
    for(OKJoint j : jointSearch) {
      int jointID = j.getJointID();
      int userID = j.getUserID();
      if(userID != 0) {
        updateJoint(userID, jointID);
      } else {
        IntVector users = context.getUserList();  
        for(int ui = 0; ui < users.size(); ui++ ) {
          if (userID == 0 || users.get(ui) == userID) {
            updateJoint(users.get(ui), jointID);
          }
        }
      }
    }
  }
  
  void bDraw() {
    for (OKJoint jointv : joints) {
      pushStyle();
      //strokeWeight(10);
      stroke(context.mixUserColorWith(jointv.getUserID(), color(255),0.5));
      fill(context.mixUserColorWith(jointv.getUserID(), color(255),0.5), 100);      
      PVector j = jointv.getVector();
      hotspot.overlayEllipse(150.,j.x,j.y,j.z);
      //point(j.x,j.y,j.z);
      if (showStats) {
        hotspot.overlayText(String.format("x: %,2f\ny: %,2f\nz: %,2f\nc: %,2f\n",j.x,j.y,j.z,jointv.getConfidence()),j.x,j.y,j.z);
      }
      popStyle();
    }
  }
}

class OKJointPairTrack extends OKJointTrack {
  OKJoint joint1;
  OKJoint joint2;

  public OKJointPairTrack(int u1, int j1, int u2, int j2) {
    joint2 = new OKJoint(u1,j1);
    joint1 = new OKJoint(u2,j2);
    addJoint(joint1);
    addJoint(joint2);
  }

  void bDraw() {
    OKJoint j1 = findJoint(joint1);
    OKJoint j2 = findJoint(joint2);    
    if (j1 != null && j2 != null) {
      strokeWeight(10);
      stroke(context.mixUserColorWith(j1.getUserID(), color(255),0.5));
      PVector j1v = j1.getVector();
      PVector j2v = j2.getVector();
      line(j1v.x,j1v.y,j1v.z,j2v.x,j2v.y,j2v.z);
    } else {
    }
  }
}

class OKJointLeadHotSpot extends OKJointTrack {
  OKHotSpot follow;

  public OKJointLeadHotSpot(int u, int j) {
    addJoint(u,j);
  }

  void setFollow(OKHotSpot f) {
    follow = f;
  }

  void updateJoint(int userID, int jointID) {
    if(context.isTrackingSkeleton(userID)) {
      PVector j = new PVector();
      float confidence = context.getJointPositionSkeleton(userID, jointID, j);
      if (j != null) {
        if (hotspot.isPointWithin(hotspot.translateToModel(j))) {
          follow.setPosition(j.x,j.y,j.z);
        }
      }  
    }
  }
}
