import 'package:flutter_test/flutter_test.dart';
import 'package:madact15/question.dart';

void main() {
  test('Question.fromJson maps trivia data into a model', () {
    final question = Question.fromJson({
      'question': 'What is the capital of France?',
      'correct_answer': 'Paris',
      'incorrect_answers': ['London', 'Berlin', 'Madrid'],
    });

    expect(question.question, 'What is the capital of France?');
    expect(question.correctAnswer, 'Paris');
    expect(question.options, hasLength(4));
    expect(question.options.toSet(), {'Paris', 'London', 'Berlin', 'Madrid'});
  });
}
