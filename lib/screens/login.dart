import 'package:chatapp/resources/firebase_repository.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseRepository _firebaseRepository = FirebaseRepository();

  bool isLoginPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return FlatButton (
      padding: EdgeInsets.all(32),
      child: Text (
        "Login",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.6
        ),
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

    _firebaseRepository.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _firebaseRepository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if(isNewUser) {
        _firebaseRepository.addDataToDb(user).then((value) {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Dashboard())
          );
        });
      } else {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => Login())
        );
      }
    });
  }
}
