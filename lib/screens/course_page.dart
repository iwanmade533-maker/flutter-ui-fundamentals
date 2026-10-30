
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import 'create_course_page.dart';
import 'favorites_page.dart';
import '../widgets/course_card.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading
                ? null
                : () {
                    context.read<CourseProvider>().loadCourses();
                  },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: provider.isSaving
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateCoursePage(),
                  ),
                );
              },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Course'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Made Iwan Darma Saputra',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text('NIM: 2415051113'),
                ],
              ),
            ),
          ),

          if (provider.isLoading)
            const LinearProgressIndicator(),

          if (provider.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Informasi: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            context
                                .read<CourseProvider>()
                                .loadCourses();
                          },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),

          Expanded(
            child: provider.courses.isEmpty
                ? Center(
                    child: provider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Belum ada course.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 90,
                    ),
                    itemCount: provider.courses.length,
                    itemBuilder: (context, index) {
                      final course = provider.courses[index];

                      return CourseCard(course: course);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
