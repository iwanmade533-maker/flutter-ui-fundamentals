
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseReadDataSource {
  CourseApiService({
    required this.baseUrl,
    required this.apiKey,
  });

  final String baseUrl;
  final String apiKey;

  @override
  Future<List<Course>> getCourses() async {
    final projectUrl = baseUrl.replaceFirst(
      RegExp(r'/$'),
      '',
    );

    final uri = Uri.parse(
      '$projectUrl/rest/v1/courses',
    ).replace(
      queryParameters: {
        'select': '*',
        'order': 'id.asc',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'apikey': apiKey,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil course melalui REST API. '
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception(
        'Format respons REST API tidak valid.',
      );
    }

    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw Exception('Format data course tidak valid.');
      }

      return Course.fromJson(item);
    }).toList();
  }
}
