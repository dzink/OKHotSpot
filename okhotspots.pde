OKHotSpotContext context;

void setup() {
  size(940, 680, OPENGL);
  context = new OKHotSpotContext(this);
  
  OKHotSpot hot = new OKHotSpot();            // New hotspot
  hot.setSize(600);                           // Set size
  hot.setPosition(0,0,1800);                  // Set location relative to Kinect
  hot.setRotation(0,radians(0),radians(90));  // Rotate hotspot (turn it on its side
  context.addHotSpot(hot);
  

  

    
  OKBackForthScanner scan = new OKBackForthScanner();   // New behavior: animation of a scanner going back and forth
  hot.addBehavior(scan);                                // Add this scanning to large hotspot
  OKMassScanner mass = new OKMassScanner("clicky");     // New behavior: scanning mass detection
  mass.setScanner(scan);                                // Tie the scanner to the mass detector
  hot.addBehavior(mass);                                // add behavior to hotspot
  mass.enableStats();                                   // add display of stats to behavior

  
  OKJointTrack joint = new OKJointTrack();
  joint.addJoint("jetsons",1,OKHotSpotContext.SKEL_RIGHT_HIP);
  joint.addJoint("squibblebeat",1,OKHotSpotContext.SKEL_LEFT_KNEE);
  joint.enableStats();
  hot.addBehavior(joint);

  /*OKJointPairTrack joint2 = new OKJointPairTrack(1,OKHotSpotContext.SKEL_RIGHT_HAND,1,OKHotSpotContext.SKEL_RIGHT_SHOULDER);
  hot.addBehavior(joint2);*/
  


  OKMassEdge masse = new OKMassEdge("enter");  // New behavior: edge detection
  hot.addBehavior(masse);                      // Add to large hotspot

  
  OKHotSpot handme = new OKHotSpot();  // New Hotspot
  handme.setSize(100,100,100);         // Set size
  handme.setPosition(200,0,1800);      // Set position
  context.addHotSpot(handme);          // Add to scene
  
  OKMassDetect mdetect = new OKMassDetect("handy");   // New behavior: mass detection
  mdetect.enableStats();                              // Display mass stats
  handme.addBehavior(mdetect);                        // Add behavior to hotspot

  // New behavior: a hotspot will center on a given joint
  OKJointLeadHotSpot lead = new OKJointLeadHotSpot(0,OKHotSpotContext.SKEL_RIGHT_HAND);
  lead.setFollow(handme);  // set the small hotspot that will follow this behavior
  hot.addBehavior(lead);   // add behavior to large hotspot
  
}

void draw() {
  background(50);  
  context.updateKinectOSC(); 
}





