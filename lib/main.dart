import 'package:flutter/material.dart';

const String studentName = 'Made Iwan Darma Saputra';
const String studentId = '2415051113';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 16 - Debugging',
      home: const DebuggingPage(),
    );
  }
}

class DebuggingPage extends StatelessWidget {
  const DebuggingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16 - Debugging'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '$studentId - $studentName',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // KASUS A
          const Text(
            'Kasus A - RenderFlex Overflow',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.info),
              const SizedBox(width: 8),

              // Expanded membuat Text mengambil
              // ruang yang tersedia saja.
              const Expanded(
                child: Text(
                  '$studentId - $studentName - '
                  'teks sangat panjang yang dapat menyebabkan '
                  'RenderFlex overflow jika tidak dibatasi.',
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          // KASUS B
          const Text(
            'Kasus B - ListView dalam Column',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            height: 220,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'ListView sudah diberi Expanded',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Expanded memberikan batas tinggi
                // kepada ListView.
                Expanded(
                  child: ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.list),
                        title: Text('Item ${index + 1}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          // KASUS C
          const Text(
            'Kasus C - Keyboard Overflow',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KeyboardFormPage(),
                ),
              );
            },
            child: const Text('Buka Form'),
          ),

          const Divider(height: 32),

          // KASUS D
          const Text(
            'Kasus D - Navigasi Ganda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          const Text(
            'Tombol dibuat tidak dapat ditekan berulang '
            'selama proses navigasi berlangsung.',
          ),

          const SizedBox(height: 10),

          const NavigationButton(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ======================================================
// KASUS C
// ======================================================

class KeyboardFormPage extends StatelessWidget {
  const KeyboardFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasus C - Keyboard'),
      ),

      // SingleChildScrollView membuat halaman
      // dapat digeser ketika keyboard muncul.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 300),

            const Text(
              'Form Feedback',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Form berhasil dikirim'),
                    ),
                  );
                },
                child: const Text('Kirim'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// KASUS D
// ======================================================

class NavigationButton extends StatefulWidget {
  const NavigationButton({super.key});

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  bool isNavigating = false;

  Future<void> openPage() async {
    // Mencegah tombol melakukan push berkali-kali.
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SecondPage(),
      ),
    );

    if (!mounted) return;

    setState(() {
      isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isNavigating ? null : openPage,
      icon: const Icon(Icons.open_in_new),
      label: Text(
        isNavigating
            ? 'Sedang membuka...'
            : 'Buka Halaman',
      ),
    );
  }
}

// ======================================================
// HALAMAN NAVIGASI
// ======================================================

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Kedua'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '$studentId - $studentName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Navigasi berhasil dibuka.',
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}