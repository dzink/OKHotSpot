class OKMessage {
  String symbol;
  
  public OKMessage(String s){
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
    return (symbol ==s);
}

class OKJointMessager {
  // xpos, ypos, zpos, dxpos, dypos, dzpos, confidence
  
  PVector current = new OKJoint();
  PVector last;
  
  void update(OKJoint j) {
    if (j!=null) {
      OscMessage m = new OscMessage(symbol);
      v = j.getVector();
      m.add(v.x,v.y,v.z);
      if(last == null)  {
        sendOnMessage();
        m.add(0.,0.,0.);
      } else {
        l = last.getVector();
        m.add(l.x-v.x,l.y-v.y,l.z-v.z);
      }
      context.addMessage(m);
    } else if (last != null) {
      sendOffMessage();
    }
  }
}
  
/*class OKMassMessage extends OKMessage {
 
}*/
