import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/object_model.dart';

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();
  static const String baseUrl = 'https://api.restful-api.dev/objects';

  Future<List<ObjectModel>> fetchObjects({int page = 1, int limit = 12}) async {
    final uri = Uri.parse('$baseUrl?page=$page&limit=$limit');
    final res = await client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      final list = decoded is List ? decoded : (decoded is Map && decoded['data'] is List ? decoded['data'] : []);
      return (list as List).map<ObjectModel>((e) => ObjectModel.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch: ${res.statusCode} ${res.body}');
  }

  Future<ObjectModel> fetchDetail(String id) async {
    final res = await client.get(Uri.parse('$baseUrl/$id'), headers: {'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ObjectModel.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed detail: ${res.statusCode} ${res.body}');
  }

  Future<ObjectModel> createObject(String name, Map<String, dynamic> data) async {
    final res = await client.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'data': data}));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ObjectModel.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed create: ${res.statusCode} ${res.body}');
  }

  Future<ObjectModel> updateObject(String id, String name, Map<String, dynamic> data) async {
    final res = await client.put(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'data': data}));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ObjectModel.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed update: ${res.statusCode} ${res.body}');
  }

  Future<void> deleteObject(String id) async {
    final res = await client.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    throw Exception('Failed delete: ${res.statusCode} ${res.body}');
  }
}
