import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3001/api';
  static String? token;

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
  }

  static Future<void> saveToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', newToken);
  }

  static Future<void> clearToken() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static Map<String, String> get _headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint) async {
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final Map<String, String> requestHeaders = Map.from(_headers);
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: requestHeaders,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    return await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
  }

  // Specific method for AI Scanner HF API
  static Future<http.Response> uploadImageForScan(String filePath) async {
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('https://kifliii-api-manajemen-tpa.hf.space/predict-cnn')
    );
    
    request.headers.addAll({
      'accept': 'application/json',
      // MultipartRequest automatically sets the boundary for Content-Type
    });
    
    request.files.add(await http.MultipartFile.fromPath(
      'file', 
      filePath,
      filename: 'image_scan.jpg',
      contentType: MediaType('image', 'jpeg'),
    ));
    
    var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
    return await http.Response.fromStream(streamedResponse);
  }
}
