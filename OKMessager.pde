class OKMessager {
  String symbol = "OscMessage";
  String subSymbol = "";
  
  public OKMessager(String s){
    symbol = s;
  }

  public OKMessager(String s, String ss){
    symbol = s;
    subSymbol = ss;
  }
  
  OscMessage newMessage() {
    OscMessage o = new OscMessage(symbol);
    return o;
  }

  OscMessage newMessage(String s) {
    OscMessage o = newMessage();
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
  
  boolean matchMessage(String s) {
    //println("Does " + s + " match " + symbol);
    return (symbol.equals(s));
  }
  
  void report() {
    println("New OKMessager: " + symbol);
  }
}

class OKJointMessager extends OKMessager {
  // xpos, ypos, zpos, dxpos, dypos, dzpos, confidence
  
  OKJoint current = new OKJoint();
  OKJoint last;
  
  public OKJointMessager(String s) {
    super(s);
  }
  
  void update(OKJoint j) {
    if (j!=null) {
      OscMessage m = newMessage("position");
      PVector v = j.getVector();
      m.add(new float[] {v.x,v.y,v.z});
      if(last == null)  {
        sendOnMessage();
        m.add(new float[] {0.,0.,0.});
      } else {
        PVector l = last.getVector();
        println(last.getUserID());
        println(l);
        m.add(new float[] {l.x-v.x,l.y-v.y,l.z-v.z});
      }
      last = j.get();//new OKJoint(new PVector(v.x,v.y,v.z), j.getUserID(), j.getJointId(), j.getConfidence());
      sendMessage(m);
    } else if (last != null) {
      last = null;
      sendOffMessage();
    }
  }
  
  void update() {
  }
}
  
/*class OKMassMessage extends OKMessage {
 
}*/
