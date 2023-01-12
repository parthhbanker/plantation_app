import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<List<dynamic>> fetchApiData({required String url}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    }
    return jsonDecode(response.body);
  }

  static Future<bool> postApiData(
      {required String url, required Map<dynamic, dynamic> body}) async {
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
