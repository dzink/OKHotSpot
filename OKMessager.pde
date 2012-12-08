class OKMessager {
  String symbol = "OscMessage";
  
  public OKMessager(String s){
    symbol = s;
  }
  
  OscMessage sendOSC() {
    OscMessage myMessage = new OscMessage("oscCommand");
    //myMessage.add(mass);     
    return myMessage;
  }
  
  void sendOnMessage() {
    OscMessage m = new OscMessage(symbol + "/noteOn");
    m.add(1.);
    context.addMessage(m);
  }

  void sendOffMessage() {
    OscMessage m = new OscMessage(symbol + "/noteOff");
    m.add(1.);
    context.addMessage(m);
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
      OscMessage m = new OscMessage(symbol);
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
      context.addMessage(m);
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
