
import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  CourseRepository({
    required this.readDataSource,
    required this.writeDataSource,
  });

  final CourseReadDataSource readDataSource;
  final CourseDataSource writeDataSource;

  Future<List<Course>> getCourses() {
    return readDataSource.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return writeDataSource.createCourse(course);
  }

  Future<void> updateCourse(int id, Course course) {
    return writeDataSource.updateCourse(id, course);
  }

  Future<void> deleteCourse(int id) {
    return writeDataSource.deleteCourse(id);
  }
}
