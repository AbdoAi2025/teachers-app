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

  // 🏷️ إرسال بيانات باستخدام POST
  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(url, data: data);
  }

  // 🏷️ جلب البيانات باستخدام  GET groups
  static Future<Response> getData(String url, {Map<String, dynamic>? query}) async {
    return await dio.get(url, queryParameters: query);
  }



  // 🟢 دالة خاصة لإنشاء مجموعة جديدة
  static Future<Response> postGroupData(Map<String, dynamic> groupData) async {
    return await dio.post("groups/add", data: groupData);
  }

  //دالةخاصة بتعديل مجموعة جديدة

  static Future<Response> putData (Map<String,dynamic> updateGroupData) async{
    return await dio.put("groups/update",data: updateGroupData);
  }



  // 🏷️ تحميل بيانات الطلاب
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

  // 🟢 دالة خاصة لإنشاء طالب جديد
  static Future<Response> postStudentData(Map<String, dynamic> studentData) async {
    return await dio.post("students/add", data: studentData);
  }

}
