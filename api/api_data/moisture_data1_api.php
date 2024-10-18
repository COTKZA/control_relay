<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// Include the database connection
include './../config.php';
// Prepare the SQL query to get all records from the esp32_data table
$sql = "SELECT * FROM moisture_data1 ORDER BY date DESC, time DESC";
$result = $conn->query($sql);

// Check if there are results
if ($result->num_rows > 0) {
    $data = array(); // Initialize an array to store the data

    // Fetch each row and add it to the data array
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    // Output the data in JSON format
    echo json_encode($data);
} else {
    // If no data is found, return an empty array
    echo json_encode([]);
}

// Close the database connection
$conn->close();
?>
