

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_event.dart';
import 'package:teachers_app/bloc/presentation/student/student_state.dart';
import 'package:teachers_app/models/data/add_student_model.dart';
import 'package:teachers_app/models/data/update_student_model.dart';
import 'package:teachers_app/pages/student_screen.dart';

class UpdateStudentPage extends StatefulWidget {

  final UpdateStudentModel student ;



  UpdateStudentPage({required this.student});


  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {

   // نقوم بتعبئة القيم مباشرة عند تحميل الصفحة
  @override
  void initState() {
    super.initState();
    _studentIdController.text = widget.student.studentId;
    _nameController.text = widget.student.name;
    _phoneController.text = widget.student.phone;
    _parentPhoneController.text = widget.student.parentPhone;
    _selectedGrade                   =widget.student.gradeId;

  }



  int? _selectedGrade;

  final List<int> _grades = [1, 2, 3, 4, 5]; // قيم `gradeId`

  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();



  void _submitStudent() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _parentPhoneController.text.isEmpty ||
        _studentIdController.text.isEmpty ||

        _selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ الرجاء ملء جميع الحقول")),
      );
      return;
    }


    print("📌 `gradeId` قبل الإرسال: $_selectedGrade"); // ✅ تأكد من أن `gradeId` ليس `null` أو `غير صحيح`

    final newStudent = UpdateStudentModel(
      studentId:widget.student.studentId,      //  تأكد من تمرير ID الطالب
      gradeId: _selectedGrade!,
      phone: _phoneController.text.trim(),
      parentPhone: _parentPhoneController.text.trim(),
      name: _nameController.text.trim(),

    );



    // 👈 الانتقال مباشرة إلى صفحة student screen  دون انتظار API
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => StudentScreen()),
          (route) => false,
    );

    BlocProvider.of<StudentBloc>(context).add(UpdateStudentEvent(newStudent));

    BlocProvider.of<StudentBloc>(context).add(
      LoadStudentByIdEvent(widget.student.studentId),
    );

    BlocProvider.of<StudentBloc>(context).stream.listen((state) {
      if (state is StudentUpdatedState) {
        Navigator.pop(context); // ✅ العودة بعد نجاح التحديث
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("✏️ تعديل بيانات الطالب ")),
      body: SingleChildScrollView(
        child: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is StudentUpdatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ تم تعديل بيانات الطالب بنجاح!")),
              );
              Navigator.pop(context);
            } else if (state is StudentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("⚠️ فشل التعديل : ${state.message}")),
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
                ElevatedButton(onPressed: _submitStudent, child: Text("حفظ التعديلات")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_event.dart';
import 'package:teachers_app/bloc/presentation/student/student_state.dart';
import 'package:teachers_app/models/data/update_student_model.dart';
import 'package:teachers_app/pages/student_screen.dart';

class UpdateStudentPage extends StatefulWidget {
  final UpdateStudentModel student;

  UpdateStudentPage({required this.student});

  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  late TextEditingController _studentIdController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _parentPhoneController;
  int? _selectedGrade;

  final List<int> _grades = [1, 2, 3, 4, 5]; // قيم `gradeId`

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(text: widget.student.studentId);
    _nameController = TextEditingController(text: widget.student.name);
    _phoneController = TextEditingController(text: widget.student.phone);
    _parentPhoneController = TextEditingController(text: widget.student.parentPhone);
    _selectedGrade = widget.student.gradeId;
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  void _submitStudent() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _parentPhoneController.text.isEmpty ||
        _studentIdController.text.isEmpty ||
        _selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ الرجاء ملء جميع الحقول")),
      );
      return;
    }

    print("📌 `gradeId` قبل الإرسال: $_selectedGrade");

    final newStudent = UpdateStudentModel(
      studentId: widget.student.studentId,
      gradeId: _selectedGrade!,
      phone: _phoneController.text.trim(),
      parentPhone: _parentPhoneController.text.trim(),
      name: _nameController.text.trim(),
    );

    BlocProvider.of<StudentBloc>(context).add(UpdateStudentEvent(newStudent));

    BlocProvider.of<StudentBloc>(context).stream.listen((state) {
      if (state is StudentUpdatedState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ تم تعديل بيانات الطالب بنجاح!")),
        );

        BlocProvider.of<StudentBloc>(context).add(LoadStudentsEvent());

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StudentScreen()),
              (route) => false,
        );
      } else if (state is StudentError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ فشل التعديل : ${state.message}")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("✏️ تعديل بيانات الطالب")),
      body: SingleChildScrollView(
        child: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is StudentUpdatedState) {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _nameController, decoration: InputDecoration(labelText: "اسم الطالب")),
                TextField(controller: _phoneController, decoration: InputDecoration(labelText: "رقم الهاتف")),
                TextField(controller: _parentPhoneController, decoration: InputDecoration(labelText: "رقم ولي الأمر")),
                SizedBox(height: 20),
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
                ElevatedButton(
                  onPressed: _submitStudent,
                  child: Text("حفظ التعديلات"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
