import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teachers_app/bloc/presentation/group/group_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/bloc/presentation/group/group_state.dart';
import 'package:teachers_app/models/data/group_model.dart';
import 'package:teachers_app/models/data/update_group_model.dart';
import 'package:teachers_app/pages/home_page.dart';

class UpdateGroupPage extends StatefulWidget {
  final UpdateGroupModel group ;



  UpdateGroupPage({required this.group});

  @override
  _UpdateGroupPageState createState() => _UpdateGroupPageState();
}

class _UpdateGroupPageState extends State<UpdateGroupPage> {
  late TextEditingController _nameController;
  String? _selectedDay;
  List<String> _selectedStudents = [];
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;

  final List<String> _daysOfWeek = [
    "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _selectedDay = _daysOfWeek[widget.group.day];
    _selectedStudents = widget.group.studentsIds;
    _timeFrom = _parseTime(widget.group.timeFrom);
    _timeTo = _parseTime(widget.group.timeTo);
  }

  // 🟢 تحويل النص إلى `TimeOfDay`
  TimeOfDay _parseTime(String time) {
    try {
      final format = DateFormat.jm(); // يدعم صيغة AM و PM
      final parsedTime = format.parse(time);
      return TimeOfDay.fromDateTime(parsedTime);
    } catch (e) {
      print("خطأ في تحويل الوقت: $e");
      return TimeOfDay.now(); // إرجاع وقت افتراضي في حالة الخطأ
    }
  }


  // 🟢 اختيار اليوم
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

  // 🟢 اختيار وقت البداية أو النهاية
  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStart ? _timeFrom! : _timeTo!,
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

  // 🔵 إرسال بيانات المجموعة إلى `Bloc`
  void _updateGroup() {
    String name = _nameController.text;
    if (name.isEmpty || _selectedDay == null || _timeFrom == null || _timeTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ الرجاء ملء جميع الحقول"))
      );
      return;
    }

    final updatedGroup = UpdateGroupModel(
      groupId: widget.group.groupId,
      name: name,
      studentsIds: _selectedStudents,
      day: _daysOfWeek.indexOf(_selectedDay!),
      timeFrom: _timeFrom!.format(context),
      timeTo: _timeTo!.format(context),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("جاري تحديث المجموعة..."),
            ],
          ),
        );
      },
    );

    BlocProvider.of<GroupBloc>(context).add(UpdateGroupEvent(updatedGroup));

    Future.delayed(Duration(seconds: 2), () {
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
      appBar: AppBar(title: Text("✏️ تعديل المجموعة")),
      body: SingleChildScrollView(
        child: BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupUpdatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ تم تحديث المجموعة بنجاح!"))
              );

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
                // 📝 اسم المجموعة
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

                // ✅ زر تحديث المجموعة
                ElevatedButton(
                  onPressed: _updateGroup,
                  child: Text("💾 حفظ التعديلات"),
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
