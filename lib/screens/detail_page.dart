
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class DetailPage extends StatelessWidget {
  final Course course;

  const DetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isFavorite = provider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Kode: ${course.code}'),
            Text('SKS: ${course.credits}'),
            Text('Status: ${course.status}'),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                const SizedBox(width: 8),
                Text(
                  isFavorite
                      ? 'Sudah menjadi favorit'
                      : 'Belum menjadi favorit',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CourseProvider>()
                    .toggleFavorite(course.code);
              },
              icon: Icon(
                isFavorite ? Icons.favorite_border : Icons.favorite,
              ),
              label: Text(
                isFavorite
                    ? 'Hapus dari Favorit'
                    : 'Tambahkan ke Favorit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
