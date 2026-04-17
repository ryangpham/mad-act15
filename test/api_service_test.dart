import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:madact15/api_service.dart';

void main() {
  test('fetchQuestions returns parsed trivia questions', () async {
    final service = ApiService(
      client: MockClient((http.Request request) async {
        expect(request.url.host, 'opentdb.com');
        expect(request.url.path, '/api.php');
        expect(request.url.queryParameters, {
          'amount': '10',
          'category': '9',
          'difficulty': 'easy',
          'type': 'multiple',
        });

        return http.Response('''
          {
            "response_code": 0,
            "results": [
              {
                "question": "What is the capital of France?",
                "correct_answer": "Paris",
                "incorrect_answers": ["London", "Berlin", "Madrid"]
              }
            ]
          }
          ''', 200);
      }),
    );

    final questions = await service.fetchQuestions();

    expect(questions, hasLength(1));
    expect(questions.first.question, 'What is the capital of France?');
    expect(questions.first.correctAnswer, 'Paris');
    expect(questions.first.options, hasLength(4));
    expect(questions.first.options.toSet(), {
      'Paris',
      'London',
      'Berlin',
      'Madrid',
    });
  });

  test('fetchQuestions throws when the request fails', () async {
    final service = ApiService(
      client: MockClient((_) async => http.Response('Server error', 500)),
    );

    await expectLater(service.fetchQuestions(), throwsException);
  });

  test(
    'fetchQuestions throws when the trivia API returns an error code',
    () async {
      final service = ApiService(
        client: MockClient(
          (_) async =>
              http.Response('{"response_code": 1, "results": []}', 200),
        ),
      );

      await expectLater(service.fetchQuestions(), throwsException);
    },
  );
}
