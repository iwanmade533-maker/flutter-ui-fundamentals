
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ui_fundamentals/providers/course_provider.dart';
import 'package:flutter_ui_fundamentals/repositories/course_repository.dart';
import 'package:flutter_ui_fundamentals/screens/course_page.dart';
import 'package:flutter_ui_fundamentals/services/course_api_service.dart';

void main() {
  testWidgets('Course Explorer menampilkan identitas mahasiswa', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CourseProvider(
          CourseRepository(
  CourseApiService('https://course-api-pearl.vercel.app'),
)
        ),
        child: const MaterialApp(
          home: CoursePage(),
        ),
      ),
    );

    expect(find.text('Made Iwan Darma Saputra'), findsOneWidget);
    expect(find.text('NIM: 2415051113'), findsOneWidget);
  });
}
