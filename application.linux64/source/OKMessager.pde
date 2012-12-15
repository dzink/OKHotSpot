class OKMessager {
  String symbol = "OscMessage";
  String subSymbol = "";
  
  public OKMessager() {
  }
  
  public OKMessager(String s){
    symbol = s;
  }

  public OKMessager(String s, String ss){
    symbol = s;
    subSymbol = ss;
  }
  
  OscMessage newMessage() {
    OscMessage o = newMessage("");
    return o;
  }

  OscMessage newMessage(String s) {
    OscMessage o = new OscMessage(s);
    o.setAddrPattern(s);
    return o;
  }
  
  void sendMessage(OscMessage m) {
    context.addMessage(m);
  }
  
  void sendOnMessage() {
    OscMessage m = newMessage("/noteOn");
    m.add(1.);
    //sendMessage(m);
  }

  void sendOffMessage() {
    OscMessage m = newMessage("/noteOff");
    m.add(0.);
    //sendMessage(m);
  }
  
  void report() {
    //println("New OKMessager: " + symbol);
  }
}

class OKJointMessager extends OKMessager {
  // xpos, ypos, zpos, dxpos, dypos, dzpos, confidence
  
  OKJoint current = new OKJoint();
  OKJoint last;
  int userID;
  int jointID;
  
  public OKJointMessager() {
  }
  
  public OKJointMessager(String s, int u, int j) {
    super(s);
    userID = u;
    jointID = j;
  }
  
  void update(OKJoint j) {
    convertJointToMessage(j);
  }
  
  void convertJointToMessage(OKJoint j) {
    if (j!=null) {
      OscMessage m = newMessage(symbol);
      PVector v = j.getVector();
      PVector uv = v.get();
      uv.normalize();
      m.add(new float[] {v.x,v.y,v.z,uv.x,uv.y,uv.z,v.mag()});
      if(last == null)  {
        sendOnMessage();
        m.add(new float[] {0.,0.,0.,0.,0.,0.,0.});
      } else {
        PVector l = last.getVector();
        l.sub(v);
        PVector ul = l.get();
        ul.normalize();
        //println(last.getUserID());
        //println(l);
        m.add(new float[] {l.x,l.y,l.z,ul.x,ul.y,ul.z,l.mag()});
      }
      last = j.get();//new OKJoint(new PVector(v.x,v.y,v.z), j.getUserID(), j.getJointId(), j.getConfidence());
      sendMessage(m);
    } else if (last != null) {
      last = null;
      sendOffMessage();
    }
  }  
  
  OKJoint getJoint(int uid, int jid) {
    if(context.isTrackingSkeleton(uid)) {
      PVector j = new PVector();
      float confidence = context.getJointPositionSkeleton(uid, jid, j);
      return new OKJoint(j, uid, jid, confidence);
    }
    return null;  
  }
  
  OKJoint getSingleJoint() {
    return getJoint(userID, jointID);
  }
  
  void update() {
  }
}

class OKMultiJointMessager extends OKJointMessager {
  int[] uid;
  int[] jid;

  public OKMultiJointMessager(){
  }

  public OKMultiJointMessager(String s, int u1, int j1, int u2, int j2) {
    uid = new int[] {u1,u2};
    jid = new int[] {j1,j2};
    symbol = s;
  }

  OKJoint getSingleJoint(int i){
    return getJoint(uid[i],jid[i]);
  }
  
}
  
class OKMassMessager extends OKMessager {
  int mass;
  int lastMass;
  float density;
  float lastDensity;
  
  public OKMassMessager(String s) {
    symbol = s;
  }
  
  void update(int mss, float d) {
    //println("resetting");
    lastDensity = density;
    lastMass = mass;
    mass = mss;
    density = d;
    if (mass != lastMass || density != lastDensity) {
      OscMessage m = newMessage(symbol);
      m.add(new int[] {mass, lastMass - mass});
      m.add(new float[] {density, lastDensity - density});
      sendMessage(m);
    }
  }
}
