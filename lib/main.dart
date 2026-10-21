
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_state.dart';
import 'models/course.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

// Contoh data JSON yang diubah menjadi objek Course.
final List<Course> courses = [
  Course.fromJson({
    'code': 'MOB01',
    'title': 'Dart Fundamentals',
    'credits': 2,
    'status': 'Selesai',
  }),
  Course.fromJson({
    'code': 'MOB02',
    'title': 'Flutter UI Fundamentals',
    'credits': 3,
    'status': 'Aktif',
  }),
  Course.fromJson({
    'code': 'MOB03',
    'title': 'Responsive Layout',
    'credits': 3,
    'status': 'Aktif',
  }),
];

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CoursePage(),
      ),
    ),
  );
}

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCount =
        context.watch<CourseState>().favorites.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Course Model Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            studentName,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            'NIM: $studentId',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Total Favorites: $favoriteCount',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12),

          ...courses.map((course) {
            return CourseCard(course: course);
          }),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();
    final favorite = state.isFavorite(course.code);

    return Card(
      child: ListTile(
        title: Text(course.title),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS • ${course.status}',
        ),
        trailing: IconButton(
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<CourseState>().toggleFavorite(course.code);
          },
        ),
      ),
    );
  }
}
