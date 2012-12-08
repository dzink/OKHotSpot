
class OKHotSpot
{
  String oscCommand;// = "hotspot";
  OscMessage message;
      
  boolean isActive = false;  // Whether or not this hotspot is active

  PVector position;  // position (calculated first)
  PVector rotation;  // rotation (calculated second)
  PVector scaling;   // scaling  (calculated third)
  PVector minBound = new PVector();  // bottom left front corner of hot spot's minimum real world limits
  PVector maxBound = new PVector();  // top right back corner of hot spot's maximum real world limits
  PMatrix3D matrix = new PMatrix3D();   // Stored matrix conversion
  PMatrix3D imatrix = new PMatrix3D();  // Stored inverted matrix conversion

  color bright = color(255,100,100,200);  // Bright brightness
  color medium = color(255,100,100,100);  // Medium brightness
  color dim = color(255,100,100,50);      // Dim brightness
  float pointSize = 50;

  ArrayList<OKBehavior> behaviors = new ArrayList();    // All behaviors
  ArrayList<OKMassDetect> massDetect = new ArrayList(); // Mass detect behaviors
  ArrayList<OKJointTrack> jointTrack = new ArrayList(); // Joint track behaviors
  ArrayList<OKAnimation> animation = new ArrayList(); // Animation behaviors

  
  public OKHotSpot(){
      
    position = new PVector();
    scaling = new PVector();
    rotation = new PVector();
    hResize(1);
    hRotate(0,0,0);
    hTranslate(0,0,0);
    //hColor=color(0,169,200,19);
  }
  

  
  /*void setContext(HotSpots[] c) {
    context = c[0];
  }*/
  
  void hResize(float nx) {
    scaling.set(nx,nx,nx);
  }
  void init(int n) {
  }
  
 
  void recalcMatrix() {
    matrix.reset();
    //matrix.scale(1,1,1);
    matrix.translate(position.x,position.y,position.z);
    matrix.rotateX(rotation.x);
    matrix.rotateY(rotation.y);
    matrix.rotateZ(rotation.z);
    matrix.scale(scaling.x,scaling.y,scaling.z);
    imatrix = matrix.get();
    imatrix.invert();
    setMaxBoundary();
  }
  
  //set fast boundaries for (slightly more) matrix-free checking
  void setMaxBoundary() {
    PVector a = new PVector(0,0,0);
    PVector b = new PVector(0,0,0);
    float[][] l = new float[3][8];
    int c=0;
    for(float x=-1; x<=1; x+=2) {
      for(float y=-1; y<=1; y+=2) {
        for(float z=-1; z<=1; z+=2) {
          a = matrix.mult(new PVector(x,y,z),a);
          l[0][c] = a.x;
          l[1][c] = a.y;
          l[2][c] = a.z;          
          c++;
        }
      }
    }
    Arrays.sort(l[0]);
    Arrays.sort(l[1]);
    Arrays.sort(l[2]);
    minBound.set(l[0][0],l[1][0],l[2][0]);
    maxBound.set(l[0][7],l[1][7],l[2][7]);
  }
 
  
  void hResize(float nx, float ny, float nz) {
    scaling.set(nx,ny,nz);
    recalcMatrix();
  }

  void hRotate(float ny) {
    rotation.set(0,ny,0);
    recalcMatrix();
  }
  
  void hRotate(float nx, float ny, float nz) {
    rotation.set(nx,ny,nz);
    recalcMatrix();
  }

  void hTranslate(float nx, float ny, float nz) {
     position.set(nx,ny,nz);
     recalcMatrix();
  }
  
  void hAnimate() {
    //drawCore();
    drawOutline();
 
  }
  
  void setMatrix() {
    applyMatrix(matrix);
    /*translate(position.x,position.y,position.z);
    rotateX(rotation.x);
    rotateY(rotation.y);
    rotateZ(rotation.z);
    scale(scaling.x,scaling.y,scaling.z);*/
  }
  
  void update() {
    for(OKBehavior b : behaviors) {
      b.update();
    }
  }
  
  void sendMessages() {
    for(OKBehavior b : behaviors) {
      b.sendMessages();
    }
  }
  
