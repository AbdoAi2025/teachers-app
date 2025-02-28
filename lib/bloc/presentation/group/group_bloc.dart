

// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachers_app/bloc/presentation/group/group_event.dart';
import 'package:teachers_app/bloc/presentation/group/group_state.dart';

import 'package:teachers_app/repositories/data/group_repository.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository repository;

  GroupBloc(this.repository) : super(GroupsLoadingState()) {
    on<LoadGroupsEvent>((event, emit) async {
      try {
        final groups = await repository.getGroups();
        emit(GroupsLoadedState(groups));
      } catch (e) {
        emit(GroupErrorState(e.toString()));
      }
    });

    on<CreateGroupEvent>((event, emit) async {
      try {
        await repository.createGroup(event.group);
        emit(GroupCreatedState());
        add(LoadGroupsEvent()); // إعادة تحميل القائمة
      } catch (e) {
        emit(GroupErrorState(e.toString()));
      }
    });

    on<UpdateGroupEvent>((event,emit) async {
      try {
        await repository.updateGroup(event.group);
        emit(GroupUpdatedState());
        add(LoadGroupsEvent());
      }catch(e){
        emit(GroupErrorState(e.toString()));
      }
    });

    on<DeleteGroupEvent>((event, emit) async {
      try {
        await repository.deleteGroup(event.groupId);
        emit(GroupDeletedState());
        add(LoadGroupsEvent()); // إعادة تحميل المجموعات بعد الحذف
      } catch (e) {
        emit(GroupErrorState(e.toString()));
      }
    });


  }
}