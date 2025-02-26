




// Bloc لإدارة الحالة
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/auth/auth_event.dart';
import 'package:teachers_app/bloc/presentation/auth/auth_state.dart';
import 'package:teachers_app/repositories/data/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        final user = await repository.login(event.username, event.password);
        emit(AuthSuccessState(user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}