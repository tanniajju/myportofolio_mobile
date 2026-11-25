import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// ApiClient palsu: tidak memanggil jaringan sungguhan.
ApiClient fakeApiClient() {
  return ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async {
      final path = request.url.path;
      if (path == '/api/v1/auth/token/') {
        return http.Response(jsonEncode({'token': 'test-token'}), 200);
      }
      if (path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }
      if (path == '/api/v1/projects/' && request.method == 'GET') {
        return http.Response('[]', 200);
      }
      if (path == '/api/v1/projects/' && request.method == 'POST') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'id': 'uuid-1', ...body}), 201);
      }
      return http.Response('Not found', 404);
    }),
  );
}

/// Membungkus [child] dengan provider yang dibutuhkan layar-layar aplikasi.
Widget wrapWithProviders(Widget child, {String? token}) {
  final apiClient = fakeApiClient();
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: apiClient),
      ChangeNotifierProvider(
        create: (_) => AuthState(apiClient, initialToken: token),
      ),
    ],
    child: MaterialApp(home: child),
  );
}
