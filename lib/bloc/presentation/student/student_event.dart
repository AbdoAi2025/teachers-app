import 'package:teachers_app/models/data/add_student_model.dart';

abstract class StudentEvent {}

class LoadStudentsEvent extends StudentEvent {
  final bool hasGroups;
  LoadStudentsEvent({this.hasGroups = false});
}


class CreateStudentEvent extends StudentEvent{
  final AddStudentModel student;
  CreateStudentEvent(this.student);

}
