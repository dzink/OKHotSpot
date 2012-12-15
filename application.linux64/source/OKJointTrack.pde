class OKJointTrack extends OKBehavior {
  //ArrayList<Integer> userIDs = new ArrayList();
  //ArrayList<Integer> joints = new ArrayList();
  //int[] userID = {0};
  //int[] jointID = {OKHotSpotContext.SKEL_RIGHT_HAND};
  //ArrayList<OKJoint> jointSearch = new ArrayList();
  ArrayList<OKJoint> joints = new ArrayList();
  //ArrayList<OKJointMessager> messages = new ArrayList();
  //String symbol = "JointTrack";

  public OKJointTrack() {
  }

  public OKJointTrack(String s, int u, int j) {
    //symbol = s;
    addJoint(s,u,j);
    //messages.add(new OKJointMessager(s,u,j);
  }

  boolean isJointTrack() {
    return true;
  }
  
  void update() {
    trackJoints();
  }
  
  OKJoint findJoint(OKJoint j) {
    //println("searching for joint");
    if (j != null && hotspot.isPointWithin(hotspot.translateToModel(j.getVector()))) {
      //println("found joint");
      j.setVector(hotspot.translateToModel(j.getVector()));
      //println("translated joint");
      return j;
    }
    return null;
  }
  
  void trackJoints() {
    joints.clear();
    for (OKMessager m : messages) {
      OKJoint j = findJoint(((OKJointMessager) m).getSingleJoint());
      if(j != null) {
        joints.add(j);
      }
      ((OKJointMessager) m).update(j);
    }

  }

  void addJoint(String s, int u, int j) {
    //OKJoint jt = new OKJoint(u,j);
    addMessage(new OKJointMessager(s, u, j));
    //jointSearch.add(jt);
  }
  
  void bDraw() {
    //println(joints.size());
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

class OKMultiJointTrack extends OKJointTrack {
  OKJoint joint1;
  OKJoint joint2;

  public OKMultiJointTrack(String s, int u1, int j1, int u2, int j2) {
    //joint2 = new OKJoint(u1,j1);
    //joint1 = new OKJoint(u2,j2);
    addMessage(new OKMultiJointMessager(s,u1,j1,u2,j2));
    //addJoint(joint1);
    //addJoint(joint2);
  }

  void trackJoints() {
    joints.clear();
    for (OKMessager m : messages) {
      joint1 = findJoint(((OKMultiJointMessager) m).getSingleJoint(0));
      joint2 = findJoint(((OKMultiJointMessager) m).getSingleJoint(1));
      OKJoint dJoint;
      if (joint1 != null && joint2 != null) {
        joints.add(joint1);
        joints.add(joint2);
        println("new run");
        println(joint1.getVector());
        println(joint2.getVector());
        PVector d = joint1.getVector().get();
        d.sub(joint2.getVector());
        println(d);
        dJoint = new OKJoint(d,joint1.getUserID(),joint1.getJointID(),1);
      } else {
        dJoint = null;
      }
      ((OKMultiJointMessager) m).update(dJoint);
    }
  }

  void bDraw() {
    if (joint1 != null && joint2 != null) {
      strokeWeight(10);
      stroke(context.mixUserColorWith(joint1.getUserID(), color(255),0.5));
      PVector j1v = joint1.getVector();
      println(j1v);
      PVector j2v = joint2.getVector();
      line(j1v.x,j1v.y,j1v.z,j2v.x,j2v.y,j2v.z);
      println(j2v);
    } else {
      //((OKJointTrack) this).bDraw();
    }
  }
}

class OKJointLeadHotSpot extends OKJointTrack {
  OKHotSpot follow;
  OKJoint joint;

  public OKJointLeadHotSpot(int u, int j) {
    //addJoint(u,j);
    joint = new OKJoint(u,j);
  }

  void setFollow(OKHotSpot f) {
    follow = f;
  }

  void trackJoints() {
    int userID = joint.getUserID();
    int jointID = joint.getJointID();
    if(context.isTrackingSkeleton(userID)) {
      PVector j = new PVector();
      context.getJointPositionSkeleton(userID, jointID, j);
      if (j != null) {
        if (hotspot.isPointWithin(hotspot.translateToModel(j))) {
          follow.setPosition(j.x,j.y,j.z);
        }
      }  
    }
  }
}
