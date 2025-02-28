

import 'package:dio/dio.dart';
import 'package:teachers_app/models/data/add_group_model.dart';
import 'package:teachers_app/models/data/group_model.dart';
import 'package:teachers_app/models/data/update_group_model.dart';
import 'package:teachers_app/network/core/dio_helper.dart';


abstract class GroupRepository {
  Future<List<GroupModel>> getGroups();

  Future<void> createGroup(AddGroupModel group);

  Future<void> updateGroup(UpdateGroupModel group);

  Future<void> deleteGroup(String groupId); // ✅ إضافة دالة الحذف

}

class GroupRepositoryImpl implements GroupRepository {


  @override
  Future<List<GroupModel>> getGroups() async {
    final response = await DioHelper.getData('groups/myGroups');
    return (response.data['data'] as List).map((e) => GroupModel.fromJson(e)).toList();
  }

  @override
  Future<void> createGroup(AddGroupModel group) async {
    await DioHelper.postGroupData(group.toJson());
  }

  @override
  Future<void> updateGroup(UpdateGroupModel group) async{
    await DioHelper.putData(group.toJson());

  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await DioHelper.deleteGroup(groupId); // استدعاء دالة الحذف من DioHelper
  }

}
