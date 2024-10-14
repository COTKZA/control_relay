import 'dart:async';
import 'package:flutter/material.dart';
import '../models/data_model.dart';
import '../services/api_service.dart';

class DataListRealtimeScreen extends StatefulWidget {
  @override
  _DataListRealtimeScreenState createState() => _DataListRealtimeScreenState();
}

class _DataListRealtimeScreenState extends State<DataListRealtimeScreen> {
  late Future<List<DataModel>> dataList;
  final ApiService apiService = ApiService();
  late Timer _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    fetchData(); // Initial fetch
    // Set up periodic fetching every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
  }

  Future<void> fetchData() async {
    setState(() {
      dataList = apiService.fetchData(); // Fetch data from API
    });
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
        title: Text('Real-time Data'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<DataModel>>(
        future: dataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final latestData = snapshot.data!.first; // Get the latest data

            return Center(
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
                              'Latest Humidity: ${latestData.humidity}%',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${latestData.date}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'Time: ${latestData.time}',
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
                    RelayStatusWidget(relay: latestData.relay),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
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
