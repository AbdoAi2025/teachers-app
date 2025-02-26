



class GroupModel {
  final String groupId;
  final String groupName;
  final int groupDay;
  final int studentCount;
  final String timeFrom;
  final String timeTo;
  final List<String> studentsIds;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupDay,
    required this.studentCount,
    required this.timeFrom,
    required this.timeTo,
    required this.studentsIds,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['groupId'] ?? "", // تأكيد عدم وجود `null`
      groupName: json['groupName'] ?? "Unknown Group",
      groupDay: json['groupDay'] ?? 0, // إذا كانت `null` اجعلها 0
      studentCount: json['studentCount'] ?? 0, // إذا كانت `null` اجعلها 0
      timeFrom: json['timeFrom'] ?? "", // إذا كانت `null` اجعلها 0
      timeTo: json['timeTo'] ?? "", // إذا كانت `null` اجعلها 0
      studentsIds: List<String>.from(json['studentsIds'] ?? []),
    );
  }
}




