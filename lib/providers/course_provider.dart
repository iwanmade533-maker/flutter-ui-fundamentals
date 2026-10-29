
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

  List<Course> get favoriteCourses {
    return courses
        .where((course) => _favorites.contains(course.code))
        .toList();
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    notifyListeners();
  }

  Future<void> loadCourses() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();

      // Buang favorite yang tidak lagi ada di data API.
      final existingCodes =
          courses.map((course) => course.code).toSet();
      _favorites.removeWhere(
        (code) => !existingCodes.contains(code),
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Course> createCourse(Course course) async {
    if (isSaving) {
      throw Exception('Operasi penyimpanan sedang berlangsung.');
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      final createdCourse =
          await repository.createCourse(course);

      await _refreshAfterSave();

      return createdCourse;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> updateCourse(
    int id,
    Course course,
  ) async {
    if (isSaving) {
      throw Exception('Operasi penyimpanan sedang berlangsung.');
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      await _refreshAfterSave();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> deleteCourse(Course course) async {
    if (isSaving) {
      throw Exception('Operasi penyimpanan sedang berlangsung.');
    }

    final courseId = course.id;

    if (courseId == null) {
      throw Exception('ID course tidak tersedia.');
    }

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.deleteCourse(courseId);

      courses.removeWhere(
        (item) => item.id == courseId,
      );

      _favorites.remove(course.code);
      notifyListeners();

      try {
        courses = await repository.getCourses();

        final existingCodes =
            courses.map((item) => item.code).toSet();

        _favorites.removeWhere(
          (code) => !existingCodes.contains(code),
        );
      } catch (e) {
        error = 'Course terhapus, tetapi refresh gagal: $e';
      }

      notifyListeners();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _refreshAfterSave() async {
    try {
      courses = await repository.getCourses();

      final existingCodes =
          courses.map((course) => course.code).toSet();

      _favorites.removeWhere(
        (code) => !existingCodes.contains(code),
      );

      error = null;
    } catch (e) {
      error = e.toString();

      throw Exception(
        'Perubahan dikirim, tetapi daftar course gagal dimuat ulang: $e',
      );
    }
  }
}
