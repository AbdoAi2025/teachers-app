/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "اسم المستخدم",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "كلمة المرور",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✅ تسجيل الدخول ناجح!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // ✅ الانتقال إلى الصفحة الرئيسية بعد نجاح تسجيل الدخول
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("❌ خطأ: ${state.message}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AuthLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("⚠️ الرجاء إدخال اسم المستخدم وكلمة المرور"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      BlocProvider.of<AuthBloc>(context).add(
                        LoginRequested(username, password),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("تسجيل الدخول", style: TextStyle(fontSize: 18)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/auth/auth_bloc.dart';
import 'package:teachers_app/bloc/presentation/auth/auth_event.dart';
import 'package:teachers_app/bloc/presentation/auth/auth_state.dart';
import 'package:teachers_app/bloc/presentation/group/group_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/network/core/dio_helper.dart';
import 'package:teachers_app/pages/home_page.dart';
import 'package:teachers_app/repositories/data/group_repository.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تسجيل الدخول")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "اسم المستخدم"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "كلمة المرور"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccessState) {
                  print("✅ تسجيل الدخول ناجح - التوكين: ${state.user.accessToken}");
                  DioHelper.setToken(state.user.accessToken); // حفظ التوكين
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                      create: (context) => GroupBloc(GroupRepositoryImpl())..add(LoadGroupsEvent()),
                      child: HomePage(),
                    )),
                  );
                } else if (state is AuthErrorState) {
                  print("❌ خطأ في تسجيل الدخول: ${state.message}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    final username = usernameController.text;
                    final password = passwordController.text;
                    BlocProvider.of<AuthBloc>(context).add(LoginEvent(username, password));
                  },
                  child: Text("تسجيل الدخول"),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
