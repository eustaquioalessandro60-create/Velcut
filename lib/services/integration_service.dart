import 'dart:convert';
import 'package:http/http.dart' as http;

class IntegrationService {
  // Backend endpoint to store/retrieve API keys and create jobs
  // Configure SERVER_BASE in environment or use local default
  static const String _serverBase = String.fromEnvironment('SERVER_BASE', defaultValue: 'http://localhost:4000');

  static Future<bool> saveApiKey(String provider, String apiKey, String adminToken) async {
    final uri = Uri.parse('$_serverBase/api/keys');
    final res = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminToken'
        },
        body: jsonEncode({'provider': provider, 'key': apiKey}));
    return res.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> getApiKeys(String adminToken) async {
    final uri = Uri.parse('$_serverBase/api/keys');
    final res = await http.get(uri, headers: {'Authorization': 'Bearer $adminToken'});
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  static Future<Map<String, dynamic>> createJob(String provider, String type, Map<String, dynamic> payload, String adminToken) async {
    final uri = Uri.parse('$_serverBase/api/generate');
    final res = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminToken'
        },
        body: jsonEncode({'provider': provider, 'type': type, 'payload': payload}));
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Job creation failed: ${res.statusCode}');
  }
}
