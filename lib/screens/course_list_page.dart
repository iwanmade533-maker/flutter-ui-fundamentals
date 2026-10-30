
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_form_page.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  Future<void> _openCreatePage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CourseFormPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Data Manager'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CourseProvider>().loadCourses();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreatePage(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Course'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          // Loading pertama kali.
          if (provider.isLoading && provider.courses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Menampilkan error, termasuk ketika data lama tersedia.
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal memuat data course.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                      ),
                      if (provider.courses.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Data sebelumnya masih tersedia, '
                          'tetapi belum berhasil diperbarui.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.loadCourses(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Tampilan ketika belum ada data.
          if (provider.courses.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.loadCourses,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text('Belum ada data course.'),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tekan tombol Tambah Course untuk memulai.',
                    ),
                  ),
                ],
              ),
            );
          }

          // Tampilan daftar course.
          return RefreshIndicator(
            onRefresh: provider.loadCourses,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Made Iwan Darma Saputra',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('NIM: 2415051113'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Daftar Course (${provider.courses.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...provider.courses.map(
                  (course) => CourseCard(course: course),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
