
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
  // Single source of truth: state hanya disimpan di parent.
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifting State Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              studentName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('NIM: $studentId'),
            const SizedBox(height: 20),

            Text(
              'Status favorit: ${isFavorite ? "Aktif" : "Tidak aktif"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Child pertama menerima state dari parent.
            FavoriteStatusCard(
              title: 'Widget Pertama',
              isFavorite: isFavorite,
              onFavoriteChanged: toggleFavorite,
            ),

            // Child kedua menerima state yang sama.
            FavoriteStatusCard(
              title: 'Widget Kedua',
              isFavorite: isFavorite,
              onFavoriteChanged: toggleFavorite,
            ),

            const SizedBox(height: 16),
            const Text(
              'Tekan salah satu ikon hati. '
              'Kedua widget akan mengikuti status yang sama.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteStatusCard extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const FavoriteStatusCard({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          isFavorite ? 'Favorit aktif' : 'Belum menjadi favorit',
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteChanged,
        ),
      ),
    );
  }
}
