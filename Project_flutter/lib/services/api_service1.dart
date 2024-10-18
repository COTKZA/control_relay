import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/data_model.dart';

class ApiService1 {
  Future<List<DataModel>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1/control_relay/api/api_data/moisture_data1_api.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => DataModel.fromJson(data))
          .toList()
          .take(10)
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
