



class AddStudentModel {
  final int gradeId;
  final String phone;
  final String parentPhone;
  final String name;
  final String password;

  AddStudentModel({
    required this.gradeId,
    required this.phone,
    required this.parentPhone,
    required this.name,
    required this.password,
  });


  factory AddStudentModel.fromJson(Map<String, dynamic> json) {
    return AddStudentModel(
      gradeId: json["gradeId"] ?? 0,
      phone: json["phone"] ?? "",
      parentPhone: json["parentPhone"] ?? "",
      name: json["name"] ?? "",
      password: json["password"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gradeId": gradeId,
      "phone": phone,
      "parentPhone": parentPhone,
      "name": name,
      "password": password,
    };
  }
}
