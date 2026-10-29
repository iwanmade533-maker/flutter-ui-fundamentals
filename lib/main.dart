
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_page.dart';
import 'services/course_api_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(
        CourseRepository(
          CourseApiService(
            'https://course-api-pearl.vercel.app',
          ),
        ),
      )..loadCourses(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CoursePage(),
      ),
    ),
  );
}
