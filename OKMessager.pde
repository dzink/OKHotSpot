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
  
  public OKJointMessager(String s, int u, int j) {
    super(s);
    userID = u;
    jointID = j;
  }
  
  void update(OKJoint j) {
    if (j!=null) {
      OscMessage m = newMessage(symbol);
      PVector v = j.getVector();
      m.add(new float[] {v.x,v.y,v.z,v.mag()});
      if(last == null)  {
        sendOnMessage();
        m.add(new float[] {0.,0.,0.});
      } else {
        PVector l = last.getVector();
        l.sub(v);
        println(last.getUserID());
        println(l);
        m.add(new float[] {l.x,l.y,l.z,l.mag()});
      }
      last = j.get();//new OKJoint(new PVector(v.x,v.y,v.z), j.getUserID(), j.getJointId(), j.getConfidence());
      sendMessage(m);
    } else if (last != null) {
      last = null;
      sendOffMessage();
    }
  }
  
  OKJoint getJoint() {
    if(context.isTrackingSkeleton(userID)) {
      PVector j = new PVector();
      float confidence = context.getJointPositionSkeleton(userID, jointID, j);
      return new OKJoint(j, userID, jointID, confidence);
    }
    return null;  
  }
  
  void update() {
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
      
      OscMessage m = newMessage();
      m.add(new int[] {mass, lastMass - mass});
      m.add(new float[] {density, lastDensity - density});
      sendMessage(m);
    }
  }
}
