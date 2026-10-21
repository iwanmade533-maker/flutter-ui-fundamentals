
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ui_fundamentals/course_state.dart';
import 'package:flutter_ui_fundamentals/main.dart';

void main() {
  testWidgets('Course page menampilkan identitas mahasiswa',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CourseState(),
        child: const MaterialApp(
          home: CoursePage(),
        ),
      ),
    );

    expect(find.text(studentName), findsOneWidget);
    expect(find.text('NIM: $studentId'), findsOneWidget);
  });
}
