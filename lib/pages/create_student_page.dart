import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_event.dart';
import 'package:teachers_app/bloc/presentation/student/student_state.dart';
import 'package:teachers_app/models/data/add_student_model.dart';
import 'package:teachers_app/pages/home_page.dart';
import 'package:teachers_app/pages/student_screen.dart';

class CreateStudentPage extends StatefulWidget {
  @override
  _CreateStudentPageState createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int? _selectedGrade;

  final List<int> _grades = [1, 2, 3, 4, 5]; // قيم `gradeId`

  void _submitStudent() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _parentPhoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ الرجاء ملء جميع الحقول")),
      );
      return;
    }

    final newStudent = AddStudentModel(
      gradeId: _selectedGrade!,
      phone: _phoneController.text,
      parentPhone: _parentPhoneController.text,
      name: _nameController.text,
      password: _passwordController.text,
    );



    // 👈 الانتقال مباشرة إلى صفحة student screen  دون انتظار API
     Navigator.pushAndRemoveUntil(
     context,
      MaterialPageRoute(builder: (context) => StudentScreen()),
    (route) => false,
     );

    BlocProvider.of<StudentBloc>(context).add(CreateStudentEvent(newStudent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة طالب جديد")),
      body: SingleChildScrollView(
        child: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is StudentCreatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ تم إضافة الطالب بنجاح!")),
              );
              Navigator.pop(context);
            } else if (state is StudentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("⚠️ فشل الإضافة: ${state.message}")),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _nameController, decoration: InputDecoration(labelText: "اسم الطالب")),
                TextField(controller: _phoneController, decoration: InputDecoration(labelText: "رقم الهاتف")),
                TextField(controller: _parentPhoneController, decoration: InputDecoration(labelText: "رقم ولي الأمر")),
                TextField(controller: _passwordController, decoration: InputDecoration(labelText: "كلمة المرور"), obscureText: true),
                SizedBox(height: 20,),
                DropdownButton<int>(
                  hint: Text("اختر الصف الدراسي"),
                  value: _selectedGrade,
                  items: _grades.map((grade) {
                    return DropdownMenuItem<int>(
                      value: grade,
                      child: Text("الصف $grade"),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedGrade = value),
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _submitStudent, child: Text("إضافة الطالب")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
