class OKBehavior {
  
  OKHotSpot hotspot;
  ArrayList<OKMessager> messages = new ArrayList();
  String oscSymbol = "oscCommand";
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

  void addMessage(OKMessager m) {
    messages.add(m);
    m.report();
  }
  
  void sendMessages() {
    if (messages.size() > 0) {
      
    }
  }
}
