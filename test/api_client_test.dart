import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  const sample = {
    'id': '7d1f6c0e-0000-0000-0000-000000000001',
    'title': 'Portfolio',
    'description': 'Web portofolio Django',
    'tech_stack': 'Django',
    'project_url': 'https://example.com',
    'project_image_url': '',
    'star_count': 3,
    'is_starred': false,
    'starred_by_names': <String>[],
  };

  test('getProjects mengubah JSON array menjadi List<Project>', () async {
    final client = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        expect(request.url.toString(), 'http://test/api/v1/projects/');
        return http.Response(jsonEncode([sample]), 200);
      }),
    );

    final projects = await client.getProjects();
    expect(projects, hasLength(1));
    expect(projects.first.techStack, 'Django');
    expect(projects.first.id, sample['id']);
  });

  test('createProject mengirim token dan tidak mengirim id', () async {
    final client = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        expect(request.headers['Authorization'], 'Token abc');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body.containsKey('id'), isFalse);
        expect(body['project_url'], 'https://example.com');
        return http.Response(jsonEncode(sample), 201);
      }),
    );

    final created = await client.createProject(
      const Project(
        title: 'Portfolio',
        description: 'Web portofolio Django',
        techStack: 'Django',
        projectUrl: 'https://example.com',
      ),
      token: 'abc',
    );
    expect(created.id, sample['id']);
  });

  test('status non-2xx melempar ApiException', () async {
    final client = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => http.Response('nope', 400)),
    );

    expect(
      () => client.obtainToken('u', 'p'),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'code', 400)),
    );
  });

  test(
    'AuthState login lalu logout tetap menghapus token saat error',
    () async {
      final client = ApiClient(
        baseUrl: 'http://test',
        client: MockClient((request) async {
          if (request.url.path == '/api/v1/auth/token/') {
            return http.Response(jsonEncode({'token': 'abc'}), 200);
          }
          return http.Response('invalid token', 401);
        }),
      );
      final auth = AuthState(client);

      await auth.login('admin', 'secret');
      expect(auth.token, 'abc');
      expect(auth.isLoggedIn, isTrue);

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    },
  );
}
