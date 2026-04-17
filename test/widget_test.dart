import 'package:flutter_test/flutter_test.dart';

import 'package:madact15/main.dart';

void main() {
  testWidgets('App shows the quiz shell', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Trivia Quiz'), findsOneWidget);
    expect(
      find.text(
        'Quiz screen setup complete. Next step: add models and API fetching.',
      ),
      findsNothing,
    );
  });
}
