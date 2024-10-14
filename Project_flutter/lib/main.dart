import 'package:flutter/material.dart';
import 'screens/data_list_screen.dart';
import 'screens/data_list_realtime.dart'; // Import the new screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to DataListScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Background color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Shadow elevation
              ),
              child: Text(
                'View Data List',
                style: TextStyle(
                  fontSize: 20, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to DataListRealtimeScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataListRealtimeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color for the new button
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Shadow elevation
              ),
              child: Text(
                'View Real-time Data',
                style: TextStyle(
                  fontSize: 20, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
