class OKBehavior {
  
  OKHotSpot hotspot;
  OKMessager messager;


  int mass = 0;
    
  void addParentHotSpot(OKHotSpot o) {
    hotspot = o;
  }
  
  void makeMessager(String oscCommand) {
  }
  
  void bDraw() {
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
}
