


class AddGroupModel {
  final String id;
  final String name;
  final List<String> studentsIds;
  final int day;
  final String timeFrom;
  final String timeTo;

  AddGroupModel({
    required this.id,
    required this.name,
    required this.studentsIds,
    required this.day,
    required this.timeFrom,
    required this.timeTo,
  });

  factory AddGroupModel.fromJson(Map<String, dynamic> json) {
    return AddGroupModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      studentsIds: List<String>.from(json["studentsIds"] ?? []),
      day: json["day"] ?? 0,
      timeFrom: json["timeFrom"] ?? "",
      timeTo: json["timeTo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "studentsIds": studentsIds,
      "day": day,
      "timeFrom": timeFrom,
      "timeTo": timeTo,
    };
  }
}
