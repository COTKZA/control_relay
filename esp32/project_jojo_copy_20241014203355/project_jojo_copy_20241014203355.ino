#include <WiFi.h>
#include <HTTPClient.h> // นำเข้าห้องสมุด HTTPClient

// ตั้งค่าการเชื่อมต่อ WiFi
const char* ssid = "cotkza";
const char* password = "12345678";

// กำหนดขาเชื่อมต่อของเซ็นเซอร์ MQ-2
const int mq2Pin = 34; // ใช้ขา ADC ของ ESP32

// กำหนดขาเชื่อมต่อของรีเลย์
const int relayPin = 26; // เปลี่ยนขานี้ตามต้องการ

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
  pinMode(relayPin, OUTPUT);
  // ปิดรีเลย์เริ่มต้น
  digitalWrite(relayPin, LOW);
}

void loop() {
  // อ่านค่าจากเซ็นเซอร์ MQ-2
  int sensorValue = analogRead(mq2Pin);
  
  // แปลงค่า Analog ให้เป็นค่าความเข้มของก๊าซ
  Serial.print("Sensor Value: ");
  Serial.println(sensorValue);
  
  // ควบคุมรีเลย์ตามค่าจากเซ็นเซอร์
  String relayState = "OFF"; // เริ่มต้นรีเลย์เป็น OFF
  if (sensorValue < 2000) {
    // เปิดรีเลย์
    digitalWrite(relayPin, HIGH);
    relayState = "ON"; // เปลี่ยนสถานะรีเลย์เป็น ON
    Serial.println("Relay ON");
  } else if (sensorValue > 3000) {
    // ปิดรีเลย์
    digitalWrite(relayPin, LOW);
    relayState = "OFF"; // เปลี่ยนสถานะรีเลย์เป็น OFF
    Serial.println("Relay OFF");
  }

  // ส่งค่าที่อ่านได้ไปยัง PHP
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.100.110/control_relay/api/save_data.php"); // เปลี่ยนให้เป็นที่อยู่ของเซิร์ฟเวอร์ PHP
    http.addHeader("Content-Type", "application/x-www-form-urlencoded");

    // สร้าง payload สำหรับส่ง
    String payload = "humidity=" + String(sensorValue) + "&relay=" + relayState;
    
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

  // รอเวลา 2 วินาทีก่อนอ่านค่าครั้งถัดไป
  delay(5000);
}
