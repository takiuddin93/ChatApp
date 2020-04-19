import 'package:flutter/widgets.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/resources/authentication_methods.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _authenticationMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
