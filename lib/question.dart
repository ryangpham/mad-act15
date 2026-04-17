class Question {
  const Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  final String question;
  final String correctAnswer;
  final List<String> options;

  factory Question.fromJson(Map<String, dynamic> json) {
    final options =
        List<String>.from(json['incorrect_answers'] as List<dynamic>)
          ..add(json['correct_answer'] as String)
          ..shuffle();

    return Question(
      question: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      options: options,
    );
  }
}
