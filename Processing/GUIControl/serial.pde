
int lf = 10;    // Linefeed in ASCII
String myString = null;

void sendCommand(String s) {
  String commandLine = s;
  println(commandLine);
  actions += s+"\r\n";
  actionRecord.setText(actions);
  myPort.write(commandLine);
}

void setServo(String s, int v) {
  String commandLine = v + s;
  println(commandLine);
  myPort.write(commandLine);

}

void sendChar(String s) {
  myPort.write(s);
}

