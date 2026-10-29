
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favorites = provider.favoriteCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Courses'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Made Iwan Darma Saputra',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('NIM: 2415051113'),
                ],
              ),
            ),
          ),
          Expanded(
            child: favorites.isEmpty
                ? const Center(
                    child: Text('Belum ada course favorit.'),
                  )
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final course = favorites[index];

                      return ListTile(
                        leading: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        title: Text(course.title),
                        subtitle: Text(
                          '${course.code} • ${course.credits} SKS',
                        ),
                        trailing: IconButton(
                          tooltip: 'Hapus dari favorites',
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            context
                                .read<CourseProvider>()
                                .toggleFavorite(course.code);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
