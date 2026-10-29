
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  static const String apiUrl =
      'https://course-api-pearl.vercel.app/courses';

  Future<List<Course>> loadCourses() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    debugPrint('HTTP Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      debugPrint('Jumlah mata kuliah: ${data.length}');

      return data
          .map(
            (item) => Course.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw Exception('HTTP ${response.statusCode}');
  }
}
