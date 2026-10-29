
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'create_course_page.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

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
            tooltip: 'Mata kuliah favorit',
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Course',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCoursePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
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
                  'Made Iwan Darma Saputra',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text('NIM: 2415051113'),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CourseProvider provider,
  ) {
    if (provider.isLoading && provider.courses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null && provider.courses.isEmpty) {
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
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (provider.isLoading)
            const LinearProgressIndicator(),
          if (provider.error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Gagal memperbarui data: ${provider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          for (final course in provider.courses)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${course.credits}'),
                ),
                title: Text(course.title),
                subtitle: Text(
                  '${course.code} • ${course.credits} SKS • ${course.status}',
                ),
                trailing: Icon(
                  provider.isFavorite(course.code)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: provider.isFavorite(course.code)
                      ? Colors.red
                      : null,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailPage(course: course),
                    ),
                  );
                },
                onLongPress: () {
                  provider.toggleFavorite(course.code);
                },
              ),
            ),
        ],
      ),
    );
  }
}
