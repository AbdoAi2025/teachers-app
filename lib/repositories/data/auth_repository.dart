


import 'package:dio/dio.dart';
import 'package:teachers_app/models/data/user_model.dart';
import 'package:teachers_app/network/core/dio_helper.dart';



abstract class AuthRepository {
  Future<UserModel> login(String username, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserModel> login(String username, String password) async {
    final response = await DioHelper.postData(
      url: 'users/signin',
      data: {
        "username": username,
        "password": password,
      },
    );

    return UserModel.fromJson(response.data);
  }
}
