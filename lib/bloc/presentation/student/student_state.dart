import 'package:teachers_app/models/data/Load_student_by_Id_Model.dart';
import 'package:teachers_app/models/data/student_model.dart';

abstract class StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;
  StudentLoaded(this.students);
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}

class StudentCreatedState extends  StudentState{}

class StudentUpdatedState extends  StudentState{}

class StudentByIdLoaded extends StudentState {
  final LoadStudentByIdModel student;
  StudentByIdLoaded(this.student);
}