import 'dart:convert';

import 'package:http/http.dart' as http;

import 'question.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _host = 'opentdb.com';
  static const String _path = '/api.php';

  final http.Client _client;

  Future<List<Question>> fetchQuestions() async {
    final uri = Uri.https(_host, _path, {
      'amount': '10',
      'category': '9',
      'difficulty': 'easy',
      'type': 'multiple',
    });

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load questions: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final responseCode = data['response_code'] as int?;

    if (responseCode != null && responseCode != 0) {
      throw Exception('Trivia API returned response_code $responseCode');
    }

    final results = data['results'] as List<dynamic>;

    return results
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
