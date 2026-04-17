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
    expect(find.text('Restart Quiz'), findsOneWidget);
  });

  testWidgets('Quiz flow updates score and can restart', (
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
            const Question(
              question: 'What color is the sky on a clear day?',
              correctAnswer: 'Blue',
              options: ['Green', 'Blue', 'Red', 'Yellow'],
            ),
          ]),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.text('Paris'));
    await tester.pump();

    expect(find.text('Score: 1'), findsOneWidget);
    expect(find.text('Correct!'), findsOneWidget);

    await tester.tap(find.text('Next Question'));
    await tester.pump();

    expect(find.text('Question 2 of 2'), findsOneWidget);
    expect(find.text('What color is the sky on a clear day?'), findsOneWidget);

    await tester.tap(find.text('Green'));
    await tester.pump();

    expect(find.text('Score: 1'), findsOneWidget);
    expect(find.text('Correct answer: Blue'), findsOneWidget);
    expect(find.text('Restart Quiz'), findsOneWidget);

    await tester.tap(find.text('Restart Quiz'));
    await tester.pump();

    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
  });
}
