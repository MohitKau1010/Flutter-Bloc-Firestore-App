import 'package:equatable/equatable.dart';
import 'package:fluttersmallproject/entities/user.dart';
abstract class UserState extends Equatable{
  User user;
  UserState({this.user}) : super([user]);
}

/// <---- UserUndefined class
class UserUndefined extends UserState{
  /// toString() for output value
  @override
  String toString() => "UserState: UserUndefined";
}

/// <---- UserLoggedIn class
class UserLoggedIn extends UserState {
  final User user;

  UserLoggedIn(this.user) : super();

  ///copy privous state
  UserLoggedIn copyWith({User user,}) {
    return UserLoggedIn(this.user);
  }

  /// toString() for output value
  @override
  String toString() => "UserState: UserLoggedIn {user: ${user.token} ${user.email} }";
}

/// <----- UserLoggedOut class
class UserLoggedOut extends UserState{

  /// toString() for output value
  @override
  String toString() => "UserState: UserLoggedOut";
}