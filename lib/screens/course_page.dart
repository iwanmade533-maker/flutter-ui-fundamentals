
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'create_course_page.dart';
import 'edit_course_page.dart';
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
              child: Text(
                'Informasi: ${provider.error}',
                style: const TextStyle(color: Colors.red),
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

                      return _CourseCard(course: course);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
  });

  final Course course;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Course?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${course.title}" (${course.code})?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    // Periksa context setelah dialog ditutup.
    if (!context.mounted || confirmed != true) return;

    final provider = context.read<CourseProvider>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      await provider.deleteCourse(course);

      // Periksa context setelah proses DELETE selesai.
      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Course "${course.title}" berhasil dihapus.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isFavorite = provider.isFavorite(course.code);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(course.credits.toString()),
        ),
        title: Text(course.title),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS • ${course.status}',
        ),
        trailing: Wrap(
          spacing: 0,
          children: [
            IconButton(
              tooltip: isFavorite
                  ? 'Hapus dari favorites'
                  : 'Tambahkan ke favorites',
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: provider.isSaving
                  ? null
                  : () {
                      context
                          .read<CourseProvider>()
                          .toggleFavorite(course.code);
                    },
            ),
            IconButton(
              tooltip: 'Edit course',
              icon: const Icon(Icons.edit),
              onPressed: provider.isSaving
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditCoursePage(
                            course: course,
                          ),
                        ),
                      );
                    },
            ),
            IconButton(
              tooltip: 'Hapus course',
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: provider.isSaving
                  ? null
                  : () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }
}
