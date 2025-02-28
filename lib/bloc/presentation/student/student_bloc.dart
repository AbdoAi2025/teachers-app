import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/repositories/data/student_repository.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository repository;

  StudentBloc(this.repository) : super(StudentLoading()) {
    on<LoadStudentsEvent>((event, emit) async {
      try {
        print("📡 جاري تحميل الطلاب...");
        final students = await repository.getStudents(hasGroups: event.hasGroups);
        emit(StudentLoaded(students));
      } catch (e) {
        print("❌ فشل تحميل الطلاب: $e");
        emit(StudentError(e.toString()));
      }
    });

    //to add  a new student
    on<CreateStudentEvent>((event,emit) async {
      try {
        await repository.createStudent(event.student);
        emit(StudentCreatedState());
        add(LoadStudentsEvent());
      }catch(e){
        emit(StudentError(e.toString()));
      }
    });

    //to update students
    on<UpdateStudentEvent>((event,emit)async{
      try{
        await repository.updateStudentData(event.student);
        emit(StudentUpdatedState());
        add(LoadStudentsEvent());
      }catch(e){
        emit(StudentError(e.toString()));
      }
    });


  }
}
