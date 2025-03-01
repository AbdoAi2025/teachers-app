import 'package:teachers_app/models/data/add_student_model.dart';
import 'package:teachers_app/models/data/update_student_model.dart';

abstract class StudentEvent {}

class LoadStudentsEvent extends StudentEvent {
  final bool hasGroups;
  LoadStudentsEvent({this.hasGroups = false});
}


class CreateStudentEvent extends StudentEvent{
  final AddStudentModel student;
  CreateStudentEvent(this.student);

}

class UpdateStudentEvent extends StudentEvent{
  final UpdateStudentModel student;
  UpdateStudentEvent(this.student);

}

class LoadStudentByIdEvent extends StudentEvent {
  final String studentId;
  LoadStudentByIdEvent(this.studentId);
}
