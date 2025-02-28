class UpdateStudentModel {
  final String studentId;
  final int gradeId;
  final String phone;
  final String parentPhone;
  final String name;

  UpdateStudentModel({
    required this.studentId,
    required this.gradeId,
    required this.phone,
    required this.parentPhone,
    required this.name,
  });

  factory UpdateStudentModel.fromJson(Map<String, dynamic> json) {
    print("📌 البيانات المستلمة من JSON: $json"); // ✅ طباعة البيانات عند استلامها
    return UpdateStudentModel(
      studentId: json["studentId"] ?? "",
      gradeId: json["gradeId"] ?? 0,
      phone: json["phone"] ?? "",
      parentPhone: json["parentPhone"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      "studentId": studentId,
      "gradeId": gradeId,
      "phone": phone,
      "parentPhone": parentPhone,
      "name": name,
    };
    print("📡 البيانات المرسلة كـ JSON: $data"); // ✅ طباعة البيانات عند الإرسال
    return data;
  }
}
