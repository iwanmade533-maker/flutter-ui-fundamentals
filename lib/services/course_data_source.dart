
import '../models/course.dart';

abstract class CourseReadDataSource {
  Future<List<Course>> getCourses();
}

abstract class CourseDataSource implements CourseReadDataSource {
  Future<Course> createCourse(Course course);

  Future<void> updateCourse(int id, Course course);

  Future<void> deleteCourse(int id);
}
