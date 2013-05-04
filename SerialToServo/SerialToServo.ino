// http://enajet.air-nifty.com/blog/2012/01/arduino-proce-1.html
#include <LiquidCrystal.h>
#include<Servo.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
Servo servo0;
int target0 = 0;
int current0 = 0;
Servo servo1;
int target1 = 0;
int current1 = 0;
Servo servo2;
int target2 = 0;
int current2 = 0;
Servo servo3;
int target3 = 0;
int current3 = 0;
int ledZutto = 14;
int led = 15;
int ledCount = 0;

const int switchPin = 16;
int switchState = 0;

const int potentiometerPin = 17;
int potentiometerValue = 0;

const int buttonPin = 18;
int buttonState = 0;

Servo servo4;
int target4 = 0;
int current4 = 0;
Servo servo5;
int target5 = 0;
int current5 = 0;

String serialRead;

void setup() {
  lcd.begin(16, 2);
  // 115200Baudで通信します。
  Serial.begin(115200);
  servo0.attach(6);
  servo1.attach(7);
  servo2.attach(8);
  servo3.attach(9);
  servo4.attach(10);
  servo5.attach(13);
  pinMode(ledZutto, OUTPUT);
  pinMode(led, OUTPUT);
  digitalWrite(ledZutto, HIGH);
  pinMode(switchPin, INPUT);
  pinMode(buttonPin, INPUT);
}

void loop() {
  lcd.clear();
  lcd.print(millis()/1000);
  // Button
  buttonState = digitalRead(buttonPin);
  lcd.print(",b");
  lcd.print(buttonState);
  // switch
  //switchState = digitalRead(switchPin);
  //lcd.setCursor(1, 0);
  lcd.print(",s");
  lcd.print(switchState);
  // sensor
  //lcd.setCursor(3, 0);
  lcd.print(",p");
  lcd.print(potentiometerValue);
  
  // シリアル受信した文字列がある場合は
  // LCDの書き込み開始位置を二行目に指定します。
  if(Serial.available() > -1){
    lcd.setCursor(0, 1);
  }
  
  switchState = digitalRead(switchPin);
  if(switchState == LOW){
    setSerialRead2Position();
  }else{
    potentiometerValue = analogRead(potentiometerPin);
    target0 = potentiometerValue*0.176;
    target5 = target4 = target3 = target2 = target1 = target0;
  }
  
  if(ledCount > 1){
    ledCount --;
    digitalWrite(led, HIGH);
  }else{
    digitalWrite(led, LOW);
  }
  
  moveServo(servo0,target0,current0);
  moveServo(servo1,target1,current1);
  moveServo(servo2,target2,current2);
  moveServo(servo3,target3,current3);
  moveServo(servo4,target4,current4);
  moveServo(servo5,target5,current5);
  
  delay(20);
}

void setSerialRead2Position(){
  // シリアル受信した文字列がある間は繰り返し処理をします。
  serialRead = "";
  while (Serial.available()) {
    serialRead +=char(Serial.read());
  }

  if(serialRead.indexOf("\n")+1 == serialRead.length()){
    strPerser(serialRead);
  }
}

void strPerser(String str){
  if(str.length() < 3){
    //digitalWrite(led, LOW);
    return;
  }
  ledCount = 60;
  //digitalWrite(led, HIGH);

  int i = 0;
  String s;
  
  str.concat(",");
  
  while (str.indexOf(",") > 3) {
    s = str.substring(0, str.indexOf(","));
    keyToServo(s);
    str.replace(s + ",", "");
    i ++;
  }
  
//  lcd.setCursor(10, 0);
//  lcd.print("len:");
//  lcd.print(i);
}

void keyToServo(String& key){
    if(key.startsWith("0rh:")){
      target0 = String(key.substring(key.indexOf(':') + 1)).toInt();
    }else if(key.startsWith("0bd:")){
      target1 = String(key.substring(key.indexOf(':') + 1)).toInt();
    }else if(key.startsWith("0lh:")){
      target2 = String(key.substring(key.indexOf(':') + 1)).toInt();
    }else if(key.startsWith("1rh:")){
      target3 = String(key.substring(key.indexOf(':') + 1)).toInt();
    }else if(key.startsWith("1bd:")){
      target4 = String(key.substring(key.indexOf(':') + 1)).toInt();
    }else if(key.startsWith("1lh:")){
      target5 = String(key.substring(key.indexOf(':') + 1)).toInt();
    }
}

void moveServo(Servo& servo, int& target, int& current){
  //current = (current*0.9+target*0.1);
  current = (current*0.8+target*0.2);
  //current = target;
  servo.write(current);
  lcd.print(current);
  lcd.print(",");
}
