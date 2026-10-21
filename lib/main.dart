
import 'package:flutter/material.dart';
import 'course_state.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CoursePage(),
  ));
}

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final CourseState courseState = CourseState();

  @override
  void dispose() {
    courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChangeNotifier Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              studentName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('NIM: $studentId'),
            const SizedBox(height: 16),

            ListenableBuilder(
              listenable: courseState,
              builder: (context, child) {
                return Column(
                  children: [
                    Text(
                      'Total Favorites: ${courseState.favorites.length}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    courseTile('MOB01', 'Dart Fundamentals'),
                    courseTile('MOB02', 'Flutter UI Fundamentals'),
                    courseTile('MOB03', 'Responsive Layout'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget courseTile(String id, String title) {
    final favorite = courseState.isFavorite(id);

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(favorite ? 'Favorit aktif' : 'Belum favorit'),
        trailing: IconButton(
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.red : null,
          ),
          onPressed: () => courseState.toggleFavorite(id),
        ),
      ),
    );
  }
}
