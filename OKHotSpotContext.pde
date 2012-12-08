import oscP5.*;
import netP5.*;
import SimpleOpenNI.*;
import javax.media.opengl.*;
import processing.opengl.*;

class OKHotSpotContext extends SimpleOpenNI {
  ArrayList<OKHotSpot> hotspots = new ArrayList();
  PImage rgbImage;
  PVector[] depthPoints;
  //HotSpots[] selfRef = new HotSpots[1];
  PVector[] back;
  int[] userMap;
  IntVector userList = new IntVector();
  int pointDistance = 12;
  float cloudWeight = 2;
  boolean fullOscMessage = false;
  
  color[] userColors = { color(0,255,255), color(120,255,0), color(255,120,0), color(0,120,255), color(255,255,0), color(120,0,255) };


  OscP5 oscP5;
  NetAddress myRemoteLocation;

  ArrayList<OscMessage> messages = new ArrayList();

  PVector cameraPosition = new PVector(0,0,-1100);
  PVector cameraRotation = new PVector(0,0,0);
  float cameraZoom = -1800;
  
  public OKHotSpotContext(processing.core.PApplet parent) {
    super(parent);
    initKinect();
    initOSCP5();
  }
  
  void initKinect() {
    enableDepth();
    enableRGB();
    alternativeViewPointDepthToImage();
    enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
    setMirror(true);
    setSmoothingSkeleton(0.3);
    //hint(DISABLE_DEPTH_TEST); 
  }
  
  void initOSCP5() {
    oscP5= new OscP5(this, 12000);
    myRemoteLocation= new NetAddress("127.0.0.1", 57120); //ip supercollider    
  }
  
  void updateKinectOSC() {
    //println(frameRate);
    messages.clear();
    update();
    rgbImage = rgbImage();
    depthPoints = depthMapRealWorld();
    userMap = getUsersPixels(SimpleOpenNI.USERS_ALL);
    updateHotSpots();
    makeScene();
    userUpdate();
    drawHotSpots();    
    sendMessages();
  }
  
  void addHotSpot(OKHotSpot hot) {
    //selfRef[0] = this;
    //hot.setContext(selfRef);
    hotspots.add(hot); 
  }

  void updateHotSpots() {
    for(OKHotSpot hot : hotspots) {
      hot.update();
    }
  }
  
  void drawHotSpots() {
    for(OKHotSpot hot : hotspots) {
      hot.draw();
    }
  }
  
  void makeScene() {
    for(OKHotSpot hot : hotspots) {
      hot.clearMass();
    }
    pushStyle();
    strokeWeight(cloudWeight);

   
    boolean drawnFlag;
    for (int i = 0; i < depthPoints.length; i+=pointDistance) {
      PVector currentPoint = depthPoints[i];
      if (userMap[i] >0) {
        drawnFlag = false;
        for(OKHotSpot hot : hotspots) {
          if(hot.isFastPointWithin(currentPoint)) {
            ArrayList<OKMassDetect> masses = hot.getMassDetect();
            if(masses.size() > 0) {
              PVector modelPoint = hot.translateToModel(currentPoint);
              for(OKMassDetect m : masses) {
                if(m.checkMass(modelPoint, rgbImage.pixels[i], userMap[i]) && !drawnFlag) {
                  m.drawMass(currentPoint, rgbImage.pixels[i], userMap[i]);
                  drawnFlag = true;
                }
              }
            }
          }
        }
        if (!drawnFlag) {
          
          //stroke(lerpColor(color(rgbImage.pixels[i]), color(255), 0.10),255);
          stroke(mixUserColorWith(userMap[i],rgbImage.pixels[i],0.85));
          point(currentPoint.x, currentPoint.y, currentPoint.z);
          
        }
      }
      
    }
    popStyle();
  }
  
  void addMessage(OscMessage m) {
    messages.add(m);
  }
  
