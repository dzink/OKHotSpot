class OKMessage {
  String symbol;
  
  public OKMessage(String s){
    symbol = s;
  }
  
  OscMessage sendOSC() {
    OscMessage myMessage = new OscMessage("oscCommand");
    //myMessage.add(mass);     
    return myMessage;
  }
  
  
}

/*class OKMassMessage extends OKMessage {
 
}*/
