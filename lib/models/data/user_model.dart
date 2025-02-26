


class UserModel {
  final String id;
  final String username;
  final String roleName;
  final String accessToken;

  UserModel({
    required this.id,
    required this.username,
    required this.roleName,
    required this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      roleName: json['roleName'],
      accessToken: json['accessToken'],
    );
  }
}