  void draw(){
    pushMatrix();
    stroke(255,10);
    setMatrix();
    hAnimate();
    for(OKBehavior b : behaviors) {
      b.bDraw();
    }
    popMatrix();
  }
  
  void drawCore() {
    //core
    if(isActive) {
      fill(0,20);
    } else {
      fill(0,20);
    }
    box(1.5,1.5,1.5);
  }
  
  void drawOutline() {
    //core
    pushStyle();
    if(isActive) {
      fill(0,20);
    } else {
      fill(0,20);
    }
    //noFill();
    noFill();
    stroke(255,50);
    strokeWeight(2);
    box(2);
    popStyle();
  }
  
  /*void drawJoints() {
    for(int joint : joints) {
      PVector j = translateToModel(getJointVector(joint));
      fill(255);
      if(isPointWithin(j)) {

        //drawPointAt(j, 0.5);
        drawJointAt(j, 255);
      } 
        
        
    }
  }*/
  
  void drawJointAt(PVector j, float b) {
    pushStyle();
    fill(255,255,0,b);
    stroke(0,b*0.4);
    strokeWeight(1);
    pushMatrix();
    translate(j.x,j.y,j.z);
    rotateX(-rotation.x);
    rotateY(-rotation.x);
    ellipse(0,0,pointSize/scaling.x,pointSize/scaling.y);
    popStyle();
    popMatrix();
  }
  
  boolean checkMass(PVector p, int pixel, int userID) {
    if (isFastPointWithin(p)) {
      if (isPointWithin(translateToModel(p))) {
        //for(OKMassDetect b : 
        //return foundMass(p);
      }
    }
    return false;
  }
  
  boolean foundMass(PVector p) {
    //mass++;
    pushStyle();
    stroke(255,100);
    point(p.x,p.y,p.z);
    popStyle();
    return true;
  }
  
  void clearMass() {
    //mass = 0;
  }
  
  // uses the real-world boundaries of the box that is inscribed by the real box. Use this to determine if the system should even bother checking to see if a point is in the box
  boolean isFastPointWithin(PVector p) {
    return(p.x > minBound.x && p.x < maxBound.x &&  
      p.y > minBound.y && p.y < maxBound.y && 
      p.z > minBound.z && p.z < maxBound.z); 
  }
  
  // uses the hotspot coordinates to see if a point is in the box
  boolean isPointWithin(PVector p) {
    if(p.x>=-1 && p.x<=1 && p.y>=-1 && p.y<=1 && p.z>=-1 && p.z<=1) {
      return true;
    } else {
      return false;
    }
  }

  boolean isPointWithinEdge(PVector p, float edge) {
    if(abs(p.x)>=edge || abs(p.y)>=edge || abs(p.z)>=edge) {
      return true;
    } else {
      return false;
    }
  }

  PVector translateToModel(PVector a) {
    PVector b = new PVector();
    b = imatrix.mult(a,b);
    return b;
  }
  
  void drawPointAxisX(PVector p) {
    line(1,p.y,p.z,-1,p.y,p.z);
  }
  
  void drawPointAxisY(PVector p) {
    line(p.x,1,p.z,p.x,-1,p.z);
  }
  
  void drawPointAxisZ(PVector p) {
    line(p.x,p.y,1,p.x,p.y,-1);
  }  
  
  void drawPointX(PVector p, float bright) {
    pushMatrix();
    pushStyle();
    pushMatrix();
    translate(-1,p.y,p.z);
    rotateY(PI/2);
    fill(130,255,120,200*bright);
    ellipse(0,0,pointSize/scaling.z,pointSize/scaling.y);
    popMatrix();
    noStroke();
    fill(120,255,120,50*bright);
    translate(1,p.y,p.z);
    rotateY(PI/2);
    ellipse(0,0,pointSize/scaling.z,pointSize/scaling.y);
    popMatrix();
    
    popStyle();
  }
  
