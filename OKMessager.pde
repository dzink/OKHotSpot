class OKMessager {
  String messageM;
  
  OscMessage sendOSC() {
    OscMessage myMessage = new OscMessage("oscCommand");
    //myMessage.add(mass);     
    return myMessage;

  }
}
