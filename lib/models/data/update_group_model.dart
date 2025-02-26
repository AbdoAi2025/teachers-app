class UpdateGroupModel {
  final String groupId;
  final String name;
  final List<String> studentsIds;
  final int day;
  final String timeFrom;
  final String timeTo;

  UpdateGroupModel({
    required this.groupId,
    required this.name,
    required this.studentsIds,
    required this.day,
    required this.timeFrom,
    required this.timeTo,
  });

  // 📝 تحويل البيانات من JSON عند استلامها من API
  factory UpdateGroupModel.fromJson(Map<String, dynamic> json) {
    return UpdateGroupModel(
      groupId: json['groupId'],
      name: json['name'],
      studentsIds: List<String>.from(json['studentsIds'] ?? []),
      day: json['day'],
      timeFrom: json['timeFrom'],
      timeTo: json['timeTo'],
    );
  }

  // 📝 تحويل البيانات إلى JSON عند إرسالها إلى API
  Map<String, dynamic> toJson() {
    return {
      "groupId": groupId,
      "name": name,
      "studentsIds": studentsIds,
      "day": day,
      "timeFrom": timeFrom,
      "timeTo": timeTo,
    };
  }
}
