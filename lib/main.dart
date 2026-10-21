
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoursePage(),
    );
  }
}

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              studentName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('NIM: $studentId'),
            const SizedBox(height: 20),

            // Mendengarkan perubahan CourseState.
            Consumer<CourseState>(
              builder: (context, state, child) {
                return Column(
                  children: [
                    Text(
                      'Total Favorites: ${state.favorites.length}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    courseTile(
                      state,
                      'MOB01',
                      'Dart Fundamentals',
                    ),
                    courseTile(
                      state,
                      'MOB02',
                      'Flutter UI Fundamentals',
                    ),
                    courseTile(
                      state,
                      'MOB03',
                      'Responsive Layout',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget courseTile(
    CourseState state,
    String id,
    String title,
  ) {
    final favorite = state.isFavorite(id);

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          favorite ? 'Favorit aktif' : 'Belum favorit',
        ),
        trailing: IconButton(
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.red : null,
          ),
          onPressed: () => state.toggleFavorite(id),
        ),
      ),
    );
  }
}
