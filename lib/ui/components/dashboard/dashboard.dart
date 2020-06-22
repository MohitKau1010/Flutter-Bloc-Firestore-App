import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_event.dart';
import 'package:fluttersmallproject/bloc/user/user_state.dart';
import 'package:fluttersmallproject/ui/colors/colors.dart';

class Dashboard extends StatelessWidget {
  UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DashBoard"),//AppLocalizations.of(context).tr('label_dashboard')
      ),
      body: Container(
        child: Center(
          child: BlocBuilder(
              bloc: _userBloc,
              // ignore: missing_return
              builder: (BuildContext context, UserState userState) {
                if (userState is UserLoggedIn) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 8,
                            ),
                            Text("Welcome",//AppLocalizations.of(context).tr('label_welcome')
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(userState.user.email,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 8,
                            ),
                            Text(userState.user.token,
                                style: TextStyle(
                                    fontSize: 10, color: accentColor)),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 16,
                          ),
                          RaisedButton(
                            onPressed: () {
                              _userBloc.dispatch(Logout(userState.user));
                            },
                            child: Text('label_logout',
                              style: TextStyle(color: grayColor),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
