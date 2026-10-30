
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ui_fundamentals/main.dart';

void main() {
  testWidgets('Aplikasi Course Data Manager dapat dibangun', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Course Data Manager'), findsOneWidget);
  });
}
