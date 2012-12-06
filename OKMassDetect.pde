class OKMassDetect extends OKBehavior {
  boolean showStats = false;
  int mass = 0;
  
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
  
  void enableStats() {
    showStats = true;
  }
  
  void bDraw() {
    if (showStats) {
      textSize(32);
      fill(255);
      stroke(255);
      pushMatrix();
      translate(1,1,1);
      hotspot.invertMatrix();
      PVector s = hotspot.getScaling();
      PVector pos = hotspot.getMaxBound();
      textAlign(RIGHT,TOP);
      translate(pos.x,pos.y,pos.z);
      text(mass,0,0,0);
      //text(mass,0,0,0);
      popMatrix();
    }
  }
  
  void update() {
    mass = 0;
  }
  
    boolean isMassDetect() {
    return true;
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
