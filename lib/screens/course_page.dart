
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  static const String studentName =
      'Made Iwan Darma Saputra';
  static const String studentId = '2415051113';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text('NIM: $studentId'),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CourseProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    }

    if (provider.courses.isEmpty) {
      return const Center(
        child: Text('Data course belum tersedia'),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.courses.length,
        itemBuilder: (context, index) {
          final course = provider.courses[index];
          return CourseCard(course: course);
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(course.credits.toString()),
        ),
        title: Text(course.title),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS',
        ),
        trailing: Chip(
          label: Text(course.status),
        ),
      ),
    );
  }
}
