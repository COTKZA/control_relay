<?php
include 'config.php';

// ตั้งค่าเขตเวลาประเทศไทย
date_default_timezone_set('Asia/Bangkok');

// รับค่าจาก ESP32 ผ่านการส่งข้อมูลแบบ POST
$humidity1 = isset($_POST['humidity1']) ? intval($_POST['humidity1']) : 0;
$relay1 = isset($_POST['relay1']) ? $_POST['relay1'] : 'OFF'; // ค่ารีเลย์ 1
$humidity2 = isset($_POST['humidity2']) ? intval($_POST['humidity2']) : 0;
$relay2 = isset($_POST['relay2']) ? $_POST['relay2'] : 'OFF'; // ค่ารีเลย์ 2

// หาค่าวันที่และเวลา
$date = date("Y-m-d");
$time = date("H:i:s");

// สร้างคำสั่ง SQL สำหรับการบันทึกข้อมูลลงใน moisture_data1
$sql1 = "INSERT INTO moisture_data1 (date, time, humidity, relay) VALUES ('$date', '$time', $humidity1, '$relay1')";

// สร้างคำสั่ง SQL สำหรับการบันทึกข้อมูลลงใน moisture_data2
$sql2 = "INSERT INTO moisture_data2 (date, time, humidity, relay) VALUES ('$date', '$time', $humidity2, '$relay2')";

if ($conn->query($sql1) === TRUE && $conn->query($sql2) === TRUE) {
    echo "สร้างบันทึกใหม่สำเร็จใน humid_data1 และ humid_data2";
} else {
    echo "Error: " . $sql1 . "<br>" . $conn->error;
    echo "Error: " . $sql2 . "<br>" . $conn->error;
}

// ปิดการเชื่อมต่อ
$conn->close();
?>
