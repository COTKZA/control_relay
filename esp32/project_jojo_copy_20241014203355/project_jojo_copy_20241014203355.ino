#include <WiFi.h>
#include <HTTPClient.h> // นำเข้าห้องสมุด HTTPClient

// ตั้งค่าการเชื่อมต่อ WiFi
const char* ssid = "cotkza";
const char* password = "12345678";

// กำหนดขาเชื่อมต่อของเซ็นเซอร์ MQ-2
const int mq2Pin1 = 34; // เซ็นเซอร์ตัวที่ 1
const int mq2Pin2 = 35; // เซ็นเซอร์ตัวที่ 2

// กำหนดขาเชื่อมต่อของรีเลย์
const int relayPin1 = 26; // รีเลย์ตัวที่ 1
const int relayPin2 = 27; // รีเลย์ตัวที่ 2

void setup() {
  // เริ่มการสื่อสาร Serial Monitor
  Serial.begin(115200);
  
  // เชื่อมต่อ WiFi
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  // กำหนดขารีเลย์เป็น OUTPUT
  pinMode(relayPin1, OUTPUT);
  pinMode(relayPin2, OUTPUT);
  
  // ปิดรีเลย์เริ่มต้น
  digitalWrite(relayPin1, LOW);
  digitalWrite(relayPin2, LOW);
}

void loop() {
  // อ่านค่าจากเซ็นเซอร์ MQ-2
  int sensorValue1 = analogRead(mq2Pin1);
  int sensorValue2 = analogRead(mq2Pin2);
  
  // แปลงค่า Analog ให้เป็นค่าความเข้มของก๊าซ
  Serial.print("Sensor Value 1: ");
  Serial.println(sensorValue1);
  Serial.print("Sensor Value 2: ");
  Serial.println(sensorValue2);
  
  // ควบคุมรีเลย์ตามค่าจากเซ็นเซอร์ตัวที่ 1
  String relayState1 = "OFF"; // เริ่มต้นรีเลย์ 1 เป็น OFF
  if (sensorValue1 < 3000) {
    // เปิดรีเลย์ 1
    digitalWrite(relayPin1, HIGH);
    relayState1 = "ON"; // เปลี่ยนสถานะรีเลย์ 1 เป็น ON
    Serial.println("Relay 1 ON");
  } else {
    // ปิดรีเลย์ 1
    digitalWrite(relayPin1, LOW);
    relayState1 = "OFF"; // เปลี่ยนสถานะรีเลย์ 1 เป็น OFF
    Serial.println("Relay 1 OFF");
  }

  // ควบคุมรีเลย์ตามค่าจากเซ็นเซอร์ตัวที่ 2
  String relayState2 = "OFF"; // เริ่มต้นรีเลย์ 2 เป็น OFF
  if (sensorValue2 < 3000) {
    // เปิดรีเลย์ 2
    digitalWrite(relayPin2, HIGH);
    relayState2 = "ON"; // เปลี่ยนสถานะรีเลย์ 2 เป็น ON
    Serial.println("Relay 2 ON");
  } else {
    // ปิดรีเลย์ 2
    digitalWrite(relayPin2, LOW);
    relayState2 = "OFF"; // เปลี่ยนสถานะรีเลย์ 2 เป็น OFF
    Serial.println("Relay 2 OFF");
  }

  // ส่งค่าที่อ่านได้ไปยัง PHP
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.100.165/control_relay/api/save_data.php"); // เปลี่ยนให้เป็นที่อยู่ของเซิร์ฟเวอร์ PHP
    http.addHeader("Content-Type", "application/x-www-form-urlencoded");

    // สร้าง payload สำหรับส่ง
    String payload = "humidity1=" + String(sensorValue1) + "&relay1=" + relayState1 +
                     "&humidity2=" + String(sensorValue2) + "&relay2=" + relayState2;
    
    // ส่ง POST request
    int httpResponseCode = http.POST(payload);
    
    // ตรวจสอบผลลัพธ์
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode); // แสดงรหัส HTTP
      Serial.println(response); // แสดงผลลัพธ์จาก PHP
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
    
    // ปิดการเชื่อมต่อ HTTP
    http.end();
  }

  // รอเวลา 5 วินาทีก่อนอ่านค่าครั้งถัดไป
  delay(1000);
}
