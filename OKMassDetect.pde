class OKMassDetect extends OKBehavior {
  int mass = 0;
  
  public OKMassDetect() {
  }
  
  public OKMassDetect(String s) {
    addMessage(s);
  }
  
  void addMessage(String s) {
    messages.add(new OKMassMessager(s));
  }
  
  boolean checkMass(PVector p, color pixel, int userID) {
    if (hotspot.isPointWithin(p)) {
      mass++;
      return true;
    }
    return false;
  }
  
  void drawMass(PVector p, color pixel, int userID) {
    pushStyle();
    //strokeWeight(4);    
    stroke(context.mixUserColorWith(userID, pixel, 0.7));
    point(p.x,p.y,p.z);
    popStyle();
  } 

  
  void bDraw() {
    if (showStats) {
      
      fill(255);
      stroke(255);
      hotspot.overlayText(String.format("mass: %,d\ndensity: %2f",mass,hotspot.massScaleForPosition(mass)),1,-1.1,-1);
    }
  }
  
  void update() {
    for(OKMessager m : messages) {
      ((OKMassMessager) m).update(mass,hotspot.massScaleForPosition(mass));
    }
    mass = 0;
  }
  
    boolean isMassDetect() {
    return true;
  }
}

// This class draws white around the outer 90% of the hotspot
class OKMassEdge extends OKMassDetect {

  float edge = 0.95;

  public OKMassEdge(String s) {
    addMessage(s);
  }
  
  boolean checkMass(PVector p, color pixel, int userID) {
    if (hotspot.isPointWithin(p) && hotspot.isPointWithinEdge(p, edge)) {
      mass++;
      return true;
    }
    return false;
  }  
  
  void drawMass(PVector p, int pixel, int userID) {
    pushStyle();
    //strokeWeight(4);
    stroke(context.mixUserColorWith(userID, color(255), 0.3));
    point(p.x,p.y,p.z);
    popStyle();
  }  
}

class OKMassScanner extends OKMassDetect {
  
  OKScanner scanner;
  
  public OKMassScanner(String s) {
    addMessage(s);
  }
  
  void setScanner(OKScanner s) {
    scanner = s;
  }
  
  
  
  // PVector in real-world coordinates
  boolean checkMass(PVector p, color pixel, int userID) {
    if (hotspot.isPointWithin(p)) {
      if(checkScan(p.x)) {
        mass++;
        return true;
      }
    }
    return false;
  }
  
  void drawMass(PVector p, color pixel, int userID) {
    pushStyle();
    //strokeWeight(4);    
    stroke(context.mixUserColorWith(userID, pixel, 0.3));
    point(p.x,p.y,p.z);
    popStyle();
  } 
  
  boolean checkScan(float n) {
    return scanner.checkScan(n);
  }
}
