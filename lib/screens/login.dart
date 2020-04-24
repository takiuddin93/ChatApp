import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: UniversalVariables.whiteColor,
      body: Stack(
        children: [
          Positioned(
            top: media.height * 0.16,
            left: media.width * 0.10,
            right: media.width * 0.10,
            child: SvgPicture.asset('assets/svgs/chat_app_logo.svg'),
          ),
          Positioned(
            top: media.height * 0.64,
            left: media.width * 0.20,
            right: media.width * 0.20,
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
      color: UniversalVariables.blueColor,
      padding: EdgeInsets.all(1),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child:
                SvgPicture.asset('assets/svgs/btn_google_light_normal_ios.svg'),
          ),
          Expanded(
            flex: 8,
            child: Text(
              "Sign-In with Gooogle",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                  color: UniversalVariables.whiteColor),
            ),
          ),
        ],
      ),
      onPressed: () => performLogin(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
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
