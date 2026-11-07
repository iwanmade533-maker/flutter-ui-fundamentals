
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ui_fundamentals/main.dart';
import 'package:flutter_ui_fundamentals/models/course.dart';
import 'package:flutter_ui_fundamentals/providers/course_provider.dart';
import 'package:flutter_ui_fundamentals/repositories/course_repository.dart';
import 'package:flutter_ui_fundamentals/services/course_data_source.dart';

void main() {
  late CourseProvider courseProvider;

  setUp(() {
    final fakeDataSource = FakeCourseDataSource();

    final repository = CourseRepository(
  readDataSource: fakeDataSource,
  writeDataSource: fakeDataSource,
);

    courseProvider = CourseProvider(repository);
  });

  tearDown(() {
    courseProvider.dispose();
  });

  testWidgets('Aplikasi Course Explorer dapat dibangun', (
    WidgetTester tester,
  ) async {
    await courseProvider.loadCourses();

    await tester.pumpWidget(
      ChangeNotifierProvider<CourseProvider>.value(
        value: courseProvider,
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Course Explorer'), findsWidgets);
    expect(find.text('Ringkasan Course'), findsOneWidget);
    expect(find.text('Course Terbaru'), findsOneWidget);
    expect(find.text('Pemrograman Mobile'), findsOneWidget);
  });

  testWidgets('Dashboard menampilkan ringkasan course', (
    WidgetTester tester,
  ) async {
    await courseProvider.loadCourses();

    await tester.pumpWidget(
      ChangeNotifierProvider<CourseProvider>.value(
        value: courseProvider,
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Total Course'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('Favorites'), findsWidgets);
  });
}

class FakeCourseDataSource implements CourseDataSource {
  final List<Course> _courses = [
    const Course(
      id: 1,
      code: 'IF101',
      title: 'Pemrograman Mobile',
      credits: 3,
      status: 'active',
    ),
    const Course(
      id: 2,
      code: 'IF102',
      title: 'Basis Data',
      credits: 3,
      status: 'planned',
    ),
    const Course(
      id: 3,
      code: 'B50KA',
      title: 'Pemrograman',
      credits: 3,
      status: 'active',
    ),
  ];

  @override
  Future<List<Course>> getCourses() async {
    return List<Course>.from(_courses);
  }

  @override
  Future<Course> createCourse(Course course) async {
    final newCourse = Course(
      id: _courses.isEmpty ? 1 : _courses.last.id! + 1,
      code: course.code,
      title: course.title,
      credits: course.credits,
      status: course.status,
    );

    _courses.add(newCourse);

    return newCourse;
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final index = _courses.indexWhere((item) => item.id == id);

    if (index != -1) {
      _courses[index] = Course(
        id: id,
        code: course.code,
        title: course.title,
        credits: course.credits,
        status: course.status,
      );
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    _courses.removeWhere((course) => course.id == id);
  }
}
