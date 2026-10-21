
import 'package:flutter/foundation.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository _repository;

  CourseState()
      : _repository = CourseRepository(CourseService());

  List<Course> courses = [];
  final Set<String> favorites = {};

  bool isLoading = false;
  String? errorMessage;

  bool isFavorite(String id) {
    return favorites.contains(id);
  }

  int get favoriteCount => favorites.length;

  Future<void> loadCourses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      courses = await _repository.getCourses();
    } catch (e) {
      errorMessage = 'Gagal memuat data mata kuliah: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    notifyListeners();
  }
}
