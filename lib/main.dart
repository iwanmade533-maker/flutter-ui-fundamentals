
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(
        CourseRepository(CourseService()),
      )..loadCourses(),
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
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            studentName,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'NIM: $studentId',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Total Favorites: ${provider.favoriteCount}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),

          if (provider.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (provider.error != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gagal memuat data: ${provider.error}',
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<CourseProvider>().loadCourses();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            )
          else if (provider.courses.isEmpty)
            const Text('Belum ada data mata kuliah.')
          else
            ...provider.courses.map((course) {
              final favorite = provider.isFavorite(course.code);

              return Card(
                child: ListTile(
                  title: Text(course.title),
                  subtitle: Text(
                    '${course.code} • ${course.credits} SKS • '
                    '${course.status}',
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      favorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      context
                          .read<CourseProvider>()
                          .toggleFavorite(course.code);
                    },
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
