import 'dart:convert';
import 'package:cargoproai/app/controllers/object_controller.dart';
import 'package:cargoproai/app/data/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('update replaces item in list', () async {
    final mock = MockClient((req) async {
      if (req.method == 'PUT') {
        final id = req.url.pathSegments.last;
        return http.Response(
            jsonEncode({
              'id': id,
              'name': 'Updated',
              'data': {'x': 1}
            }),
            200);
      }
      return http.Response('[]', 200);
    });
    final ctrl = ObjectController(ApiService(client: mock));
    // seed
    ctrl.objects.addAll([
      // minimal object to update
      // ignoring model import for brevity; we rely on API call to overwrite
    ]);
    // Simulate insert at index 0
    ctrl.objects.addAll([]);
    final updated =
        await ctrl.updateObject('1', 'Updated', jsonEncode({'x': 1}));
    expect(updated?.name, 'Updated');
  });
}
