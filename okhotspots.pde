OKHotSpotContext context;

void setup() {
  size(940, 680, OPENGL);
  context = new OKHotSpotContext(this);
  
  OKHotSpotSphere hot = new OKHotSpotSphere();
  hot.hResize(600,600,600);
  hot.hTranslate(200,0,1800);
  hot.hRotate(0,radians(90),radians(0));
    
  /*OKBackForthScanner scan = new OKBackForthScanner();
  //hot.addBehavior(scan);
  OKMassScanner mass = new OKMassScanner();
  mass.setScanner(scan);
  hot.addBehavior(mass);
  mass.enableStats();
  mass.addMessage("scannerMass");*/

  
  OKJointTrack joint = new OKJointTrack("Theremooo",1,OKHotSpotContext.SKEL_RIGHT_HAND);
  joint.addJoint(1,OKHotSpotContext.SKEL_LEFT_HAND);
  joint.enableStats();
  hot.addBehavior(joint);

  /*OKJointPairTrack joint2 = new OKJointPairTrack(1,OKHotSpotContext.SKEL_RIGHT_HAND,1,OKHotSpotContext.SKEL_RIGHT_SHOULDER);
  hot.addBehavior(joint2);*/
  


  OKMassEdge masse = new OKMassEdge();  
  hot.addBehavior(masse);

  OKMassDetect mdetect = new OKMassDetect();  
  hot.addBehavior(mdetect);
  
  context.addHotSpot(hot);
}

void draw() {
  background(100);  
  context.updateKinectOSC(); 
}