  void sendMessages() {
    OscBundle b = new OscBundle();
    for(OscMessage o : messages) {
      //oscP5.send(hot.sendOSC(), myRemoteLocation);
      //hot.sendMessages();
      if(!fullOscMessage) {
        String[] tokens = o.addrPattern().split("[/]+");
        o.setAddrPattern(tokens[0]);
        o.add(tokens);
      }
      b.add(o);

    }
    oscP5.send(b, myRemoteLocation);
  }
  
  IntVector getUserList() {
    return userList;
  }
  
  void userUpdate() {
    getUsers(userList);
    int c = 0;
    if (userList.size() > 0) {
      int userID = userList.get(0);
      if (isTrackingSkeleton(userID)) {      
        PVector torso = new PVector();
        getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_TORSO, torso);      
        if(c==0) {
          camera(torso.x+cameraPosition.x,torso.y+cameraPosition.y,torso.z+cameraPosition.z, // eyeX, eyeY, eyeZ
            torso.x,torso.y,torso.z,

            0.0,-1.0, 0.0); // upX, upY, upZ*/
        }
      }
      c++;
    }
    if (c==0) {
      camera(cameraPosition.x,cameraPosition.y,cameraPosition.z, // eyeX, eyeY, eyeZ
            0,0,1100, // centerX, centerY, centerZ
            0.0,-1.0, 0.0); // upX, upY, upZ*/
    }
  }  
  
  void cameraLeft() {
    cameraRotation.set(cameraRotation.x,cameraRotation.y-PI/24.,cameraRotation.z);
    cameraReset();
  }

  void cameraUp() {
    cameraRotation.set(cameraRotation.x+PI/24.,cameraRotation.y,cameraRotation.z);
    cameraReset();
  }

  void cameraRight() {
    cameraRotation.set(cameraRotation.x,cameraRotation.y+PI/24.,cameraRotation.z);
    cameraReset();
  }

  void cameraDown() {
    cameraRotation.set(cameraRotation.x-PI/24.,cameraRotation.y,cameraRotation.z);
    cameraReset();
  }

  void cameraZoomIn() {
    cameraZoom += 100;
    cameraReset();
  }

  void cameraZoomOut() {
    cameraZoom -= 100;
    cameraReset();
  }
  
  void cameraReset() {
    PMatrix3D cameraMatrix = new PMatrix3D();
    cameraMatrix.rotateX(cameraRotation.x);
    cameraMatrix.rotateY(cameraRotation.y);
    cameraMatrix.rotateZ(cameraRotation.z);
    cameraMatrix.translate(0,0,cameraZoom);
    //cameraMatrix.invert();
    cameraPosition = cameraMatrix.mult(new PVector(0,0,0), cameraPosition);
  }
  
    
  color getUserColor(int userID) {
    return userColors[userID % 6];
  }
  
  color mixUserColorWith(int userID, color mix, float amount) {
    return lerpColor(getUserColor(userID),mix,amount);
  }

  void setCloudWeight(float w) {
    cloudWeight = w;
  }
  
  void increaseCloudWeight() {
    cloudWeight += 0.5;
  }

  void decreaseCloudWeight() {
    cloudWeight -= 0.5;
  }

}   

  
// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  context.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!! ID: " + Integer.toString(userId));
    context.startTrackingSkeleton(userId);
  } 
  else { 
    println("  Failed to calibrate user !!! ID: " + Integer.toString(userId));
    context.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Assume psi pose for user ID: " + Integer.toString(userId));
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
}

void keyPressed() {
  println("keycode: " + keyCode);
  switch (keyCode) {
    case 37: case 100:  // left
      context.cameraLeft();
    break;
    case 38: case 104:  // up
      context.cameraUp();
    break;
    case 39: case 102:  // right
      context.cameraRight();
    break;
    case 40: case 98:   // down
      context.cameraDown();
    break;
    case 33: case 105:
      context.cameraZoomIn();
    break;
    case 34: case 99:
      context.cameraZoomOut();
      break;
    case 61: case 107:
      context.increaseCloudWeight();
    break;
    case 45: case 109:
      context.decreaseCloudWeight();
    break;
  }
}
