

class LoadStudentByIdModel {
  final String studentId;
  final String name;
  final String phone;
  final String parentPhone;
  final String gradeNameEn;
  final String gradeNameAr;

  LoadStudentByIdModel({
    required this.studentId,
    required this.name,
    required this.phone,
    required this.parentPhone,
    required this.gradeNameEn,
    required this.gradeNameAr,
  });

  factory LoadStudentByIdModel.fromJson(Map<String, dynamic> json) {
    return LoadStudentByIdModel(
      studentId: json["studentId"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      parentPhone: json["parentPhone"] ?? "",
      gradeNameEn: json["grade"]["nameEn"] ?? "",
      gradeNameAr: json["grade"]["nameAr"] ?? "",
    );
  }
}
