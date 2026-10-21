
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CoursePage(),
      ),
    ),
  );
}

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider: watch & read')),
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

            // watch() mendengarkan perubahan jumlah favorit.
            const FavoriteCount(),
            const SizedBox(height: 12),

            courseTile('MOB01', 'Dart Fundamentals'),
            courseTile('MOB02', 'Flutter UI Fundamentals'),
            courseTile('MOB03', 'Responsive Layout'),
          ],
        ),
      ),
    );
  }

  Widget courseTile(String id, String title) {
    return Card(
      child: ListTile(
        title: Text(title),

        // Consumer membatasi area UI yang mendengarkan state.
        subtitle: Consumer<CourseState>(
          builder: (context, state, child) {
            return Text(
              state.isFavorite(id)
                  ? 'Favorit aktif'
                  : 'Belum favorit',
            );
          },
        ),

        trailing: Consumer<CourseState>(
          builder: (context, state, child) {
            return IconButton(
              icon: Icon(
                state.isFavorite(id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: state.isFavorite(id) ? Colors.red : null,
              ),

              // read() memanggil aksi tanpa memasang listener.
              onPressed: () {
                context.read<CourseState>().toggleFavorite(id);
              },
            );
          },
        ),
      ),
    );
  }
}

class FavoriteCount extends StatelessWidget {
  const FavoriteCount({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget ini dibangun ulang ketika CourseState berubah.
    final state = context.watch<CourseState>();

    return Text(
      'Total Favorites: ${state.favorites.length}',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
