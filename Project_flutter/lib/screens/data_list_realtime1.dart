import 'dart:async';
import 'package:flutter/material.dart';
import '../models/data_model.dart';
import '../services/api_service1.dart';

class DataListRealtimeScreen1 extends StatefulWidget {
  @override
  _DataListRealtimeScreenState1 createState() =>
      _DataListRealtimeScreenState1();
}

class _DataListRealtimeScreenState1 extends State<DataListRealtimeScreen1> {
  DataModel? latestData; // Store the latest data
  final ApiService1 apiService = ApiService1();
  late Timer _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    fetchData(); // Initial fetch
    // Set up periodic fetching every 1 second
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
  }

  Future<void> fetchData() async {
    try {
      // Fetch data from API
      List<DataModel> fetchedData = await apiService.fetchData();
      if (fetchedData.isNotEmpty) {
        DataModel newData = fetchedData.first; // Get the latest data
        // Update state only if the new data is different
        if (latestData == null ||
            latestData!.date != newData.date ||
            latestData!.time != newData.time) {
          setState(() {
            latestData = newData; // Update latestData
          });
        }
      }
    } catch (e) {
      // Handle error if needed
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Soil Moisture Sensor 1'),
        backgroundColor: Colors.blueAccent,
      ),
      body: latestData != null
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display humidity
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latest Humidity: ${latestData!.humidity}%',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${latestData!.date}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'Time: ${latestData!.time}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 20), // Space between humidity and relay status

                    // Display relay status
                    RelayStatusWidget(relay: latestData!.relay),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class RelayStatusWidget extends StatelessWidget {
  final String relay;

  const RelayStatusWidget({required this.relay});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Relay Status: $relay',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: relay == 'ON' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
