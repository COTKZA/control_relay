import 'dart:async';
import 'package:flutter/material.dart';
import '../models/data_model.dart';
import '../services/api_service1.dart';
import 'detail_screen.dart'; // Import the DetailScreen

class DataListScreen extends StatefulWidget {
  @override
  _DataListScreenState createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  late Future<List<DataModel>> dataList;
  final ApiService1 apiService = ApiService1();
  late Timer _timer;
  List<DataModel> _existingData = []; // เก็บข้อมูลที่มีอยู่แล้ว

  @override
  void initState() {
    super.initState();
    fetchData(); // Initial data fetch
    _startTimer(); // Start the periodic fetch timer
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void fetchData() async {
    List<DataModel> newData = await apiService.fetchData(); // ดึงข้อมูลใหม่

    setState(() {
      // ตรวจสอบข้อมูลใหม่และเพิ่มเข้าไปใน _existingData
      for (var item in newData) {
        if (!_existingData.any((existing) => existing.id == item.id)) {
          _existingData.insert(0, item); // เพิ่มข้อมูลใหม่ที่ไม่ซ้ำกัน
        }
      }
      // เก็บข้อมูลไว้เพียง 10 รายการล่าสุด
      if (_existingData.length > 10) {
        _existingData = _existingData.sublist(0, 10);
      }
      dataList = Future.value(_existingData); // อัปเดต future ด้วยข้อมูลใหม่
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData(); // Fetch data every 10 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Data 1'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<DataModel>>(
        future: dataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.cloud, color: Colors.blueAccent),
                    title: Text(
                      'ID: ${item.id}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Date: ${item.date}',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          'Time: ${item.time}',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          'Humidity: ${item.humidity}',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          'Relay: ${item.relay}',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to DetailScreen and pass the data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            dataId: item.id,
                            date: item.date,
                            time: item.time,
                            humidity: item.humidity,
                            relay: item.relay,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
