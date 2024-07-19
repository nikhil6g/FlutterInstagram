import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/user.dart' as model;
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
class UserProvider with ChangeNotifier{
   model.User? _user;
  final AuthMethods _authMethods= AuthMethods();
  model.User? getUser (){
    //print('Extracting from userprovider');
    // return model.User.dummyUser();
    return _user;
  }

  Future<void> refreshUser() async{
    // print("called refreshUser");
    model.User user= await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
    //print("already notifies");
  }
  /*Future<void> dummy()async{
    print("Welcome to User provider");
    _user= model.User.dummyUser();
  }*/
}