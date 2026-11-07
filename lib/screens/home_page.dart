
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onOpenCourses,
  });

  final VoidCallback onOpenCourses;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;

    final activeCount =
        courses.where((course) => course.status == 'active').length;

    final doneCount =
        courses.where((course) => course.status == 'done').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadCourses,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Course Explorer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kelola dan pantau daftar mata kuliah '
                    'dengan mudah.',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Ringkasan Course',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (provider.isLoading && courses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (provider.error != null && courses.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: provider.loadCourses,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 600 ? 4 : 2;

                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    children: [
                      _SummaryCard(
                        title: 'Total Course',
                        value: courses.length.toString(),
                        icon: Icons.menu_book,
                        color: Colors.indigo,
                      ),
                      _SummaryCard(
                        title: 'Active',
                        value: activeCount.toString(),
                        icon: Icons.play_circle_outline,
                        color: Colors.green,
                      ),
                      _SummaryCard(
                        title: 'Selesai',
                        value: doneCount.toString(),
                        icon: Icons.check_circle_outline,
                        color: Colors.blue,
                      ),
                      _SummaryCard(
                        title: 'Favorites',
                        value: provider.favoriteCourses.length.toString(),
                        icon: Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 24),

            const Text(
              'Course Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            if (courses.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Belum ada course. Silakan tambahkan course baru.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...courses.take(3).map(
                (course) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.book_outlined),
                    ),
                    title: Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${course.code} • ${course.credits} SKS',
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: onOpenCourses,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Semua Course'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
