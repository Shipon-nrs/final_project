import 'package:flutter_test/flutter_test.dart';

import 'package:projet/main.dart'; // make sure this path matches your main.dart

void main() {
  testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LostAndFoundApp());

    expect(find.text('Lost & Found'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Login'), findsOneWidget);
  });
}
