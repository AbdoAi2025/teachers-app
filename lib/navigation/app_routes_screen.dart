

import 'package:flutter/material.dart';


import 'app_routes.dart';

class AppRoutesScreens {


  static MaterialPageRoute get(RouteSettings settings) {

    return MaterialPageRoute(builder: (BuildContext context){
      var route = settings.name;
      switch(route){
      //  case AppRoutes.addStudent: return AddStudentScreen();
      //case AppRoutes.createGroup: return CreateEditGroupScreen();
      }
      return Container();

    });
  }
}
