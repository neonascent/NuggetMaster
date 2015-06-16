// include the library code:
#include <LiquidCrystal.h>
#include <Servo.h>

#define numberOfModes 6
// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);



long pos = 0;
int mode = 0;
bool buttonPressed = false;

bool actionBlip = false;

String names[numberOfModes] = {"Shoulder Twist", "Shoulder Bend", "Elbow Bend", "Wrist Angle", "Wrist Bend", "Hand Open"};
int parameters[numberOfModes] = {90, 90, 90, 90, 90, 90};
int parametersMin[numberOfModes] = {0, 0, 0, 0, 0, 0};
int parametersMax[numberOfModes] = {180, 180, 180, 180, 180, 180};
int parametersInc[numberOfModes] = {10, 10, 10, 10, 10, 10};
int servoPins[6] = {1,2,3,11,12,13};
Servo servo[6];

void setup() {
  for (int i = 0; i < 6; i++) {
    servo[i].attach(servoPins[i]);
    servo[i].write(parameters[i]);
  }
  

  //delay(1000);
  //Serial.println("M45");
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.setCursor(0, 0);
  lcd.print("NuggetMaster");

  // put your setup code here, to run once:
  //Serial.begin(9600);
  //initialize();
}

void initialize() {
  setTitle("Initializing");
  delay(1000);
  //Serial.println("X");
  //out("S0");
 // delay(1000);
 // out("P0");
 // delay(1000);
//  pos = 0;
}

void loop() {

  
  
   //move servo
   //setTitle("Initializing");
   servo[mode].write(parameters[mode]);
   responsiveDelay(1000);
}

bool checkInput() {
  int x;
  x = analogRead (0);
  lcd.setCursor(10, 1);

  if (!buttonPressed) {
    if (x < 60) {
      mode++;
    }
    else if (x < 200) {
      parameters[mode] += parametersInc[mode];
    }
    else if (x < 400) {
      parameters[mode] -= parametersInc[mode];
    }
    else if (x < 600) {
      mode--;
    }
    else if (x < 800) {
      initialize();
    } else {
      return false; 
    }
  } else {
    if (x > 1000) {
      buttonPressed = false;
    }
    return false;
  }

  buttonPressed = true;

  if (mode > numberOfModes - 1) mode = 0;
  if (mode < 0) mode = numberOfModes - 1;
  if (parameters[mode] > parametersMax[mode]) parameters[mode] = parametersMax[mode];
  if (parameters[mode] < parametersMin[mode]) parameters[mode] = parametersMin[mode];

  return true;
}

void bluetooth() {
  String readString;
  while (1) {
    while (Serial.available()) {
      delay(3);  //delay to allow buffer to fill
      if (Serial.available() > 0) {
        char c = Serial.read();  //gets one byte from serial buffer
        readString += c; //makes the string readString
      }
    }

    if (readString.length() > 0) {
      out(readString);
    }

    if (checkInput()) {
      setTitle(names[mode]);
      setParameter((String)parameters[mode]);
      break;
    }

  }
}

void setTitle(String s) {
  lcd.setCursor(0, 0);
  lcd.print(s + "           ");
}

void setParameter(String s) {
  lcd.setCursor(12, 1);
  lcd.print(s + "   ");
}

void out(String s) {
  Serial.println(s);
  lcd.setCursor(0, 1);
  lcd.print(s);

  // action blip
  if (actionBlip) {
    lcd.print(".");
  } else {
    lcd.print(" ");
  }
  actionBlip = !actionBlip;

  for (int i = s.length(); i < 11; i++) {
    lcd.print(" ");
  }
}

void responsiveDelay(int time) {
  for (int i = 0; i < time; i += 22) {
    if (checkInput()) {
      setTitle(names[mode]);
      setParameter((String)parameters[mode]);
      break;
    }
    delay(20);
  }
}
