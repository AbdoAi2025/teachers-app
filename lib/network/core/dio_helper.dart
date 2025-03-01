import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static String? token;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://assistant-app-2136afb92d95.herokuapp.com/api/v1/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static void setToken(String accessToken) {
    token = accessToken;
    dio.options.headers['Authorization'] = 'Bearer $token';
    print("🔑 التوكين تم حفظه: $token");
  }

  // ️ إرسال بيانات باستخدام POST
  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(url, data: data);
  }

  // ️ جلب البيانات باستخدام  GET groups
  static Future<Response> getData(String url, {Map<String, dynamic>? query}) async {
    return await dio.get(url, queryParameters: query);
  }



  //  دالة خاصة لإنشاء مجموعة جديدة
  static Future<Response> postGroupData(Map<String, dynamic> groupData) async {
    return await dio.post("groups/add", data: groupData);
  }

  //دالةخاصة بتعديل مجموعة جديدة

  static Future<Response> putData (Map<String,dynamic> updateGroupData) async{
    return await dio.put("groups/update",data: updateGroupData);
  }


  // دالة خاصة لمسح مجموعة باستخدام DELETE
  static Future<Response> deleteGroup(String groupId) async {
    return await dio.delete("groups/delete/$groupId");
  }




  //  تحميل بيانات الطلاب
  static Future<List<dynamic>> fetchStudents({bool hasGroups = false}) async {
    try {
      final response = await getData("students/myStudents", query: {"hasGroups": hasGroups});
      print("✅ تم جلب بيانات الطلاب بنجاح!");
      return response.data['data'];
    } catch (e) {
      print("❌ فشل في تحميل بيانات الطلاب: $e");
      throw Exception("حدث خطأ أثناء تحميل الطلاب.");
    }
  }

  //  دالة خاصة لإنشاء طالب جديد
  static Future<Response> postStudentData(Map<String, dynamic> studentData) async {
    return await dio.post("students/add", data: studentData);
  }


  static Future<Response> putStudentData(Map<String, dynamic> updateStudentData) async {
    try {
      print("📡 إرسال طلب تعديل الطالب...");
      print("📤 البيانات المرسلة (JSON): ${updateStudentData}"); // ✅ طباعة البيانات قبل الإرسال

      Response response = await dio.put("students/update", data: updateStudentData);

      print("✅ استجابة API بعد التعديل: ${response.data}"); // ✅ طباعة استجابة الـ API
      return response;
    } catch (e) {
      print("❌ خطأ في طلب التعديل: $e");
      throw Exception("فشل تعديل الطالب: $e");
    }
  }




  static Future<Response> deleteStudent(String studentId) async {
    return await dio.delete("students/delete/$studentId");
  }



  static Future<Map<String, dynamic>> getStudentById(String studentId) async {
    try {
      print("📡 إرسال طلب لجلب بيانات الطالب ID: $studentId");

      Response response = await dio.get("students/$studentId");

      print("✅ استجابة API: ${response.data}");

      return response.data; // إرجاع بيانات الطالب على شكل `Map`
    } catch (e) {
      print("❌ فشل جلب بيانات الطالب: $e");
      throw Exception("فشل جلب بيانات الطالب: $e");
    }
  }





}
