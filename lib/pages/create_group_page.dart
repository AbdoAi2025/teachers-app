


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/bloc/presentation/group/group_state.dart';
import 'package:teachers_app/models/data/add_group_model.dart';
import 'package:teachers_app/models/data/group_model.dart';
import 'package:teachers_app/pages/home_page.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDay;
  String? _selectedGrade;
  List<String> _selectedStudents = [];
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;

  final List<String> _daysOfWeek = [
    "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"
  ];

  final List<String> _grades = [
    "الصف الأول", "الصف الثاني", "الصف الثالث", "الصف الرابع", "الصف الخامس"
  ];

  // 🟢 فتح Bottom Sheet لاختيار اليوم
  void _showDayPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _daysOfWeek.map((day) {
            return ListTile(
              title: Text(day),
              onTap: () {
                setState(() {
                  _selectedDay = day;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // 🟢 فتح Time Picker لاختيار الوقت
  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _timeFrom = pickedTime;
        } else {
          _timeTo = pickedTime;
        }
      });
    }
  }

  // 🟢 فتح Bottom Sheet لاختيار الصف
  void _showGradePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _grades.map((grade) {
            return ListTile(
              title: Text(grade),
              onTap: () {
                setState(() {
                  _selectedGrade = grade;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // 🔵 إرسال بيانات المجموعة إلى `Bloc`
  void _createGroup() {
    String name = _nameController.text;
    if (name.isEmpty || _selectedDay == null || _selectedGrade == null || _timeFrom == null || _timeTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ الرجاء ملء جميع الحقول"))
      );
      return;
    }

    final newGroup = AddGroupModel(
      id: "",
      name: name,
      studentsIds: _selectedStudents,
      day: _daysOfWeek.indexOf(_selectedDay!),
      timeFrom: _timeFrom!.format(context),
      timeTo: _timeTo!.format(context),
    );


    // 👈 الانتقال مباشرة إلى الصفحة الرئيسية دون انتظار API
   // Navigator.pushAndRemoveUntil(
     // context,
   //   MaterialPageRoute(builder: (context) => HomePage()),
          //(route) => false,
   // );






    // 👈 عرض شاشة تحميل أثناء تنفيذ الطلب
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("جاري إنشاء المجموعة..."),
            ],
          ),
        );
      },
    );

    // 👈 تنفيذ الطلب
    BlocProvider.of<GroupBloc>(context).add(CreateGroupEvent(newGroup));

    // 👈 عند نجاح العملية، أغلق شاشة التحميل وانتقل إلى `HomePage`
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pop(context); // إغلاق شاشة التحميل
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("➕ إنشاء مجموعة جديدة")),
      body: SingleChildScrollView(
        child: BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupCreatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ تم إنشاء المجموعة بنجاح!"))
              );

              // 👈 تحديث الصفحة الرئيسية وعرض المجموعة المضافة فورًا
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
              );
            } else if (state is GroupErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("⚠️ حدث خطأ: ${state.message}"))
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "📌 اسم المجموعة"),
                ),
                SizedBox(height: 16),

                // 📅 اختيار اليوم
                InkWell(
                  onTap: _showDayPicker,
                  child: _buildField("📅 اليوم", _selectedDay ?? "اختر يومًا"),
                ),
                SizedBox(height: 16),

                // ⏰ اختيار وقت البداية
                InkWell(
                  onTap: () => _pickTime(true),
                  child: _buildField("⏰ وقت البداية",
                      _timeFrom != null ? _timeFrom!.format(context) : "اختر وقت البداية"),
                ),
                SizedBox(height: 16),

                // ⏰ اختيار وقت النهاية
                InkWell(
                  onTap: () => _pickTime(false),
                  child: _buildField("⏰ وقت النهاية",
                      _timeTo != null ? _timeTo!.format(context) : "اختر وقت النهاية"),
                ),
                SizedBox(height: 16),

                // 🏫 اختيار الصف
                InkWell(
                  onTap: _showGradePicker,
                  child: _buildField("🏫 الصف الدراسي", _selectedGrade ?? "اختر الصف"),
                ),
                SizedBox(height: 16),

                // ✅ زر إنشاء المجموعة
                ElevatedButton(
                  onPressed: _createGroup,
                  child: Text("✅ إنشاء مجموعة"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 مكون لعرض الحقول القابلة للنقر
  Widget _buildField(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
*/




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/bloc/presentation/group/group_state.dart';
import 'package:teachers_app/models/data/add_group_model.dart';
import 'package:teachers_app/pages/home_page.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDay;
  String? _selectedGrade;
  List<String> _selectedStudents = [];
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;

  final List<String> _daysOfWeek = [
    "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"
  ];

  final List<String> _grades = [
    "الصف الأول", "الصف الثاني", "الصف الثالث", "الصف الرابع", "الصف الخامس"
  ];

  final List<Map<String, dynamic>> _studentsList = [
    {"studentId": "a39aaad1-63e5-4de4-a39a-9738dc6d1232", "studentName": "Student2 teacher1"},
    {"studentId": "7da3ad32-0440-4b89-9ba2-bba261dfc9b6", "studentName": "abdo student1 for teacher1"},
    {"studentId": "611f457e-a047-448b-a338-9df57c328d7f", "studentName": "mostafa"},
    {"studentId": "2cf2a99c-a205-498e-9217-a4aa33d0318d", "studentName": "Student1 teacher1"},
    {"studentId": "240445a2-6613-476c-8b9c-fff0d355e276", "studentName": "Student3 teacher1"},
    {"studentId": "21d59b61-4421-457e-9a51-beaabbdfcb84", "studentName": "abdo"},
    {"studentId": "b4190346-d9eb-4f40-89b4-2367118a81a8", "studentName": "hamdy"},
    {"studentId": "8cc291b1-2d01-4972-956f-b2ec77957522", "studentName": "محمد"},
    {"studentId": "51fb8df5-5f76-4b58-86b7-0dd871776dda", "studentName": "Abdo"},
    {"studentId": "3ea44a6a-7421-424f-8897-3d6d1e316a3d", "studentName": "hamdy1"},
    {"studentId": "303873dc-a873-4005-a0cc-9d906c9640eb", "studentName": "ahmed"},
  ];

  void _showDayPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _daysOfWeek.map((day) {
            return ListTile(
              title: Text(day),
              onTap: () {
                setState(() => _selectedDay = day);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() => isStart ? _timeFrom = pickedTime : _timeTo = pickedTime);
    }
  }

  void _showGradePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _grades.map((grade) {
            return ListTile(
              title: Text(grade),
              onTap: () {
                setState(() => _selectedGrade = grade);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showStudentPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return ListView(
              children: _studentsList.map((student) {
                bool isSelected = _selectedStudents.contains(student["studentId"]);
                return CheckboxListTile(
                  title: Text(student["studentName"]),
                  value: isSelected,
                  onChanged: (value) {
                    setStateBottomSheet(() {
                      if (value == true)
                        _selectedStudents.add(student["studentId"]);
                      else
                        _selectedStudents.remove(student["studentId"]);
                    });
                    setState(() {});
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  void _createGroup() {
    final newGroup = AddGroupModel(
      id: "",
      name: _nameController.text,
      studentsIds: _selectedStudents,
      day: _daysOfWeek.indexOf(_selectedDay!),
      timeFrom: _timeFrom!.format(context),
      timeTo: _timeTo!.format(context),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("جاري إنشاء المجموعة..."),
        ]),
      ),
    );

    BlocProvider.of<GroupBloc>(context).add(CreateGroupEvent(newGroup));

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("➕ إنشاء مجموعة جديدة")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "📌 اسم المجموعة")),
            SizedBox(height: 16),
            InkWell(onTap: _showDayPicker, child: _buildField("📅 اليوم", _selectedDay ?? "اختر يومًا")),
            SizedBox(height: 16),
            InkWell(onTap: () => _pickTime(true), child: _buildField("⏰ وقت البداية", _timeFrom?.format(context) ?? "اختر وقت البداية")),
            SizedBox(height: 16),
            InkWell(onTap: () => _pickTime(false), child: _buildField("⏰ وقت النهاية", _timeTo?.format(context) ?? "اختر وقت النهاية")),
            SizedBox(height: 16),
            InkWell(onTap: _showGradePicker, child: _buildField("🏫 الصف", _selectedGrade ?? "اختر الصف")),
            SizedBox(height: 16),
            InkWell(
              onTap: _showStudentPicker,
              child: _buildField("👨‍🎓 الطلاب",
                  _selectedStudents.isNotEmpty ? _studentsList.where((s) => _selectedStudents.contains(s["studentId"])).map((s) => s["studentName"]).join(", ") : "اختر الطلاب"),
            ),
            SizedBox(height: 32),
            ElevatedButton(onPressed: _createGroup, child: Text("✅ إنشاء مجموعة")),
          ]),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: Colors.blue)),
      ]),
    );
  }
}
