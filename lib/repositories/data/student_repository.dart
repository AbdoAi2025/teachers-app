import 'package:dio/dio.dart';
import 'package:teachers_app/models/data/add_student_model.dart';
import 'package:teachers_app/models/data/student_model.dart';
import 'package:teachers_app/network/core/dio_helper.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents({bool hasGroups = false});

  Future<void> createStudent(AddStudentModel student);

}

class StudentRepositoryImpl implements StudentRepository {
  @override
  Future<List<Student>> getStudents({bool hasGroups = false}) async {
    try {
      print("📡 إرسال طلب لجلب بيانات الطلاب...");
      final response = await DioHelper.getData(
        'students/myStudents',
        query: {"hasGroups": hasGroups},
      );
      print("✅ استجابة API: ${response.data}");

      return (response.data['data'] as List)
          .map((e) => Student.fromJson(e))
          .toList();
    } catch (e) {
      print("❌ فشل في تحميل الطلاب: $e");
      throw Exception("فشل في تحميل الطلاب");
    }
  }

  @override
  Future<void> createStudent(AddStudentModel student) async {
    await DioHelper.postStudentData(student.toJson());
  }

}
