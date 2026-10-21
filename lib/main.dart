
import 'package:flutter/material.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FavoritesPage(),
  ));
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Parent menjadi pemilik shared state.
  final Set<String> favorites = {};

  void toggleFavorite(String course) {
    setState(() {
      if (favorites.contains(course)) {
        favorites.remove(course);
      } else {
        favorites.add(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Favorites')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(studentName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('NIM: $studentId'),
            const SizedBox(height: 16),
            Text('Total Favorites: ${favorites.length}'),
            const SizedBox(height: 16),

            // Data dan callback diteruskan ke child pertama.
            FavoriteChild(
              course: 'Dart Fundamentals',
              isFavorite: favorites.contains('Dart Fundamentals'),
              onToggle: () => toggleFavorite('Dart Fundamentals'),
            ),

            // Data dan callback diteruskan lagi ke child kedua.
            FavoriteChild(
              course: 'Flutter UI Fundamentals',
              isFavorite: favorites.contains('Flutter UI Fundamentals'),
              onToggle: () => toggleFavorite('Flutter UI Fundamentals'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteChild extends StatelessWidget {
  final String course;
  final bool isFavorite;
  final VoidCallback onToggle;

  const FavoriteChild({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(course),
        subtitle: Text(isFavorite ? 'Favorit' : 'Belum favorit'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
