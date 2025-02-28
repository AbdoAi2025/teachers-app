


// الأحداث
import 'package:teachers_app/models/data/add_group_model.dart';
import 'package:teachers_app/models/data/update_group_model.dart';

abstract class GroupEvent {}

class LoadGroupsEvent extends GroupEvent {}


class CreateGroupEvent extends GroupEvent {
  final AddGroupModel group;
  CreateGroupEvent(this.group);
}

class UpdateGroupEvent extends GroupEvent{
  final UpdateGroupModel group;
  UpdateGroupEvent(this.group);
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;
  DeleteGroupEvent(this.groupId);
}
