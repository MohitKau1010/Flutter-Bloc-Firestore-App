import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_event.dart' as UserEvent;
import 'package:fluttersmallproject/bloc/user/user_state.dart';
import 'package:fluttersmallproject/ui/theme/app_theme.dart';

import 'dashboard/dashboard.dart';
import 'loading/Loading.dart';
import 'login/login.dart';

class FirebaseAuthApp extends StatefulWidget {
  @override
  _FirebaseAuthAppState createState() => _FirebaseAuthAppState();
}

class _FirebaseAuthAppState extends State<FirebaseAuthApp> {

  /// bloc class
  UserBloc userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    ///
    userBloc.dispatch(UserEvent.Check());   /// for run check event.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firebase Sample",
      theme: defaultTheme,
      home: BlocBuilder(
          bloc: userBloc,
          builder: (BuildContext context, UserState userState) {
            ///if user logged in then goto dashboard..
            if (userState is UserLoggedIn) {
              return Dashboard();
              /// when user has fetching the data form database: ---> UserUndefined
            } else if (userState is UserUndefined) {
              return Splash();
            } else {
              /// if user has no data then goto login.
              return Login();
            }
          }),
    );
  }

  @override
  void dispose() {
    userBloc.dispose();
  }
}
