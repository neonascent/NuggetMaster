void createGUI() {
  cp5 = new ControlP5(this);

  // change the default font to Verdana
  PFont p = createFont("Arial", 20);
  //p.setSize(20);
  cp5.setControlFont(p);
  //  controlP5.setControlFont(p);

  int y = 70;

  myKnobA = cp5.addKnob("hand")
    .setRange(0, 90)
      .setValue(servoPosition[5])
        .setPosition(100, y)
          .setRadius(100)
            .setDragDirection(Knob.VERTICAL)
              ;

  myKnobB = cp5.addKnob("wristRot")
    .setRange(0, 180)
      .setValue(servoPosition[4])
        .setPosition(400, y)
          .setRadius(100)
            .setDragDirection(Knob.VERTICAL)
              ;

 // y+= 280;
  

  y += 260;

  myKnobC = cp5.addKnob("wrist")
    .setRange(0, 180)
      .setValue(servoPosition[3])
        .setPosition(100, y)
          .setRadius(100)
            .setDragDirection(Knob.VERTICAL)
              ;

  myKnobD = cp5.addKnob("elbow")
    .setRange(0, 180)
      .setValue(servoPosition[2])
        .setPosition(400, y)
          .setRadius(100)
            .setDragDirection(Knob.VERTICAL)
              ;

  y += 260;

  myKnobE = cp5.addKnob("shoulder")
    .setRange(0, 180)
      .setValue(servoPosition[1])
        .setPosition(100, y)
          .setRadius(100)
            .setDragDirection(Knob.VERTICAL)
              ;

  myKnobF = cp5.addKnob("shoulderRot")
    .setRange(0, 180)
      .setValue(servoPosition[0])
        .setPosition(400, y)
          .setRadius(100)
            .setDragDirection(Knob.VERTICAL)
              ;
              
     y += 260;          

   actionRecord = cp5.addTextarea("actions")
                  .setPosition(100,y)
                  .setSize(200,200)
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  .setColor(color(128))
                  .setColorBackground(color(255,100))
                  .setColorForeground(color(255,100));
                  ;
   actionRecord.setText("");
   
     buttonStep = cp5.addButton("step")
     .setValue(128)
     .setPosition(400,y)
     ;
     
     buttonClear = cp5.addButton("reset")
     .setValue(128)
     .setPosition(500,y)
     ;
  
     y += 50; 
     
     play = cp5.addButton("play")
     .setBroadcast(false)     
     .setValue(128)
     .setPosition(400,y)
     .setBroadcast(true)
     ;
     
     save = cp5.addButton("saveAction")
     .setBroadcast(false)
     .setValue(128)
     .setPosition(500,y)
     .setBroadcast(true)
     ;
     
     y += 50;
  
    macros = cp5.addDropdownList("macros")
          .setPosition(300,y)
          ;
          
}


