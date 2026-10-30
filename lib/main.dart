
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_page.dart';
import 'services/course_supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Supabase.
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );

    // Service -> Repository -> Provider.
    final courseService = CourseSupabaseService();
    final courseRepository = CourseRepository(courseService);

    runApp(
      ChangeNotifierProvider<CourseProvider>(
        create: (_) => CourseProvider(courseRepository)..loadCourses(),
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Gagal menginisialisasi aplikasi: $e');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      StartupErrorApp(
        error: e.toString(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const CoursePage(),
    );
  }
}

// Tampilan jika inisialisasi Supabase gagal.
class StartupErrorApp extends StatelessWidget {
  final String error;

  const StartupErrorApp({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Gagal Memulai Aplikasi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Terjadi kesalahan saat menghubungkan aplikasi.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SelectableText(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
