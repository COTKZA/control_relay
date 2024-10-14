class DataModel {
  final String id;
  final String date;
  final String time;
  final String humidity;
  final String relay;

  DataModel({
    required this.id,
    required this.date,
    required this.time,
    required this.humidity,
    required this.relay,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      humidity: json['humidity'],
      relay: json['relay'],
    );
  }
}
