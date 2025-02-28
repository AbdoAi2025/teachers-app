import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_event.dart';
import 'package:teachers_app/bloc/presentation/student/student_state.dart';
import 'package:teachers_app/models/data/update_student_model.dart';
import 'package:teachers_app/pages/create_student_page.dart';
import 'package:teachers_app/pages/home_page.dart';
import 'update_student_page .dart';


class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentBloc>(context).add(LoadStudentsEvent(hasGroups: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📖 قائمة الطلاب"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          },
        ),
      ),

      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentUpdatedState || state is StudentCreatedState) {
            BlocProvider.of<StudentBloc>(context).add(LoadStudentsEvent());
          }
        },
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentLoaded) {
              return state.students.isEmpty
                  ? Center(child: Text("⚠️ لا يوجد طلاب متاحين"))
                  : ListView.builder(
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  final student = state.students[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text(student.studentName, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("📞 هاتف الطالب: ${student.studentPhone}"),
                          Text("📞 هاتف ولي الأمر: ${student.studentParentPhone}"),
                          Text("📚 الصف: ${student.gradeNameAr}"),
                          Text("🏫 المجموعة: ${student.groupName ?? "غير مسجل في مجموعة"}"),
                        ],
                      ),

                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateStudentPage(
                                student: UpdateStudentModel(
                                  studentId: student.studentId,
                                  name: student.studentName,
                                  phone: student.studentPhone,
                                  parentPhone: student.studentParentPhone,
                                  gradeId: int.tryParse(student.gradeNameAr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1, // ✅ استخلاص الرقم من `gradeNameAr`
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is StudentError) {
              return Center(child: Text("⚠️ خطأ: ${state.message}", style: TextStyle(color: Colors.red)));
            }
            return Center(child: Text("🔍 لم يتم العثور على بيانات"));
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateStudentPage()),
          );
        },
        child: Icon(Icons.person_add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
