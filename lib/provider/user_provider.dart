import 'package:flutter/widgets.dart';
import 'package:chatapp/models/users.dart';
import 'package:chatapp/resources/authentication_methods.dart';

class UserProvider with ChangeNotifier {
  Users _users;
  AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  Users get getUser => _users;

  Future<void> refreshUser() async {
    Users users = await _authenticationMethods.getUserDetails();
    _users = users;
    notifyListeners();
  }
}
