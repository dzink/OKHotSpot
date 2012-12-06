OKHotSpotContext context;

void setup() {
  size(940, 680, OPENGL);
  context = new OKHotSpotContext(this);
  
  OKHotSpot hot = new OKHotSpot();
  hot.hResize(600,600,600);
  hot.hTranslate(200,0,1800);
  hot.hRotate(0,radians(90),radians(90));
    
  OKBackForthScanner scan = new OKBackForthScanner();
  hot.addBehavior(scan);

  OKMassScanner mass = new OKMassScanner();
  mass.setScanner(scan);
  hot.addBehavior(mass);
  mass.enableStats();


  OKMassEdge masse = new OKMassEdge();  
  hot.addBehavior(masse);

  OKMassDetect mdetect = new OKMassDetect();  
  hot.addBehavior(mdetect);
  
  context.addHotSpot(hot);
  
  sphereDetail(5);
  ambientLight(255,255,255);
}

void draw() {
  background(100);  
  context.updateKinectOSC(); 
}





