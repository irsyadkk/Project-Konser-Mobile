import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_tpm/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseNetwork {
  static const String baseUrl =
      'https://api-konser-559917148272.us-central1.run.app/';

  //LOGIN
  static Future<User> loginUser(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(baseUrl + endpoint),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final accessToken = body['accessToken'];
      final user = body['safeUserData'];
      if (accessToken != null && user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setInt('user_id', user['id']);
        await prefs.setString('user_email', user['email']);
        await prefs.setInt('user_umur', user['umur']);
        await prefs.setString('user_nama', user['nama']);
        return User.fromJson(user, accessToken);
      } else {
        throw Exception("Token atau data tidak ada...${response.statusCode}");
      }
    } else {
      throw Exception("Failed to login...${response.statusCode}");
    }
  }

  //LOGOUT
  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  //GET
  static Future<List<dynamic>> getData(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(Uri.parse(baseUrl + endpoint), headers: {
      'content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load data...${response.statusCode}');
    }
  }

  //DETAIL
  static Future<Map<String, dynamic>> getDetailData(
      String endpoint, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response =
        await http.get(Uri.parse('$baseUrl$endpoint/$id'), headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load detail data...${response.statusCode}');
    }
  }

  //REGIS
  static Future<bool> regisUser(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Failed to register user...${response.statusCode}");
    }
  }

  //ORDER
  static Future<bool> order(
      String endpoint, Map<String, dynamic> data, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.patch(Uri.parse('$baseUrl$endpoint/$id'),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to make order...${response.statusCode}");
    }
  }
}
