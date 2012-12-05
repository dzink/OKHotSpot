class OKAnimation extends OKBehavior {
  float value = 0.;
  float speed = 40.;
  
  void tickAnimation() {
    if (speed != 0.) {
      value += 1./speed;
      if (value > 1.) {
        value -= 1;
      }
    }
  }
  
  void bDraw() {
    tickAnimation();
  }
  
  void setSpeed(float s) {
    speed = s;
  }
  
  void setValue(float v) {
    value = v;
  }
}

class OKScanner extends OKAnimation {
  float mesh = 0.4;
  float sWidth = 0.2;

  void bDraw() {
    pushStyle();
    strokeWeight(1);
    stroke(255);
    drawMesh(value);
    if(value>sWidth) {
      drawMesh(value-sWidth);
    }else {
      drawMesh(value-sWidth+1.);
    }
    tickAnimation();
    popStyle();
  }
  
  float mapValueToCoords(float n) {
    return map(n,0,1,-1,1);
  }

  float mapCoordsToValue(float n) {
    return map(n,-1,1,0,1);
  }
  
  void drawMesh(float n) {
    n = mapValueToCoords(n);
    for(float y=-1.; y<=1.; y+=mesh){
      line(n,1,y,n,-1,y);
      line(n,y,1,n,y,-1);
    }        
  }
  
  boolean checkScan(float n) {
    n = mapCoordsToValue(n);
    if(value>sWidth) {
      return (n>=(value-sWidth) && n<=(value));
    }else {
      return (n>=(1+value-sWidth) || n<=(value));
    }
  }
  

  
}
