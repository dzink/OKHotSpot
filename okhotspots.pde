OKHotSpotContext context;

void setup() {
  size(940, 680, OPENGL);
  context = new OKHotSpotContext(this);
  
  OKHotSpot hot = new OKHotSpot();
  hot.hResize(-200,200,200);
  hot.hTranslate(0,0,1800);
  //hot.hRotate(0,0,radians(90));
  //hot.init(8);
  /*hot.trackJoint(SimpleOpenNI.SKEL_LEFT_HAND);
  hot.trackJoint(SimpleOpenNI.SKEL_LEFT_ELBOW);
  hot.trackJoint(SimpleOpenNI.SKEL_RIGHT_HAND);
  hot.trackJoint(SimpleOpenNI.SKEL_RIGHT_ELBOW);
  hot.trackJoint(SimpleOpenNI.SKEL_LEFT_HIP);
  hot.trackJoint(SimpleOpenNI.SKEL_RIGHT_HIP);
  hot.trackJoint(SimpleOpenNI.SKEL_TORSO);
  hot.trackJoint(SimpleOpenNI.SKEL_HEAD);*/

  
  OKMassEdge masse = new OKMassEdge();
  hot.addMassDetect(masse);
    
  OKScanner scan = new OKScanner();
  hot.addBehavior(scan);

  OKMassScanner mass = new OKMassScanner();
  mass.setScanner(scan);
  hot.addMassDetect(mass);
  
  context.addHotSpot(hot);
  
  sphereDetail(5);
  ambientLight(255,255,255);
}

void draw() {
  background(100);  
  context.updateKinectOSC(); 
}





