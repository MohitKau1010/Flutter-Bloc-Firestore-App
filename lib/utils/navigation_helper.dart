import 'package:flutter/material.dart';
class NavigationHelper{

  ///for push screen
  static void push(BuildContext context, Widget page){
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page),);
  }

  /// for pop screen
  static void pop(BuildContext context){
    Navigator.of(context).pop();
  }
}