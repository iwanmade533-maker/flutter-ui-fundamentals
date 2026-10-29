
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);

  final CourseRepository repository;

  List<Course> courses = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  final Set<String> _favorites = {};

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    notifyListeners();
  }

  List<Course> get favoriteCourses {
    return courses
        .where((course) => _favorites.contains(course.code))
        .toList();
  }

  Future<void> loadCourses() async {
    if (isLoading) return;

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

  Future<Course> createCourse(Course course) async {
    if (isSaving) {
      throw Exception('Penyimpanan sedang berlangsung.');
    }

    isSaving = true;
    notifyListeners();

    try {
      final createdCourse =
          await repository.createCourse(course);

      await loadCourses();

      if (error != null) {
        throw Exception(
          'Course tersimpan, tetapi daftar gagal dimuat ulang.',
        );
      }

      return createdCourse;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
