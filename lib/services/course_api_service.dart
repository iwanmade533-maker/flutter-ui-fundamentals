
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  @override
  Future<List<Course>> getCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil course: HTTP ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    final List<dynamic> data;

    if (decoded is List) {
      data = decoded;
    } else if (decoded is Map<String, dynamic> &&
        decoded['courses'] is List) {
      data = decoded['courses'] as List<dynamic>;
    } else {
      throw Exception('Format data course dari API tidak valid.');
    }

    return data.map((item) {
      return Course.fromJson(
        item as Map<String, dynamic>,
      );
    }).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal menambahkan course: HTTP ${response.statusCode}',
      );
    }

    if (response.body.trim().isNotEmpty) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final result = decoded['course'] is Map<String, dynamic>
            ? decoded['course'] as Map<String, dynamic>
            : decoded;

        if (result.containsKey('code') &&
            result.containsKey('title')) {
          return Course.fromJson(result);
        }
      }
    }

    return course;
  }

  @override
  Future<void> updateCourse(
    int id,
    Course course,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal memperbarui course: HTTP ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal menghapus course: HTTP ${response.statusCode}',
      );
    }
  }
}
