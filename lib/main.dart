import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/auth/auth_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/bloc/presentation/student/student_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_event.dart';
import 'package:teachers_app/network/core/dio_helper.dart';
import 'package:teachers_app/pages/login_page.dart';
import 'package:teachers_app/repositories/data/auth_repository.dart';
import 'package:teachers_app/repositories/data/student_repository.dart';

import 'repositories/data/group_repository.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthRepositoryImpl()),
        ),
        BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(StudentRepositoryImpl())..add(LoadStudentsEvent()),
        ),


        BlocProvider<GroupBloc>(
          create: (context) => GroupBloc(GroupRepositoryImpl())..add(LoadGroupsEvent()),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
