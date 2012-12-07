class OKBehavior {
  
  OKHotSpot hotspot;
  ArrayList<OKMessage> messages = new ArrayList();

  boolean showStats = false;
  int mass = 0;
    
  void addParentHotSpot(OKHotSpot o) {
    hotspot = o;
  }
  
  void makeMessager(String oscCommand) {
  }
  
  void bDraw() {
  }
  
    
  void enableStats() {
    showStats = true;
  }
  
  void report() {
    println("hello!");
  }
  
  void update() {
  }
  
  boolean isMassDetect() {
    return false;
  }
  
  boolean isJointTrack() {
    return false;
  }
  
  void addMessage(String symbol) {
  }
  
  void sendMessages() {
    if (messages.size() > 0) {
      
    }
  }
}
