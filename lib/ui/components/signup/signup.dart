import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersmallproject/bloc/user/user_bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_event.dart';
import 'package:fluttersmallproject/entities/user.dart';
import 'package:fluttersmallproject/ui/colors/colors.dart';
import 'package:fluttersmallproject/utils/navigation_helper.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserBloc _userBloc = UserBloc();

  void _signUpUser(BuildContext context) async {
    try {
      final FirebaseUser firebaseUser =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (firebaseUser != null) {
        User user = User(
            token: await firebaseUser.getIdToken(), email: firebaseUser.email);
        _userBloc.dispatch(Login(user));
        NavigationHelper.pop(context);
      }
    } on PlatformException catch (e) {
      if ("ERROR_EMAIL_ALREADY_IN_USE" == e.code) {
        final snackBar =
            SnackBar(content: Text('message_email_already_in_use'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(content: Text('message_could_not_signup  +++ ${e.code}'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('label_signup'),
      ),
      body: Container(
        child: Column(children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                InputDecoration(labelText: "label_email"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "message_enter_email";
                              }
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration:
                                InputDecoration(labelText: "label_password"),
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "message_enter_password";
                              }
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _signUpUser(context);
                                }
                              },
                              child: Text("label_signup",
                                  style: TextStyle(color: grayColor)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
