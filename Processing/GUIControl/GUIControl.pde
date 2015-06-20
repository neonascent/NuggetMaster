
/**
 * ControlP5 Knob
 *
 *
 * find a list of public methods available for the Knob Controller
 * at the bottom of this sketch.
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 *
 */

import controlP5.*;
import processing.serial.*;

ControlP5 cp5;

int myColorBackground = color(0, 0, 0);
Serial myPort;  // Create object from Serial class

Knob myKnobA;
Knob myKnobB;
Knob myKnobC;
Knob myKnobD;
Knob myKnobE;
Knob myKnobF;
Button buttonStep;
Button buttonClear;
Button save;
Button play;
DropdownList macros;
Textarea actionRecord;

String actions = "";

boolean centerCheck = false;
color checkColor;

int val = 0;

int[] servoPosition = {
  90, 93, 72, 90, 90, 90
};
String[] servoLabel = {
  "z", "x", "a", "s", "q", "w"
};

void setup() {
  size(720, 1280);
  smooth();
  noStroke();

  println(Serial.list());

  String portName = Serial.list()[0];
  //String portName = "COM52";
  myPort = new Serial(this, portName, 19200);
  actions = "";
  createGUI();
  populateMacros();

  for (int i = 0; i < servoLabel.length; i++) {
    sendCommand(servoPosition[i] + servoLabel[i]);
    delay(100);
  }
}

void populateMacros() {
  // a convenience function to customize a DropdownList
  macros.setBackgroundColor(color(190));
  macros.setItemHeight(25);
  macros.setBarHeight(15);
  macros.captionLabel().set("macros");
  macros.captionLabel().style().marginTop = 3;
  macros.captionLabel().style().marginLeft = 3;
  macros.valueLabel().style().marginTop = 3;
  macros.clear();


  for (int i=0; i<100; i++) {    
    String filename = "macro_"+i+".txt";
    println("Looking for "+ filename);
    File f = new File(dataPath(filename));
    if (f.exists()) {
      macros.addItem("Macro "+i, i);
      println("Adding "+ filename);
    } else {
      break;
    }
  }
  //ddl.scroll(0);
  macros.setColorBackground(color(60));
  macros.setColorActive(color(255, 128));
}



void loadMacro(int n) {

  println("loading macro");
  String lines[] = loadStrings("macro_"+n+".txt");
  println("there are " + lines.length + " lines");
  String temp = "";
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().length() > 0) 
      temp += lines[i] + "\r\n";
  }
  print(temp);
  actionRecord.setText(temp);
}

void saveMacro(int n, String s) {
  String[] lines = split(s, "\r\n");
  saveStrings(dataPath("macro_"+n+".txt"), lines);
}

// Called whenever there is something available to read
void serialEvent(Serial port) {
  // Data from the Serial port is read in serialEvent() using the read() function and assigned to the global variable: val
  val = port.read();
  // For debugging
  //print((char)val);
}

void draw() {
  background(myColorBackground);
  fill(70);
  rect(0, 600, width, height/2);
  // fill(0, 100);
  // rect(60, 40, 380, 200);
}


void hand(int theValue) {
  sendCommand(theValue+servoLabel[5]);
  delay(50);
}

void wristRot(int theValue) {
  sendCommand(theValue+servoLabel[4]);
  delay(50);
}

void play() {
  String[] lines = split(actionRecord.text(), "\r\n");
  for (int i = 0; i < (lines.length-1); i++) {
    if (lines[i].startsWith(">")) {
      delay(500);
    } else {
      sendCommand(lines[i]);
      delay(20);
    }
  }
  print("done");
}

void saveAction() {
  for (int i=0; i<100; i++) {    
    String filename = "macro_"+i+".txt";
    File f = new File(dataPath(filename));
    if (!f.exists()) {
      saveMacro(i, actionRecord.text());
      break;
    }
  }
  populateMacros();
}

void wrist(int theValue) {
  sendCommand(theValue+servoLabel[3]);
  delay(50);
}

void elbow(int theValue) {
  sendCommand(theValue+servoLabel[2]);
  delay(50);
}

void shoulder(int theValue) {
  sendCommand(theValue+servoLabel[1]);
  delay(50);
}

void shoulderRot(int theValue) {
  sendCommand(theValue+servoLabel[0]);
  delay(50);
}

void step(int theValue) {
  actions += ">.."+"\r\n";
  actionRecord.setText(actions);
}