  void drawPointY(PVector p, float bright) {
    pushStyle();
    pushMatrix();
    translate(p.x,1,p.z);
    rotateX(PI/2);
    fill(255,120,120,200*bright);
    ellipse(0,0,pointSize/scaling.x,pointSize/scaling.z);
    popMatrix();
    noStroke();
    fill(255,120,120,50*bright);
    pushMatrix();
    translate(p.x,-1,p.z);
    rotateX(PI/2);
    ellipse(0,0,pointSize/scaling.x,pointSize/scaling.z);
    popMatrix();
    popStyle();
  }
  
  void drawPointZ(PVector p, float bright) {
    pushStyle();
    fill(120,120,255,200*bright);
    pushMatrix();
    translate(p.x,p.y,-1);
    rotateZ(PI/2);
    ellipse(0,0,pointSize/scaling.y,pointSize/scaling.x);
    popMatrix();
    pushMatrix();
    translate(p.x,p.y,1);
    rotateZ(PI/2);
    noStroke();
    point(0,0,0);
    fill(120,120,255,50*bright);
    ellipse(0,0,pointSize/scaling.y,pointSize/scaling.x);
    popMatrix();
    popStyle();
  }
  
  void drawPointAt(PVector p, float bright) {
    drawPointAxisX(p);
    drawPointAxisY(p);
    drawPointAxisZ(p);
    drawPointX(p, bright);
    drawPointY(p, bright);    
    drawPointZ(p, bright);    
  }
  
  void makeBright() {
    fill(bright);
  }
  
  void makeDim() {
    fill(dim);
  }

  ArrayList<OKJointTrack> getJointTrack() {
    return jointTrack;
  }
  
  ArrayList<OKMassDetect> getMassDetect() {
    return massDetect;
  }
  
  void addBehavior(OKBehavior b) {
    b.addParentHotSpot(this);
    if(b.isMassDetect()) addMassDetect((OKMassDetect) b);
    //if(b.isJointTrack()) addJointTrack(b);
    behaviors.add(b);
  }

  private void addMassDetect(OKMassDetect b) {
    massDetect.add(b);
  }

  void addJointTrack(OKJointTrack b) {
    jointTrack.add(b);
  }

  PVector getScaling() {
    return scaling;
  }
  
  PVector getPosition() {
    return position;
  }
  
  PVector getMinBound() {
    return minBound;
  }
  
  PVector getMaxBound() {
    return maxBound;
  }
  
  void invertMatrix() {
    applyMatrix(imatrix);
  }
  
  void overlayText(String ot, float x, float y, float z) {
    pushStyle();
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    faceFront(x,y,z);
    textAlign(RIGHT,TOP);
    textSize(64);    
    text(ot,0,0,0);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
    popStyle();
  }
  
  void overlayEllipse(float r, float x, float y, float z) {
    pushStyle();
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    faceFront(x,y,z);
    ellipse(0,0,r,r);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
    popStyle();
  }
  
  void faceFront(float x, float y, float z) {
    translate(x,y,z);
    scale(1,-1,1);
    invertMatrix();
    translate(position.x,position.y,position.z);
  }
  
  void overlayText(float ot, float x, float y, float z) {
    overlayText(Float.toString(ot),x,y,z);
  }
  
  
}


// Everything is a hotspot - overrides a number of location and rotation-specific things.
class OKGlobalHotSpot extends OKHotSpot {
  void setMatrix() {
  }
  
  void draw() {
    for(OKBehavior b : behaviors) {
      b.bDraw();
    }
  }
  
  boolean isFastPointWithin(PVector p) {
    return true;
  }
  
  // uses the hotspot coordinates to see if a point is in the box
  boolean isPointWithin(PVector p) {
    return true;
  }

  boolean isPointWithinEdge(PVector p, float edge) {
    return false;
  }
  
}

class OKHotSpotSphere extends OKHotSpot {
  float distanceFromOrigin(PVector p) {
    return p.mag();
  }
  
  boolean isPointWithin(PVector p) {
    return (abs(p.mag())<=1.);
  }

  boolean isPointWithinEdge(PVector p, float edge) {
    return (abs(p.mag())>=edge);
  }
  
  void drawOutline() {
    //core
    pushStyle();
    if(isActive) {
      fill(0,20);
    } else {
      fill(0,20);
    }
    //noFill();
    noFill();
    stroke(255,50);
    strokeWeight(2);
    sphere(2);
    popStyle();
  }
}
