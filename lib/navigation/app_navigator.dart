import 'package:flutter/material.dart';


import 'app_routes.dart';

class AppNavigator {


  static Future<dynamic> navigateToAddStudent(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.addStudent);
  }

  static Future<dynamic> navigateToCreateGroup(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.createGroup);
  }
}
