import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersmallproject/bloc/user/user_bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_event.dart' as UserEvent;
import 'package:fluttersmallproject/entities/user.dart';
import 'package:fluttersmallproject/ui/colors/colors.dart';
import 'package:fluttersmallproject/ui/components/signup/signup.dart';
import 'package:fluttersmallproject/utils/navigation_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<Color> _colors = [Colors.orange, Colors.pink];
  List<double> _stops = [0.0, 0.9];

  final TextEditingController _emailController = TextEditingController();

  ///txt email
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// A FormState object can be used to save, reset and validate every filed
  final TextEditingController _passwordController = TextEditingController();

  ///txt password
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ///Google signIn
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///Firebase auth
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Can display SnackBar.s and BottomSheet.s.
  UserBloc _userBloc = UserBloc();

  ///login with email password...
  void _signInWithEmailAndPassword() async {
    try {
      final FirebaseUser firebaseUser = await _auth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text,);
      if (firebaseUser != null) {
        final String token = await firebaseUser.getIdToken();
        User user = User(email: firebaseUser.email, token: token);
        _userBloc.dispatch(UserEvent.Login(user)); /// use if user is logged in
      }
    } on PlatformException catch (e) {
      if ("ERROR_USER_NOT_FOUND" == e.code) {
        final snackBar = SnackBar(
            content: Text('message_invalid_username_or_password'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(content: Text('message_could_not_signup'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  ///google sign in...
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser firebaseUser =
    await _auth.signInWithCredential(credential);
    assert(firebaseUser.email != null);
    assert(firebaseUser.displayName != null);
    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
    if (firebaseUser != null) {
      User user = User(
          token: await firebaseUser.getIdToken(), email: firebaseUser.email);
      _userBloc.dispatch(UserEvent.Login(user));  /// use if user is logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _colors,
                        stops: _stops,
                      )
                  ),
                ),
              ),
              Column(children: <Widget>[
                SizedBox(height: 190,),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: "Email"),
                              // ignore: missing_return
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "email is empty";
                                }
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration:
                              InputDecoration(labelText: "Password"),
                              // ignore: missing_return
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'password is empty';
                                }
                              },
                            ),
                            SizedBox(height: 90,),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _signInWithEmailAndPassword();
                                  }
                                },
                                child: Text("Login",
                                    style: TextStyle(color: grayColor)),
                              ),
                            ),
                            Center(
                              child: Text(
                                "or",
                                style: TextStyle(
                                  color: accentColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () {
                                  _signInWithGoogle();
                                },
                                child: Text("Login with google",
                                    style: TextStyle(color: grayColor)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () {
                                  NavigationHelper.push(context, Signup());
                                },
                                child: Text("Signup Here",
                                    style: TextStyle(color: grayColor)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(children: <Widget>[
                  SizedBox(
                    height: 16,
                  )
                ])
              ]),
            ]),
      ),
    );
  }
}
