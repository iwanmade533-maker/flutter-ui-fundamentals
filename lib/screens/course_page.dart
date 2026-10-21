
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'detail_page.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 600;
        final expanded = width >= 840;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              selectedIndex == 0
                  ? 'Course Explorer'
                  : 'Mata Kuliah Favorit',
            ),
          ),
          body: Row(
            children: [
              if (!compact)
                NavigationRail(
                  selectedIndex: selectedIndex,
                  extended: expanded,
                  onDestinationSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                ),
              if (!compact) const VerticalDivider(width: 1),
              Expanded(
                child: _buildContent(provider),
              ),
            ],
          ),
          bottomNavigationBar: compact
              ? NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: 'Courses',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  Widget _buildContent(CourseProvider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                studentName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'NIM: $studentId',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text('Total Favorites: ${provider.favoriteCount}'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildCourseList(provider),
        ),
      ],
    );
  }

  Widget _buildCourseList(CourseProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Gagal memuat data mata kuliah.'),
              const SizedBox(height: 8),
              Text(provider.error!),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  context.read<CourseProvider>().loadCourses();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final courses = selectedIndex == 0
        ? provider.courses
        : provider.courses
            .where((course) => provider.isFavorite(course.code))
            .toList();

    if (courses.isEmpty) {
      return Center(
        child: Text(
          selectedIndex == 0
              ? 'Belum ada data mata kuliah.'
              : 'Belum ada mata kuliah favorit.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

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
    );
  }
}
