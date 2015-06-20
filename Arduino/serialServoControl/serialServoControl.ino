// include the library code:
#include <Servo.h>

int servoPins[6] = {2, 3, 4, 11, 12, 13};
Servo servo[6];
int relayPin = 8;

void setup() {
  for (int i = 0; i < 6; i++) {
    servo[i].attach(servoPins[i]);
  }
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW);
  Serial.begin(19200);
  Serial.println("Ready");
}


void loop() {

  static int v = 0;

  if ( Serial.available()) {
    char ch = Serial.read();

    switch (ch) {
      case '0'...'9':
        v = v * 10 + ch - '0';
        break;
      case 'z':
        servoWrite(0, v);
        v = 0;
        break;
      case 'x':
        servoWrite(1, v);
        v = 0;
        break;
      case 'a':
        servoWrite(2, v);
        v = 0;
        break;
      case 's':
        servoWrite(3, v);
        v = 0;
        break;
      case 'q':
        servoWrite(4, v);
        v = 0;
        break;
      case 'w':
        servoWrite(5, v);
        v = 0;
        break;
      case 'n':
        relay(HIGH);
        break;
      case 'f':
        relay(LOW);
        break;
      case '>':
        delay(500);
        break;
    }
  }

}

void relay(int status) {
  digitalWrite(relayPin, status);
}

void servoWrite(int s, int v) {
  servo[s].write(v);
  Serial.print(s);
  Serial.print(":");
  Serial.println(v);
  //delay(50);
}
