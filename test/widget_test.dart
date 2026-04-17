import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:madact15/api_service.dart';
import 'package:madact15/question.dart';
import 'package:madact15/quiz_screen.dart';

class FakeApiService extends ApiService {
  FakeApiService(this.questions);

  final List<Question> questions;

  @override
  Future<List<Question>> fetchQuestions() async => questions;
}

void main() {
  testWidgets('Quiz screen shows fetched question data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuizScreen(
          apiService: FakeApiService([
            const Question(
              question: 'What is the capital of France?',
              correctAnswer: 'Paris',
              options: ['Paris', 'London', 'Berlin', 'Madrid'],
            ),
          ]),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('Trivia Quiz'), findsOneWidget);
    expect(find.text('Question 1 of 1'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('What is the capital of France?'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
  });
}
