import 'package:bloc/bloc.dart';
import 'package:fluttersmallproject/bloc/user/user_event.dart';
import 'package:fluttersmallproject/bloc/user/user_state.dart';
import 'package:fluttersmallproject/entities/user.dart';
import 'package:fluttersmallproject/model/user_model.dart';
import 'package:fluttersmallproject/utils/db_provider.dart';
import 'package:sqflite/sqflite.dart';
class UserBloc extends Bloc<UserEvent,UserState>{

  //Create Singleton
  static final UserBloc _userBloc = new UserBloc._internal();

  factory UserBloc() {
    return _userBloc;
  }
  UserBloc._internal();

  ///STEP 1:
  /// Init state...
  @override
  UserState get initialState => UserUndefined(); ///  <----UserUndefined is important part that is userstate

  ///STEP 2:
  /// stream UserState type
  /// async* <---- is used for sequece operations..
  /// async* means that is not dendepends on other task.
  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {

    /**
     * this is listner type funtion that that is used for
     */

    ///Check is
    if(event is Check){
      Database db = await DBProvider().database;
      ///
      User userWithID = await UserModel(db).getFirstUser();/// this checks
      if(userWithID == null){
        yield UserLoggedOut(); ///return userstate.
      }else{
        yield UserLoggedIn(userWithID); ///return userstate & pass current logged_in user
      }
    }
    if (event is Login){
      try{
        Database db = await DBProvider().database;
        /// User is Model...
        /// UserModel is for Sqlite...
        User userWithID = await UserModel(db).insert(event.user); /// insert onto local db
        print("UserBloc Step 2: Insert DB ----> $userWithID");
        if(userWithID != null){
          yield UserLoggedIn(userWithID); ///return userstate.
        }else{
          yield UserLoggedOut(); /// return userstate.
        }
      }catch(error){
        yield UserLoggedOut(); /// return userstate.
      }
    }
    if(event is Logout){
      try{
        Database db = await DBProvider().database;
        int deletedCount =  await UserModel(db).delete(event.user.id);
        print("UserBloc Step 2: Logout ----> $deletedCount"); //1
        yield UserLoggedOut();
      }catch(error){
        //ToDo: Write log
        print("UserBloc Step 2: Logout ----> $error");
      }
    }
  }

  ///STEP 3:
  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    super.onTransition(transition);
    print("UserBloc Step 3: Transition ----> $transition");
  }
}