
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    final favoriteCourses = provider.courses
        .where((course) => provider.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah Favorit'),
      ),
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Text('Belum ada mata kuliah favorit.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final course = favoriteCourses[index];

                return CourseCard(
                  course: course,
                  isFavorite: provider.isFavorite(course.code),
                  onFavoritePressed: () {
                    context
                        .read<CourseProvider>()
                        .toggleFavorite(course.code);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(course: course),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
