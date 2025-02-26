

import 'package:teachers_app/models/data/user_model.dart';



// الحالات (States)

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final UserModel user;
  AuthSuccessState(this.user);
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}