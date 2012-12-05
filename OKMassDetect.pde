class OKMassDetect extends OKBehavior {
  
  int mass = 0;
  
  // PVector in real-world coordinates
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
    stroke(context.mixUserColorWith(userID, pixel, 0.5));
    point(p.x,p.y,p.z);
    popStyle();
  } 
}

// This class draws white around the outer 90% of the hotspot
class OKMassEdge extends OKMassDetect {

  float edge = 0.9;
  
  boolean checkMass(PVector p, color pixel, int userID) {
    if (hotspot.isPointWithin(p) && hotspot.isPointWithinEdge(p, edge)) {
      mass++;
      return true;
    }
    return false;
  }  
  
  void drawMass(PVector p, int pixel, int userID) {
    pushStyle();
    strokeWeight(4);
    stroke(context.mixUserColorWith(userID, color(255), 0.6));
    point(p.x,p.y,p.z);
    popStyle();
  }  
}

class OKMassScanner extends OKMassDetect {
  
  int mass = 0;
  OKScanner scanner;
  
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
    stroke(context.mixUserColorWith(userID, pixel, 0.5));
    point(p.x,p.y,p.z);
    popStyle();
  } 
  
  boolean checkScan(float n) {
    return scanner.checkScan(n);
  }
}
