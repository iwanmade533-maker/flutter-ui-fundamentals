
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';
import '../screens/course_form_page.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
  });

  final Course course;

  Future<void> _deleteCourse(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Course'),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${course.title}"?',
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
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final provider = context.read<CourseProvider>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      await provider.deleteCourse(course);

      if (!context.mounted) return;

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Course berhasil dihapus.'),
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

  Color _statusColor() {
    switch (course.status) {
      case 'active':
        return Colors.green;
      case 'done':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel() {
    switch (course.status) {
      case 'active':
        return 'Active';
      case 'done':
        return 'Done';
      default:
        return 'Planned';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(course.code);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailPage(course: course),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.shade50,
              child: Text(
                course.credits.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            title: Text(
              course.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.code),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        label: Text(_statusLabel()),
                        backgroundColor: _statusColor().withValues(
                          alpha: 0.12,
                        ),
                        labelStyle: TextStyle(
                          color: _statusColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text('${course.credits} SKS'),
                    ],
                  ),
                ],
              ),
            ),
            trailing: PopupMenuButton<String>(
              tooltip: 'Aksi Course',
              onSelected: (value) {
                if (value == 'favorite') {
                  provider.toggleFavorite(course.code);
                } else if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseFormPage(course: course),
                    ),
                  );
                } else if (value == 'delete') {
                  _deleteCourse(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'favorite',
                  child: Row(
                    children: [
                      Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFavorite
                            ? 'Hapus dari Favorit'
                            : 'Tambah ke Favorit',
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