void reset(int theValue) {
  actions = "";
  actionRecord.setText(actions);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      myKnobE.setValue(myKnobE.getValue() + 1);
    } else if (keyCode == DOWN) {
      myKnobE.setValue(myKnobE.getValue() - 1);
    } else if (keyCode == LEFT) {
      myKnobF.setValue(myKnobF.getValue() + 1);
    } else if (keyCode == RIGHT) {
      myKnobF.setValue(myKnobF.getValue() - 1);
    } else if (keyCode == ENTER) {
      buttonStep.setValue(128);
    }
  } else if (keyCode == 97) { // NUM1
    myKnobD.setValue(myKnobD.getValue() + 1);
  } else if (keyCode == 100) { // NUM4
    myKnobD.setValue(myKnobD.getValue() - 1);
  } else if (keyCode == 98) { // NUM2
    myKnobC.setValue(myKnobC.getValue() + 1);
  } else if (keyCode == 101) { // NUM5
    myKnobC.setValue(myKnobC.getValue() - 1);
  } else if (keyCode == 104) { // NUM8
    myKnobB.setValue(myKnobB.getValue() + 1);
  } else if (keyCode == 105) { // NUM9
    myKnobB.setValue(myKnobB.getValue() - 1);
  } else if (keyCode == 107) { // +
    myKnobA.setValue(myKnobA.getValue() + 1);
  } else if (keyCode == 109) { // -
    myKnobA.setValue(myKnobA.getValue() - 1);
  }
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    if (theEvent.getGroup().toString().startsWith("macros")) {
      loadMacro((int)theEvent.getGroup().getValue());
    }
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } else if (theEvent.isController()) {    
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

/*
a list of all methods available for the Knob Controller
 use ControlP5.printPublicMethodsFor(Knob.class);
 to print the following list into the console.
 
 You can find further details about class Knob in the javadoc.
 
 Format:
 ClassName : returnType methodName(parameter type)
 
 controlP5.Knob : Knob setConstrained(boolean) 
 controlP5.Knob : Knob setDragDirection(int) 
 controlP5.Knob : Knob setMax(float) 
 controlP5.Knob : Knob setMin(float) 
 controlP5.Knob : Knob setNumberOfTickMarks(int) 
 controlP5.Knob : Knob setRadius(float) 
 controlP5.Knob : Knob setRange(float) 
 controlP5.Knob : Knob setResolution(float) 
 controlP5.Knob : Knob setScrollSensitivity(float) 
 controlP5.Knob : Knob setSensitivity(float) 
 controlP5.Knob : Knob setShowRange(boolean) 
 controlP5.Knob : Knob setStartAngle(float) 
 controlP5.Knob : Knob setTickMarkLength(int) 
 controlP5.Knob : Knob setTickMarkWeight(float) 
 controlP5.Knob : Knob setValue(float) 
 controlP5.Knob : Knob setViewStyle(int) 
 controlP5.Knob : Knob showTickMarks(boolean) 
 controlP5.Knob : Knob shuffle() 
 controlP5.Knob : Knob snapToTickMarks(boolean) 
 controlP5.Knob : Knob update() 
 controlP5.Knob : boolean isConstrained() 
 controlP5.Knob : boolean isShowRange() 
 controlP5.Knob : boolean isShowTickMarks() 
 controlP5.Knob : float getAngle() 
 controlP5.Knob : float getRadius() 
 controlP5.Knob : float getRange() 
 controlP5.Knob : float getResolution() 
 controlP5.Knob : float getStartAngle() 
 controlP5.Knob : float getTickMarkWeight() 
 controlP5.Knob : float getValue() 
 controlP5.Knob : int getDragDirection() 
 controlP5.Knob : int getNumberOfTickMarks() 
 controlP5.Knob : int getTickMarkLength() 
 controlP5.Knob : int getViewStyle() 
 controlP5.Controller : CColor getColor() 
 controlP5.Controller : ControlBehavior getBehavior() 
 controlP5.Controller : ControlWindow getControlWindow() 
 controlP5.Controller : ControlWindow getWindow() 
 controlP5.Controller : ControllerProperty getProperty(String) 
 controlP5.Controller : ControllerProperty getProperty(String, String) 
 controlP5.Controller : Knob addCallback(CallbackListener) 
 controlP5.Controller : Knob addListener(ControlListener) 
 controlP5.Controller : Knob bringToFront() 
 controlP5.Controller : Knob bringToFront(ControllerInterface) 
 controlP5.Controller : Knob hide() 
 controlP5.Controller : Knob linebreak() 
 controlP5.Controller : Knob listen(boolean) 
 controlP5.Controller : Knob lock() 
 controlP5.Controller : Knob plugTo(Object) 
 controlP5.Controller : Knob plugTo(Object, String) 
 controlP5.Controller : Knob plugTo(Object[]) 
 controlP5.Controller : Knob plugTo(Object[], String) 
 controlP5.Controller : Knob registerProperty(String) 
 controlP5.Controller : Knob registerProperty(String, String) 
 controlP5.Controller : Knob registerTooltip(String) 
 controlP5.Controller : Knob removeBehavior() 
 controlP5.Controller : Knob removeCallback() 
 controlP5.Controller : Knob removeCallback(CallbackListener) 
 controlP5.Controller : Knob removeListener(ControlListener) 
 controlP5.Controller : Knob removeProperty(String) 
 controlP5.Controller : Knob removeProperty(String, String) 
 controlP5.Controller : Knob setArrayValue(float[]) 
 controlP5.Controller : Knob setArrayValue(int, float) 
 controlP5.Controller : Knob setBehavior(ControlBehavior) 
 controlP5.Controller : Knob setBroadcast(boolean) 
 controlP5.Controller : Knob setCaptionLabel(String) 
 controlP5.Controller : Knob setColor(CColor) 
 controlP5.Controller : Knob setColorActive(int) 
 controlP5.Controller : Knob setColorBackground(int) 
 controlP5.Controller : Knob setColorCaptionLabel(int) 
 controlP5.Controller : Knob setColorForeground(int) 
 controlP5.Controller : Knob setColorValueLabel(int) 
 controlP5.Controller : Knob setDecimalPrecision(int) 
 controlP5.Controller : Knob setDefaultValue(float) 
 controlP5.Controller : Knob setHeight(int) 
 controlP5.Controller : Knob setId(int) 
 controlP5.Controller : Knob setImages(PImage, PImage, PImage) 
 controlP5.Controller : Knob setImages(PImage, PImage, PImage, PImage) 
 controlP5.Controller : Knob setLabelVisible(boolean) 
 controlP5.Controller : Knob setLock(boolean) 
 controlP5.Controller : Knob setMax(float) 
 controlP5.Controller : Knob setMin(float) 
 controlP5.Controller : Knob setMouseOver(boolean) 
 controlP5.Controller : Knob setMoveable(boolean) 
 controlP5.Controller : Knob setPosition(PVector) 
 controlP5.Controller : Knob setPosition(float, float) 
 controlP5.Controller : Knob setSize(PImage) 
 controlP5.Controller : Knob setSize(int, int) 
 controlP5.Controller : Knob setStringValue(String) 
 controlP5.Controller : Knob setUpdate(boolean) 
 controlP5.Controller : Knob setValueLabel(String) 
 controlP5.Controller : Knob setView(ControllerView) 
 controlP5.Controller : Knob setVisible(boolean) 
 controlP5.Controller : Knob setWidth(int) 
 controlP5.Controller : Knob show() 
 controlP5.Controller : Knob unlock() 
 controlP5.Controller : Knob unplugFrom(Object) 
 controlP5.Controller : Knob unplugFrom(Object[]) 
 controlP5.Controller : Knob unregisterTooltip() 
 controlP5.Controller : Knob update() 
 controlP5.Controller : Knob updateSize() 
 controlP5.Controller : Label getCaptionLabel() 
 controlP5.Controller : Label getValueLabel() 
 controlP5.Controller : List getControllerPlugList() 
 controlP5.Controller : PImage setImage(PImage) 
 controlP5.Controller : PImage setImage(PImage, int) 
 controlP5.Controller : PVector getAbsolutePosition() 
 controlP5.Controller : PVector getPosition() 
 controlP5.Controller : String getAddress() 
 controlP5.Controller : String getInfo() 
 controlP5.Controller : String getName() 
 controlP5.Controller : String getStringValue() 
 controlP5.Controller : String toString() 
 controlP5.Controller : Tab getTab() 
 controlP5.Controller : boolean isActive() 
 controlP5.Controller : boolean isBroadcast() 
 controlP5.Controller : boolean isInside() 
 controlP5.Controller : boolean isLabelVisible() 
 controlP5.Controller : boolean isListening() 
 controlP5.Controller : boolean isLock() 
 controlP5.Controller : boolean isMouseOver() 
 controlP5.Controller : boolean isMousePressed() 
 controlP5.Controller : boolean isMoveable() 
 controlP5.Controller : boolean isUpdate() 
 controlP5.Controller : boolean isVisible() 
 controlP5.Controller : float getArrayValue(int) 
 controlP5.Controller : float getDefaultValue() 
 controlP5.Controller : float getMax() 
 controlP5.Controller : float getMin() 
 controlP5.Controller : float getValue() 
 controlP5.Controller : float[] getArrayValue() 
 controlP5.Controller : int getDecimalPrecision() 
 controlP5.Controller : int getHeight() 
 controlP5.Controller : int getId() 
 controlP5.Controller : int getWidth() 
 controlP5.Controller : int listenerSize() 
 controlP5.Controller : void remove() 
 controlP5.Controller : void setView(ControllerView, int) 
 java.lang.Object : String toString() 
 java.lang.Object : boolean equals(Object) 
 
 
 */
