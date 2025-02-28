



// الحالات
import 'package:teachers_app/models/data/group_model.dart';

abstract class GroupState {}

class GroupsLoadingState extends GroupState {}

class GroupsLoadedState extends GroupState {
  final List<GroupModel> groups;
  GroupsLoadedState(this.groups);
}

class GroupErrorState extends GroupState {
  final String message;
  GroupErrorState(this.message);
}

class GroupCreatedState extends GroupState {}

class GroupUpdatedState extends GroupState{}

class GroupDeletedState extends GroupState {}
