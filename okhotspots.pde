OKHotSpotContext context;

void setup() {
  size(940, 680, OPENGL);
  context = new OKHotSpotContext(this);
  
  OKHotSpot hot = new OKHotSpot();
  hot.setSize(1200);
  hot.setPosition(200,0,1800);
  //hot.setRotation(0,radians(90),radians(0));
  context.addHotSpot(hot);
  
  OKHotSpot handme = new OKHotSpot();
  handme.setSize(100,100,100);
  handme.setPosition(200,0,1800);
  context.addHotSpot(handme);
  
  OKJointLeadHotSpot lead = new OKJointLeadHotSpot(0,OKHotSpotContext.SKEL_RIGHT_HAND);
  lead.setFollow(handme);
  
  hot.addBehavior(lead);
    
  OKBackForthScanner scan = new OKBackForthScanner();
  hot.addBehavior(scan);
  OKMassScanner mass = new OKMassScanner();
  mass.setScanner(scan);
  hot.addBehavior(mass);
  mass.enableStats();
  mass.addMessage("scannerMass");

  
  OKJointTrack joint = new OKJointTrack("Theremang",1,OKHotSpotContext.SKEL_RIGHT_HAND);
  //joint.addJoint(1,OKHotSpotContext.SKEL_LEFT_HAND);
  joint.enableStats();
  hot.addBehavior(joint);

  /*OKJointPairTrack joint2 = new OKJointPairTrack(1,OKHotSpotContext.SKEL_RIGHT_HAND,1,OKHotSpotContext.SKEL_RIGHT_SHOULDER);
  hot.addBehavior(joint2);*/
  


  OKMassEdge masse = new OKMassEdge();  
  hot.addBehavior(masse);

  OKMassDetect mdetect = new OKMassDetect();  
  mdetect.enableStats();
  handme.addBehavior(mdetect);
  
}

void draw() {
  background(50);  
  context.updateKinectOSC(); 
}





