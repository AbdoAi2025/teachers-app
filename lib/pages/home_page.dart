import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/bloc/presentation/group/group_state.dart';
import 'package:teachers_app/bloc/presentation/student/student_bloc.dart';
import 'package:teachers_app/bloc/presentation/student/student_event.dart';
import 'package:teachers_app/models/data/update_group_model.dart';
import 'package:teachers_app/models/data/group_model.dart';
import 'package:teachers_app/pages/create_group_page.dart';
import 'package:teachers_app/pages/student_screen.dart';
import 'package:teachers_app/pages/update_group_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GroupBloc>(context).add(LoadGroupsEvent());
    BlocProvider.of<StudentBloc>(context).add(LoadStudentsEvent());
  }

  int _selectedIndex = 0; // لتحديد الصفحة الحالية

  // 🏷️ محتوى كل تبويب
  Widget _getScreen(int index) {
    if (index == 0) {
      return BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoadedState) {
            return ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];

                return Card(
                  child: ListTile(
                    title: Text(group.groupName),
                    subtitle: Text("عدد الطلاب: ${group.studentCount ?? 0}"),

                    // ✏️ زر التعديل
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        // ✅ تحويل `GroupModel` إلى `UpdateGroupModel` قبل تمريره
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateGroupPage(
                              group: UpdateGroupModel(
                                groupId: group.groupId,
                                name: group.groupName,
                                studentsIds: group.studentsIds,
                                day: group.groupDay,
                                timeFrom: group.timeFrom,
                                timeTo: group.timeTo,
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
          } else if (state is GroupErrorState) {
            return Center(child: Text("❌ خطأ: ${state.message}"));
          }
          return Center(child: Text("لا توجد بيانات"));
        },
      );
    } else {
      return StudentScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📚 الصفحة الرئيسية')),

      body: _getScreen(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: "المجموعات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الطلاب",
          ),
        ],
      ),

      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      )
          : null, // إخفاء الزر عند فتح صفحة الطلاب، لأنه موجود داخل `StudentScreen`
    );
  }
}
