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