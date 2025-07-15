import '../models/course.dart';
import '../db/DatabaseHelper.dart';

class CourseService {
  static final CourseService _instance = CourseService._internal();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  CourseService._internal();

  factory CourseService() {
    return _instance;
  }

  // Lấy tất cả khóa học
  Future<List<Course>> getAllCourses() async {
    try {
      return await _dbHelper.getAllCourses();
    } catch (e) {
      throw Exception('Không thể tải danh sách khóa học: $e');
    }
  }

  // Thêm khóa học mới
  Future<int> addCourse(Course course) async {
    try {
      // Kiểm tra validation
      _validateCourse(course);
      return await _dbHelper.insertCourse(course);
    } catch (e) {
      throw Exception('Không thể thêm khóa học: $e');
    }
  }

  // Xóa khóa học
  Future<int> deleteCourse(int courseId) async {
    try {
      if (courseId <= 0) {
        throw Exception('ID khóa học không hợp lệ');
      }
      return await _dbHelper.deleteCourse(courseId);
    } catch (e) {
      throw Exception('Không thể xóa khóa học: $e');
    }
  }

  // Cập nhật khóa học
  Future<int> updateCourse(Course course) async {
    try {
      _validateCourse(course);
      if (course.id == null || course.id! <= 0) {
        throw Exception('ID khóa học không hợp lệ');
      }
      return await _dbHelper.updateCourse(course);
    } catch (e) {
      throw Exception('Không thể cập nhật khóa học: $e');
    }
  }

  // Tìm khóa học theo ID
  Future<Course?> getCourseById(int id) async {
    try {
      final courses = await _dbHelper.getAllCourses();
      return courses.firstWhere(
        (course) => course.id == id,
        orElse: () => throw Exception('Không tìm thấy khóa học'),
      );
    } catch (e) {
      return null;
    }
  }

  // Tìm kiếm khóa học theo tên
  Future<List<Course>> searchCoursesByName(String name) async {
    try {
      final courses = await _dbHelper.getAllCourses();
      return courses
          .where(
            (course) => course.name.toLowerCase().contains(name.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Không thể tìm kiếm khóa học: $e');
    }
  }

  // Lấy tổng số khóa học
  Future<int> getTotalCourses() async {
    try {
      final courses = await _dbHelper.getAllCourses();
      return courses.length;
    } catch (e) {
      throw Exception('Không thể đếm số khóa học: $e');
    }
  }

  // Lấy tổng học phí
  Future<double> getTotalFees() async {
    try {
      final courses = await _dbHelper.getAllCourses();
      double total = 0.0;
      for (final course in courses) {
        total += course.fee.toDouble();
      }
      return total;
    } catch (e) {
      throw Exception('Không thể tính tổng học phí: $e');
    }
  }

  // Kiểm tra validation cho khóa học
  void _validateCourse(Course course) {
    if (course.name.trim().isEmpty) {
      throw Exception('Tên khóa học không được để trống');
    }

    if (course.name.trim().length < 2) {
      throw Exception('Tên khóa học phải có ít nhất 2 ký tự');
    }

    if (course.name.trim().length > 20) {
      throw Exception('Tên khóa học không được vượt quá 20 ký tự');
    }

    if (course.duration.trim().isEmpty) {
      throw Exception('Thời lượng khóa học không được để trống');
    }

    if (course.fee < 0) {
      throw Exception('Học phí không thể âm');
    }
  }

  // Đóng kết nối database
  Future<void> close() async {
    await _dbHelper.close();
  }
}
