import 'dart:convert';
import 'package:cargoproai/app/data/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('createObject parses response', () async {
    final mock = MockClient((req) async {
      expect(req.method, 'POST');
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      expect(body['name'], 'Test');
      return http.Response(
          jsonEncode({
            'id': 'abc123',
            'name': 'Test',
            'data': {'a': 1}
          }),
          200);
    });
    final api = ApiService(client: mock);
    final obj = await api.createObject('Test', {'a': 1});
    expect(obj.id, 'abc123');
  });
}
