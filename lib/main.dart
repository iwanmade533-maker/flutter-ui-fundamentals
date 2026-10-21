
import 'package:flutter/material.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ValueNotifierPage(),
  ));
}

class ValueNotifierPage extends StatefulWidget {
  const ValueNotifierPage({super.key});

  @override
  State<ValueNotifierPage> createState() => _ValueNotifierPageState();
}

class _ValueNotifierPageState extends State<ValueNotifierPage> {
  // State dengan ValueNotifier.
  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);

  // State pembanding yang menggunakan setState().
  int setStateCount = 0;

  @override
  void dispose() {
    favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueNotifier Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                studentName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('NIM: $studentId'),
              const SizedBox(height: 30),

              const Text(
                '1. Menggunakan ValueNotifier',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),

              ValueListenableBuilder<int>(
                valueListenable: favoriteCount,
                builder: (context, value, child) {
                  return Text(
                    'Jumlah Favorite: $value',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              ElevatedButton.icon(
                onPressed: () {
                  favoriteCount.value++;
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Tambah Favorite'),
              ),

              const Divider(height: 40),

              const Text(
                '2. Menggunakan setState()',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),

              Text(
                'Jumlah Counter: $setStateCount',
                style: const TextStyle(fontSize: 24),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    setStateCount++;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Counter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
