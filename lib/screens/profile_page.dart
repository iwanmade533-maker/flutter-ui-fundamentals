
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String studentName = 'Made Iwan Darma Saputra';
  static const String studentId = '2415051113';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.indigo,
            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              studentName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Mahasiswa',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 28),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.indigo,
                  ),
                  title: const Text('Nama Lengkap'),
                  subtitle: const Text(studentName),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.badge_outlined,
                    color: Colors.indigo,
                  ),
                  title: const Text('NIM'),
                  subtitle: const Text(studentId),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(
                    Icons.phone_android,
                    color: Colors.indigo,
                  ),
                  title: Text('Nama Aplikasi'),
                  subtitle: Text('Course Explorer'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Course Explorer merupakan aplikasi '
                    'manajemen mata kuliah yang dibuat '
                    'menggunakan Flutter, Provider, REST API, '
                    'dan Supabase.',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
