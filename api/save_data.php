<?php
include 'config.php';

// รับค่าจาก ESP32 ผ่านการส่งข้อมูลแบบ POST
$humidity = isset($_POST['humidity']) ? intval($_POST['humidity']) : 0;
$relay = isset($_POST['relay']) ? $_POST['relay'] : 'OFF'; // ค่ารีเลย์ (ON/OFF)

// หาค่าวันที่และเวลา
$date = date("Y-m-d");
$time = date("H:i:s");

// สร้างคำสั่ง SQL สำหรับการบันทึกข้อมูล
$sql = "INSERT INTO moisture_data (date, time, humidity, relay) VALUES ('$date', '$time', $humidity, '$relay')";

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// ปิดการเชื่อมต่อ
$conn->close();
?>
