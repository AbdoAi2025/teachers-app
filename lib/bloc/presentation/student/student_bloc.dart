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

    on<UpdateStudentEvent>((event, emit) async {
      try {
        print("📡 استقبال `UpdateStudentEvent` وتنفيذ التعديل...");
        print("📤 البيانات المرسلة إلى `repository`: ${event.student.toJson()}"); // ✅ تأكيد البيانات

        await repository.updateStudentData(event.student);

        print("✅ تم تعديل الطالب بنجاح!");
        emit(StudentUpdatedState());
        add(LoadStudentsEvent()); // ✅ إعادة تحميل القائمة بعد التعديل
      } catch (e) {
        print("❌ فشل تعديل الطالب: $e");
        emit(StudentError("فشل تعديل الطالب: $e"));
      }
    });

    on<LoadStudentByIdEvent>((event, emit) async {
      try {
        emit(StudentLoading());
       final student= await repository.getStudentById(event.studentId);
        emit(StudentByIdLoaded(student));
        add(LoadStudentsEvent());
      }catch(e){
        emit(StudentError("فشل جلب بيانات الطالب: $e"));
      }
    });
  }
}
