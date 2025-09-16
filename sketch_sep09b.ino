int leftSensor = A0;
int rightSensor = A1;

void setup(){
  Serial.begin(9600);
}

void loop(){
  int leftVal = analogRead(leftSensor);
  int rightVal = analogRead(rightSensor);
  
  Serial.print(leftVal);
  Serial.print(",");
  Serial.println(rightVal);
  delay(20);
}
