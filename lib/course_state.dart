
import 'package:flutter/foundation.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  CourseState(this.repository);

  final CourseRepository repository;

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
