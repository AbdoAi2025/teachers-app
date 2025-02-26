


class Student {
  final String studentId;
  final String studentName;
  final String studentPhone;
  final String studentParentPhone;
  final String gradeNameAr;
  final String? groupId;
  final String? groupName;

  Student({
    required this.studentId,
    required this.studentName,
    required this.studentPhone,
    required this.studentParentPhone,
    required this.gradeNameAr,
    this.groupId,
    this.groupName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      studentName: json['studentName'],
      studentPhone: json['studentPhone'],
      studentParentPhone: json['studentParentPhone'],
      gradeNameAr: json['gradeNameAr'],
      groupId: json['groupId'],
      groupName: json['groupName'],
    );
  }
}
