import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String token;
  Login({Key key, this.token}) : super(key: key);

  @override
  _LoginState createState() => _LoginState(this.token);
}

class _LoginState extends State<Login> {
  String token;
  _LoginState(this.token);
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.appBar,
      body: Stack(
        children: [
          Center(
            child: loginButon(),
          ),
          isLoginPressed
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget loginButon() {
    return FlatButton(
      padding: EdgeInsets.all(32),
      child: Text(
        "Sign-In with Gooogle",
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1.6),
      ),
      onPressed: () => performLogin(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void performLogin() {
    print("tring to perform login");

    setState(() {
      isLoginPressed = true;
    });

    _authenticationMethods.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user, token);
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user, String token) {
    _authenticationMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authenticationMethods.addDataToDb(user, token).then((value) {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Dashboard()));
        });
      } else {
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      }
    });
  }
}
