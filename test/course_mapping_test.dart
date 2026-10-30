
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_fundamentals/models/course.dart';

void main() {
  group('Pengujian JSON Mapping Course', () {
    test('Berhasil membaca JSON dengan key yang benar', () {
      final course = Course.fromJson({
        'id': 1,
        'code': 'IF101',
        'title': 'Pemrograman Dasar',
        'credits': 3,
        'status': 'planned',
      });

      expect(course.code, 'IF101');
      expect(course.title, 'Pemrograman Dasar');
      expect(course.credits, 3);
    });

    test('Menangani key credits yang salah', () {
      final course = Course.fromJson({
        'id': 1,
        'code': 'IF101',
        'title': 'Pemrograman Dasar',
        'credit': 3,
        'status': 'planned',
      });

      expect(course.credits, 0);
    });

    test('Menangani tipe data credits yang tidak valid', () {
      final course = Course.fromJson({
        'id': 1,
        'code': 'IF101',
        'title': 'Pemrograman Dasar',
        'credits': 'bukan angka',
        'status': 'planned',
      });

      expect(course.credits, 0);
    });
  });
}
